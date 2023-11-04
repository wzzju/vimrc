" peaksea/ir_black/dracula, default is peaksea
colorscheme monokai
" highlight the current line
set cursorline
" show the line number
set number

" highlight color
highlight Search ctermbg=yellow ctermfg=black
highlight IncSearch ctermbg=black ctermfg=yellow
highlight MatchParen cterm=underline ctermbg=NONE ctermfg=NONE

" xpu syntax highlighting
au BufNewFile,BufRead *.xpu set ft=cpp
" settings about c++ syntax highlighting
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_posix_standard = 1
let g:cpp_concepts_highlight = 1
let g:cpp_experimental_template_highlight = 1

set undofile
set undodir=~/.vim_runtime/temp_dirs/undodir
" maximum number of changes that can be undone
set undolevels=1000
" maximum number lines to save for undo on a buffer reload
set undoreload=10000

set backup
set backupdir=~/.vim_runtime/temp_dirs/backupdir
" make backup before overwriting the current buffer
set writebackup
" overwrite the original backup file
set backupcopy=yes
" meaningful backup name, ex: filename@2015-04-05.14:59
au BufWritePre * let &bex = '@' . strftime("%F.%H:%M")

set swapfile
set directory=~/.vim_runtime/temp_dirs/swapdir

" better Unix / Windows compatibility
set viewoptions=folds,options,cursor,unix,slash

" use // instead of /**/
autocmd FileType c,cpp,xpu setlocal commentstring=//\ %s

" auto indent 4 characters
set tabstop=4
set shiftwidth=4

" settings of gitgutter
set updatetime=100
let g:gitgutter_enabled = 1

" Check if NERDTree is open or active
function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction
" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction
" Highlight currently open buffer in NERDTree
autocmd BufEnter * call SyncTree()
function! ToggleNerdTree()
  set eventignore=BufEnter
  NERDTreeToggle
  set eventignore=
endfunction
nmap <leader>nn :call ToggleNerdTree()<CR>
" settings of NERDTree
let g:NERDTreeWinPos = "left"

" settings of indentLine
let g:indentLine_enabled = 1
let g:indentLine_char = '▏'
let g:indentLine_showFirstIndentLevel = 0
let g:indentLine_first_char = '▏'
nnoremap <Leader>ei :IndentLinesToggle<CR>

" settings of vim-markdown
let g:vim_markdown_conceal_code_blocks = 0

" settings of clang-format
let g:clang_format#code_style = "google"
let g:clang_format#style_options = {
      \ "BasedOnStyle": "Google",
      \ "AccessModifierOffset": -4,
      \ "AlignAfterOpenBracket": "AlwaysBreak",
      \ "AlignOperands": "false",
      \ "AllowAllParametersOfDeclarationOnNextLine": "false",
      \ "AllowShortBlocksOnASingleLine": "false",
      \ "AllowShortCaseLabelsOnASingleLine": "false",
      \ "AllowShortFunctionsOnASingleLine": "Empty",
      \ "AllowShortIfStatementsOnASingleLine": "false",
      \ "AllowShortLoopsOnASingleLine": "false",
      \ "AlwaysBreakAfterReturnType": "None",
      \ "AlwaysBreakTemplateDeclarations": "true",
      \ "BinPackArguments": "false",
      \ "BinPackParameters": "false",
      \ "BreakConstructorInitializers": "AfterColon",
      \ "ColumnLimit": 100,
      \ "ConstructorInitializerIndentWidth": 8,
      \ "ContinuationIndentWidth": 8,
      \ "DerivePointerAlignment": "true",
      \ "FixNamespaceComments": "true",
      \ "IndentCaseLabels": "false",
      \ "IndentWidth": 4,
      \ "MaxEmptyLinesToKeep": 1,
      \ "NamespaceIndentation": "None",
      \ "PenaltyBreakAssignment": 2,
      \ "PenaltyBreakBeforeFirstCallParameter": 1,
      \ "PenaltyBreakComment": 500,
      \ "PenaltyBreakFirstLessLess": 120,
      \ "PenaltyBreakString": 1000,
      \ "PenaltyExcessCharacter": 1000000,
      \ "PenaltyReturnTypeOnItsOwnLine": 400,
      \ "PointerAlignment": "Left",
      \ "SortIncludes": "true"}
