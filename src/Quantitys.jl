include("Units.jl")
module Quantitys
using Units
# adding methods to:
import Base: promote_rule, convert, show, sqrt, +, *, -, /, ^, .*, ./, .^, ==

typealias QValue  Union(Real, Complex{Float64}, ImaginaryUnit)

immutable Quantity{T<:QValue} <: Number
    value::T
    unit::Unit
end
Quantity_(x::Number, y::Unit) = y == Unitless ? x : Quantity(x,y)
Quantity(x::Quantity, y::Unit) = error("Quantity{Quantity} not allowed")
QUnit(x::String) = Quantity(1,Unit(x))

type QArray{T<:QValue, N} <: AbstractArray
    value::Array{T, N}
    unit::Unit
end
QArray_(x::Array, y::Unit) = y == Unitless ? x : QArray(x,y)
QArray_(x::QValue, unit::Unit) = Quantity_(x, unit) # enables a[1] to return a Quantity
QArray(x::QArray, unit::Unit) = error("QArray{QArray} not allowed")
typealias QType Union(Unit, Quantity, QArray)


*{T,S}(x::Quantity{T}, y::Quantity{S}) = Quantity_(x.value*y.value, x.unit*y.unit)
/{T,S}(x::Quantity{T}, y::Quantity{S}) = Quantity_(x.value/y.value, x.unit/y.unit)
+{T,S}(x::Quantity{T}, y::Quantity{S}) = x.unit == y.unit ? Quantity_(x.value+y.value, x.unit) : error("x=$x cannot add with y=$y because units are not equal")
-{T,S}(x::Quantity{T}, y::Quantity{S}) = x.unit == y.unit ? Quantity_(x.value-y.value, x.unit) : error("x=$x cannot subtract with y=$y because units are not equal")
-{T}(x::Quantity{T}) = Quantity_(-x.value, x.unit)
^{T}(x::Quantity{T}, y::Integer) = Quantity_(x.value^convert(FloatingPoint,y), x.unit^convert(FloatingPoint,y))
^{T}(x::Quantity{T}, y::Rational) = Quantity_(x.value^convert(FloatingPoint,y), x.unit^convert(FloatingPoint,y))
^{T}(x::Quantity{T}, y::QValue) = Quantity_(x.value^y, x.unit^y) # I get errors about ambiguity if I don't define this for n::Integer
sqrt(x::Quantity) = x^(1/2)


convert{T<:QValue}(::Type{Quantity{T}}, x::QValue) = Quantity(convert(T,x), Unitless)
convert{T<:QValue, S<:QValue}(::Type{Quantity{T}}, x::Quantity{S}) = Quantity(convert(T,x.value), x.unit)
convert{T<:QValue, S<:QValue}(::Type{T}, x::Quantity{S}) = convert(T,x.value)


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
*(x::Array, y::QType) = QArray_(x*y.value, y.unit)
*(x::QType, y::Array) = y*x
/(x::QType, y::QType) = QArray_(x.value/y.value, x.unit/y.unit)
/(x::QType, y::Array) = QArray_(x.value/y, x.unit)
/(x::Array, y::QType) = QArray_(y.value/x, y.unit)
/(x::Unit, y::Union(QArray, Array)) = QArray_(y.value, x/y.unit)
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

export QUnit

end #end module






