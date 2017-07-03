[![Build Status](https://travis-ci.org/ggggggggg/Physical.jl.svg?branch=master)](https://travis-ci.org/ggggggggg/Physical.jl)

Use `Unitful.jl` instead of this package. This won't be maintained.


```Physical``` provides simple support for arbitrary unit systems in Julia, as well a nice set of predefined units and constants. The keys are the types `Quantity` and `Unit`, but you should just use predefined unit constants for the most part. Since `Physical` is not yet an official package, install with `Pkg.clone("https://github.com/ggggggggg/Physical.jl.git")`.


```
julia> using Physical
julia> f = 1*ElectronVolt/H_planck # H_planck is in units of h, so resulting expression have units with h
1.0 eV h⁻¹
julia> asbase(f)
2.4270444990211597e14 s⁻¹ # all Quantities can be reduced to base units
julia> f+1e9*(Mega*Hertz)
5.120237599283019 eV h⁻¹
julia> 1e9*(Mega*Hertz)+f # adding compatible Quantities casts to units of the first Quantity
1.242704449902116e9 MHz 

```
Using units is as simple as multiplying any number or array by the predefined unit constants. Using units it will keep you from doing stupid things like
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
Create new units with ```DerivedUnit```, unit symbols can be unicode, like that `Ω` above. Convert units to base units and other units using ```asbase``` and ```as```.  Warning, when you use ```as(from,to)``` it uses the unit of `to` but ignores the value of `to`.
```
julia> Foot = DerivedUnit("ft",0.3048*Meter)
1 ft 
julia> l=22*Foot+3*Meter
31.84251968503937 ft 
julia> l*Volt
31.84251968503937 ft V 
julia> asbase(l)
9.7056 m 
julia> as(l,Angstrom)
9.7056e10 Å 
```
```BaseUnit(x::String)``` creates a new base unit. If you just want to add to the existing base units, feel free to use ```BaseUnit```.  If you want to change the base units, on the fly you can. Look at ```testQuantities.jl``` if you want to replace a prefixed base unit like kg. If you add a ``.jl`` file to the ``data/default`` folder it will be loaded in a fixed order automatically by ``Physical``.  This allows you to add or replace units and constants easily. For debugging purposes, ``Physical.loaded_files`` contains the file names in the order they were loaded. Also you can define a totally different unit system in without messing with ```default```, take a look at ```data/what_to_load.jl```.
```
julia> Foot = BaseUnit("ft")
1 ft 
julia> DerivedUnit("m", 3.28084*Foot)
1 m 
julia> asbase(Meter)
3.28084 ft
```
There is also a Type for uncertain numbers, with error propagation. It currently treats the covariance and correlation between numbers as 0.  If you have a good idea of how to implement covariance and correlation, let me know, or do it yourself. It usually chooses a reasonable format given the number of significant digits.  If there is only one significant digit or less it will print out the entire representation of the value and uncertainty, because that usually means something has gone wrong.  There is room to improve the choice of representations.
```
julia> a = Uncertain(100,1)
100 ± 1.0
julia> b = Uncertain(50,0.4)
50.0 ± 0.40
julia> a+b
150 ± 1.1
julia> a*b
5000 ± 64
julia> (a*b*Meter)^2
25000000 ± 640000 m²
```

You can also check out ```SIUnits.jl``` which is similar.  The main difference is that ```SIUnits``` uses the type system and multiple dispatch to have high performance and pretty much just does SI base units. ```Physical``` uses dictionaries to allow for arbitrary units like `eV` instead of a combination of a large prefactor and many other base units.  As a result ```Physical``` is not reccomended for high performance.  You can do something like ```y=eV*Meter*performance_sensitive_function(x/(eV*Meter))``` such that performance sensitive parts of your code don't interact with ```Physical``` at all.

Potential future features
- [ ] LaTeX printing in iJulia
- [ ] Guesses at pretty unit reduction
- [ ] Maximally accurate fundamental units from CODATA

Feel free to start an issue if you have any problems or questions or just want to get in contact with me.
