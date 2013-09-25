using Physical

mm = Milli*Meter

println(Physical.Quantitys.remove_prefix(convert(UTF8String,"mm")))
println(Physical.Quantitys.remove_prefix(Physical.Quantitys.Unit("mm")))
println(Physical.Quantitys.remove_prefix(mm))
