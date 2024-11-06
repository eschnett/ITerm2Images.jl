# ITerm2Images

* [![GitHub
  CI](https://github.com/eschnett/ITerm2Images.jl/workflows/CI/badge.svg)](https://github.com/eschnett/ITerm2Images.jl/actions)
* [![codecov](https://codecov.io/gh/eschnett/ITerm2Images.jl/branch/main/graph/badge.svg?token=6JBYLRAD2X)](https://codecov.io/gh/eschnett/ITerm2Images.jl)

This is a Julia package to display graphics inline on terminals that
support [iTerm2](https://iterm2.com/documentation-images.html) inline
graphics. This is similar to
[SixelTerm.jl](https://github.com/eschnett/SixelTerm.jl) but is
optimized for [iTerm2](https://iterm2.com) terminals.

The main advantage of this approach is having usable graphics on
remote connections without having to mess with X or other remote
display connections. This works for Julia running on many remote
platforms. It also supports the [tmux](tmux.github.io) terminal
multiplexer.

## Examples

Here is an example using Plots with the default GR backend:

```julia
using CairoMakie
using ITerm2Images
scatter(rand(10), rand(10); markersize=30.0)
```
Note that when using it with Plots, you have to do `using ITerm2Images` after `using Plots`.
For some reason, Plots.jl adds its own display to the stack, so we need the ITerm2Images
display added last.

This is how things look in iTerm2:
<img src="https://raw.githubusercontent.com/eschnett/ITerm2Images.jl/main/demo-makie.png" width=900px></img>

## Acknowledgements

This package was inspired by
[SixelTerm.jl](https://github.com/eschnett/SixelTerm.jl) and
[imgcat](https://iterm2.com/utilities/imgcat).
