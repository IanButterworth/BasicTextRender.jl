using Luxor, FileIO, ImageCore, Statistics, DelimitedFiles

size = 80

for font in ["Courier","Courier New","Monaco"]
    @info "Rendering $font characters"
    fontdir = joinpath(@__DIR__,"fonts",font)
    !isdir(fontdir) && mkdir(fontdir)
    xFirsts = Int[]
    xLasts = Int[]
    yFirsts = Int[]
    yLasts = Int[]
    for charIDX in 0:255
        char = Char(charIDX)
        file = joinpath(fontdir,"$charIDX.png")
        Drawing(150, 150, file)
        origin()
        background("black")
        fontface(font)
        setcolor("white")
        setopacity(1)
        fontsize(size)
        text(string(char), Point(0,0), halign = :bottom,  valign = :left)
        finish()
        #preview()
        img = load(file)
        pixcol = mean(img, dims=1)[1,:]
        #@show pixrow[1]
        xOccupied = findall(pixcol .!= RGB(0,0,0))
        if length(xOccupied)>2
            push!(xFirsts, Int(xOccupied[1]))
            push!(xLasts, Int(xOccupied[end]))
        end
        pixrow = mean(img, dims=2)[:,1]
        yOccupied = findall(pixrow .!= RGB(0,0,0))
        if length(yOccupied)>2
            push!(yFirsts, Int(yOccupied[1]))
            push!(yLasts, Int(yOccupied[end]))
        end
    end
    x_first_pix = minimum(xFirsts)
    x_last_pix = maximum(xLasts)
    y_first_pix = minimum(yFirsts)
    y_last_pix = maximum(yLasts)
    for charIDX in 0:255
        file = joinpath(fontdir,"$charIDX.png")
        img = load(file)
        save(file, img[y_first_pix:y_last_pix, x_first_pix:x_last_pix,])
    end

end
