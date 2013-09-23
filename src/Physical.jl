import Base: promote_rule, convert, show, sqrt, +, *, -, /, ^, .*, ./, .^, ==

macro promote_type(x) # useful for debugging promote_rule issues
    promote_type(map((y)->typeof(y) == y ? y : typeof(y), eval(x))...)
end


typealias QValue  Union(Real, Complex{Float64}, ImaginaryUnit)
immutable Unit <: Number
    powers::Array{Float64}
end
immutable Quantity{T<:QValue} <: Number
    value::T
    unit::Unit
end
type SIArray{T<:QValue, N} <: AbstractArray
    value::Array{T, N}
    unit::Unit
end
typealias SIType Union(Unit, Quantity, SIArray)
SIArray(x::QValue, unit::Unit) = Quantity(x, unit) # enables a[1] to return a Quantity


+(x::Unit, y::Unit) = error("cannot add Units")
-(x::Unit, y::Unit) = error("cannot subtract Units")
*(x::Unit, y::Unit) = Unit(x.powers+y.powers)
*(x::Unit, y::QValue) = Quantity(y, Unitless)*x
*(x::QValue, y::Unit) = *(y,x)
/(x::Unit, y::Unit) = Unit(x.powers-y.powers)
^(x::Unit, y::Integer) = Unit(x.powers*(y==0 ? 1: y)) # I get errors about ambiguity if I don't define this for n::Integer
^(x::Unit, y::Rational) = Unit(x.powers*(y==0 ? 1: y))
^(x::Unit, y::QValue) = Unit(x.powers*(y==0 ? 1: y))
==(x::Unit, y::Unit) = x.powers == y.powers

*{T,S}(x::Quantity{T}, y::Quantity{S}) = Quantity(x.value*y.value, x.unit*y.unit)
/{T,S}(x::Quantity{T}, y::Quantity{S}) = Quantity(x.value/y.value, x.unit/y.unit)
+{T,S}(x::Quantity{T}, y::Quantity{S}) = x.unit == y.unit ? Quantity(x.value+y.value, x.unit) : error("x=$x cannot add with y=$y because units are not equal")
-{T,S}(x::Quantity{T}, y::Quantity{S}) = x.unit == y.unit ? Quantity(x.value-y.value, x.unit) : error("x=$x cannot subtract with y=$y because units are not equal")
-{T}(x::Quantity{T}) = Quantity(-x.value, x.unit)
^{T}(x::Quantity{T}, y::Integer) = Quantity(x.value^n, x.unit^y)
^{T}(x::Quantity{T}, y::Rational) = Quantity(x.value^n, x.unit^y)
^{T}(x::Quantity{T}, y::QValue) = Quantity(x.value^n, x.unit^y) # I get errors about ambiguity if I don't define this for n::Integer
sqrt(x::Quantity) = x^(1/2)


convert{T<:QValue}(::Type{Quantity{T}}, x::Unit) = Quantity{T}(convert(T,1), x)
convert{T<:QValue}(::Type{Quantity{T}}, x::QValue) = Quantity(convert(T,x), Unitless)
convert{T<:QValue, S<:QValue}(::Type{Quantity{T}}, x::Quantity{S}) = Quantity(convert(T,x.value), x.unit)
convert{T<:QValue, S<:QValue}(::Type{T}, x::Quantity{S}) = convert(T,x.value)

promote_rule(::Type{Bool}, ::Type{Unit}) = Quantity
promote_rule{T<:QValue}(::Type{T}, ::Type{Unit}) = Quantity{T}
promote_rule{S<:QValue}(::Type{Bool}, ::Type{Quantity{S}}) = Quantity{S}
promote_rule{S<:QValue}(::Type{Unit}, ::Type{Quantity{S}}) = Quantity{S}
promote_rule{T<:QValue,S<:QValue}(::Type{T}, ::Type{Quantity{S}}) = Quantity{promote_type(T,S)}
promote_rule{T<:QValue,S<:QValue}(::Type{Quantity{T}}, ::Type{Quantity{S}}) = Quantity{promote_type(T,S)}

