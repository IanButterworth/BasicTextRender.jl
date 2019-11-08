# BasicTextRender.jl

Warning.. very basic.. More of an experiment.. Concatenates characters from pre-rendered lookup images, then resizes and colors. 100% julia, no libs. Gets blurry if font height is greater than ~90 pixels.

Provides `rendertext` for generating a rendered image of a string and
`overlaytext!` for directly overlaying text on a loaded image.

Currently built to support truly monospaced fonts only, and Courier is the only font that is provided.
(other open source licensed fonts welcome via PR, see `gen/makeCharLookups.jl`)

## Generating rendered text
```julia
> using BasicTextRender
> img = rendertext("Hello world", height=50)
50×316 Array{RGBA{Float64},2} with eltype RGBA{Float64}:
...
> using FileIO
> save("img.png", img)
```
![img](img.png)


```julia
using BasicTextRender, ColorTypes
img = rendertext("Hello world", height=30, color=RGBA(1.0,0.0,0.0,1.0), backgroundColor=RGBA(1.0,1.0,0.0,1.0))
```
![img](img2.png)


## Overlaying text on a loaded image

```julia
img = rand(RGBA{Float64},80,700)
overlaytext!(img, "BasicTextRender.jl", 60, (10,40))
save("logo.png", img)
```
![logo](logo.png)

## Speed (slow then fast-ish)
The first time `rendertext` runs it should take about 5 seconds, as it loads the
character lookup table, but subsequent calls for the same scale and font will be fast.

```julia
using BenchmarkTools
@btime rendertext("Hello world", height=30) #599.991 μs (352 allocations: 2.28 MiB)
```
