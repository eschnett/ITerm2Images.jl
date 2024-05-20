using CairoMakie
using ITerm2Images
using Test

# The `@test ... isa Any` statements test that no exception is thrown.

scene = scatter(rand(10), rand(10); markersize=30.0)

@testset "Display an image" begin
    @test display(scene) isa Any
end

# CairoMakie supports only a few MIME types. We use a PNG image to
# test the other MIME types.
img = repr("image/png", scene)

@testset "Display an image as $tp" for tp in ITerm2Images.imagetypes
    if tp in ["application/pdf", "application/postscript", "image/png", "image/svg+xml"]
        @test display(tp, scene) isa Any
    else
        @test display(tp, img) isa Any
    end
end