" formatting is executed on the save event
let g:clang_format#auto_format = 1
" automatically detects the style file like .clang-format
let g:clang_format#detect_style_file = 1
" map to <Leader>cf in C/C++ code
autocmd FileType c,cpp,xpu nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,xpu vnoremap <buffer><Leader>cf :ClangFormat<CR>
" auto-enabling auto-formatting
autocmd FileType c,cpp,xpu ClangFormatAutoEnable
" toggle auto formatting:
nnoremap <Leader>ec :ClangFormatAutoToggle<CR>

" use black to format python files
" let g:black_virtualenv = '~/.virtualenvs/develop'
let g:black_skip_string_normalization = 1
let g:black_linelength = 100
autocmd FileType python nnoremap <buffer><Leader>pf :<C-u>Black<CR>
autocmd FileType python vnoremap <buffer><Leader>pf :BlackVisual<CR>
autocmd BufWritePre *.py silent execute ':Black'
" use isort to sort python imports
let g:vim_isort_config_overrides = {
  \ 'profile': 'black',
  \ 'line_length': 100,
  \ }
let g:vim_isort_map = '<Leader>i'
autocmd FileType python nnoremap <buffer><Leader>i :<C-u>Isort<CR>
autocmd BufWritePre *.py silent execute ':Isort'

" use dart-vim-plugin to format dart files
autocmd FileType dart nnoremap <buffer><Leader>df :<C-u>DartFmt<CR>
autocmd BufWritePre *.dart silent execute ':DartFmt'

" settings of Language Server Protocol
if executable('clangd')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'clangd',
    \ 'cmd': {server_info->['clangd']},
    \ 'allowlist': ['c', 'cpp', 'xpu', 'objc', 'objcpp'],
    \ })
endif
if executable('pylsp')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'pylsp',
    \ 'cmd': {server_info->['pylsp']},
    \ 'allowlist': ['python'],
    \ })
endif
if executable('bash-language-server')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'bash-language-server',
    \ 'cmd': {server_info->[&shell, &shellcmdflag, 'bash-language-server start']},
    \ 'allowlist': ['sh', 'bash'],
    \ })
