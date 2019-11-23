""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                            Basic Vim Config                                  "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set title          " Set the terminal's title.

set relativenumber " Display relative line numbers
set number         " Show line numbers by default.
set numberwidth=2  " Keep the line number gutter narrow so three digits is cozy.

set ignorecase     " Case-insensitive searching (Caveat: see option `smartcase`).
set smartcase      " But case-sensitive if search contains upper case character
set hlsearch       " Highlight matches
set incsearch      " Highlight matches as you type.

set hidden         " Allow buffer to go background without saving changes to disk.
set noautochdir    " Do not automatically change directory.

set tabstop=8      " Number of columns to display for a tab character.
set softtabstop=4  " Controls how many spaces vim use when hitting tab.
set expandtab      " Expand typing tab into N spaces defined by `softtabstop`

set autoindent     " Copy indentation from the previous line. This is only used
                   " when filetype specific indentation from filetype setting
                   " is not used.
set shiftwidth=4   " Control number of spaces for each step of autoindent.
set nosmartindent  " Disable heuristics based indentation. This option should be
                   " only used in cases when not happy with filetype based indentation.

set mouse=         " Disable Mouse

set nowrap         " Don't wrap lines by buffer width.

set undofile       " Make undo available even after closing file or nvim.

set clipboard+=unnamed " Use system clipboard

set nostartofline  " Prevent cursor from moving to beginning of line when
                   " switching buffers

set showmatch      " Show matching brackets when cursor is over them
set matchtime=1    " How many tenths of a second to blink when matching brackets

set colorcolumn=81 " Display coloured line at column specified.
set list listchars=tab:>-,trail:· " Display tabs and trailing spaces.

" Make a copy of the file and overwrite the original one. This is required as
" this make file watchers correctly detect file change. Setting it to no/auto
" will make file watchers not detect change (because of rename).
set backupcopy=yes

" Save backups in first available directory specified in the below list.
" Directory ending with // makes vim use conflict free names when making
" backup copy.
call myhelpers#CreateDirectory('~/.local/share/nvim/backup/')
set backupdir=~/.local/share/nvim/backup//,.

" Enable swap file. Helps recover changes in case vim/computer crashes. Also
" prevents multiple vim/Neovim instances from editing the same file.
set swapfile
call myhelpers#CreateDirectory('~/.local/share/nvim/swap/')
set directory=~/.local/share/nvim/swap//,.

" Enable true colors in terminal Neovim UI.
set termguicolors

" Enable different cursor shapes in terminal Neovim UI.
" FIXME: This is currently known to cause cursor shape leak into other
"        splits/panes in tmux.
set guicursor=i-ci:ver30-iCursor-blinkwait300-blinkon200-blinkoff150

" Complete till longest match. Makes completions in Vim more like bash/zsh.
set wildmode=longest:full,full

" Make completions more IDE like.
" menu: Show completions in a menu.
" longest: Only insert longest common match from the completions.
" preview: Show additional information such as function arguments, type.
set completeopt=menu,longest,preview

set spelllang=en
set spell               " Enable spell checking.

set encoding=utf-8      " The encoding displayed.
set fileencoding=utf-8  " The encoding written to file.

set cmdheight=2         " Better display for messages

" don't give |ins-completion-menu| messages. (Eg: -- XXX completion (YYY), Pattern not found)
set shortmess+=c

set signcolumn=yes      " always show signcolumns

" No screen redrawn while executing macros, registers and other commands.
" Improves scrolling performance.
set lazyredraw

" Don't optimize for reduction in bytes on tty
set ttyfast

set foldenable          " Enable folding
set foldmethod=indent   " Default to fold based on indentation. Using syntax will be very slow.

set wildoptions=pum,tagfile " Use popup menu (pum) to display completions.

" Move netrw local files to .local directory
let g:netrw_home = fnamemodify($MYVIMRC, ":p:h") . '.local/netrw'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                           Remote Plugin Hosts                                "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" To Setup these check ~/.config/nvim/bin/setup-additional-dependencies script
let g:loaded_python_provider = 1 " Disable Python 2 support
let g:python3_host_prog = fnamemodify($MYVIMRC, ":p:h") . '/bin/python3'
let g:ruby_host_prog = fnamemodify($MYVIMRC, ":p:h") . '/bin/ruby'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                 Plugins                                      "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" turn on filetype detection along with loading filetype specific plugin
" and smart indentation.
filetype plugin indent on

let g:MY_MINPAC_DIR='~/.config/nvim/pack/minpac/opt/minpac/'
if !isdirectory(glob(g:MY_MINPAC_DIR . ".git"))
    echo "====================================================================="
    echo "Installing minpac (plugin manager)"
    echo "====================================================================="
    execute "!mkdir -p "  . g:MY_MINPAC_DIR
    execute "!git clone " . "https://github.com/k-takata/minpac.git " . g:MY_MINPAC_DIR
    autocmd VimEnter * call minpac#update() | silent! source $MYVIMRC
endif

packadd minpac
call minpac#init()
" minpac must have {'type': 'opt'} so that it can be loaded with `packadd`.
call minpac#add('k-takata/minpac', {'type': 'opt'})
"" Define user commands for updating/cleaning the plugins.
" Each of them loads minpac, reloads .vimrc to register the
" information of plugins, then performs the task.
command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()

call minpac#add('joshdick/onedark.vim')
augroup on_plugin_load_onedark
  autocmd!
  autocmd VimEnter * colorscheme onedark
augroup END

" Support . (dot; repeat) for the plugins that support it.
call minpac#add('tpope/vim-repeat')

" Columnate text based on delimiter
call minpac#add('junegunn/vim-easy-align')

" Vim easy jumps. Try s{char}{char}
call minpac#add('justinmk/vim-sneak')

" Fuzzy file search
call minpac#add('junegunn/fzf', { 'do': '! ./install --bin' })
call minpac#add('junegunn/fzf.vim')
" Close fzf completion buffer faster when pressing ESC
" https://github.com/junegunn/fzf/issues/632#issuecomment-236959826
if has('nvim')
  aug fzf_setup
    au!
    au TermOpen term://*FZF tnoremap <silent> <buffer><nowait> <esc> <c-c>
  aug END
end

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                 Linter                                       "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call minpac#add('dense-analysis/ale')
let g:ale_completion_enabled = 0 " Disable Ale's completion provider.
let g:ale_disable_lsp = 1 " Disable LSP.
let g:ale_fix_on_save = 0 " Don't automatically fix files on save.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   Ruby                                       "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call minpac#add('vim-ruby/vim-ruby')
let g:rubycomplete_buffer_loading = 0 " Don't load/evaluate code in order to provide completions.
let g:rubycomplete_classes_in_global = 0 " Parse the entire buffer to add a list of classes to the completion results

let g:rubycomplete_rails = 0 " Don't load/evaluate Rails environment.

let g:rubycomplete_load_gemfile = 1 " Load gems in the Gemfile (As they are generally safe to evaluate)
let g:rubycomplete_use_bundler = 1 " Load gems in the Bundler (As they are generally safe to evaluate)

let g:ruby_spellcheck_strings = 1


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                Golang                                        "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call minpac#add('fatih/vim-go')
" disable vim-go :GoDef short cut (gd)
" this is handled by LanguageClient [LC]
let g:go_def_mapping_enabled = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                        Conquer of Completions                                "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call minpac#add('neoclide/coc.nvim', {'branch': 'release'})

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <C-d> <Plug>(coc-range-select)
xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
