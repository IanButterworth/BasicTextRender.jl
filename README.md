# BasicTextRender.jl

Warning.. very basic.. More of a experiment..

Concatenates characters from lookup images, then resizes and colors.

```julia
> using BasicTextRender
> img = rendertext("Hello world", height=30)
30×190 Array{RGBA{Float64},2} with eltype RGBA{Float64}:
...
> save("img.png", img)
```
![img](img.png)


```julia
using FileIO, ColorTypes

img = rendertext("Hello world", height=30, color=RGBA(1.0,0.0,0.0,1.0), backgroundColor=RGBA(1.0,1.0,0.0,1.0))
```
![img](img2.png)

```julia
using BenchmarkTools
@btime rendertext("Hello world", height=30) #1.052 ms (667 allocations: 2.20 MiB)
```
Note. First time `rendertext` runs it will take ~10 seconds, as it loads the character lookup table
