StatusLine = {}

local Git = require("git")

local MODES = {
    n = "Normal",
    i = "Insert",
    v = "Visual(C)",
    V = "Visual(L)",
    s = "Select(C)",
    S = "Select(L)",
    ["^V"] = "Visual(B)",
    ["CTRL-S"] = "Select(B)",
    i = "Insert",
    c = "Command"
}

StatusLine.Mode = function()
    local mode = vim.api.nvim_get_mode()
    local modekey = mode["mode"]
    if MODES[modekey] == nil then
        return modekey
    end
    return MODES[modekey]
end

-- StatusLine.VCSCurrentBranchName = function()
--     local f = Git.CurrentBranch
--     local status, branch = pcall(f)
--     if status then
--         return branch
--     end
--     return ""
-- end

local f = io.open(".git/HEAD", "r")
branchname = f:read("*all")

StatusLine.VCSCurrentBranchName = function()
    return branchname
end

fsevent = vim.loop.new_fs_event()
callback = function()
  local f = io.open(".git/HEAD", "r")
  branchname = f:read("*all")
  f:close()
end
fsevent:start(".git/HEAD", {}, callback)

vim.api.nvim_set_option("laststatus", 2) -- Enable statusline display

local statusline = ""
statusline = statusline .. "%#PmenuSel# %{luaeval('StatusLine.Mode()')} %#LineNr#" -- Mode
statusline = statusline .. "%#CursorColumn#"
statusline = statusline .. " %{luaeval('StatusLine.VCSCurrentBranchName()')} " -- Git Branch
statusline = statusline .. "%f" -- Filename
statusline = statusline .. "%m" -- Modified flag

-- Right side Components
statusline = statusline .. "%=" -- Justify right
statusline = statusline .. "%y" -- File type
-- Encoding (such as utf-8) and line ending
statusline = statusline .. " [%{&fileencoding?&fileencoding:&encoding} | %{&fileformat}] "

statusline = statusline .. " %p%% " -- Cursor position of the line (in percent)
statusline = statusline .. " %l:%c " -- Line Number and Column number.

vim.api.nvim_set_option("statusline", statusline)

return StatusLine
