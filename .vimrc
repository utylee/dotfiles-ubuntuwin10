set nocompatible
"source $VIMRUNTIME/vimrc_example.vim
"source $VIMRUNTIME/mswin.vim
"behave mswin

if &shell =~# 'fish$'
    set shell=sh
endif

let g:netrw_keepdir=0
runtime macros/matchit.vim

augroup remember_folds
  autocmd!
  autocmd BufWinLeave * mkview
  autocmd BufWinEnter * silent! loadview
augroup END


"10ms is more reasonable value
set timeoutlen=1000 ttimeoutlen=10

"set grepprg=rg\ --color=never
"set grepprg=rg\ --vimgrep

" 밑줄_이 아닌 하이픈- 으로도 파싱을 해주는 것 아닐까 합니다
set iskeyword+=-

set grepprg=ag
set updatetime=1000

let g:simple_todo_map_normal_mode_keys = 0

set rtp+=~/.fzf
let g:fzf_history_dir = '~/.fzf/fzf-history'
let g:fzf_layout = { 'down': '40%' }
let g:fzf_preview_window = []

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'query':   ['fg', 'Ignore'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Ignore'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

let g:terminal_ansi_colors = [
    \ '#073642', '#dc322f', '#859900', '#b58900',
    \ '#268bd2', '#d33682', '#2aa198', '#eee8d5',
    \ '#002b36', '#cb4b16', '#586e75', '#657b83',
    \ '#839496', '#6c71c4', '#93a1a1', '#fdf6e3']

"set t_Co=16
"let g:solarized_termcolors=16

" coc setups  ---------------------------------------------------------
"
"
"
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for apply code actions at the cursor position.
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer.
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for apply refactor code actions.
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument

"
"

" 기존 coc.nvim 설정입니다
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
"inoremap <silent><expr> <TAB>
"      \ pumvisible() ? "\<C-n>" :
"      \ <SID>check_back_space() ? "\<TAB>" :
"      \ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

"function! s:check_back_space() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~# '\s'
"endfunction

"" Use <c-space> to trigger completion.
"if has('nvim')
"  inoremap <silent><expr> <c-space> coc#refresh()
"else
"  inoremap <silent><expr> <c-@> coc#refresh()
"endif

"" Make <CR> auto-select the first completion item and notify coc.nvim to
"" format on enter, <cr> could be remapped by other vim plugin
"inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
"                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
"" Use `[g` and `]g` to navigate diagnostics
"" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
"nmap <silent> [g <Plug>(coc-diagnostic-prev)
"nmap <silent> ]g <Plug>(coc-diagnostic-next)

"" GoTo code navigation.
"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> gr <Plug>(coc-references)

"" Use K to show documentation in preview window.
"nnoremap <silent> K :call <SID>show_documentation()<CR>

"function! s:show_documentation()
"  if (index(['vim','help'], &filetype) >= 0)
"    execute 'h '.expand('<cword>')
"  elseif (coc#rpc#ready())
"    call CocActionAsync('doHover')
"  else
"    execute '!' . &keywordprg . " " . expand('<cword>')
"  endif
"endfunction

"" Highlight the symbol and its references when holding the \ursor.
"autocmd CursorHold * silent call CocActionAsync('highlight')

"" Symbol renaming.
"nmap ,e <Plug>(coc-rename)
"nmap ,d <Plug>(coc-codeaction)

""coc-prettier settings
"command! -nargs=0 Prettier :CocCommand prettier.formatFile
"vmap ;f  <Plug>(coc-format-selected)
""nmap ;f  <Plug>(coc-format-selected)

" 파일저장시 자동 수정이 아닌 수동 수정으로 변경합니다
nmap ;f  :Prettier<CR>
nmap ;g  :Format<CR>


"command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, '--hidden', <bang>0)
" Ag 검색시 파일명이 아닌 컨텐츠에서만 검색코자할 때 쓰는 옵션입니다
" https://github.com/junegunn/fzf.vim/issues/346
" 거기에서 두번째 파라미터로 ag의 옵션을 넣어줬습니다 ag 옵션을 제거하고
" 사용하게끔 했더군요
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, ' --path-to-ignore ~/.ignore', {'options': '--delimiter : --nth 4..'}, <bang>0)

