import Base: promote_rule, convert, show, sqrt, +, *, -, /, ^, .*, ./, .^, ==, log, log10, exp

type Uncertain{T<:Real} <: Real
    v::T # value
    u::T # uncertainty standard deviation
end
Uncertain_(v,u) = u > 0 && v != 0 ? Uncertain(v,u) : error("Uncertain(v=$v, u=$u) v!=0 and u>0 required")
Uncertain(x::Uncertain,y) = error("Uncertain{Uncertain} not allowed")
correlation(x::Uncertain,y::Uncertain) = 0.0
covariance(x::Uncertain,y::Uncertain)  = 0.0
Uncertain(x::Number, y::Number) = Uncertain(convert(FloatingPoint, x), convert(FloatingPoint, y))

quadsum_neg(x::Number...) = sqrt(sum(sign([x...]).*([x...].^2)))
+(x::Uncertain, y::Uncertain) = Uncertain_(x.v+y.v, quadsum_neg(x.u,+y.u,covariance(x,y)))
-(x::Uncertain) = Uncertain(-x.v, x.u)
-(x::Uncertain, y::Uncertain) = x + -y
*(x::Uncertain, y::Uncertain) = Uncertain_(x.v*y.v, quadsum_neg(x.u/x.v, y.u/y.v, 2*x.u*y.u*correlation(x,y)/(x.v*y.v)))
/(x::Uncertain, y::Uncertain) = Uncertain_(x.v/y.v, quadsum_neg(x.u/x.v, y.u/y.v, -2*x.u*y.u*correlation(x,y)/(x.v*y.v)))
log(x::Uncertain) = Uncertain_(log(x.v), x.u/x.v)
log(base::Number, x::Uncertain) = Uncertain_(log(base,x.v), x.u/(x.v*log(base)))
log10(x::Uncertain) = log(10, x)
^(x::Uncertain, y::Uncertain) = error("x^y with both ::Uncertain not implemented, don't know formula")
^(x::Uncertain, y::Number) = Uncertain_(x.v^y, y*x.u/x.v)
^(x::Uncertain, y::Integer) = Uncertain_(x.v^convert(FloatingPoint,y), y*x.u/x.v)
^(x::Number, y::Uncertain) = Uncertain_(x^y.v, log(x)*y.u)
exp(x::Uncertain) = Uncertain_(exp(x.v), x.u)
^{T<:Number}(::MathConst{:e},x::Uncertain{T}) = exp(x)

promote_rule{T<:Number, S<:Number}(::Type{T}, ::Type{Uncertain{S}}) = Uncertain{promote_type(T,S)}
promote_rule{T<:Number, S<:Number}(::Type{Uncertain{T}}, ::Type{Uncertain{S}}) = Uncertain{promote_type(T,S)}
promote_rule{T<:Number}(::Type{T}, ::Type{Uncertain{T}}) = Uncertain{T}

convert{T<:Number, S<:Integer}(::Type{Uncertain{T}},x::S) = Uncertain(x.v, x.u)
convert{T<:Number, S<:Rational}(::Type{Uncertain{T}},x::S) = Uncertain(x.v, x.u)
convert{T<:Integer, S<:Rational}(::Type{Uncertain{T}},x::S) = Uncertain(x.v, x.u)
convert{T<:FloatingPoint}(::Type{Uncertain{T}},x::T) = Uncertain(x.v, x.u)
convert{T<:Number, S<:Number}(::Type{Uncertain{T}}, x::S) = Uncertain(convert(T,x), convert(T,0))
convert{T<:Number}(::Type{Uncertain}, x::T) = Uncertain(x, convert(T,0))
convert{T<:Number}(::Type{Uncertain{T}}, x::T) = Uncertain(x, convert(T,0))
convert(::Type{Uncertain}, x::Uncertain) = Uncertain(x.v, x.u)
convert(::Type{Uncertain{BigFloat}}, x::Uncertain) = Uncertain(convert(BigFloat, x.v), convert(BigFloat,x.u))

function show(io::IO, x::Uncertain)
    show(io, x.v)
    print(io, " \u00b1 ")
    show(io, x.u)
end

a = Uncertain(1.0,0.1)
b = Uncertain(2.0, 0.05)
x = Uncertain(5.7, 1)
y = Uncertain(0.1, 0.1)
x*y
a*b+x+b
b^2
a*b^-2
x/b
