module ITerm2Images

using Base64

struct ITerm2Display <: AbstractDisplay end

# The MIME image types we support
const imagetypes = ["application/pdf",
                    "application/postscript",
                    "image/bmp",
                    "image/gif",
                    "image/jpeg",
                    "image/pict",
                    "image/png",
                    "image/svg+xml",
                    "image/tiff",
                    "image/webp",
                    "image/x-pixmap",
                    "image/x-portable-bitmap",
                    "image/x-portable-graymap",
                    "image/x-portable-greymap",
                    "image/x-portable-pixmap",
                    "image/x-tiff",
                    "image/x-xbitmap",
                    "image/x-xbm",
                    "image/xbm",
                    "image/xpm"]

const MIMEImageType = Union{[MIME{Symbol(tp)} for tp in imagetypes]...}

# The tmux terminal multiplexer rewrites some escape sequences. See
# <https://iterm2.com/utilities/imgcat> for details.

# tmux requires unrecognized OSC sequences to be wrapped with DCS
# tmux; <sequence> ST, and for all ESCs in <sequence> to be replaced
# with ESC ESC. It only accepts ESC backslash for ST. We use TERM
# instead of TMUX because TERM gets passed through ssh.

function istmux()
    term = get(ENV, "TERM", "")
    return startswith(term, "screen") || startswith(term, "tmux")
end

OSC() = istmux() ? "\ePtmux;\e\e]" : "\e]"
ST() = istmux() ? "\a\e\\" : "\a"

function Base.display(::ITerm2Display, m::MIMEImageType, x)
    # Get a string representation of the MIME type
    tp = string(typeof(m).parameters[1])
    @assert typeof(m) == MIME{Symbol(tp)}
    # Convert to that MIME type, and then encode in base64
    im = base64encode(repr(tp, x))
    # Output the image with the right escape sequence, as described on
    # <https://iterm2.com/documentation-images.html>
    sz = length(im)
    write(stdout, OSC(), "1337;File=[size=$(sz);inline=1]:", im, ST())
    return nothing
end

function Base.display(d::ITerm2Display, x)
    # Note: Should we try other image types as well? Or should we try
    # to find the best image type?
    if !showable("image/png", x)
        # fall through to the Displays lower in the display stack
        throw(MethodError(display, "nope"))
    end
    display(d, "image/png", x)
    return nothing
end

function __init__()
    Base.Multimedia.pushdisplay(ITerm2Display())
    return nothing
end

end