" fzf 에서 Rg 실행시 옵션과 파일명이 아닌 컨텐츠에서의 검색만을 하도록 하는
" 옵션입니다
" https://github.com/junegunn/fzf.vim/issues/346
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)

"command! -bang -nargs=* Ag
"\ call fzf#vim#ag(<q-args>,
"\                 <bang>0 ? fzf#vim#with_preview('up:60%')
"\                         : fzf#vim#with_preview('right:50%:hidden', '?'),
"\                 <bang>0)

function! s:find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

command! ProjectFiles execute 'Files' s:find_git_root()

"let g:ConqueTerm_Interrupt = '<c-c>'
"nnoremap ,c :let @* = expand("%:p").":".line('.')<cr>
nnoremap ,x :let @+ = expand("%:p").":".line('.')<cr>

"set tags+=/home/utylee/temp/azerothcore/src/tags,~/temp/azerothcore/modules/tags
"set tags+=/home/utylee/temp/TrinityCore/src/tags
"set tags+=/home/utylee/temp/projectLegion/src/tags
set tags=tags;/
"set tags+=/home/utylee/temp/SkyFire.548/src/tags

" cpp <---> h 간을 간편하게 바꿔주는 vim 커맨드
nnoremap <F4> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>
"nnoremap <leader>h :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>
"map <leader>0 :cd /home/utylee/temp/TrinityCore/build/src/server/worldserver<cr>  :GdbStart gdb -f worldserver <cr>
		"\ :e new <cr> 
		"\ :GdbStart gdb -f worldserver <cr>

map <leader>0 :cd /home/utylee/temp/projectLegion/build/src/server/worldserver<cr>  :GdbStart gdb -f worldserver <cr>


" 현재파일의 디렉토리로 변경 %->  상대경로파일명, :p-> 절대경로파일명, :h->
" 한마디전으로

nmap <leader>z :cd %:p:h<cr> :pwd<cr>
nmap <leader>Z :ProsessionDelete<cr> :cd %:p:h<cr> :pwd<cr>

" 버퍼를 저장하지 않아도 버퍼간 이동을 가능하게끔합니다
set hidden
set tags=tags;/

"인터렉티브한 쉘을 실행해서 ! ts 를 먹히게 해준다고 하는데 bashrc 를 실행하면
"너무 느려져서 삭제하고 아래와 같이 바꿉니다
"set shell=/bin/bash\ -i
"
" bashrc 의 alias를 읽기 위한 설정입니다
"let $BASH_ENV = "/home/utylee/.bashrc"

"!ts 가 -i 로 인터렉티브하게 안해도 실행되게끔 해줍니다
" 해당 파일안에는 현재 ts 함수만 설정되어 있습니다
let $BASH_ENV = "/home/utylee/.bash_functions"
let vim_markdown_preview_hotkey='<C-m>'

"set term=screen-256color
set backspace=indent,eol,start

" maybe nvim config?
"let g:loaded_python_provider = 1

"osx 터미널 상에서의 인서트모드 커서를 변경합니다.
"let &t_SI = "\<Esc>]50;CursorShape=1\x7"
"let &t_EI = "\<Esc>]50;CursorShape=0\x7"
"osx + tmux 상에서의 인서트모드 커서를 변경합니다.
"let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
"let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"


""""""""""""""""""
" 일반 ubuntu - linux 상에서의 커서설정
"

"에디트(이동)모드커서
let &t_EI .= "\<Esc>[1 q"
"수정(인서트)모드커서
let &t_SI .= "\<Esc>[5 q"

