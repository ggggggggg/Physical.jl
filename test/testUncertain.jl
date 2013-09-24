using Physical
a = Uncertain(2.5,0.4)
b = Uncertain(4.1,0.3)

# these all have covariance = 0
#used http://laffers.net/blog/2010/11/15/error-propagation-calculator/ to calculate test cases
@assert a+b == Uncertain(6.6,0.5)
@assert a-b == Uncertain(-1.6, 0.5)
@assert a*b == Uncertain(10.25, 1.8033579788827288)
@assert a/b == Uncertain(0.6097560975609757, 0.1072788803618518)
@assert log(b) == Uncertain(1.410986973710262, 0.07317073170731708)
@assert log10(b) == Uncertain(0.6127838567197355, 0.03177764501731111)
@assert exp(b) == Uncertain(60.34028759736194, 18.10208627920858)
@assert a^b.v == Uncertain(42.81086821817254,28.083929551121184)
@assert exp(b) == e^b
@assert 1.0/b == Uncertain(0.24390243902439027, 0.017846519928613924)
@assert a^-1.0 == Uncertain(0.4,0.064)
@assert 1*b == b


# BigFloat
c = Uncertain(BigFloat(1), sqrt(BigFloat(2)))
d = Uncertain(BigFloat(2), sqrt(BigFloat(0.1)))
f = (c+c)/2-c

@assert f.v == 0
f^-1;
1^d;

