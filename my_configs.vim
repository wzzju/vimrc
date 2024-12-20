" peaksea/ir_black/dracula, default is peaksea
colorscheme monokai
" highlight the current line
set cursorline
" show the line number
set number
" set term shell
set shell=/bin/bash
" enable mouse support only in visual mode and insert mode
set mouse=vi

" highlight color
highlight Search ctermbg=yellow ctermfg=black
highlight IncSearch ctermbg=black ctermfg=yellow
highlight MatchParen cterm=underline ctermbg=NONE ctermfg=NONE

" settings about c++ syntax highlighting
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_posix_standard = 1
let g:cpp_concepts_highlight = 1
let g:cpp_experimental_template_highlight = 1
" cppm syntax highlight
au BufNewFile,BufRead *.cppm set ft=cpp
au BufNewFile,BufRead *.xpu set ft=cpp

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
autocmd FileType c,cpp setlocal commentstring=//\ %s

" auto indent 2 characters
set tabstop=2
set shiftwidth=2

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
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0

" settings of clang-format
let g:clang_format#code_style = "google"
let g:clang_format#style_options = {
      \ "Language" : "Cpp",
      \ "TabWidth" : 2,
      \ "ContinuationIndentWidth" : 4,
      \ "AccessModifierOffset" : -1,
      \ "Standard" : "Cpp11",
      \ "AllowAllParametersOfDeclarationOnNextLine" : "true",
      \ "BinPackParameters" : "false",
      \ "BinPackArguments" : "false",
      \ "IncludeBlocks" : "Preserve"}
" formatting is executed on the save event
let g:clang_format#auto_format = 1
" automatically detects the style file like .clang-format
let g:clang_format#detect_style_file = 1
" map to <Leader>cf in C/C++ code
autocmd FileType c,cpp nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp vnoremap <buffer><Leader>cf :ClangFormat<CR>
" auto-enabling auto-formatting
autocmd FileType c,cpp ClangFormatAutoEnable
" toggle auto formatting:
nnoremap <Leader>ec :ClangFormatAutoToggle<CR>

" use black to format python files
" let g:black_use_virtualenv = 'true'
" let g:black_virtualenv = '/work/.virtualenvs/develop'
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

" rust file detection, syntax highlighting, formatting
autocmd FileType rust nnoremap <buffer><Leader>rf :<C-u>RustFmt<CR>
let g:rustfmt_autosave = 1
let g:rustfmt_command = "rustfmt"

" shell format
let g:shfmt_extra_args = '-i 2'
let g:shfmt_fmt_on_save = 0
autocmd FileType sh nnoremap <buffer><Leader>sf :<C-u>Shfmt<CR>
autocmd FileType sh vnoremap <buffer><Leader>sf :Shfmt<CR>

" settings of Language Server Protocol
if executable('clangd')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'clangd',
    \ 'cmd': {server_info->['clangd']},
    \ 'allowlist': ['c', 'cpp', 'objc', 'objcpp'],
    \ })
endif
if executable('pylsp')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'pylsp',
    \ 'cmd': {server_info->['pylsp']},
    \ 'allowlist': ['python'],
    \ })
endif
" rustup component add rust-analyzer
if executable('rust-analyzer')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'rust-analyzer',
    \ 'cmd': {server_info->['rust-analyzer']},
    \ 'allowlist': ['rust'],
    \ })
endif
if executable('bash-language-server')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'bash-language-server',
    \ 'cmd': {server_info->[&shell, &shellcmdflag, 'bash-language-server start']},
    \ 'allowlist': ['sh', 'bash'],
    \ })
endif
if executable('cmake-language-server')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'cmake',
    \ 'cmd': {server_info->['cmake-language-server']},
    \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'build/'))},
    \ 'whitelist': ['cmake'],
    \ 'initialization_options': {
    \   'buildDirectory': 'build',
    \ }
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

  let g:lsp_format_sync_timeout = 1000
  autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
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

" settings for ALE
let g:ale_linters = {
      \ 'rust': ['cargo', 'clippy'],
      \ 'python': ['pylsp'],
      \ }
" ~/.config/pycodestyle:
" [pycodestyle]
" ignore = E501
" max-line-length=100
let g:ale_fixers = {
      \ 'rust': ['cargo', 'rustfmt']
      \ }
let g:ale_rust_cargo_use_clippy = 1
" Disable ALE from parsing the compile_commands.json file,
" because the compile_commands.json file can be very huge.
let g:ale_c_parse_compile_commands = 1
let g:ale_set_highlights = 1
let g:ale_lint_on_enter = 1
let g:ale_cpp_cc_options = '-std=c++17 -Wall'
let g:ale_cpp_clangtidy_checks = ['-*','cppcoreguidelines-*']
" --filter=-readability/todo,-whitespace/todo
let g:ale_cpp_cpplint_options = '-whitespace/line_length,-build/c++11,+build/include_what_you_use'
let g:ale_c_cpplint_options = '-whitespace/line_length,-build/c++11,+build/include_what_you_use'
nnoremap <Leader><Leader> :<C-u>ALEToggle<CR>
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

" settings of rainbow parentheses
let g:rainbow_active = 1
let g:rainbow_conf = {
  \	  'separately': {
  \	    'nerdtree': 0,
  \	  }
  \ }

augroup glyph_palette_install
  autocmd! *
  autocmd FileType fern call glyph_palette#apply()
  autocmd FileType nerdtree,startify call glyph_palette#apply()
augroup END

" Mode Cursor Settings
let &t_SI.="\e[5 q" "SI = INSERT mode
let &t_SR.="\e[4 q" "SR = REPLACE mode
let &t_EI.="\e[1 q" "EI = NORMAL mode (ELSE)

" apt install ctags
" brew install ctags
nmap <Leader>t :TagbarToggle<CR>
