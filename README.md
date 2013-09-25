```Physical``` provides simple support for units in Julia, as well a nice set of predefined units and constants. So lets start with an example

```
julia> using Physical
julia> d = 1*Meter
1 m 
julia> f = 1*Joule/Physical.h_plank
1.5091903117461535e33 s⁻¹
```
Using units is as simple as multiplying any number or array by the predefined unit constants. Once you are using units it will keep you from doing stupid things like
```
julia> d+f
ERROR: x=1 m  cannot add with y=1.5091903117461535e33 s⁻¹ because units are not equal
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
Create new units with ```QUnit```. Convert units to base units and other units using ```asbase``` and ```as```.  Warning, when you use ```as(from,to)``` it uses the unit of `to` but ignores the value of `to`.
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

```QUnit(x::String)``` creates a new base unit.  ```QUnit(x::String, y::Quantity)``` creates a new derived unit.  I'm going to use this to switch my base mass unit to the slug.
```
julia> Slug = QUnit("slug")
1 slug 
julia> QUnit("kg", 0.0685217659*Slug)
1 kg 
julia> asbase(KiloGram)
0.0685217659 slug 
```

Planned features: LaTex printing in iJulia, a function that guesses a nice ways to simplifiy the units. Maximally accurate fundamental units from CODATA. 
