using Test, BasicTextRender, ImageCore

@testset "BasicTextRender.jl tests" begin
    img = rendertext("Hello world")
    @test size(img) == (89, 561)

    img = rendertext("Hello world", height=30)
    @test size(img) == (30, 190)
    img = rendertext("Hello world", height=30, font="Courier New")
    @test size(img) == (31, 202)

    img = rendertext("Hello world", height=30, font="Monaco")
    @test size(img) == (30, 167)

    img = rendertext("Hello world", height=30,
                    color=RGBA(1.0,0.0,0.0,1.0))
    @test size(img) == (30, 190)

    img = rendertext("Hello world", height=30,
                    color=RGBA(1.0,0.0,0.0,1.0),
                    backgroundColor=RGBA(1.0,1.0,1.0,1.0))
    @test size(img) == (30, 190)

    img = rand(RGBA{Float64},80,700)
    overlaytext!(img, "BasicTextRender.jl", 60, (10,40))

    @test size(img) == (80, 700)


end
