"======================================================================
"
" init-plugins.vim
"
" Modified by zhiyuan
" Last Modified: 2019-07-05 18:30:57
"
"======================================================================
" vim: set ts=4 sw=4 tw=78 noet :



"----------------------------------------------------------------------
" 默认情况下的分组，可以在前面覆盖之
"----------------------------------------------------------------------
if !exists('g:bundle_group')
  let g:bundle_group = ['basic', 'tags', 'enhanced', 'filetypes', 'textobj']
  let g:bundle_group += ['tags', 'airline', 'nerdtree']
  let g:bundle_group += ['snip']
  let g:bundle_group += ['coc']
  let g:bundle_group += ['leaderf']
  let g:bundle_group += ['markdown']
  let g:bundle_group += ['edit']
  let g:bundle_group += ['task']
  let g:bundle_group += ['float']
endif


"----------------------------------------------------------------------
" 计算当前 vim-init 的子路径
"----------------------------------------------------------------------
let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')

function! s:path(path)
  let path = expand(s:home . '/' . a:path )
  return substitute(path, '\\', '/', 'g')
endfunc


"----------------------------------------------------------------------
" 在 ~/.vim/bundles 下安装插件
"----------------------------------------------------------------------
call plug#begin(get(g:, 'bundle_home', '~/.vim/bundles'))


"----------------------------------------------------------------------
" 默认插件
"----------------------------------------------------------------------

" 全文快速移动，<leader><leader>f{char} 即可触发
Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'haya14busa/incsearch-easymotion.vim'

map z/ <Plug>(incsearch-fuzzy-/)
map z? <Plug>(incsearch-fuzzy-?)
map zg/ <Plug>(incsearch-fuzzy-stay)

" incsearch.vim x fuzzy x vim-easymotion

