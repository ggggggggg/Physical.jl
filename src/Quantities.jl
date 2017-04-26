include("PUnits.jl")
include("Uncertainty.jl")
module Quantities
using PUnits, Uncertainty
# adding methods to:
import Base: promote_rule, convert, show, sqrt, +, *, -, /, ^, .*, ./, .^, ==, getindex, setindex!, size, ndims, endof, length, isapprox,
<, >, >=, <=, .!=, .==, .<, .>, .>=, .<=

typealias QValue  Union{Number, AbstractArray, Uncertain} # things that go inside a Quantity
# Quantity is where most of the action happens
# Quantity combines a value with some units
# Quantities can be reduced to base units via asbase, which uses the UnitSytem Dict
# all other conversions are call on asbase
type Quantity{T<:QValue}
    value::T
    unit::Unit
end
function Quantity_(x::QValue, y::Unit)
    if asbase(y) == Unitless
        return asbase(Quantity(x,y))
    end
    Quantity(x,y)
end
Quantity(x::Quantity, y::Unit) = error("Quantity{Quantity} not allowed")
# UnitSytem by example with SI units
# UnitSystem["J"] = a quantity with other units that is equal to a Joule
# UnitSystem["m"] = 0 which markes it as a non-prefixed base unit
UnitSystem = Dict{String, Union{Quantity, Int}}() # I should figure out how to give DefaultUnitSystem a type
reset_unit_system() = [pop!(UnitSystem, k) for (k,v) in UnitSystem]
function QUnit(x::AbstractString; prefix=0)
    return Quantity(1,Unit(x,prefix))
end
function BaseUnit(x::AbstractString; prefix=0, latex="", system=UnitSystem)
    system[x] = prefix # base units have their prefix as the dict value
    return Quantity(1,Unit(x,prefix))
end
function DerivedUnit(x::AbstractString, y::Quantity; latex="", system=UnitSystem)
    x=convert(String, x)
    system[x] = y
    return Quantity(1,Unit(x))
end
function asbase(x::Quantity, system=UnitSystem)
    x, x.unit
    prefactor, prefixless_unit = remove_prefix(x.unit)
    out=prefactor*x.value
    for (unitsymbol,n) in prefixless_unit.d
        next = system[unitsymbol.sym]
        if isa(next,Quantity)
            out *= asbase(next, system)^n
        elseif isa(next,Int) # next is the prefix of a base unit
            out *= (10.^-(next*n))*QUnit(unitsymbol.sym, prefix=next)^n
        else
            throw(ValueError())
        end
    end
    return out
end

function asbase(x::Unit, system=UnitSystem)
    out=Unitless
    for (unitsymbol,n) in x.d
        next = system[unitsymbol.sym]
        if isa(next,Quantity)
            out *=  asbase(next.unit, system)^n
        elseif isa(next,Int) # next is the prefix of a base unit
            out *= Unit(unitsymbol.sym,next)^n
        else
            throw(ValueError())
        end
    end
    return out
end
function as(from::Quantity, to::Quantity, system=UnitSystem) # warning, ignores the value of to, only looks at the units
    out = Quantity(1, to.unit)
    f,t = asbase(from, system), asbase(out, system)
    f.unit == t.unit ? out *= f.value./t.value : error("incompatible base units $(f.unit) and $(t.unit)")
    return out
end
# this is purposfully the only way to use a Prefix
*(x::Prefix, y::Quantity) = length(y.unit.d) == 1 ? Quantity(y.value, x*y.unit) : error("Prefix*Quantity only defined for Quantities with only one unit")
function *{T,S}(x::Quantity{T}, y::Quantity{S})
    xp,xu = remove_prefix(x.unit)
    yp,yu = remove_prefix(y.unit)
    Quantity_(xp*yp*x.value*y.value, xu*yu)
