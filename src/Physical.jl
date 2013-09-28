include("Quantitys.jl")
module Physical
using Quantitys
export as, asbase, QUnit, Prefix
export Uncertain

# looks in Physical/data and loads files in alpabetical order
# stores load order in Physica.loaded_files for debugging
datapath = normpath(dirname(Base.source_path()), "../data")
loaded_files = sort(readdir(datapath)) 
for filename in loaded_files
	include(joinpath(datapath,filename))
end


end # end module
