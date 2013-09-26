```Physical``` provides simple support for units in Julia, as well a nice set of predefined units and constants. The keys are the types `Quantity` and `Unit`, but you should just use predefined unit constants for the most part. Since `Physical` is not yet an official package, install with `Pkg.clone("https://github.com/ggggggggg/Physical.jl.git")`.

```
julia> using Physical
julia> f = 1*ElectronVolt/H_plank
1.0 eV h⁻¹
julia> asbase(f)
2.4270444990211597e14 s⁻¹
julia> f+1e9*(Mega*Hertz)
5.120237599283019 eV h⁻¹
julia> 1e9*(Mega*Hertz)+f
1.242704449902116e9 MHz 

```
Using units is as simple as multiplying any number or array by the predefined unit constants. Once you are using units it will keep you from doing stupid things like
```
julia> d = 17*(Milli*Meter)
17 mm 
julia> d+f
ERROR: incompatible base units s⁻¹ and m 
```

Say you want to call ``sin``, but you want to be sure that the argument is in radians?
```
julia> theta = pi/2*Radian
1.5707963267948966 rad 
julia> sin(theta/Radian)
1.0
julia> sin(1*Meter/Radian)
ERROR: no method sin(Quantity{Float64},)
```
This works because any operation that leads to a unitless number, just returns a standard Julia datatype.
```
julia> R=[1,2,3,4]*Ohm
[1,2,3,4] Ω 
julia> R*17*Ampere/(14*Volt)
4-element Float64 Array:
 1.21429
 2.42857
 3.64286
 4.85714
```
Create new units with ```QUnit```, unit symbols can be unicode, like that `Ω` above. Convert units to base units and other units using ```asbase``` and ```as```.  Warning, when you use ```as(from,to)``` it uses the unit of `to` but ignores the value of `to`.
```
julia> Foot = QUnit("ft", 0.3048*Meter)
julia> Pound = QUnit("lb", 4.44822162*Newton)
julia> asbase(12*Foot*Pound)
16.269815397312 m²kg s⁻²
julia> as(12*Foot*Pound, Newton*Meter)
16.269815397312 m N 
julia> as(12*Foot*Pound, 7000*Newton*Meter) # note the value of the second argument doesn't do anything
16.269815397312 m N 
```

```QUnit(x::String)``` creates a new base unit.  ```QUnit(x::String, y::Quantity)``` creates a new derived unit. Both of these will overwrite existing units. I'm going to use this to switch my base mass unit to the slug.
```
julia> Slug = QUnit("slug")
1 slug 
julia> QUnit("kg", 0.0685217659*Slug)
1 kg 
julia> asbase(KiloGram)
0.0685217659 slug 
```
There is also a Type for uncertain numbers, with error propagation. It currently treats the covariance and correlation between numbers as 0.  If you have a good idea of how to implement covariance and correlation, let me know, or do it yourself.
```
julia> a = Uncertain(100,1)
100.0 ± 1.0
julia> b = Uncertain(10,5)
10.0 ± 5.0
julia> a*b
1000.0 ± 500.09999000199946
julia> a-b
90.0 ± 5.0990195135927845
julia> a+b
110.0 ± 5.0990195135927845
julia> (a*b*Meter)^2
1.0e6 ± 1.0001999800039988e6 m²
```
Future features
- [ ] LaTex printing in iJulia
- [ ] Guesses at pretty unit reduction
- [ ] Maximally accurate fundamental units from CODATA
- [ ] Round properly when displaying Uncertain numbers

Feel free to start an issue if you have any problems or questions or just want to get in contact with me.