# SIArray
+(x::SIArray, y::SIArray) = x.unit == y.unit ? SIArray(x.value+y.value, x.unit) : error("x=$x cannot add with y=$y because units are not equal")
-(x::SIArray, y::SIArray) = x.unit == y.unit ? SIArray(x.value-y.value, x.unit) : error("x=$x cannot add with y=$y because units are not equal")
-(x::SIArray) = SIArray(-x.value, x.unit)
*(x::SIArray, y::SIArray) = SIArray(x.value*y.value, x.unit*y.unit)
.*(x::SIArray, y::SIArray) = SIArray(x.value.*y.value, x.unit*y.unit)
/(x::SIArray, y::SIArray) = SIArray(x.value/y.value, x.unit/y.unit)
./(x::SIArray, y::SIArray) = SIArray(x.value./y.value, x.unit/y.unit)
^(x::SIArray, y::Integer) = SIArray(x.value^y, x.unit^y)
^(x::SIArray, y::QValue) = SIArray(x.value^y, x.unit^y)
.^(x::SIArray, y::QValue) = SIArray(x.value.^y, x.unit^y)
Base.getindex(x::SIArray, y...) = SIArray(getindex(x.value, y...),x.unit)
Base.setindex!(x::SIArray, y, z...) = setindex!(x.value, y, z...)
Base.size(x::SIArray) = size(x.value)
Base.ndims(x::SIArray) = ndims(x.value)
Base.endof(x::SIArray) = endof(x.value)
Base.length(x::SIArray) = length(x.value)

convert{T,N,S,N2}(::Type{SIArray{T,N}}, x::Array{S,N2}) = SIArray(convert(promote_type(Array{promote_type(T,S),N}),x), Unitless)

Base.sin(x::SIType) = x.unit == Unitless ? SIArray(sin(x.value), Unitless) : error("sin(x) require unitless argument")


const UnitSymbols = ["m", "kg", "s", "A", "K", "mol", "cd"]
const Meter    = Unit(float64([1,0,0,0,0,0,0]))
const KiloGram = Unit(float64([0,1,0,0,0,0,0]))
const Second   = Unit(float64([0,0,1,0,0,0,0]))
const Ampere   = Unit(float64([0,0,0,1,0,0,0]))
const Kelvin   = Unit(float64([0,0,0,0,1,0,0]))
const Mole     = Unit(float64([0,0,0,0,0,1,0]))
const Candela  = Unit(float64([0,0,0,0,0,0,1]))
const Unitless = Unit(float64([0,0,0,0,0,0,0]))
const Gram       = (1//1000)KiloGram
const CentiMeter = (1//100)Meter

const Joule      = KiloGram*Meter^2/Second^2
const Newton     = KiloGram*Meter/Second^2

aJoule = Quantity(1, Joule)
aMeter = Quantity(1, Meter)

GramMeter = Gram*Meter
ComplexForce = (1+2.0*im)*Newton

a = SIArray([1,2,3,4],Meter)
b = SIArray([1 2 3 4], Newton)
a+a
a.*a
a*b
a.^2
sin(aMeter/Meter)

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
    if x.powers == float64([0,0,0,0,0,0,0])
        print(io, "Unitless")
    end
    for i in 1:length(UnitSymbols)
        if x.powers[i] == 1
            print(io, UnitSymbols[i]*"\u200a")
        elseif x.powers[i] != 0
            print(io, UnitSymbols[i]*superscript(x.powers[i]))
        end
    end
end
function show{T}(io::IO, x::Quantity{T})
    show(io, x.value)
    print(io, " ")
    show(io, x.unit)
end
function show(io::IO, x::SIArray)
    show(io, x.value)
    print(io, " ")
    show(io, x.unit)
end

