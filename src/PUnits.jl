module PUnits
import Base: promote_rule, convert, show, sqrt, +, *, -, /, ^, .*, ./, .^, ==

type UnitSymbol
    sym::UTF8String # unit symbol, ie "m"
    pre::Int16      # integer representing power of 10 of prefix, ie 3 represents kilo
end
UnitSymbol(sym::String, pre::Int) = UnitSymbol(convert(UTF8String, sym), int16(pre))
Base.hash(x::UnitSymbol) = hash("$(x.sym),$(x.pre)") # make UnitSymbol act nice with Dict
Base.isequal(x::UnitSymbol, y::UnitSymbol) = x.sym==y.sym && x.pre==y.pre
PrefixSystem = Dict{Int16, UTF8String}()
type Prefix
    pre::Int16
end
function Prefix(sym::String, pre::Int)
    PrefixSystem[int16(pre)] = convert(UTF8String, sym)
    return Prefix(int16(pre))
end
type Unit
        d::Dict{UnitSymbol, Float64} # dict of exponents for unitsymbols
end
function Unit(x::String, y::Int=0)
    z = Unit()
    z.d[UnitSymbol(x,y)] = 1.0
    return z
end
Unit() = Unit(Dict{UnitSymbol, Float64}())
const Unitless = Unit()

function remove_prefix(x::Unit)
    z = Unit()
    total_power = 0
    for (unitsymbol, exponent) in x.d
        z.d[UnitSymbol(unitsymbol.sym,0)] = exponent
        total_power += unitsymbol.pre*exponent
    end
    return 10^total_power, z # prefactor, unit without prefix
end
defaultget(x::Dict, key::UnitSymbol) = haskey(x, key) ? x[key] : float64(0)
function *(x::Unit, y::Unit)
    z = Unit()
    combined_units = union(keys(x.d), keys(y.d))
    for u in combined_units
        new_exponent = float64(float32(defaultget(x.d,u)+defaultget(y.d,u))) # round to float32 precision
        if new_exponent != 0.0
                z.d[u] = new_exponent
        end
    end
    return z
end
function ^(x::Unit,y::Integer)
    z = Unit()
    for (k,v) in x.d
            z.d[k] = v*y
    end
    return z
end
function ^(x::Unit,y::Rational)
    z = Unit()
    for (k,v) in x.d
            z.d[k] = v*y
    end
    return z
end
function ^(x::Unit,y::Number)
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

function *(x::Prefix, y::Unit)
    length(y.d) != 1 ? error("Prefix*Unit only allowed for single units, length(Unit.d) = $(y.d)") : 0
    for (unitsymbol, exponent) in y.d
        exponent != 1 ? error("Prefix*Unit only allowed for single units with exponent==1, y=$(y), exponent=$exponent") : 0
        z = Unit()
        z.d[UnitSymbol(unitsymbol.sym, unitsymbol.pre+x.pre)] = float64(1)
        return z
    end
end


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
prettyround(x::Float64) = x%1 == 0 ? int64(round(x)) : x
function show(io::IO,x::Unit)
    if isempty(x.d)
        print(io, "Unitless")
    end
    for (unitsymbol, exponent) in x.d
        if exponent == 1
            show(io, unitsymbol)
            print(io, " ")
        elseif exponent != 0
            show(io, unitsymbol)
            print(io, superscript(prettyround(exponent)))
        end
    end
end
function show(io::IO, unitsymbol::UnitSymbol)
    if haskey(PrefixSystem, unitsymbol.pre)
        print(io, PrefixSystem[unitsymbol.pre]*unitsymbol.sym)
    else
        print(io,"(10"*superscript(unitsymbol.pre)*unitsymbol.sym*")")
    end
end
function show(io::IO, prefix::Prefix)
    print(io, "Prefix $(prefix.pre) => "*get(PrefixSystem, prefix.pre, "10"*superscript(prefix.pre)))
end

export Unit, Unitless, Prefix, remove_prefix

end