" solid block
" let &t_EI .= "\<Esc>[1 q"
  " 1 or 0 -> blinking block
  " 3 -> blinking underscore
  "	4 -> solid underscore
  " Recent versions of xterm (282 or above) also support
  " 5 -> blinking vertical bar
  " 6 -> solid vertical bar
  
"24bit true color 지원을 위해 추가했던 것 같습니다

let &t_8f="\e[38;2;%ld;%ld;%ldm"
let &t_8b="\e[48;2;%ld;%ld;%ldm"

"set guicolors  "vim 8.0에서 true color 적용문법 번경
set termguicolors
" backround column erase 문제 수정 문법
set t_ut=

"set t_Co=256
"set t_Co=16
"let g:solarized_termcolors=256
"let g:solarized_termcolors=16
"let g:solarized_termtrans=0


"set diffexpr=MyDiff()
"function MyDiff()
  "let opt = '-a --binary '
  "if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  "if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  "let arg1 = v:fname_in
  "if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  "let arg2 = v:fname_new
  "if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  "let arg3 = v:fname_out
  "if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  "let eq = ''
  "if $VIMRUNTIME =~ ' '
    "if &sh =~ '\<cmd'
      "let cmd = '""' . $VIMRUNTIME . '\diff"'
      "let eq = '"'
    "else
      "let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    "endif
  "else
    "let cmd = $VIMRUNTIME . '\diff'
  "endif
  "silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
"endfunction

"set runtimepath=~/.vim
"==================================================================
"set nocompatible
"filetype off
"set rtp+=~/vimfiles/bundle/vundle
"call vundle#rc('~/vimfiles/bundle')
"Plugin 'gmarik/vundle'
""Plugin 'The-NERD-tree'
"Plugin 'jistr/vim-nerdtree-tabs' "닫을때tree도같이닫아줌
"
"Plugin 'AutoComplPop' "단어자동완성
""Plugin 'SuperTab'
"Plugin 'SuperTab-continued.'
"Plugin 'a.vim' "헤더-소스 전환
"Plugin 'bufexplorer.zip' "파일의 History
""Plugin 'qtpy.vim'
"Plugin 'flazz/vim-colorschemes'
""Plugin 'Python-mode-klen'
""Plugin 'cqml.vim'
""Plugin 'number-marks'
""Plugin 'qt2vimsyntax'
"filetype plugin indent on
"syntax on
"
""autocmd VimEnter * if &filetype !=# 'gitcommit'| NERDTree | wincmd p | endif 
""autocmd BufEnter * if &filetype !=# 'gitcommit'| NERDTree | wincmd p | endif
"autocmd VimEnter * NERDTree
"autocmd BufEnter * NERDTreeMirror
"
"autocmd VimEnter * wincmd w
"
"let g:NERDTreeWinPos = "right"
"let g:NERDTreeWinSize = 36
"let g:nerdtree_tabs_open_on_gui_startup=1

"==================================================================

execute pathogen#infect()

filetype plugin indent on
syntax on

"ncm2
"coc.nvim 으로 교체합니다	
"autocmd BufEnter * call ncm2#enable_for_buffer()
" set completeopt=noinsert,menuone,noselect
"set nocompatible
"python에서 $2 $1 이런게 나와서 일단 아래 vim lsp를 사용하기로 변경
"let g:LanguageClient_serverCommands = {
	"\ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    "\ }

	"\ 'css': ['css-languageserver', '--stdio'],
	"\ 'python': ['~/.pyenv/shims/pyls'],
" ternjs 를 사용하므로 제거
"\ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
"\ 'javascript': ['javascript-typescript-stdio'],

" nnoremap <F5> :call LanguageClient_contextMenu()<CR>
"" Or map each action separately
" nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
" nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
" nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"

"let g:ale_completion_enabled = 1
"set omnifunc=ale#completion#OmniFunc


" autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
    " pip install python-language-server
" au User lsp_setup call lsp#register_server({
" 	\ 'name': 'css-lc',
" 	\ 'cmd': {server_info->[&shell, &shellcmdflag, 'css-languageserver --stdio']},
" 	\ 'whitelist': ['css'],
" 	\ })
" if executable('pyls')
"     " pip install python-language-server
"     au User lsp_setup call lsp#register_server({
"         \ 'name': 'pyls',
" 		\ 'cmd': {server_info->['pyls']},
"         \ 'whitelist': ['python'],
"         \ })
" endif
" if executable('rls')
"     au User lsp_setup call lsp#register_server({
"         \ 'name': 'rls',
"         \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
"         \ 'whitelist': ['rust'],
"         \ })
" endif
" let g:lsp_signs_enabled = 1         " enable signs
" let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode

"let g:virtualenv_directory = '/home/utylee/00-Projects/venv-tyTrader'


