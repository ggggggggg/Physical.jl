module PUnits
import Base: promote_rule, convert, show, sqrt, +, *, -, /, ^, .*, ./, .^, ==
# UnitSymbol was added to support prefixes
type UnitSymbol
    sym::String # unit symbol, ie "m"
    pre::Int16      # integer representing power of 10 of prefix, ie 3 represents kilo
end
UnitSymbol(sym::AbstractString, pre::Int) = UnitSymbol(convert(String, sym), Int16(pre))
Base.hash(x::UnitSymbol) = hash("$(x.sym),$(x.pre)") # make UnitSymbol act nice with Dict
Base.isequal(x::UnitSymbol, y::UnitSymbol) = x.sym==y.sym && x.pre==y.pre
PrefixSystem = Dict{Int16, String}()
reset_prefix_system() = [pop!(PrefixSystem, k) for (k,v) in PrefixSystem]
type Prefix
    pre::Int16
end
function Prefix(sym::AbstractString, pre::Int)
    PrefixSystem[Int16(pre)] = convert(String, sym)
    return Prefix(Int16(pre))
end
# Unit keeps track of unit symbols and powers, it has no idea how a symbol relates to
# any other symbol
type Unit
        d::Dict{UnitSymbol, Float64} # dict of exponents for unitsymbols
end
function Unit(x::AbstractString, prefix::Int=0)
    z = Unit()
    z.d[UnitSymbol(x,prefix)] = 1.0
    return z
end
Unit() = Unit(Dict{UnitSymbol, Float64}())
const Unitless = Unit()

function remove_prefix(x::Unit)
    z = Unit()
    total_power = 0
    for (unitsymbol, exponent) in x.d
        z.d[UnitSymbol(unitsymbol.sym,0)] = exponent + defaultget(z.d, UnitSymbol(unitsymbol.sym,0))
        total_power += unitsymbol.pre*exponent
    end
    filter!((k,v)->v!=0,z.d)
    return 10^total_power, z # prefactor, unit without prefix
end
defaultget(x::Dict, key::UnitSymbol) = haskey(x, key) ? x[key] : Float64(0)
function *(x::Unit, y::Unit)
    z = Unit()
    combined_units = union(keys(x.d), keys(y.d))
    for u in combined_units
        # round to Float32 precision so we dont end up with m^1e-12
        # going all the way to Float32 precision is probably overkill
        new_exponent = Float64(Float32(defaultget(x.d,u)+defaultget(y.d,u))) # round to Float32 precision
        if new_exponent != 0.0
                z.d[u] = new_exponent
        end
    end
    return z
end
function ^(x::Unit,y::Integer) # there must be a shorter way to define ^
    z = Unit()
    for (k,v) in x.d
            z.d[k] = v*y
    end
    return z
end
function ^(x::Unit,y::Rational)
    z = Unit()
    for (k,v) in x.dNao
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
        z.d[UnitSymbol(unitsymbol.sym, unitsymbol.pre+x.pre)] = Float64(1)
        return z
    end
end


# printing Text

superscript(c::Char) = "⁰¹²³⁴⁵⁶⁷⁸⁹·⁻"[[1,4,6,8,10,13,16,19,22,25,28,30][search("0123456789.-", c)]]
superscript(x::Number) = map(superscript,repr(x))
prettyround(x::Float64) = x%1 == 0 ? Int64(round(x)) : x
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
