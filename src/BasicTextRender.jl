module BasicTextRender

using FileIO, ImageCore, ImageTransformations, ImageFiltering

charStack = nothing
loadedFont = nothing
kern = ImageFiltering.KernelFactors.IIRGaussian((2,2))
loadedScale = nothing

"""
    rendertext(str::String;
        height::Int=0,
        font::String="Courier",
        color::ColorTypes.RGBA{Float64}=ColorTypes.RGBA(0.0,0.0,0.0,1.0),
        backgroundColor::ColorTypes.RGBA{Float64}=ColorTypes.RGBA(0.0,0.0,0.0,0.0))

Render monospaced text from character lookup tables.
Not recommended for high quality output.
Loads slowly first time, or whenever the font is changed. Much faster next time.

font: "Courier", "Courier New", "Monaco"
"""
function rendertext(str::String;
        height::Int=0,
        font::String="Courier",
        color::ColorTypes.RGBA{Float64}=ColorTypes.RGBA(0.0,0.0,0.0,1.0),
        backgroundColor::ColorTypes.RGBA{Float64}=ColorTypes.RGBA(0.0,0.0,0.0,0.0))

    global charStack, loadedFont, kern, loadedScale

    lookupdir = joinpath(dirname(@__DIR__),"gen","fonts",font)
    !isdir(lookupdir) && error("Font not supported")

    if loadedFont != font
        charStack = map(x->Float64.(channelview(load(joinpath(lookupdir,"$x.png")))[1,:,:]),0:255)
        loadedFont = font
    end

    chars = collect(str)
    codes = Int.(codepoint.(chars)) .+ 1
    raw_chars = view(charStack, codes)
    raw_img = hcat(raw_chars...)

    colormap = ImageCore.colorsigned(RGBA(0.0,0.0,0.0,0.0), backgroundColor, color)

    scale = height / size(raw_img, 1)
    if scale == 1 || (height <= 0)
        return colormap.(raw_img)
    elseif scale < 1
        if loadedScale != scale
            σ = 0.5 * (1/scale)
            kern = ImageFiltering.KernelFactors.IIRGaussian((σ,σ))
        end

        return colormap.(ImageTransformations.imresize(ImageFiltering.imfilter(raw_img, kern, NA()), ratio=scale))
    else
        @warn "Height exceeds font lookup table height. Sharpness will be suboptimal"
        return colormap.(ImageTransformations.imresize(raw_img, ratio=scale))
    end
end

"""
    overlaytext!(img, str::String, height::Int, bottomleft::Tuple{Int,Int};
            font::String="Courier",
            color::ColorTypes.RGBA{Float64}=ColorTypes.RGBA(0.0,0.0,0.0,1.0))

Overlay text on `img` in-place.
"""
function overlaytext!(img, str::String, height::Int, bottomleft::Tuple{Int,Int};
            font::String="Courier",
            color::ColorTypes.RGBA{Float64}=ColorTypes.RGBA(0.0,0.0,0.0,1.0))

    img_text = rendertext(str, font=font, height=height, color=color)
    width = size(img_text,2)
    x, y = bottomleft
    img[x:x+height-1, y:y+width-1] .= ((1 .- alpha.(img_text)) .* img[x:x+height-1, y:y+width-1]) .+ (alpha.(img_text) .* img_text)
end

export rendertext, overlaytext!
end #module