function! StatusLine(current, width)
  let l:s = ''

  if a:current
    let l:s .= crystalline#mode() . crystalline#right_mode_sep('')
  else
    let l:s .= '%#CrystallineInactive#'
  endif
  let l:s .= ' %f%h%w%m%r '
  if a:current
    " let l:s .= crystalline#right_sep('', 'Fill') . ' %{fugitive#head()}'
    let l:s .= crystalline#right_sep('', 'Fill') . ' %{FugitiveHead()}'
  endif
  if a:current
	let l:s .= ' %{tagbar#currenttag(" %s\ ","")}'
	"let l:s .= crystalline#right_sep('', 'Fill') 
	""set statusline+=%{tagbar#currenttag('[%s]\ ','')}
  endif


  let l:s .= '%='
  if a:current
    let l:s .= crystalline#left_sep('', 'Fill') . ' %{&paste ?"PASTE ":""}%{&spell?"SPELL ":""}'
    let l:s .= crystalline#left_mode_sep('')
  endif
  if a:width > 80
    let l:s .= ' %{&ft}[%{&fenc!=#""?&fenc:&enc}][%{&ff}] %l/%L %c%V %P '
  else
    let l:s .= ' '
  endif

  return l:s
endfunction

function! TabLine()
  let l:vimlabel = has('nvim') ?  ' NVIM ' : ' VIM '
  return crystalline#bufferline(2, len(l:vimlabel), 1) . '%=%#CrystallineTab# ' . l:vimlabel
endfunction

let g:crystalline_enable_sep = 1
let g:crystalline_statusline_fn = 'StatusLine'
let g:crystalline_tabline_fn = 'TabLine'
"let g:crystalline_theme = 'default'
"let g:crystalline_theme = 'molokai'
let g:crystalline_theme = 'onedark'

set showtabline=2
set guioptions-=e
set laststatus=2


"set laststatus=2
"let g:airline_theme='base16_embers'
"let g:airline_powerline_fonts = 1
"let g:airline#extensions#virtualenv#enabled = 0
"let g:airline#extensions#tagbar#flags = 'f'
"function! AirlineWrapper(ext)
	"let head = airline#extensions#branch#head()
	"return empty(head) ? '' : printf(' %s', airline#extensions#branch#get_head())
"endfunction
"let g:airline_section_a = airline#section#create(['mode', ' ', '%{airline#extensions#branch#get_head()}'])
"let g:airline_section_b = airline#section#create(['%{virtualenv#statusline()}'])
"" Enable the list of buffers
"let g:airline#extensions#tabline#enabled = 1
"
"" Show just the filename
"let g:airline#extensions#tabline#fnamemod = ':t'
"let g:airline_mode_map = {
"\ '__' : '-',
"\ 'n'  : 'N',
"\ 'i'  : 'I',
"\ 'R'  : 'R',
"\ 'v'  : 'V',
"\ 'V'  : 'V-L',
"\ 'c'  : 'C',
"\ 's'  : 'S',
"\ 'S' : 'S-L',
"\ }





""let g:airline_section_a = airline#sections#create(['mode', %{airline#extensions#branch#get_head()}''branch'])

"let g:airline_section_a = airline#section#create(['mode', '%{AirlineWrapper()}'])
"let g:airline_section_b = airline#section#create([g:airline_symbols.branch, ' ', '%{fugitive#head()}', ' ', ' %{virtualenv#statusline()}'])
"let g:airline_section_b = airline#section#create(['%{airline#extensions#branch#get_head()}', ' %{virtualenv#statusline()}'])
"let g:airline_section_b = airline#section#create(['branch'])
"let g:airline_section_b = ['branch']
"let g:virtualenv_stl_format = '[%n]'
"let g:Powerline_symbols = 'fancy'

"디렉토리 없이 파일명만 표시하게 합니다
"let g:airline_section_c = '%t'



"function! MyOverride(...)
"	call a:l.add_section('StatusLine', 'all')
"	return l
"endfunction
"call airline#add_statusline_func('MyOverride')

let g:jedi#auto_initialization = 0 
"let g:jedi#squelch_py_warning = 1
let g:jedi#force_py_version=3

" emmet-vim 을 html과 css에서만 사용하는 설정

"let g:user_emmet_install_global = 0
"autocmd FileType html,css EmmetInstall
let g:user_emmet_leader_key='<C-Q>'

" emmet-vim 에서 태그제거가 그 내용까지 제거가돼서 vim vanilla로 구현
noremap <C-Y>k vat<Esc>da>`<da>

let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.erb,*.jsx,*.js"
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.js,*.erb'
let g:closetag_emptyTags_caseSensitive = 1
let g:closetag_shortcut = '>'
let g:closetag_close_shortcut = '<leader>>'

set noundofile
set number
set cul
set ignorecase
set shiftwidth=4
set softtabstop=4
set nobackup
set noswapfile
"no equalalways or equalalways --> split 화면에서 사이즈 유즈 관련 세팅
set noea 

" 현재 파일의 디렉토리로 이동
"set autochdir
" 만약 플러긴에서 문제가 생긴다면 아래대안을 사용할 것
"nnoremap ,cd :cd %:p:h<CR> 

if has("gui_running")
	"set lines=55
"	set columns=120
"	au GUIEnter * winpos 300 0
"
	"set guioptions -=T
	"set guioptions -=m
	set fullscreen
endif


au BufRead,BufNewFile */etc/nginx/* set ft=nginx
au BufRead,BufNewFile */nginx/* set ft=nginx

set noshellslash
"map <F5> : !python3 %<CR>
"nmap <leader>e :!python3 %<CR>
"nmap <leader>e :!python3 '%:p'<CR>
"nmap <leader>e :set shellcmdflag=-ic <CR> :!ts python '%'<CR> <CR> :set shellcmdflag=-c<CR>
"nmap <leader>e :!ts python '%:p' 2>/dev/null<CR> <CR>
"nmap <leader>r :redraw!<CR>
"nmap <leader>e :!ts python '%' 2>/dev/null<CR> <CR>
"nmap <leader>r :Rooter<CR> :pwd<cr>
"let g:rooter_manual_only = 1
"let g:rooter_patterns = ['Rakefile', '.git/']
let g:rooter_patterns = ['.git', 'Makefile', 'Rakefile']
"stop vim-rooter change dir automatically
let g:rooter_manual_only = 1   
"nmap <leader>e :!ts python '%:p' 2>/dev/null<CR> <CR>

"nmap <leader>w :!ts cargo build --release<CR> <CR>
"nmap <leader>w :!ts cargo run -j4<CR> <CR>
"nmap <leader>w :!ts ~/utylee/.virtualenvs/trsrv/Scripts/python.exe c:/Users/utylee/.virtualenvs/trsrv/src/'%' 2>/dev/null<CR> <CR>

" nmap <leader>ee :!ts python '%:p' 2>/dev/null<CR> <CR>
nmap <leader>ee :!tmux send-keys -t 1 "python %:p" Enter<CR><CR>
" nmap <leader>ew :!ts tsc '%:p' 2>/dev/null<CR> <CR>
nmap <leader>ew :!tmux send-keys -t 1 "/home/utylee/utylee/.virtualenvs/win/Scripts/python.exe  %:p" Enter<CR><CR>
nmap <leader>et :!ts tsc '%:p' 2>/dev/null<CR> <CR>
" nmap <leader>ee :!ls 3>/dev/null<CR>
nmap <leader>er :!ts npm run dev<CR> <CR>
"nmap <leader>er :!ts cargo run -j6<CR> <CR>
nmap <leader>w :!ts cargo run -j6<CR> <CR>

"nmap <leader>w :!ts python.exe '%'<CR> <CR>
" nmap <leader>c :!ts C-c<CR> <CR>
nmap <leader>c :!tmux send-keys -t 1 C-c<CR> <CR>
"nmap <leader>w :!ts /mnt/c/Users/utylee/.virtualenvs/win/Scripts/python.exe c:/Users/utylee/.virtualenvs/win/src/'%' 2>/dev/null<CR> <CR>
"현재 행을 실행하는 커맨드인데 공백제거가 안돼 아직 제대로 되지 않습니다
nmap <leader>` :set fullscreen<CR>

"nmap <leader>q :bd!<CR>
"nmap <leader>Q :cclose<CR>
"Add for all buffer close
nmap <leader>q :bd!<CR>
nmap ,q :%bd!<CR>
nmap ,c :cclose<CR>
nmap ,r :syntax sync fromstart<CR>
" ;의 반대방향 역할을 하는 ,키를 더블클릭으로 사용하기 위함입니다
nnoremap ,, ,

nmap ;z :cd %:p:h<cr> :pwd<cr>
nmap ;Z :ProsessionDelete<cr>
nmap ;r :Rooter<CR>
nnoremap ;; ;

"nmap <leader>a :bufdo bd<CR>
"map <F7> :NERDTreeTabsToggle<CR>
""nmap <leader>2 :NERDTreeToggle<CR>
"nmap <leader>2 :NERDTree<CR>
"nmap <leader>3 :NERDTreeClose<CR>
nmap <leader>1 :e $MYVIMRC<CR>
nmap <leader>5 :syntax sync fromstart<CR>
"nmap <leader>1 :e ~/todo<CR>
"nmap <leader>3 :r ~/.vim/mytemplate/main.txt<CR>
map <A-3> :tabnext<CR>
map <A-4> :tabprevious<CR>
"map <F3> :cn<CR>
"map <F4> :cp<CR>
"ex) :ccl<CR>       "Close the search result windows

map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-h> <c-w>h
map <c-l> <c-w>l
"map <C-T> :tabnew<CR>:wincmd w<CR>

" Setup some default ignores
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn)|\_site)$',
  \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg|avi|mkv|mov|mp4|wma|xlsx|mp3|ini|doc|docx|un|bak)$',
