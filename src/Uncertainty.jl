module Uncertainty

# adding methods to
import Base: promote_rule, convert, show, sqrt, +, *, -, /, ^, .*, ./, .^, ==, log, log10, exp, isapprox, signif

type Uncertain{T<:Number}
    v::T # value
    u::T # uncertainty standard deviation
end
Uncertain_(v,u) = u >= 0 ? Uncertain(v,u) : error("Uncertain(v=$v, u=$u) u>=0 required")
correlation(x::Uncertain,y::Uncertain) = 0.0
covariance(x::Uncertain,y::Uncertain)  = 0.0
Uncertain(x::Number, y::Number) = Uncertain(convert(AbstractFloat, x), convert(AbstractFloat, y))
Uncertain(x::Number) = Uncertain(x, convert(typeof(x), 0))

quadsum_neg(x::Number...) = sqrt(sum(sign([x...]).*([x...].^2)))
+(x::Uncertain, y::Uncertain) = Uncertain_(x.v+y.v, quadsum_neg(x.u,+y.u,covariance(x,y)))
+(x::Uncertain, y::Number) = x+Uncertain(y)
+(x::Number, y::Uncertain) = Uncertain(x)+y
-(x::Uncertain) = Uncertain(-x.v, x.u)
-(x::Uncertain, y::Uncertain) = x + -y
-(x::Uncertain, y::Number) = x-Uncertain(y)
-(x::Number, y::Uncertain) = Uncertain(x)-y
*(x::Uncertain, y::Uncertain) = (v = x.v*y.v; Uncertain_(v, v*quadsum_neg(x.u/x.v, y.u/y.v, 2*x.u*y.u*correlation(x,y)/(x.v*y.v))))
*(x::Uncertain, y::Number) = x*Uncertain(y)
*(x::Number, y::Uncertain) = Uncertain(x)*y
/(x::Uncertain, y::Uncertain) = (v = x.v/y.v; Uncertain_(v, v*quadsum_neg(x.u/x.v, y.u/y.v, -2*x.u*y.u*correlation(x,y)/(x.v*y.v))))
/(x::Uncertain, y::Number) = x/Uncertain(y)
/(x::Number, y::Uncertain) = Uncertain(x)/y
log(x::Uncertain) = (v = log(x.v); Uncertain_(v, x.u/x.v))
log(::Irrational{:e},x::Uncertain) = log(x)
log(base::Number, x::Uncertain) = (v = log(base,x.v); Uncertain_(v, x.u/(x.v*log(base))))
log10(x::Uncertain) = log(10, x)
^(x::Uncertain, y::Uncertain) = error("x^y with both ::Uncertain not implemented, don't know formula")
^(x::Uncertain, y::Integer) = (v = x.v^convert(AbstractFloat,y); Uncertain_(v, abs(v*y*x.u/x.v)))
^(x::Uncertain, y::Rational) = (v = x.v^convert(AbstractFloat,y); Uncertain_(v, abs(v*y*x.u/x.v)))
^(x::Uncertain, y::Number) = (v = x.v^y; Uncertain_(v, abs(v*y*x.u/x.v)))
^{T<:AbstractFloat}(x::Irrational{:e}, y::Uncertain{T}) = exp(y)
^{s,T<:AbstractFloat}(x::Irrational{s}, y::Uncertain{T}) = convert(T, eval(s))^y
^(x::Number, y::Uncertain) = (v = x^y.v; Uncertain_(v, abs(v*log(x)*y.u)))
exp(x::Uncertain) = (v = exp(x.v); Uncertain_(v, abs(v*x.u)))
^{T<:Number}(x::Irrational{:e},y::Uncertain{T}) = exp(y)
==(x::Uncertain, y::Uncertain) = ==(x.v,y.v) && ==(x.u,y.u)
isapprox(x::Uncertain, y::Uncertain) = isapprox(x.v, y.v) && isapprox(x.u, y.u)

promote_rule{T<:AbstractFloat, S<:AbstractFloat}(::Type{Uncertain{T}}, ::Type{Uncertain{S}}) = Uncertain{promote_type(T,S)}

convert{T<:AbstractFloat, S<:AbstractFloat}(::Type{Uncertain{T}}, x::Uncertain{S}) = Uncertain(convert(T,x.v), convert(T,x.u))
#convert(::Type{Uncertain{BigFloat}}, x::Uncertain) = Uncertain(convert(BigFloat, x.v), convert(BigFloat,x.u))

function show(io::IO, x::Uncertain)
	v, u = sprintf_signif(x)
    print(io, v)
    print(io, " ± ")
    print(io, u)
end
n_signif(x::Uncertain) = iceil(log10(x.v/x.u))
signif(x::Uncertain) = Uncertain(signif(x.v,n_signif(x)),x.u)

# try to show an appropriate number of significant digits
function sprintf_signif(x::Uncertain)
	n = n_signif(x)
	n <= 1 ? (return repr(x.v), repr(x.u)) : 0
	after_dec = iceil(-log10(x.u))
	if after_dec <= 0
		v = sprintf("%d", signif(x.v,n))
	elseif after_dec >= -3
		v = sprintf("%0.$(after_dec)f", x.v)
	else
		v = sprintf("%.$(n-1)e",x.v)
	end
	after_dec = iceil(1-log10(x.u))
	if after_dec <= 0
		u = sprintf("%d", signif(x.u,2))
	elseif after_dec <= 3
		u = sprintf("%0.$(after_dec)f", x.u)
	else
		u = sprintf("%.1e", x.u)
	end
	return v,u
end
sprintf(fmt::AbstractString,args...) = @eval @sprintf($fmt,$(args...))
# because of the macro @sprintf its hard to do dynamic precision strings https://groups.google.com/forum/#!msg/julia-dev/P50UdTGKkRI/KCPnQ6LqH44J
# more discussion: https://github.com/JuliaLang/julia/issues/4248#issuecomment-24196846

export Uncertain
end
