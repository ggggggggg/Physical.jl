module Units
import Base: promote_rule, convert, show, sqrt, +, *, -, /, ^, .*, ./, .^, ==

type Unit
        d::Dict{UTF8String, Float64}
end
function Unit(x::String)
    z = Unit()
    z.d[convert(UTF8String, x)] = 1.0
    return z
end
Unit() = Unit(Dict{UTF8String, Float64}())
const Unitless = Unit()

defaultget(x::Dict, key::String) = haskey(x, key) ? x[key] : float64(0)
function *(x::Unit, y::Unit)
    z = Unit()
    combined_units = union(keys(x.d), keys(y.d))
    for u in combined_units
        newpower = float64(float32(defaultget(x.d,u)+defaultget(y.d,u)))
        if newpower != 0.0
                z.d[u] = newpower
        end
    end
    return z
end
function ^(x::Unit,y::Integer)
    y == 0 ? (return x) : 0
    z = Unit()
    for (k,v) in x.d
            z.d[k] = v*y
    end
    return z
end
function ^(x::Unit,y::Rational)
    y == 0 ? (return x) : 0
    z = Unit()
    for (k,v) in x.d
            z.d[k] = v*y
    end
    return z
end
function ^(x::Unit,y::Number)
    y == 0 ? (return x) : 0
    z = Unit()
    for (k,v) in x.d
            z.d[k] = v*y
    end
    return z
end

-(x::Unit) = x^-1.0
/(x::Unit, y::Unit) = *(x,y^-1.0)
==(x::Unit, y::Unit) = x.d==y.d
+(x::Unit, y::Unit) = error("cannot add Units")
-(x::Unit, y::Unit) = error("cannot subtract Units")

# printing Text
superscript(i) = map(repr(i)) do c
    c   ==  '-' ? '\u207b' :
    c   ==  '1' ? '\u00b9' :
    c   ==  '2' ? '\u00b2' :
    c   ==  '3' ? '\u00b3' :
    c   ==  '4' ? '\u2074' :
    c   ==  '5' ? '\u2075' :
    c   ==  '6' ? '\u2076' :
    c   ==  '7' ? '\u2077' :
    c   ==  '8' ? '\u2078' :
    c   ==  '9' ? '\u2079' :
    c   ==  '0' ? '\u2070' :
    c   ==  '.' ? '\u00b7' :
    error("Unexpected Chatacter")
end
function show(io::IO,x::Unit)
    if isempty(x.d)
        print(io, "Unitless")
    end
    for (k,v) in x.d
        if v == 1
            print(io, k*"\u200a")
        elseif v != 0
            print(io, k*superscript(v))
        end
    end
end

export Unit, Unitless

end
