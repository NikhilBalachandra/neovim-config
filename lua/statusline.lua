StatusLine = {}

local Git = require("git")
local IOUtils = require("ioutils")

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

local GIT_BRANCH_FILE = ".git/HEAD"
local branchNameCache = ""
local fsevent = nil

StatusLine.mode = function()
    local mode = vim.api.nvim_get_mode()
    local modekey = mode["mode"]
    if MODES[modekey] == nil then
        return modekey
    end
    return MODES[modekey]
end

StatusLine.VCSCurrentBranchName = function()
    local f = Git.CurrentBranch
    local status, branch = pcall(f)
    if status then
        return branch
    end
    return ""
end

StatusLine.VimEnter = function()
    if IOUtils.file_exists(GIT_BRANCH_FILE) then
        branchNameCache = StatusLine.VCSCurrentBranchName()

        -- Redefine VCSCurrentBranchName function to return value from cache.
        StatusLine.VCSCurrentBranchName = function()
            return branchNameCache
        end

        fsevent = vim.loop.new_fs_event()
        callback = function()
            branchname = Git.CurrentBranch()
        end
        fsevent:start(GIT_BRANCH_FILE, {}, callback)
    end
end

StatusLine.VimLeave = function()
    -- TODO: Blocks exit for few seconds.
    fsevent:stop()
end


vim.api.nvim_set_option("laststatus", 2) -- Enable statusline display

local statusline = ""
statusline = statusline .. "%#PmenuSel# %{luaeval('StatusLine.mode()')} %#LineNr#" -- Mode
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
vim.api.nvim_command("autocmd VimEnter * lua StatusLine.VimEnter()")
vim.api.nvim_command("autocmd VimLeavePre * lua StatusLine.VimLeave()")

return StatusLine