end
*(x::Quantity, y::QValue) = Quantity_(x.value*y, x.unit)
*(x::QValue, y::Quantity) = y*x
function .*{T,S}(x::Quantity{T}, y::Quantity{S})
    xp,xu = remove_prefix(x.unit)
    yp,yu = remove_prefix(y.unit)
    Quantity_(xp*yp*(x.value.*y.value), xu*yu)
end
.*(x::Quantity, y::QValue) = Quantity_(x.value.*y, x.unit)
.*(x::QValue, y::Quantity) = y.*x
function /{T,S}(x::Quantity{T}, y::Quantity{S})
    xp,xu = remove_prefix(x.unit)
    yp,yu = remove_prefix(y.unit)
    Quantity_((xp/yp)*(x.value/y.value), xu/yu)
end
/(x::Quantity, y::QValue) = Quantity_(x.value/y, x.unit)
/(x::QValue, y::Quantity) = Quantity_(x/y.value, y.unit^-1)
function ./{T,S}(x::Quantity{T}, y::Quantity{S})
    xp,xu = remove_prefix(x.unit)
    yp,yu = remove_prefix(y.unit)
    Quantity_((xp/yp)*(x.value./y.value), xu/yu)
end
./(x::Quantity, y::QValue) = Quantity_(x.value./y, x.unit)
./(x::QValue, y::Quantity) = Quantity_(x/y.value, y.unit^-1)
+{T,S}(x::Quantity{T}, y::Quantity{S}) = Quantity_(x.value + as(y,x).value, x.unit)
-{T,S}(x::Quantity{T}, y::Quantity{S}) = Quantity_(x.value - as(y,x).value, x.unit)
-{T}(x::Quantity{T}) = Quantity_(-x.value, x.unit)
^{T}(x::Quantity{T}, y::Rational) = Quantity_(x.value^convert(AbstractFloat,y), x.unit^convert(AbstractFloat,y))
^{T}(x::Quantity{T}, y::Integer) = Quantity_(x.value^convert(AbstractFloat,y), x.unit^convert(AbstractFloat,y))
^{T}(x::Quantity{T}, y::Number) = Quantity_(x.value^convert(AbstractFloat,y), x.unit^convert(AbstractFloat,y))
.^{T}(x::Quantity{T}, y::Rational) = Quantity_(x.value.^convert(AbstractFloat,y), x.unit.^convert(AbstractFloat,y))
.^{T}(x::Quantity{T}, y::Integer) = Quantity_(x.value.^convert(AbstractFloat,y), x.unit.^convert(AbstractFloat,y))
.^{T}(x::Quantity{T}, y::Number) = Quantity_(x.value.^convert(AbstractFloat,y), x.unit.^convert(AbstractFloat,y))
for f in (:(==), :<, :>, :>=, :<=, :.!=, :(.==), :.<, :.>, :.>=, :.<=, :.!=, :isapprox)
    @eval begin function ($f)(x::Quantity, y::Quantity)
                    a = asbase(x)
                    b = asbase(y)
                    assert(a.unit == b.unit)
                    ($f)(a.value,b.value)
                end end
end
sqrt(x::Quantity) = Quantity_(sqrt(x.value), x.unit^.5)
getindex(x::Quantity, y...) = Quantity_(getindex(x.value, y...),x.unit)
setindex!(x::Quantity, y::Quantity, z...) = setindex!(x.value, as(y,x).value, z...)
setindex!(x::Quantity, y, z...) = error("x[z]=y requires same units, x.unit=$(x.unit), y has no units. use x[z] = y*same_units or x.value[z] = y instead")
size(x::Quantity) = size(x.value)
ndims(x::Quantity) = ndims(x.value)
endof(x::Quantity) = endof(x.value)
length(x::Quantity) = length(x.value)
Base.round(x::Quantity, y) = Quantity(round(x.value,y), x.unit)

function show{T}(io::IO, x::Quantity{T})
    show(io, x.value)
    print(io, " ")
    show(io, x.unit)
end

export BaseUnit, DerivedUnit, Prefix, asbase, as, Uncertain

end #end module