function! s:config_easyfuzzymotion(...) abort
  return extend(copy({
  \   'converters': [incsearch#config#fuzzy#converter()],
  \   'modules': [incsearch#config#easymotion#module()],
  \   'keymap': {"\<CR>": '<Over>(easymotion)'},
  \   'is_expr': 0,
  \   'is_stay': 1
  \ }), get(a:, 1, {}))
endfunction

noremap <silent><expr> <Space>/ incsearch#go(<SID>config_easyfuzzymotion())


" 文件浏览器，代替 netrw
Plug 'justinmk/vim-dirvish'

" 表格对齐，使用命令 Tabularize
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
Plug 'junegunn/vim-easy-align'
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

let g:easy_align_delimiter_align='l'

" Diff 增强，支持 histogram / patience 等更科学的 diff 算法
Plug 'chrisbra/vim-diff-enhanced'

" 中文文档
Plug 'yianwillis/vimcdoc'

Plug 'tpope/vim-surround'

" better terminal
" Plug 'skywind3000/vim-terminal-help'


"----------------------------------------------------------------------
" Dirvish 设置：自动排序并隐藏文件，同时定位到相关文件
" 这个排序函数可以将目录排在前面，文件排在后面，并且按照字母顺序排序
" 比默认的纯按照字母排序更友好点。
"----------------------------------------------------------------------
function! s:setup_dirvish()
  if &buftype != 'nofile' && &filetype != 'dirvish'
    return
  endif
  if has('nvim')
    return
  endif
  " 取得光标所在行的文本（当前选中的文件名）
  let text = getline('.')
  if ! get(g:, 'dirvish_hide_visible', 0)
    exec 'silent keeppatterns g@\v[\/]\.[^\/]+[\/]?$@d _'
  endif
  " 排序文件名
  exec 'sort ,^.*[\/],'
  let name = '^' . escape(text, '.*[]~\') . '[/*|@=|\\*]\=\%($\|\s\+\)'
  " 定位到之前光标处的文件
  call search(name, 'wc')
  noremap <silent><buffer> ~ :Dirvish ~<cr>
  noremap <buffer> % :e %
  noremap <buffer> <tab> :call dirvish#open("tabedit", 0)<cr>
endfunc

augroup MyPluginSetup
  autocmd!
  autocmd FileType dirvish call s:setup_dirvish()
augroup END


"----------------------------------------------------------------------
" 基础插件
"----------------------------------------------------------------------
if index(g:bundle_group, 'basic') >= 0

  " 展示开始画面，显示最近编辑过的文件
  Plug 'mhinz/vim-startify'

  " 一次性安装一大堆 colorscheme
  Plug 'flazz/vim-colorschemes'

  " 支持库，给其他插件用的函数库
  Plug 'xolox/vim-misc'

  " 用于在侧边符号栏显示 marks （ma-mz 记录的位置）
  Plug 'kshenoy/vim-signature'

  " 用于在侧边符号栏显示 git/svn 的 diff
  Plug 'mhinz/vim-signify'

  " 根据 quickfix 中匹配到的错误信息，高亮对应文件的错误行
  " 使用 :RemoveErrorMarkers 命令或者 <space>ha 清除错误
  Plug 'mh21/errormarker.vim'

  " 使用 ALT+e 会在不同窗口/标签上显示 A/B/C 等编号，然后字母直接跳转
  Plug 't9md/vim-choosewin'

  " 提供基于 TAGS 的定义预览，函数参数预览，quickfix 预览
  Plug 'skywind3000/vim-preview'
  autocmd FileType qf nnoremap <silent><buffer> p :PreviewQuickfix<cr>
  autocmd FileType qf nnoremap <silent><buffer> P :PreviewClose<cr>

  " Git 支持
  Plug 'tpope/vim-fugitive'

  " 智能注释
  Plug 'scrooloose/nerdcommenter'
  let g:NERDSpaceDelims=1
  let g:NERDRemoveExtraSpaces=1
  let g:NERDDefaultAlign='start'
  let g:NERDCustomDelimiters = {
    \ 'sty': { 'left': '%'},
    \ 'cls': { 'left': '%'}
    \ }
  nnoremap <silent><m-/> :call NERDComment('n', 'Invert')<cr>
  inoremap <silent><m-/> <esc>:call NERDComment('n', 'Invert')<cr>
  xnoremap <silent><m-/> :call NERDComment('x', 'Invert')<cr>

  " 使用 ALT+E 来选择窗口
  nmap <m-e> <Plug>(choosewin)

  " 默认不显示 startify
  let g:startify_disable_at_vimenter = 1
  let g:startify_session_dir = '~/.vim/session'

  " 使用 <space>ha 清除 errormarker 标注的错误
  noremap <silent><space>ha :RemoveErrorMarkers<cr>

  " signify 调优
  let g:signify_vcs_list = ['git', 'svn']
  let g:signify_sign_add         = '+'
  let g:signify_sign_delete      = '_'
  let g:signify_sign_delete_first_line = '‾'
  let g:signify_sign_change      = '~'
  let g:signify_sign_changedelete    = g:signify_sign_change

  " git 仓库使用 histogram 算法进行 diff
  let g:signify_vcs_cmds = {
      \ 'git': 'git diff --no-color --diff-algorithm=histogram --no-ext-diff -U0 -- %f',
      \}
endif


"----------------------------------------------------------------------
" 增强插件
"----------------------------------------------------------------------
if index(g:bundle_group, 'enhanced') >= 0

  " 用 v 选中一个区域后，ALT_+/- 按分隔符扩大/缩小选区
  Plug 'terryma/vim-expand-region'

  " 快速文件搜索
  Plug 'junegunn/fzf'

  " 给不同语言提供字典补全，插入模式下 c-x c-k 触发
  Plug 'asins/vim-dict'

  " 使用 :FlyGrep 命令进行实时 grep
  " Plug 'wsdjeg/FlyGrep.vim'

  " undo tree
  Plug 'mbbill/undotree'
  nnoremap <space>u :UndotreeToggle<cr>

  " 使用 :CtrlSF 命令进行模仿 sublime 的 grep
  Plug 'dyng/ctrlsf.vim'

  " 配对括号和引号自动补全
  Plug 'Raimondi/delimitMate'

  " 提供 gist 接口
  Plug 'lambdalisue/vim-gista', { 'on': 'Gista' }
  
  " ALT_+/- 用于按分隔符扩大缩小 v 选区
"   map <m-=> <Plug>(expand_region_expand)
"   map <m--> <Plug>(expand_region_shrink)
endif


"----------------------------------------------------------------------
" 自动生成 ctags/gtags，并提供自动索引功能
" 不在 git/svn 内的项目，需要在项目根目录 touch 一个空的 .root 文件
" 详细用法见：https://zhuanlan.zhihu.com/p/36279445
"----------------------------------------------------------------------
if index(g:bundle_group, 'tags') >= 0

  " 提供 ctags/gtags 后台数据库自动更新功能
  Plug 'ludovicchabant/vim-gutentags'

  " 提供 GscopeFind 命令并自动处理好 gtags 数据库切换
  " 支持光标移动到符号名上：<leader>cg 查看定义，<leader>cs 查看引用
  Plug 'skywind3000/gutentags_plus'

  " 重新设置键位映射
  let g:gutentags_plus_nomap = 1
  " Find symbol (reference) under cursor
  noremap <silent> <leader>gs :GscopeFind s <C-R><C-W><cr>
  " Find symbol definition under cursor
  noremap <silent> <leader>gg :GscopeFind g <C-R><C-W><cr>
  " Functions called by this function
  noremap <silent> <leader>gd :GscopeFind d <C-R><C-W><cr>
  " Functions calling this function
  noremap <silent> <leader>gc :GscopeFind c <C-R><C-W><cr>
  " Find text string under cursor
  noremap <silent> <leader>gt :GscopeFind t <C-R><C-W><cr>
  " Find egrep pattern under cursor
  noremap <silent> <leader>ge :GscopeFind e <C-R><C-W><cr>
  " Find file name under cursor
  noremap <silent> <leader>gf :GscopeFind f <C-R>=expand("<cfile>")<cr><cr>
  " Find files #including the file name under cursor
  noremap <silent> <leader>gi :GscopeFind i <C-R>=expand("<cfile>")<cr><cr>
  " Find places where current symbol is assigned
  noremap <silent> <leader>ga :GscopeFind a <C-R><C-W><cr>
  " 设定项目目录标志：除了 .git/.svn 外，还有 .root 文件
  let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']
  let g:gutentags_ctags_tagfile = '.tags'

  " 默认生成的数据文件集中到 ~/.cache/tags 避免污染项目目录，好清理
  let g:gutentags_cache_dir = expand('~/.cache/tags')

  " 默认禁用自动生成
  let g:gutentags_modules = []

  " 如果有 ctags 可执行就允许动态生成 ctags 文件
  if executable('ctags')
    let g:gutentags_modules += ['ctags']
  endif

  " 如果有 gtags 可执行就允许动态生成 gtags 数据库
  if executable('gtags') && executable('gtags-cscope')
    let g:gutentags_modules += ['gtags_cscope']
  endif

  " 设置 ctags 的参数
  let g:gutentags_ctags_extra_args = []
  let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
  let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
  let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

  " 使用 universal-ctags 的话需要下面这行，请反注释
  " let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']

  " 禁止 gutentags 自动链接 gtags 数据库
  let g:gutentags_auto_add_gtags_cscope = 0
endif


"----------------------------------------------------------------------
" 文本对象：textobj 全家桶
"----------------------------------------------------------------------
if index(g:bundle_group, 'textobj')
  
  " 基础插件：提供让用户方便的自定义文本对象的接口
  Plug 'kana/vim-textobj-user'

  " indent 文本对象：ii/ai 表示当前缩进，vii 选中当缩进，cii 改写缩进
  Plug 'kana/vim-textobj-indent'

  " 语法文本对象：iy/ay 基于语法的文本对象
  Plug 'kana/vim-textobj-syntax'

  " 函数文本对象：if/af 支持 c/c++/vim/java
"   Plug 'kana/vim-textobj-function', { 'for':['c', 'cpp', 'vim', 'java'] }

  " 参数文本对象：i,/a, 包括参数或者列表元素
  Plug 'sgur/vim-textobj-parameter'

  " 提供 python 相关文本对象，if/af 表示函数，ic/ac 表示类
"   Plug 'bps/vim-textobj-python', {'for': 'python'}

  " 提供 uri/url 的文本对象，iu/au 表示
  Plug 'jceb/vim-textobj-uri'
endif


"----------------------------------------------------------------------
" 文件类型扩展
"----------------------------------------------------------------------
if index(g:bundle_group, 'filetypes') >= 0

  " powershell 脚本文件的语法高亮
  Plug 'pprovost/vim-ps1', { 'for': 'ps1' }

  " lua 语法高亮增强
  Plug 'tbastos/vim-lua', { 'for': 'lua' }

  " C++ 语法高亮增强，支持 11/14/17 标准
  Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['c', 'cpp'] }

  " 额外语法文件
  Plug 'justinmk/vim-syntax-extra', { 'for': ['c', 'bison', 'flex', 'cpp'] }

  " python 语法文件增强
  Plug 'vim-python/python-syntax', { 'for': ['python'] }

  " rust 语法增强
  Plug 'rust-lang/rust.vim', { 'for': 'rust' }

  " vim org-mode
  Plug 'jceb/vim-orgmode', { 'for': 'org' }
endif


"----------------------------------------------------------------------
" airline
"----------------------------------------------------------------------
if index(g:bundle_group, 'airline') >= 0
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  let g:airline_left_sep = ''
  let g:airline_left_alt_sep = ''
  let g:airline_right_sep = ''
  let g:airline_right_alt_sep = ''
  let g:airline_powerline_fonts = 1
  let g:airline_exclude_preview = 1
  let g:airline_section_b = '%n'
  " let g:airline_theme='molokai'
  let g:airline_theme='angr'
  let g:airline#extensions#branch#enabled = 0
  let g:airline#extensions#syntastic#enabled = 0
  let g:airline#extensions#fugitiveline#enabled = 0
  let g:airline#extensions#csv#enabled = 0
  let g:airline#extensions#vimagit#enabled = 0
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#show_buffers = 0
  let g:airline#extensions#tabline#show_splits = 1
  let g:airline#extensions#tabline#tab_nr_type = 1
  let g:airline#extensions#tabline#exclude_preview = 1
  let g:airline#extensions#tabline#formatter = 'unique_tail'
  let g:airline#extensions#tabline#show_close_button = 0
endif


"----------------------------------------------------------------------
" NERDTree
"----------------------------------------------------------------------
if index(g:bundle_group, 'nerdtree') >= 0
  Plug 'scrooloose/nerdtree', {'on': ['NERDTree', 'NERDTreeFocus', 'NERDTreeToggle', 'NERDTreeCWD', 'NERDTreeFind'] }
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
  let g:NERDTreeMinimalUI = 1
  let g:NERDTreeDirArrows = 1
  let g:NERDTreeHijackNetrw = 0
  noremap <space>nn :NERDTree<cr>
  noremap <space>no :NERDTreeFocus<cr>
  noremap <space>nm :NERDTreeMirror<cr>
  noremap <space>nt :NERDTreeToggle<cr>
endif


"----------------------------------------------------------------------
" LanguageTool 语法检查
"----------------------------------------------------------------------
if index(g:bundle_group, 'grammer') >= 0
  Plug 'rhysd/vim-grammarous'
  noremap <space>rg :GrammarousCheck --lang=en-US --no-move-to-first-error --no-preview<cr>
  map <space>rr <Plug>(grammarous-open-info-window)
  map <space>rv <Plug>(grammarous-move-to-info-window)
  map <space>rs <Plug>(grammarous-reset)
  map <space>rx <Plug>(grammarous-close-info-window)
  map <space>rm <Plug>(grammarous-remove-error)
  map <space>rd <Plug>(grammarous-disable-rule)
  map <space>rn <Plug>(grammarous-move-to-next-error)
  map <space>rp <Plug>(grammarous-move-to-previous-error)
endif


"----------------------------------------------------------------------
" ale：动态语法检查
"----------------------------------------------------------------------
if index(g:bundle_group, 'ale') >= 0
  Plug 'w0rp/ale'

  " 设定延迟和提示信息
  let g:ale_completion_delay = 500
  let g:ale_echo_delay = 20
  let g:ale_lint_delay = 500
  let g:ale_echo_msg_format = '[%linter%] %code: %%s'

  " 设定检测的时机：normal 模式文字改变，或者离开 insert模式
  " 禁用默认 INSERT 模式下改变文字也触发的设置，太频繁外，还会让补全窗闪烁
  let g:ale_lint_on_text_changed = 'normal'
  let g:ale_lint_on_insert_leave = 1

  " 在 linux/mac 下降低语法检查程序的进程优先级（不要卡到前台进程）
  if has('win32') == 0 && has('win64') == 0 && has('win32unix') == 0
    let g:ale_command_wrapper = 'nice -n5'
  endif

  " 允许 airline 集成
  let g:airline#extensions#ale#enabled = 1

  " 编辑不同文件类型需要的语法检查器
  let g:ale_linters = {
        \ 'c': ['gcc', 'cppcheck'],
        \ 'cpp': ['gcc', 'cppcheck'],
        \ 'python': ['flake8', 'pylint'],
        \ 'lua': ['luac'],
        \ 'go': ['go build', 'gofmt'],
        \ 'java': ['javac'],
        \ 'javascript': ['eslint'],
        \ }


  " 获取 pylint, flake8 的配置文件，在 vim-init/tools/conf 下面
  function! s:lintcfg(name)
    let conf = s:path('tools/conf/')
    let path1 = conf . a:name
    let path2 = expand('~/.vim/linter/'. a:name)
    if filereadable(path2)
      return path2
    endif
    return shellescape(filereadable(path2)? path2 : path1)
  endfunc

  " 设置 flake8/pylint 的参数
  let g:ale_python_flake8_options = '--conf='.s:lintcfg('flake8.conf')
  let g:ale_python_pylint_options = '--rcfile='.s:lintcfg('pylint.conf')
  let g:ale_python_pylint_options .= ' --disable=W'
  let g:ale_c_gcc_options = '-Wall -O2 -std=c99'
  let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++14'
  let g:ale_c_cppcheck_options = ''
  let g:ale_cpp_cppcheck_options = ''

  let g:ale_linters.text = ['textlint', 'write-good', 'languagetool']

  " 如果没有 gcc 只有 clang 时（FreeBSD）
  if executable('gcc') == 0 && executable('clang')
    let g:ale_linters.c += ['clang']
    let g:ale_linters.cpp += ['clang']
  endif
endif

" ultisnip
if index(g:bundle_group, 'snip') >= 0
  Plug 'sirver/ultisnips'
  let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/vim-init/UltiSnips']
  let g:UltiSnipsEditSplit='tabdo'
  let g:UltiSnipsExpandTrigger = '<c-j>'
  let g:UltiSnipsJumpForwardTrigger = '<c-j>'
  let g:UltiSnipsJumpBackwardTrigger = '<c-k>'
endif


" coc
if index(g:bundle_group, 'coc') >= 0
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  " if hidden is not set, TextEdit might fail.
  set hidden

  " Some servers have issues with backup files, see #649
  set nobackup
  set nowritebackup

  " Better display for messages
  set cmdheight=2

  " You will have bad experience for diagnostic messages when it's default 4000.
  set updatetime=300

  " don't give |ins-completion-menu| messages.
  set shortmess+=c

  " always show signcolumns
  set signcolumn=yes

  " setting dir
  let g:coc_config_home=$HOME.'/.vim/vim-init/settings'
  let g:coc_data_home=$HOME.'/.vim/coc'

  " disable completion of some words
  let b:coc_suggest_blacklist = ["'/", '"/', ' /']

  nnoremap <silent><space>ce :CocConfig<cr>
  " auto install extensions
  let g:coc_global_extensions = ['coc-json', 'coc-tsserver', 'coc-cmake', 'coc-html', 'coc-solargraph', 'coc-python', 'coc-highlight', 'coc-yank', 'coc-vimlsp', 'coc-xml', 'coc-pyright', 'coc-markdownlint', 'coc-vimtex']

  " coc-explorer"
  :nmap <space>e :CocCommand explorer<CR>

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

  " To enable highlight current symbol on CursorHold
  autocmd CursorHold * silent call CocActionAsync('highlight')

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

  " CocEnable
  nnoremap <silent> <m-r> :CocEnable<cr>
  inoremap <silent> <m-r> <esc>:CocEnable<cr>a

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

  " Use <TAB> for select selections ranges, needs server support, like: coc-tsserver, coc-python
  " nmap <silent> <TAB> <Plug>(coc-range-select)
  " xmap <silent> <TAB> <Plug>(coc-range-select)

  " Use `:Format` to format current buffer
  command! -nargs=0 Format :call CocAction('format')

  " Use `:Fold` to fold current buffer
  command! -nargs=? Fold :call   CocAction('fold', <f-args>)

  " use `:OR` for organize import of current buffer
  command! -nargs=0 OR   :call   CocAction('runCommand', 'editor.action.organizeImport')

  " Add status line support, for integration with other plugin, checkout `:h coc-status`
  set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

  "解决coc.nvim大文件卡死状况
  let g:trigger_size = 0.5 * 1048576

  augroup hugefile
    autocmd!
    autocmd BufReadPre *
      \ let size = getfsize(expand('<afile>')) |
      \ if (size > g:trigger_size) || (size == -2) |
      \   echohl WarningMsg | echomsg 'WARNING: altering options for this huge file!' | echohl None |
      \   exec 'CocDisable' |
      \ else |
      \   exec 'CocEnable' |
      \ endif |
      \ unlet size
  augroup END
endif

"----------------------------------------------------------------------
" echodoc：搭配 YCM/deoplete 在底部显示函数参数
"----------------------------------------------------------------------
if index(g:bundle_group, 'echodoc') >= 0
  Plug 'Valloric/YouCompleteMe'
  Plug 'Shougo/echodoc.vim'

  set noshowmode
  let g:echodoc#enable_at_startup = 1
  "----------------------------------------------------------------------
  " YouCompleteMe 默认设置：YCM 需要你另外手动编译安装
  "----------------------------------------------------------------------
  " 设置配置文件路径
  let g:ycm_global_ycm_extra_conf = '~/.vim/bundles/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py'
  if match(system('uname -a'), 'aarch64') != -1
    let g:ycm_clangd_binary_path = '/data/data/com.termux/files/usr/bin/clangd'
  endif

  " 禁用预览功能：扰乱视听
  let g:ycm_add_preview_to_completeopt = 0

  " 禁用诊断功能：我们用前面更好用的 ALE 代替
  let g:ycm_show_diagnostics_ui = 0
  let g:ycm_server_log_level = 'info'
  let g:ycm_min_num_identifier_candidate_chars = 2
  let g:ycm_collect_identifiers_from_comments_and_strings = 1
  let g:ycm_complete_in_strings=1
  let g:ycm_key_invoke_completion = '<c-z>'
  " 补全anaconda虚拟环境
  " let g:ycm_path_to_python_interpreter = '/home/zhiyuan/.conda/envs/py35/bin/python3.5'
  " let g:ycm_python_binary_path = '/home/zhiyuan/.conda/envs/py35/bin/python3.5'
  " 解决ycm与UltiSnips tab键冲突
  let g:ycm_key_list_select_completion=['<m-,>','<Down>']
  let g:ycm_key_list_previous_completion=["<m-.>",'<Up>']
  let g:SuperTabDefaultCompletionType='<m-,>'

  set completeopt=menu,menuone

  " noremap <c-z> <NOP>

  " 两个字符自动触发语义补全
  let g:ycm_semantic_triggers =  {
        \ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
        \ 'cs,lua,javascript,tex': ['re!\w{2}'],
        \ }


  "----------------------------------------------------------------------
  " Ycm 白名单（非名单内文件不启用 YCM），避免打开个 1MB 的 txt 分析半天
  "----------------------------------------------------------------------
  let g:ycm_filetype_whitelist = {
        \ "c":1,
        \ "tex":1,
        \ "cpp":1,
        \ "objc":1,
        \ "objcpp":1,
        \ "python":1,
        \ "java":1,
        \ "javascript":1,
        \ "coffee":1,
        \ "vim":1,
        \ "go":1,
        \ "cs":1,
        \ "lua":1,
        \ "perl":1,
        \ "perl6":1,
        \ "php":1,
        \ "ruby":1,
        \ "rust":1,
        \ "erlang":1,
        \ "asm":1,
        \ "nasm":1,
        \ "masm":1,
        \ "tasm":1,
        \ "asm68k":1,
        \ "asmh8300":1,
        \ "asciidoc":1,
        \ "basic":1,
        \ "vb":1,
        \ "make":1,
        \ "cmake":1,
        \ "html":1,
        \ "css":1,
        \ "less":1,
        \ "json":1,
        \ "cson":1,
        \ "typedscript":1,
        \ "haskell":1,
        \ "lhaskell":1,
        \ "lisp":1,
        \ "scheme":1,
        \ "sdl":1,
        \ "sh":1,
        \ "zsh":1,
        \ "bash":1,
        \ "man":1,
        \ "markdown":1,
        \ "matlab":1,
        \ "maxima":1,
        \ "dosini":1,
        \ "conf":1,
        \ "config":1,
        \ "zimbu":1,
        \ "ps1":1,
        \ }
endif


"----------------------------------------------------------------------
" LeaderF：CtrlP / FZF 的超级代替者，文件模糊匹配，tags/函数名 选择
"----------------------------------------------------------------------
if index(g:bundle_group, 'leaderf') >= 0
  " 如果 vim 支持 python 则启用  Leaderf
"   if match(system('uname -a'), 'aarch64') == -1 && (has('python') || has('python3'))
  if (has('python') || has('python3'))
    Plug 'Yggdroot/LeaderF'

    " CTRL+p 打开文件模糊匹配
    let g:Lf_ShortcutF = '<c-p>'

    " ALT+b 打开 buffer 模糊匹配
    let g:Lf_ShortcutB = '<m-b>'

    " CTRL+n 打开最近使用的文件 MRU，进行模糊匹配
    noremap <c-n> :LeaderfMru<cr>

    " ALT+f 打开函数列表，按 i 进入模糊匹配，ESC 退出
    noremap <m-f> :LeaderfFunction!<cr>

    " ALT+t 打开 tag 列表，i 进入模糊匹配，ESC退出
    noremap <m-t> :LeaderfBufTag!<cr>

    " ALT+b 打开 buffer 列表进行模糊匹配
    noremap <m-b> :LeaderfBuffer<cr>
    let g:Lf_JumpToExistingWindow = 1

    " 全局 tags 模糊匹配
    noremap <m-m> :LeaderfTag<cr>

    " 最大历史文件保存 2048 个
    let g:Lf_MruMaxFiles = 2048

    " ui 定制
    let g:Lf_StlSeparator = { 'left': '', 'right': '', 'font': '' }

    " 如何识别项目目录，从当前文件目录向父目录递归知道碰到下面的文件/目录
    let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git']
    let g:Lf_WorkingDirectoryMode = 'Ac'
    let g:Lf_WindowHeight = 0.30
    let g:Lf_CacheDirectory = expand('~/.vim/cache')

    " 显示绝对路径
    let g:Lf_ShowRelativePath = 0

    " 隐藏帮助
    let g:Lf_HideHelp = 1

    " 模糊匹配忽略扩展名
    let g:Lf_WildIgnore = {
          \ 'dir': ['.svn','.git','.hg'],
          \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
          \ }

    " MRU 文件忽略扩展名
    let g:Lf_MruFileExclude = ['*.so', '*.exe', '*.py[co]', '*.sw?', '~$*', '*.bak', '*.tmp', '*.dll']
    let g:Lf_StlColorscheme = 'powerline'

    " 禁用 function/buftag 的预览功能，可以手动用 p 预览
    let g:Lf_PreviewResult = {'Function':0, 'BufTag':0}

    let g:Lf_ShowDevIcons = 'Source Code Pro for Powerline Medium'
  else
    " 不支持 python ，使用 CtrlP 代替
    Plug 'ctrlpvim/ctrlp.vim'

    " 显示函数列表的扩展插件
    Plug 'tacahiroy/ctrlp-funky'

    " 忽略默认键位
    let g:ctrlp_map = ''

    " 模糊匹配忽略
    let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/]\.(git|hg|svn)$',
      \ 'file': '\v\.(exe|so|dll|mp3|wav|sdf|suo|mht)$',
      \ 'link': 'some_bad_symbolic_links',
      \ }

    " 项目标志
    let g:ctrlp_root_markers = ['.project', '.root', '.svn', '.git']
    let g:ctrlp_working_path = 0

    " CTRL+p 打开文件模糊匹配
    noremap <c-p> :CtrlP<cr>

    " CTRL+n 打开最近访问过的文件的匹配
    noremap <c-n> :CtrlPMRUFiles<cr>

    " ALT+p 显示当前文件的函数列表
    noremap <m-f> :CtrlPFunky<cr>

    " ALT+n 匹配 buffer
    noremap <m-b> :CtrlPBuffer<cr>
  endif
endif


"-----------------------------------------------------------------------
" MarkDown插件安装
"-----------------------------------------------------------------------
if index(g:bundle_group, 'leaderf') >= 0
  Plug 'godlygeek/tabular', { 'for': 'markdown'}
  Plug 'gabrielelana/vim-markdown', { 'for': 'markdown' }
  Plug 'joker1007/vim-markdown-quote-syntax', { 'for': 'markdown' }
  Plug 'iamcco/markdown-preview.vim', { 'for': 'markdown' }

  " 预览快捷键
  nmap <silent> <F11> <Plug>MarkdownPreview
  imap <silent> <F11> <Plug>MarkdownPreview
  nmap <silent> <F12> <Plug>StopMarkdownPreview
  imap <silent> <F12> <Plug>StopMarkdownPreview
endif

if index(g:bundle_group, 'edit') >= 0
  Plug 'andymass/vim-matchup'
  let g:matchup_override_vimtex = 1

  Plug 'lervag/vimtex', {'for': ['tex', 'plaintex']}
  let g:tex_flavor='latex'
  let g:vimtex_quickfix_mode=2
  let g:vimtex_compiler_latexmk_engines = {
    \ '_'        : '-xelatex --shell-escape',
    \ 'pdflatex'     : '-pdf',
    \ 'dvipdfex'     : '-pdfdvi',
    \ 'lualatex'     : '-lualatex',
    \ 'xelatex'      : '-xelatex --shell-escape',
    \ 'context (pdftex)' : '-pdf -pdflatex=texexec',
    \ 'context (luatex)' : '-pdf -pdflatex=context',
    \ 'context (xetex)'  : '-pdf -pdflatex=''texexec --xtx''',
    \}
"     \ 'build_dir' : './output',
  let g:vimtex_compiler_latexmk = {
    \ 'backend' : 'jobs',
    \ 'background' : 1,
    \ 'callback' : 1,
    \ 'continuous' : 1,
    \ 'executable' : 'latexmk',
    \ 'options': [
    \   '-pdfxe',
    \   '-gg',
    \   '-verbose',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \   '-cd', ],
    \}
  let g:vimtex_view_general_viewer = 'okular'
  let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
  let g:vimtex_view_general_options_latexmk = '--unique'
  let g:vimtex_indent_ignored_envs = ['document', 'tikzpicture']
  let g:vimtex_indent_lists = []
  let g:vimtex_indent_on_ampersands = 0
  let g:tex_no_error=1
  let g:vimtex_indent_delims = {}
  let g:vimtex_mappings_disable = {}
  let g:vimtex_quickfix_autoclose_after_keystrokes = 2
  let g:vimtex_quickfix_ignore_filters = [
    \ 'Warning.*Fandol', 'Overfull', 'Underfull',
    \ 'Warning.*Font',
    \ 'Warning.*font',
    \]
endif

" task
if index(g:bundle_group, 'task') >= 0
  Plug 'skywind3000/asyncrun.vim'
  Plug 'skywind3000/asynctasks.vim'
  nnoremap <silent><space>ae :AsyncTaskEdit!<cr>
  nnoremap <silent><space>al :AsyncTaskList!<cr>
  nnoremap <silent><space>am :AsyncTaskMacro<cr>
  let g:asyncrun_rootmarks = ['.git', '.svn', '.root', '.project', '.hg']
  let g:asynctasks_term_pos = 'tab'
  let g:asynctasks_term_reuse = 1
  let g:asynctasks_term_focus = 1
  let g:asynctasks_confirm = 0
  let g:asynctasks_rtp_config = 'vim-init/settings/tasks.ini'
  " 自动打开 quickfix window ，高度为 6
  let g:asyncrun_open = 6

  " 任务结束时候响铃提醒
  let g:asyncrun_bell = 1

  let g:asynctasks_term_rows = 8
  let g:asynctasks_term_cols = 80
  let g:asynctasks_term_focus = 1

  " 设置 F10 打开/关闭 Quickfix 窗口
  nnoremap <silent><F12> :call asyncrun#quickfix_toggle(6)<cr>
  inoremap <silent><F12> <esc>:call asyncrun#quickfix_toggle(6)<cr>

  " run
  nnoremap <silent><F5> :AsyncTask file-run<cr>
  inoremap <silent><F5> <esc>:AsyncTask file-run<cr>
  " compile
  nnoremap <silent><F9> :AsyncTask file-compile<cr>
  inoremap <silent><F9> <esc>:AsyncTask file-compile<cr>
  " make
  nnoremap <silent><F7> :AsyncTask make<cr>
  inoremap <silent><F7> <esc>:AsyncTask make<cr>
  " make run
  nnoremap <silent><F8> :AsyncTask make-run<cr>
  inoremap <silent><F8> <esc>:AsyncTask make-run<cr>
  " make test
  nnoremap <silent><F6> :AsyncTask make-test<cr>
  inoremap <silent><F6> <esc>:AsyncTask make-test<cr>
  " cmake
  nnoremap <silent><F4> :AsyncTask cmake<cr>
  inoremap <silent><F4> <esc>:AsyncTask cmake<cr>
  " grep
  nnoremap <silent><F2> :AsyncTask grep-word<cr><c-w>j
  inoremap <silent><F2> :AsyncTask grep-word<cr><c-w>j
  command -nargs=0 Evim AsyncTask grep-vim
endif

if index(g:bundle_group, 'task') >= 0
  Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary!' }
  " nnoremap - :exe "lcd %:p:h \| Clap filer"<cr>
  " hi ClapSpinner cterm=bold ctermbg=232 ctermfg=197
  " hi ClapSearchText cterm=bold ctermbg=232 ctermfg=253
  " hi ClapDisplay ctermbg=234 ctermfg=57
  let g:clap_theme = {
        \ 'spinner': {'cterm': 'bold', 'ctermbg': '29', 'ctermfg': '234'},
        \ 'search_text': {'ctermbg': '29', 'ctermfg': '235'},
        \ 'input': {'ctermbg': '29'},
        \ 'display': {'ctermbg': '239', 'ctermfg': '196'},
        \ 'current_selection': {'ctermbg': '31', 'ctermfg': 'fg'}
        \ }
endif

"----------------------------------------------------------------------
" 结束插件安装
"----------------------------------------------------------------------
call plug#end()
