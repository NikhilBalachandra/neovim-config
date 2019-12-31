-- vimh is a helper function around neovim lua APIs
vimh = {}

-- Helper method to setup augroup from lua
-- Usage:
-- vimh.create_augroup("groupname", {
--     {"WinEnter", "*", [[echo "Event callback trigerred"]]},
--     {"FocusLost,WinLeave", "*", "call luaeval('...')"}
-- })
vimh.create_augroup = function(name, definitions)
    vim.api.nvim_command('augroup ' .. name)
    vim.api.nvim_command('autocmd!')
    for _, def in ipairs(definitions) do
        local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
        vim.api.nvim_command(command)
    end
    vim.api.nvim_command('augroup END')
end

return vimh
