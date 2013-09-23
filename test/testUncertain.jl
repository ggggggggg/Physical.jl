using UncertainNumber


a = Uncertain(1.0,0.1)
b = Uncertain(2.0, 0.05)
x = Uncertain(5.7, 1)
y = Uncertain(0.1, 0.1)
x*y
a*b+x+b
b^2
a*b^-2
x/b
