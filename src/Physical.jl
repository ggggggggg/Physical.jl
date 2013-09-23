import Base: promote_rule, convert, show, sqrt, +, *, -, /, ^, .*, ./, .^, ==

macro promote_type(x) # useful for debugging promote_rule issues
    promote_type(map((y)->typeof(y) == y ? y : typeof(y), eval(x))...)
end
type Unit <: Number
        d::Dict{UTF8String, Float64}
end
defaultget(x::Dict, key::String) = haskey(x, key) ? x[key] : float64(0)
Unit() = Unit(Dict{UTF8String, Float64}())
function Unit(x::String)
    z = Unit()
    z.d[convert(UTF8String, x)] = 1.0
    return z
end
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

typealias QValue  Union(Real, Complex{Float64}, ImaginaryUnit)

immutable Quantity{T<:QValue} <: Number
    value::T
    unit::Unit
end
Quantity_(x::Number, y::Unit) = y == Unitless ? x : Quantity(x,y)
Quantity(x::Quantity, y::Unit) = error("Quantity{Quantity} not allowed")

type QArray{T<:QValue, N} <: AbstractArray
    value::Array{T, N}
    unit::Unit
end
QArray_(x::Array, y::Unit) = y == Unitless ? x : QArray(x,y)
QArray_(x::QValue, unit::Unit) = Quantity_(x, unit) # enables a[1] to return a Quantity
QArray(x::QArray, unit::Unit) = error("QArray{QArray} not allowed")
typealias QType Union(Unit, Quantity, QArray)

-(x::Unit) = x^-1.0
/(x::Unit, y::Unit) = *(x,y^-1.0)
==(x::Unit, y::Unit) = x.d==y.d
+(x::Unit, y::Unit) = error("cannot add Units")
-(x::Unit, y::Unit) = error("cannot subtract Units")
*(x::Unit, y::QValue) = Quantity_(y, x)
*(x::QValue, y::Unit) = *(y,x)

*{T,S}(x::Quantity{T}, y::Quantity{S}) = Quantity_(x.value*y.value, x.unit*y.unit)
/{T,S}(x::Quantity{T}, y::Quantity{S}) = Quantity_(x.value/y.value, x.unit/y.unit)
+{T,S}(x::Quantity{T}, y::Quantity{S}) = x.unit == y.unit ? Quantity_(x.value+y.value, x.unit) : error("x=$x cannot add with y=$y because units are not equal")
-{T,S}(x::Quantity{T}, y::Quantity{S}) = x.unit == y.unit ? Quantity_(x.value-y.value, x.unit) : error("x=$x cannot subtract with y=$y because units are not equal")
-{T}(x::Quantity{T}) = Quantity_(-x.value, x.unit)
^{T}(x::Quantity{T}, y::Integer) = Quantity_(x.value^y, x.unit^y)
^{T}(x::Quantity{T}, y::Rational) = Quantity_(x.value^y, x.unit^y)
^{T}(x::Quantity{T}, y::QValue) = Quantity_(x.value^y, x.unit^y) # I get errors about ambiguity if I don't define this for n::Integer
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

# QArray
+(x::QArray, y::QArray) = x.unit == y.unit ? QArray_(x.value+y.value, x.unit) : error("x=$x cannot add with y=$y because units are not equal")
-(x::QArray, y::QArray) = x.unit == y.unit ? QArray_(x.value-y.value, x.unit) : error("x=$x cannot add with y=$y because units are not equal")
-(x::QArray) = QArray(-x.value, x.unit)
*(x::QArray, y::QArray) = QArray_(x.value*y.value, x.unit*y.unit)
*(x::QArray, y::Number) = QArray_(x.value*y, x.unit)
*(x::Number, y::QArray) = y*x
*(x::Array, y::Unit) = QArray_(x, y)
*(x::Array, y::QType) = QArray_(x*y.value, y.unit)
*(x::QType, y::Array) = y*x
/(x::QType, y::QType) = QArray_(x.value/y.value, x.unit/y.unit)
/(x::QType, y::Array) = QArray_(x.value/y, x.unit)
/(x::Array, y::QType) = QArray_(y.value/x, y.unit)
/(x::Unit, y::Union(QArray, Array)) = QArray_(y.value, x/y.unit)
/(x::Union(QArray, Array), y::Unit) = QArray_(x.value, y.unit/y)
./(x::QArray, y::QArray) = QArray_(x.value./y.value, x.unit/y.unit)
./(x::QArray, y::Array) = QArray_(x.value/y, x.unit)
./(x::Array, y::QArray) = QArray_(x/y.value, y.unit)
^(x::QArray, y::Integer) = QArray_(x.value^y, x.unit^y)
^(x::QArray, y::QValue) = QArray_(x.value^y, x.unit^y)
.^(x::QArray, y::QValue) = QArray_(x.value.^y, x.unit^y)
Base.getindex(x::QArray, y...) = QArray_(getindex(x.value, y...),x.unit)
Base.setindex!(x::QArray, y, z...) = setindex!(x.value, y, z...)
Base.size(x::QArray) = size(x.value)
Base.ndims(x::QArray) = ndims(x.value)
Base.endof(x::QArray) = endof(x.value)
Base.length(x::QArray) = length(x.value)

convert{T,N,S,N2}(::Type{QArray{T,N}}, x::Array{S,N2}) = QArray(convert(promote_type(Array{promote_type(T,S),N}),x), Unitless)

#promote_rule{T,N,S}(::Type{Array{T,N}}, ::Type{Quantity{S}}) = QArray{promote_rule{T,S},N}
#promote_rule(::Type{AbstractArray}, ::Type{Unit}) = QArray
#promote_rule{T,N,S}(::Type{QArray{T,N}}, ::Type{Quantity{S}}) = QArray{promote_rule{T,S},N}
#promote_rule(::Type{QArray}, ::Type{Unit}) = QArray{T,N}
#promote_rule(::Type{QArray}, ::Type{Number}) = QArray{T,N}

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
function show{T}(io::IO, x::Quantity{T})
    show(io, x.value)
    print(io, " ")
    show(io, x.unit)
end
function show(io::IO, x::QArray)
    show(io, x.value)
    print(io, " ")
    show(io, x.unit)
end

# actual units
const Unitless = Unit()
const Meter = Quantity(1,Unit("m"))
const Second = Quantity(1, Unit("s"))
const KiloGram = Quantity(1, Unit("kg"))
const Mole = Quantity(1, Unit("mol"))
const Candela = Quantity(1, Unit("cd"))
const Radian = Quantity(1, Unit("rad"))
const Ampere = Quantity(1, Unit("A"))
const Photon = Quantity(1, Unit("\u0194"))

const Newton = KiloGram*Meter/Second^2
const Joule = Newton*Meter
const Coulomb = Ampere*Second
const Volt = Joule/Coulomb
const Ohm = Volt/Ampere
const Hertz = 1/Second


Gram = 1//1000*KiloGram

aJoule = 1*Joule
aMeter = 1*Meter

#GramMeter = Gram*Meter
ComplexForce = (1+2.0*im)*Newton

a = [1,2,3,4]*Meter # becomes array of quantities, not QArray
b = [1 2 3 4]*Newton
#a+a
#a.*a
#a*b
a.^2



