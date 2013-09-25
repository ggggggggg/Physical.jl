include("Units.jl")
module Quantitys
using Units
# adding methods to:
import Base: promote_rule, convert, show, sqrt, +, *, -, /, ^, .*, ./, .^, ==, getindex, setindex!, size, ndims, endof, length, isapprox

typealias QValue  Union(Number, AbstractArray)
abstract HasUnits
type Quantity{T<:QValue} <: HasUnits
    value::T
    unit::Unit
end
Quantity_(x::QValue, y::Unit) = asbase(y) == Unitless ? x : Quantity(x,y) # return a normal julia object when unitless
Quantity(x::Quantity, y::Unit) = error("Quantity{Quantity} not allowed")

default_unit_system = Dict{UTF8String, Quantity}() # I should figure out how to give DefaultUnitSystem a type
function QUnit(x::String, system=default_unit_system)
    delete!(system, x) # remove from unit system to mark as base unit
    return Quantity(1,Unit(x))
end
function QUnit(x::String, y::Quantity, system=default_unit_system)
    x=convert(UTF8String, x)
    system[x] = y
    return Quantity(1,Unit(x))
end
function asbase(x::Quantity, system=default_unit_system)
    out=x.value
    for (symbol,n) in x.unit.d
        if haskey(system,symbol)
            out *= asbase(system[symbol], system)^n
        else # if it doesn't have they key, then symbol is a base unit
            out *= QUnit(symbol)^n
        end
    end
    return out
end
function asbase(x::Unit, system=default_unit_system)
    out=Unitless
    for (symbol,n) in x.d
        if haskey(system,symbol)
            out *= asbase(system[symbol].unit, system)^n
        else # if it doesn't have they key, then symbol is a base unit
            out *= Unit(symbol)^n
        end
    end
    return out
end
function as(from::Quantity, to::Quantity, system=default_unit_system) # warning, ignores the value of to, only looks at the units
    out = Quantity(1, to.unit)
    f,t = asbase(from, system), asbase(out, system)
    f.unit == t.unit ? out *= f.value./t.value : error("incompatible base units $(f.unit) and $(t.unit)")
    return out
end


*{T,S}(x::Quantity{T}, y::Quantity{S}) = Quantity_(x.value*y.value, x.unit*y.unit)
*(x::Quantity, y::QValue) = Quantity_(x.value*y, x.unit)
*(x::QValue, y::Quantity) = y*x
.*{T,S}(x::Quantity{T}, y::Quantity{S}) = Quantity_(x.value.*y.value, x.unit*y.unit)
.*(x::Quantity, y::QValue) = Quantity_(x.value.*y, x.unit)
.*(x::QValue, y::Quantity) = y.*x
/{T,S}(x::Quantity{T}, y::Quantity{S}) = Quantity_(x.value/y.value, x.unit/y.unit)
/(x::Quantity, y::QValue) = Quantity_(x.value/y, x.unit)
/(x::QValue, y::Quantity) = y/x
./{T,S}(x::Quantity{T}, y::Quantity{S}) = Quantity_(x.value./y.value, x.unit./y.unit)
./(x::Quantity, y::QValue) = Quantity_(x.value./y, x.unit)
./(x::QValue, y::Quantity) = y./x
+{T,S}(x::Quantity{T}, y::Quantity{S}) = x.unit == y.unit ? Quantity_(x.value+y.value, x.unit) : error("x=$x cannot add with y=$y because units are not equal")
-{T,S}(x::Quantity{T}, y::Quantity{S}) = x.unit == y.unit ? Quantity_(x.value-y.value, x.unit) : error("x=$x cannot subtract with y=$y because units are not equal")
-{T}(x::Quantity{T}) = Quantity_(-x.value, x.unit)
^{T}(x::Quantity{T}, y::Rational) = Quantity_(x.value^convert(FloatingPoint,y), x.unit^convert(FloatingPoint,y))
^{T}(x::Quantity{T}, y::Integer) = Quantity_(x.value^convert(FloatingPoint,y), x.unit^convert(FloatingPoint,y))
^{T}(x::Quantity{T}, y::Number) = Quantity_(x.value^convert(FloatingPoint,y), x.unit^convert(FloatingPoint,y))
.^{T}(x::Quantity{T}, y::Rational) = Quantity_(x.value.^convert(FloatingPoint,y), x.unit.^convert(FloatingPoint,y))
.^{T}(x::Quantity{T}, y::Integer) = Quantity_(x.value.^convert(FloatingPoint,y), x.unit.^convert(FloatingPoint,y))
.^{T}(x::Quantity{T}, y::Number) = Quantity_(x.value.^convert(FloatingPoint,y), x.unit.^convert(FloatingPoint,y))
isapprox(x::Quantity, y::Quantity) = x.unit == y.unit && isapprox(x.value, y.value)
for f in (:(==), :<, :>, :>=, :<=, :.!=, :(.==), :.<, :.>, :.>=, :.<=, :.!=, :isapprox)
    @eval begin function ($f)(x::Quantity, y::Quantity)
                    a = asbase(x)
                    b = asbase(y)
                    a.unit == b.unit && ($f)(a.value,b.value)
                end end
end
sqrt(x::Quantity) = Quantity_(sqrt(x.value), x.unit)
getindex(x::Quantity, y...) = Quantity_(getindex(x.value, y...),x.unit)
setindex!(x::Quantity, y::Quantity, z...) = setindex!(x.value, as(y,x).value, z...)
setindex!(x::Quantity, y, z...) = error("x[z]=y reqires same units, x.unit=$(x.unit), y has no units. use x[z] = y*same_units or x.value[z] = y instead")
size(x::Quantity) = size(x.value)
ndims(x::Quantity) = ndims(x.value)
endof(x::Quantity) = endof(x.value)
length(x::Quantity) = length(x.value)

function show{T}(io::IO, x::Quantity{T})
    show(io, x.value)
    print(io, " ")
    show(io, x.unit)
end

export QUnit, asbase, as

end #end module






