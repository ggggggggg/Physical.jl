module Uncertainty

# adding methods to
import Base: promote_rule, convert, show, sqrt, +, *, -, /, ^, .*, ./, .^, ==, log, log10, exp

type Uncertain{T<:FloatingPoint} <: FloatingPoint
    v::T # value
    u::T # uncertainty standard deviation
end
Uncertain_(v,u) = u >= 0 ? Uncertain(v,u) : error("Uncertain(v=$v, u=$u) u>=0 required")
correlation(x::Uncertain,y::Uncertain) = 0.0
covariance(x::Uncertain,y::Uncertain)  = 0.0
Uncertain(x::Number, y::Number) = Uncertain(convert(FloatingPoint, x), convert(FloatingPoint, y))
Uncertain(x::FloatingPoint, y::Number) = Uncertain(x, convert(FloatingPoint, y))

quadsum_neg(x::Number...) = sqrt(sum(sign([x...]).*([x...].^2)))
+(x::Uncertain, y::Uncertain) = Uncertain_(x.v+y.v, quadsum_neg(x.u,+y.u,covariance(x,y)))
-(x::Uncertain) = Uncertain(-x.v, x.u)
-(x::Uncertain, y::Uncertain) = x + -y
*(x::Uncertain, y::Uncertain) = (v = x.v*y.v; Uncertain_(v, v*quadsum_neg(x.u/x.v, y.u/y.v, 2*x.u*y.u*correlation(x,y)/(x.v*y.v))))
/(x::Uncertain, y::Uncertain) = (v = x.v/y.v; Uncertain_(v, v*quadsum_neg(x.u/x.v, y.u/y.v, -2*x.u*y.u*correlation(x,y)/(x.v*y.v))))
log(x::Uncertain) = (v = log(x.v); Uncertain_(v, x.u/x.v))
log(base::Number, x::Uncertain) = (v = log(base,x.v); Uncertain_(v, x.u/(x.v*log(base))))
log10(x::Uncertain) = log(10, x)
^(x::Uncertain, y::Uncertain) = error("x^y with both ::Uncertain not implemented, don't know formula")
^(x::Uncertain, y::Integer) = (v = x.v^convert(FloatingPoint,y); Uncertain_(v, abs(v*y*x.u/x.v)))
^(x::Uncertain, y::Rational) = (v = x.v^convert(FloatingPoint,y); Uncertain_(v, abs(v*y*x.u/x.v)))
^(x::Uncertain, y::Number) = (v = x.v^y; Uncertain_(v, abs(v*y*x.u/x.v)))
^{T<:FloatingPoint}(x::MathConst{:e}, y::Uncertain{T}) = exp(y)
^{s,T<:FloatingPoint}(x::MathConst{s}, y::Uncertain{T}) = convert(T, eval(s))^y
^(x::Number, y::Uncertain) = (v = x^y.v; Uncertain_(v, abs(v*log(x)*y.u)))
exp(x::Uncertain) = (v = exp(x.v); Uncertain_(v, abs(v*x.u)))
^{T<:Number}(x::MathConst{:e},y::Uncertain{T}) = exp(y)
==(x::Uncertain, y::Uncertain) = isapprox(x.v,y.v) && isapprox(x.u,y.u)

promote_rule{S<:FloatingPoint}(::Type{Bool}, ::Type{Uncertain{S}}) = Uncertain{S}
promote_rule{T<:Complex, S<:FloatingPoint}(::Type{T}, ::Type{Uncertain{S}}) = Uncertain{S}
promote_rule{S<:FloatingPoint}(::Type{BigFloat}, ::Type{Uncertain{S}}) = Uncertain{BigFloat}
promote_rule{S<:FloatingPoint}(::Type{BigInt}, ::Type{Uncertain{S}}) = Uncertain{BigFloat}
promote_rule{T, S<:FloatingPoint}(::Type{MathConst{T}}, ::Type{Uncertain{S}}) = Uncertain{S}
promote_rule{S<:FloatingPoint}(::Type{Rational}, ::Type{Uncertain{S}}) = Uncertain{promote_type(T,S)}
promote_rule{T<:Real, S<:FloatingPoint}(::Type{T}, ::Type{Uncertain{S}}) = Uncertain{promote_type(T,S)}
promote_rule{T<:FloatingPoint, S<:FloatingPoint}(::Type{Uncertain{T}}, ::Type{Uncertain{S}}) = Uncertain{promote_type(T,S)}
promote_rule{T<:FloatingPoint}(::Type{T}, ::Type{Uncertain{T}}) = Uncertain{T}

convert{T<:FloatingPoint, S<:FloatingPoint}(::Type{Uncertain{T}}, x::Uncertain{S}) = Uncertain(convert(T,x.v), convert(T,x.u))
convert{T<:FloatingPoint,s}(::Type{Uncertain{T}},x::MathConst{s}) = Uncertain(convert(T, eval(s)), convert(T,0))
convert{T<:FloatingPoint, S<:Complex}(::Type{Uncertain{T}},x::S) = error("Uncertain{Complex} not supported")
convert{T<:FloatingPoint, S<:Rational}(::Type{Uncertain{T}},x::S) = Uncertain(convert(T,x),convert(T,0))
convert{T<:FloatingPoint, S<:Number}(::Type{Uncertain{T}},x::S) = Uncertain(convert(T,x),convert(T,0))
convert{T<:FloatingPoint, S<:Real}(::Type{Uncertain{T}},x::S) = Uncertain(convert(T,x),convert(T,0))
convert{T<:FloatingPoint, S<:Integer}(::Type{Uncertain{T}},x::S) = Uncertain(convert(T,x),convert(T,0))
convert{T<:FloatingPoint}(::Type{Uncertain{T}}, x::T) = Uncertain(convert(T,x),convert(T,0))
convert{T<:FloatingPoint}(::Type{Uncertain{T}},x::T) = Uncertain(convert(T,x),convert(T,0))
convert{T<:FloatingPoint, S<:Number}(::Type{Uncertain{T}}, x::S) = Uncertain(convert(T,x), convert(T,0))
convert{T<:FloatingPoint}(::Type{Uncertain}, x::T) = Uncertain(x, convert(T,0))
convert(::Type{Uncertain}, x::Uncertain) = Uncertain(x.v, x.u)
convert(::Type{Uncertain{BigFloat}}, x::Uncertain) = Uncertain(convert(BigFloat, x.v), convert(BigFloat,x.u))

function show(io::IO, x::Uncertain)
    show(io, x.v)
    print(io, " \u00b1 ")
    show(io, x.u)
end

export Uncertain
end