\}


"arduino setup

let g:arduino_serial_baud = 9600
let g:arduino_serial_port = "/dev/ttyS8"

"nmap <leader>v :ArduinoVerify<CR>
nmap <leader>u :ArduinoUpload<CR>
nmap <leader>3 :ArduinoSerial<CR>


" Use the nearest .git directory as the cwd
" This makes a lot of sense if you are working on a project that is in version
" control. It also supports works with .svn, .hg, .bzr.
"let g:ctrlp_working_path_mode = 'r'
nmap <leader>v :Marks<cr>
nmap <leader>m :Marks<cr>
nmap <leader>a :Rg<cr>
"nmap <leader>g :ProjectFiles<cr>
nmap <leader>x :Ag<cr>
nmap <leader>s :Tags<cr>
nmap <leader>d :BTags<cr>
command! Dirs call fzf#run(fzf#wrap({'source': 'fd --type d --hidden --color=always', 'sink': 'edit'}))
nmap <leader>fa :Files<cr>
nmap <leader>ff :Dirs<cr>
nmap <leader>fg :ProjectFiles<cr>
" vim-rooter 후 파일찾기를 하는 방법도 있습니다
"nmap <leader>f :Files<cr>
"nmap <leader>; :BLines<cr>
nmap <leader>k :BLines<cr>
nmap <leader>l :Lines<cr>
nmap <leader>b :Buffers<cr>
nmap <leader>t :History<cr>		

