local IOUtils = {}

local io = require("io")

IOUtils.file_exists = function(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

return IOUtils
