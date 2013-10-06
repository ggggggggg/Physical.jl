load_unit_system("default")
#load_unit_system("cgs")


# to use cgs instead of default, just comment out line 1 and uncomment line 2
# other systems can be added easily, just make a new folder, fill it with 
# .jl files that define your prefered system and constants, then add
# load_unit_system("FOLDER_NAME") to this file and comment out everything else