endif
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  nmap <buffer> gf <plug>(lsp-definition)
  nmap <buffer> ff <plug>(lsp-peek-definition)
  nmap <buffer> gj <plug>(lsp-declaration)
  nmap <buffer> fj <plug>(lsp-peek-declaration)
  nmap <buffer> gk <plug>(lsp-type-definition)
  nmap <buffer> fk <plug>(lsp-peek-type-definition)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> fi <plug>(lsp-peek-implementation)
  nmap <buffer> gs <plug>(lsp-document-symbol-search)
  nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
  nmap <buffer> <Leader>rn <plug>(lsp-rename)
  nmap <buffer> [g <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <plug>(lsp-next-diagnostic)
  nmap <buffer> K <plug>(lsp-hover)
  nmap <buffer> <C-c> <plug>(lsp-float-close)
  nmap <buffer> <S-c> <plug>(lsp-preview-close)
  nnoremap <buffer> <expr><S-u> lsp#scroll(-4)
  nnoremap <buffer> <expr><S-d> lsp#scroll(+4)
endfunction
augroup lsp_install
  au!
  " Call s:on_lsp_buffer_enabled only for languages
  " that has the server registered.
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" settings of the git-blame
" set cmdheight=2
nnoremap <Leader>b :<C-u>call gitblame#echo()<CR>

" settings of the markdown previewer
let g:preview_markdown_parser = 'glow'
let g:preview_markdown_auto_update = 1
autocmd FileType markdown nnoremap <F4> :PreviewMarkdown right<CR>

" settings of the full screen display
let g:goyo_width = '100%'
let g:goyo_height = '100%'
let g:goyo_linenr = 1

" Disable the jedi auto-initialization, so that
" just use pylsp for the autocompletion.
let g:jedi#auto_initialization = 0

" Disable ALE from parsing the compile_commands.json file.
" Because the compile_commands.json file can be very huge.
let g:ale_c_parse_compile_commands = 1
let g:ale_set_highlights = 1
let g:ale_lint_on_enter = 1
let g:ale_cpp_cc_options = '-std=c++17 -Wall'
let g:ale_cpp_clangtidy_checks = ['-*','cppcoreguidelines-*']
" let g:ale_cpp_cpplint_options = '--filter=-readability/todo,-whitespace/todo,-whitespace/line_length,-build/c++11,+build/include_what_you_use'
" let g:ale_c_cpplint_options = '--filter=-readability/todo,-whitespace/todo,-whitespace/line_length,-build/c++11,+build/include_what_you_use'
nmap <silent> <Leader>n <Plug>(ale_next_wrap)
nmap <silent> <Leader>p <Plug>(ale_previous_wrap)

let g:copilot_filetypes = {
      \ '*': v:false,
      \ 'python': v:true,
      \ 'cpp': v:true,
      \ 'c': v:true,
      \ }

" settings of asyncomplete
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
imap <a-space> <Plug>(asyncomplete_force_refresh)

" settings of commands of `term` and `vert term`
nnoremap <Leader>v :vert term<CR>
nnoremap <Leader>h :term<CR>
nnoremap <Leader>o :tab term<CR>
tnoremap <Esc><Esc> <C-\><C-N>
" Prohibit vim from running vim in a vim terminal.
if exists('$VIM_TERMINAL')
  echohl WarningMsg | echo "Don't run vim inside a vim terminal!" | echohl None
  quit
endif

" settings of rainbow parentheses
if isdirectory(expand("$HOME/.vim_runtime/my_plugins/rainbow_parentheses.vim"))
  let g:rbpt_colorpairs = [
      \ ['brown',       'RoyalBlue3'],
      \ ['Darkblue',    'SeaGreen3'],
      \ ['darkgray',    'DarkOrchid3'],
      \ ['darkgreen',   'firebrick3'],
      \ ['darkcyan',    'RoyalBlue3'],
      \ ['darkred',     'SeaGreen3'],
      \ ['darkmagenta', 'DarkOrchid3'],
      \ ['brown',       'firebrick3'],
      \ ['gray',        'RoyalBlue3'],
      \ ['darkmagenta', 'DarkOrchid3'],
      \ ['Darkblue',    'firebrick3'],
      \ ['darkgreen',   'RoyalBlue3'],
      \ ['darkcyan',    'SeaGreen3'],
      \ ['darkred',     'DarkOrchid3'],
      \ ['red',         'firebrick3'],
      \ ]
  let g:rbpt_max = 16
  let g:rbpt_loadcmd_toggle = 0
  au VimEnter * RainbowParenthesesToggle
  au Syntax * RainbowParenthesesLoadRound
  au Syntax * RainbowParenthesesLoadSquare
  au Syntax * RainbowParenthesesLoadBraces
  " au Syntax * RainbowParenthesesLoadChevrons
endif

" show function name in vim status bar
fun! ShowFuncName()
  let lnum = line(".")
  let col = col(".")
  echohl ModeMsg
  echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
  echohl None
  call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfun
nnoremap <S-f> :<C-u>call ShowFuncName()<CR>

nnoremap <Leader>a :Ack<Space>
" settings of ctrlsf
nnoremap <Leader>g :CtrlSF<Space>
let g:ctrlsf_auto_preview = 1
let g:ctrlsf_search_mode = 'async'
let g:ctrlsf_position = 'bottom'
let g:ctrlsf_default_view_mode = 'compact'
let g:ctrlsf_default_root = 'project'
