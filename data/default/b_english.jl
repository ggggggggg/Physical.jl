# define imerial units - from http://en.wikipedia.org/w/index.php?title=Imperial_units&oldid=574336154
# Length
const Inch = DerivedUnit("in", 254//10000*Meter)
const Foot = DerivedUnit("ft", 12*Inch)
const Yard = DerivedUnit("yd", 0.9144*Meter) # wikipedia says this is exact
const Furlong = DerivedUnit("fur", 220*Yard)
const Chain = DerivedUnit("ch", 22*Yard)
const Mile = DerivedUnit("mi", 1760*Yard)
const League = DerivedUnit("lea", 3*Mile)
const Fathom = DerivedUnit("ftm", 1.853184*Meter)

# Area
const Perch = 1//102400*Mile^2
const Rood = 1//2560*Mile^2
const Acre = 1//640*Mile^2

# Mass + Weight
const Pound = DerivedUnit("lb",4.44822162*Newton)
const Slug = DerivedUnit("slug", 14.5939029*KiloGram) 