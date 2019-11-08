using BasicTextRender, FileIO, ImageCore

@time img = rendertext("Hello world", height=40)
save(joinpath(@__DIR__,"img.png"), img)

using BenchmarkTools
@btime rendertext("Hello world", height=30)


using BasicTextRender
img = rendertext("Hello world", height=50)
save("img.png", img)

using FileIO, ColorTypes
img = rendertext("Hello world", font="Monaco", height=20, color=RGBA(1.0,0.0,0.0,1.0), backgroundColor=RGBA(1.0,1.0,0.0,1.0))
save(joinpath(@__DIR__,"img2.png"), img)


using BenchmarkTools
@btime rendertext("Hello world", height=30) #1.052 ms (667 allocations: 2.20 MiB)


using BasicTextRender
img_text = rendertext("BasicTextRender.jl", height=30)


using BasicTextRender, FileIO, ImageCore
img = rand(RGBA{Float64},80,700)
overlaytext!(img, "BasicTextRender.jl", 60, (10,40))
save("logo.png", img)