nmap <silent> <leader>ud :BTags <C-R><C-W><CR>
nmap <silent> <Leader>us :Tags <C-R><C-W><CR>
nmap <silent> <Leader>ua :Rg <C-R><C-W><CR>
nmap <silent> <Leader>ul :Lines <C-R><C-W><CR>
nmap <silent> <Leader>uk :BLines <C-R><C-W><CR>

" for vim-fugitive
nmap <leader>gd :Gdiffsplit<cr>
nmap <leader>gv :Gvdiffsplit<cr>
nmap <leader>gb :Git blame<cr>
nmap <leader>gw :Gwrite<cr>
nmap <leader>gr :Gread<cr>
"from fzf
nmap <leader>gc :BCommits<cr>
nmap <leader>gx :Commits<cr>


"nmap <silent> <Leader>g :BTags <C-R><C-W><CR>
"nmap <silent> <Leader>h :Tags <C-R><C-W><CR>
"nmap <silent> <Leader>j :Rg <C-R><C-W><CR>
"nmap <silent> <Leader>; :Lines <C-R><C-W><CR>
"nmap <silent> <Leader>l :BLines <C-R><C-W><CR>
"nmap <leader>m :CtrlPMixed<cr>


" Use a leader instead of the actual named binding
"nmap <leader>f :CtrlP<cr>
"nmap <leader>f :CtrlPCurWD<cr>

