StatusLine = {}

local os = require("os")
local Git = require("git")

local MODES = {
    n = "Normal",
    i = "Insert",
    c = "Command",
    v = "V.Char",
    V = "V.Line",
    s = "S.Char",
    S = "S.Line",
    ["^V"] = "V.Block",
    ["CTRL-S"] = "S.Block"
}

local branch_last_determined_at = 0
local branch_name_cache = ""
local BRANCH_CACHE_EXPIRY = 5 -- Number of seconds

-- Determine current mode
StatusLine.mode = function()
    local mode = vim.api.nvim_get_mode()
    local modekey = mode["mode"]
    if MODES[modekey] == nil then
        return modekey
    end
    return MODES[modekey]
end

-- Determine source control branch name for the present working directory.
StatusLine.vcs_current_branch_name = function()
    local current_time = os.time()

    -- Recompute branch name if it was determined earlier than branch cache expiry
    if current_time - branch_last_determined_at > BRANCH_CACHE_EXPIRY then
        local f = Git.CurrentBranch
        local status, branch = pcall(f)
        if status then
            branch_last_determined_at = current_time
            branch_name_cache = branch
            return branch_name_cache
        end
        return ""
    end

    return branch_name_cache
end


vim.api.nvim_set_option("laststatus", 2) -- Enable statusline display

local statusline = ""

-- Add read only flag if set
statusline = statusline .. "%#Error#%r"

-- Mode
statusline = statusline .. "%#PmenuSel# %{luaeval('StatusLine.mode()')} %#LineNr#"

-- Change foreground color
statusline = statusline .. "%#CursorColumn#"

-- Git Branch
statusline = statusline .. " %{luaeval('StatusLine.vcs_current_branch_name()')} "

-- Filename
statusline = statusline .. "%f"

-- Modified
statusline = statusline .. "%m"

-- Justify right
statusline = statusline .. "%="

-- File type
statusline = statusline .. "%y"

-- Encoding (such as utf-8) and line ending
statusline = statusline .. " [%{&fileencoding?&fileencoding:&encoding} | %{&fileformat}] "

-- Cursor position of the line (in percent)
statusline = statusline .. " %p%% " 

-- Line Number and Column number.
statusline = statusline .. " %l:%c "

vim.api.nvim_set_option("statusline", statusline)

return StatusLine
