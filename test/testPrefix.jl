using Physical, Base.Test

mm = Physical.Milli*Meter

println(Physical.Quantitys.remove_prefix(convert(UTF8String,"mm")))
println(Physical.Quantitys.remove_prefix(Physical.Quantitys.Unit("mm")))
println(Physical.Quantitys.remove_prefix(mm))

@test isapprox(Physical.Mega*Physical.ElectronVolt/Physical.Joule, 1.60217657e-13)