" Easy bindings for its various modes
"nmap <leader>b :CtrlPBuffer<cr>
"nmap <leader>t :CtrlPMRU<cr>
"nmap <leader>m :CtrlPMixed<cr>
"nmap <leader>bs :CtrlPMRU<cr>
let g:ctrlp_match_window = 'max:20'

" Split size change
nmap <leader>- :resize -5<cr>
nmap <leader>= :resize +5<cr>

"d로 삭제시에 레지스터로 복사되는 것을 금지합니다
"noremap d "_d
"noremap dd "_dd
"noremap p "0p

"colorscheme molokai "oreilly jellybeans sweyla1 
"colorscheme oreilly "oreilly jellybeans sweyla1 
"colorscheme monokai "oreilly jellybeans sweyla1 
"set background=dark
"colorscheme solarized 
colorscheme solarized_sd_utylee

"let python_no_builtin_highlight = 1  
"let g:molokai_original = 1

"set air-line heme {dark, molokai, ...}
"let g:airline_theme='molokai'
"let g:airline_theme='solarized'
"et g:airline_theme='dark'
"let g:airline_theme='tomorrow'
"let g:airline_theme='zenburn'

" 일단 요 두개가 맘에 듬
"let g:airline_theme='wombat'
"let g:airline_theme='raven'

"let g:airline_theme='jellybeans'


let g:jedi#completions_command = "<C-N>"



"autocmd BufNewFile,BufRead *.qml so c:\vim\vim74\ftplugin\qml.vim
autocmd BufNewFile,BufRead *.qml setf qml 

if has("autocmd")
	augroup templates
		autocmd BufNewFile *.json 0r ~/.vim/template/skeleton.json
	augroup end
endif



"filetype plugin on
"set omnifunc=syntaxcomplete#Complete
"set complete


let g:vebugger_leader=','
"let g:vebugger_view_source_cmd='edit'
"let g:ConqueGdb_Leader = ','

"let g:ycm_confirm_extra_conf = 0
"let g:ycm_key_list_select_completion = ['', '']
"let g:ycm_key_list_previous_completion = ['', '']
"let g:ycm_autoclose_preview_window_after_completion = 1
"let g:ycm_warning_symbol = '>*'
"
"nnoremap g :YcmCompleter GoTo
"" nnoremap gg :YcmCompleter GoToImprecise
"nnoremap d :YcmCompleter GoToDeclaration
"nnoremap t :YcmCompleter GetType
"nnoremap p :YcmCompleter GetParent 
"let g:ycm_min_num_of_chars_for_completion = 1
"let g:ycm_auto_trigger = 1 
"let g:ycm_collect_identifiers_from_tags_files = 1



""For clang_complete
"let g:clang_snippets = 1
"let g:clang_snippets_engine = 'clang_complete'
""let g:clang_library_path='/usr/lib/llvm-3.8/lib'
""let g:clang_library_path='/usr/lib/x86_64-linux-gnu/libclang-3.8.so.1'
"let g:clang_library_path='/usr/lib/llvm-3.8/lib/libclang-3.8.so.1'






" For clang
" disable auto completion for vim-clang
"let g:clang_auto = 0
"" default 'longest' can not work with neocomplete
"let g:clang_c_completeopt = 'menuone,preview'
"let g:clang_cpp_completeopt = 'menuone,preview'
"
""nvim이 아닐 때만 neocomplete 변수를 넣습니다
"if !has('nvim')
"
" use neocomplete
" input patterns
"if !exists('g:neocomplete#force_omni_input_patterns')
	"let g:neocomplete#force_omni_input_patterns = {}
"endif

"for c and c++
"let g:neocomplete#force_omni_input_patterns.c =
   "\ '[^.[:digit:] *\t]\%(\.\|->\)\w*'
"let g:neocomplete#force_omni_input_patterns.cpp =
	"\ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'


