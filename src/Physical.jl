include("Quantitys.jl")
include("Uncertainty.jl")
module Physical
using Quantitys, Uncertainty
export as, asbase, QUnit, NewPrefix
export Uncertain

# looks in Physical/data and loads files in alpabetical order
# stores load order in Physica.loaded_files for debugging
datapath = normpath(dirname(Base.source_path()), "../data")
loaded_files = sort(readdir(datapath)) 
for filename in loaded_files
	include(joinpath(datapath,filename))
end


end # end module
