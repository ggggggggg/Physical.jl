# define imerial units - from http://en.wikipedia.org/w/index.php?title=Imperial_units&oldid=574336154
# Length
const Inch = QUnit("in", 254//10000*Meter)
const Foot = QUnit("ft", 12*Inch)
const Yard = QUnit("yd", 0.9144*Meter) # wikipedia says this is exact
const Furlong = QUnit("fur", 220*Yard)
const Chain = QUnit("ch", 22*Yard)
const Mile = QUnit("mi", 1760*Yard)
const League = QUnit("lea", 3*Mile)
const Fathom = QUnit("ftm", 1.853184*Meter)

# Area
const Perch = 1//102400*Mile^2
const Rood = 1//2560*Mile^2
const Acre = 1//640*Mile^2

# Mass + Weight
const Pound = QUnit("lb",4.44822162*Newton)
const Slug = QUnit("slug", 14.5939029*KiloGram) 