"let g:clang_c_options = '-std=gnu11'
"let g:clang_cpp_options = '-std=c++11 -stdlib=libc++'
"endif



"nvim이 아닐때만 neocomplete init을 행합니다
"if !has('nvim')
" For Neocomplete config

" Use neocomplete.
"let g:neocomplete#enable_at_startup = 1
" Use smartcase.
"let g:neocomplete#enable_smart_case = 1
" Use complte first result like AutoComplPop 
"let g:neocomplete#enable_auto_select = 1
" Set minimum syntax keyword length.
"let g:neocomplete#sources#syntax#min_keyword_length = 3

" Define dictionary.
"let g:neocomplete#sources#dictionary#dictionaries = {
    "\ 'default' : '',
    "\ 'vimshell' : $HOME.'/.vimshell_hist',
    "\ 'scheme' : $HOME.'/.gosh_completions'
        "\ }

" Define keyword.
"if !exists('g:neocomplete#keyword_patterns')
    "let g:neocomplete#keyword_patterns = {}
"endif
"let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
"inoremap <expr><C-g>     neocomplete#undo_completion()
"inoremap <expr><C-l>     neocomplete#complete_common_string()
"inoremap <expr><Space>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
"inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
"function! s:my_cr_function()
  ""return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  "" For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
"endfunction
" <TAB>: completion.
"inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
""" <C-h>, <BS>: close popup and delete backword char.
"inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
"inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
"" Close popup by <Space>.
""inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"
"
" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
"autocmd FileType python setlocal omnifunc=pythoncomplete#Complete

"autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
"autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
"autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
"autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
"if !exists('g:neocomplete#sources#omni#input_patterns')
  "let g:neocomplete#sources#omni#input_patterns = {}
"endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
"let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
"endif


"autocmd BufEnter * silent! normal! g`"
"set nostartofline

" Save current view settings on a per-window, per-buffer basis.
function! AutoSaveWinView()
    if !exists("w:SavedBufView")
        let w:SavedBufView = {}
    endif
    let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction

" Restore current view settings.
function! AutoRestoreWinView()
    let buf = bufnr("%")
    if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
        let v = winsaveview()
        let atStartOfFile = v.lnum == 1 && v.col == 0
        if atStartOfFile && !&diff
            call winrestview(w:SavedBufView[buf])
        endif
        unlet w:SavedBufView[buf]
    endif
endfunction

" When switching buffers, preserve window view.
if v:version >= 700
    autocmd BufLeave * call AutoSaveWinView()
    autocmd BufEnter * call AutoRestoreWinView()
endif


set langmenu=utf8
"lang mes en_US 
"set langmenu=en_US.UTF-8
set tabstop=4
"cd c:\_GoogleDrive\__시스템트레이딩\
set encoding=utf8
"set fileencodings=utf-8,cp949
set fileencodings=utf-8,cp949
"set langmenu=cp949
"set guifont=나눔고딕코딩:h12:cHANGEUL
"set guifontwide=나눔고딕코딩:h12:cHANGEUL
"set guifont=Lucida\ Console:h11:cDEFAULT
"set guifont=Consolas:h10.15:cDEFAULT
"set guifont=Consolas:h10.2:cANSI
"set guifont=Ubuntu\ Mono\ for\ Powerline:h15:cANSI
"set guifont=Ubuntu\ Mono:h15:cANSI
"set guifont=Ubuntu\ Mono\ derivative\ Powerline:h18.3
"set guifontwide=NanumGothicCoding:h23
"set guifont=D2Coding\ for\ Powerline
"set font=Ubuntu\ Mono\ derivative\ Powerline:h19
"set guifontwide=NanumGothicCoding:h15:cDEFAULT
"set guifontwide=Ubuntu:h15:cDEFAULT

"current
"set guifont=Ubuntu\ Mono\ derivative\ Powerline:h19
"set guifontwide=NanumGothicCoding:h24

"cd c:\_GoogleDrive\
"cd c:\Users\utylee\00-projects
"cd c:\Users\seoru\00-projects\00-python
"
"

"fu! Sess()
	"execute 'source Session.vim'
"endfunction
"autocmd VimEnter * call Sess()

"nmap <leader>a :source Session.vim<cr>



