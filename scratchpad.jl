using BasicTextRender, FileIO, ImageCore
using BenchmarkTools

@time img = rendertext("Hello world", height=50)
save(joinpath(@__DIR__,"img.png"), img)

@btime rendertext("Hello world", height=30)

img = rendertext("Hello world", font="Monaco", height=20, color=RGBA(1.0,0.0,0.0,1.0), backgroundColor=RGBA(1.0,1.0,0.0,1.0))
save(joinpath(@__DIR__,"img2.png"), img)

img = rand(RGBA{Float64},80,700)
overlaytext!(img, "BasicTextRender.jl", 60, (10,40))
save(joinpath(@__DIR__,"logo.png"), img)
