using BasicTextRender, FileIO, ImageCore

@time img = rendertext("Hello world", height=30,
                color=RGBA(1.0,0.0,0.0,1.0),
                backgroundColor=RGBA(1.0,1.0,1.0,1.0))

save(joinpath(@__DIR__,"test.png"), img)

using BenchmarkTools
@btime rendertext("Hello world", height=30)


using BasicTextRender
img = rendertext("Hello world", height=50)
save("img.png", img)

using FileIO, ColorTypes
img = rendertext("Hello world", height=20, color=RGBA(1.0,0.0,0.0,1.0), backgroundColor=RGBA(1.0,1.0,0.0,1.0))
save("img2.png", img)


using BenchmarkTools
@btime rendertext("Hello world", height=30) #1.052 ms (667 allocations: 2.20 MiB)
