local Git = {}

local io = require("io")

-- TODO: Improve errors. i.e git command not found / not git repository...
Git.CurrentBranch = function()
    for line in io.popen("git branch 2> /dev/null"):lines() do
        local m = line:match("%* (.+)$")
        if m then
            return m
        end
    end
    error("Couldn't determine the branch name")
end

return Git
