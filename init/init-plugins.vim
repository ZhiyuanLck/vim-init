" 取得本文件所在的目录
let s:plughome = fnamemodify(resolve(expand('<sfile>:p')), ':h')

" 仓库格式
let g:plug_url_format = 'https://hub.fastgit.org/%s.git'

" 定义一个命令用来加载插件配置
command! -nargs=1 LoadPlug exec 'so '.s:plughome.'/plugin-setting/'.'<args>.vim'

"----------------------------------------------------------------------
" 默认情况下的分组，可以在前面覆盖之
"----------------------------------------------------------------------
if !exists('g:bundle_group')
  let g:bundle_group = []
  let g:bundle_group += ['basic']
  let g:bundle_group += ['tags']
  let g:bundle_group += ['enhanced']
  let g:bundle_group += ['filetypes']
  let g:bundle_group += ['textobj']
  let g:bundle_group += ['airline']
  let g:bundle_group += ['snip']
  let g:bundle_group += ['coc']
  let g:bundle_group += ['leaderf']
  " let g:bundle_group += ['lsp']
  let g:bundle_group += ['markdown']
  " let g:bundle_group += ['clap']
  let g:bundle_group += ['edit']
  let g:bundle_group += ['task']
  let g:bundle_group += ['float']
  let g:bundle_group += ['multi-cursor']
  " let g:bundle_group += ['fcitx']
  " let g:bundle_group += ['icon']
  " let g:bundle_group = ['coc', 'leaderf']
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
" Plug 'google/vim-searchindex'

" 全文快速移动，<leader><leader>f{char} 即可触发
" Plug 'easymotion/vim-easymotion'
" map <silent>f <Plug>(easymotion-f)
" map <silent>t <Plug>(easymotion-t)
" map <silent>b <Plug>(easymotion-s)
Plug 'justinmk/vim-sneak'
nnoremap <silent> f :<C-U>call sneak#wrap('',           1, 0, 1, 1)<CR>
nnoremap <silent> F :<C-U>call sneak#wrap('',           1, 1, 1, 1)<CR>
xnoremap <silent> f :<C-U>call sneak#wrap(visualmode(), 1, 0, 1, 1)<CR>
xnoremap <silent> F :<C-U>call sneak#wrap(visualmode(), 1, 1, 1, 1)<CR>
onoremap <silent> f :<C-U>call sneak#wrap(v:operator,   1, 0, 1, 1)<CR>
onoremap <silent> F :<C-U>call sneak#wrap(v:operator,   1, 1, 1, 1)<CR>
let g:sneak#label = 1

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
" Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
Plug 'junegunn/vim-easy-align'
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

let g:easy_align_delimiter_align='l'

" Diff 增强，支持 histogram / patience 等更科学的 diff 算法
" Plug 'chrisbra/vim-diff-enhanced'

" 中文文档
" Plug 'yianwillis/vimcdoc'

" Plug 'tpope/vim-surround'
Plug 'machakann/vim-sandwich'

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
  " Plug 'mhinz/vim-startify'

  " 一次性安装一大堆 colorscheme
  Plug 'flazz/vim-colorschemes'

  " 支持库，给其他插件用的函数库
  " Plug 'xolox/vim-misc'

  " 用于在侧边符号栏显示 marks （ma-mz 记录的位置）
  Plug 'kshenoy/vim-signature'

  " 用于在侧边符号栏显示 git/svn 的 diff
  " Plug 'mhinz/vim-signify'
  Plug 'airblade/vim-gitgutter'
  nmap ]h <Plug>(GitGutterNextHunk)
  nmap [h <Plug>(GitGutterPrevHunk)
  omap ih <Plug>(GitGutterTextObjectInnerPending)
  omap ah <Plug>(GitGutterTextObjectOuterPending)
  xmap ih <Plug>(GitGutterTextObjectInnerVisual)
  xmap ah <Plug>(GitGutterTextObjectOuterVisual)
  let g:gitgutter_sign_added = '▐'
  let g:gitgutter_sign_modified = '▐'
  let g:gitgutter_sign_removed = '▐'
  let g:gitgutter_preview_win_floating = 1
  " signify 调优
  " let g:signify_vcs_list = ['git', 'svn']
  " let g:signify_sign_add         = '+'
  " let g:signify_sign_delete      = '_'
  " let g:signify_sign_delete_first_line = '‾'
  " let g:signify_sign_change      = '~'
  " let g:signify_sign_changedelete    = g:signify_sign_change

  " git 仓库使用 histogram 算法进行 diff
  let g:signify_vcs_cmds = {
      \ 'git': 'git diff --no-color --diff-algorithm=histogram --no-ext-diff -U0 -- %f',
      \}

  " 根据 quickfix 中匹配到的错误信息，高亮对应文件的错误行
  " 使用 :RemoveErrorMarkers 命令或者 <space>ha 清除错误
  " Plug 'mh21/errormarker.vim'

  " 使用 ALT+e 会在不同窗口/标签上显示 A/B/C 等编号，然后字母直接跳转
  " Plug 't9md/vim-choosewin'

  " 提供基于 TAGS 的定义预览，函数参数预览，quickfix 预览
  " Plug 'skywind3000/vim-preview'
  " autocmd FileType qf nnoremap <silent><buffer> p :PreviewQuickfix<cr>
  " autocmd FileType qf nnoremap <silent><buffer> P :PreviewClose<cr>

  " Git 支持
  Plug 'tpope/vim-fugitive'

  " 智能注释
  Plug 'scrooloose/nerdcommenter'
  let g:NERDSpaceDelims=1
  let g:NERDRemoveExtraSpaces=1
  function! SetCommentAlign()
    if index(['tex', 'sty', 'cls', 'dtx'], expand('%:e')) >= 0
      let g:NERDRemoveExtraSpaces=0
      let g:NERDDefaultAlign='start'
    else
      let g:NERDRemoveExtraSpaces=1
      let g:NERDDefaultAlign='none'
    endif
  endfunction
  augroup CommentAlignStart
    autocmd!
    autocmd BufNewFile,BufRead * silent call SetCommentAlign()
  augroup END
  let g:NERDCustomDelimiters = {
    \ 'sty': { 'left': '%'},
    \ 'cls': { 'left': '%'}
    \ }
  nnoremap <silent><m-/> :call NERDComment('n', 'Invert')<cr>
  inoremap <silent><m-/> :call NERDComment('n', 'Invert')<cr>a
  xnoremap <silent><m-/> :call NERDComment('x', 'Invert')<cr>

  " 使用 ALT+E 来选择窗口
  " nmap <m-e> <Plug>(choosewin)

  " 默认不显示 startify
  " let g:startify_disable_at_vimenter = 1
  " let g:startify_session_dir = '~/.vim/session'

  " 使用 <space>ha 清除 errormarker 标注的错误
  " noremap <silent><space>ha :RemoveErrorMarkers<cr>

endif


"----------------------------------------------------------------------
" 增强插件
"----------------------------------------------------------------------
if index(g:bundle_group, 'enhanced') >= 0

  " 用 v 选中一个区域后，ALT_+/- 按分隔符扩大/缩小选区
  " Plug 'terryma/vim-expand-region'

  " 快速文件搜索
  " Plug 'junegunn/fzf'

  " 给不同语言提供字典补全，插入模式下 c-x c-k 触发
  " Plug 'asins/vim-dict'

  " 配对括号和引号自动补全
  " Plug 'Raimondi/delimitMate'
  Plug 'jiangmiao/auto-pairs'
  let g:AutoPairsShortcutToggle = '<c-p>'
  let g:AutoPairsShortcutFastWrap = '<m-e>'
  let g:AutoPairsMapCh = 0
  " let g:AutoPairsFlyMode = 1
  let s:pairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', '`':'`', '<':'>'}
  " let g:sandwich#recipes += [
        " \   {
        " \     'buns': ['<', '>'],
" }
  augroup MyPair
    autocmd!
    autocmd FileType tex let b:AutoPairs =
          \ AutoPairsDefine(s:pairs->extend({'$':'$'}))
  augroup END

  " 提供 gist 接口
  " Plug 'lambdalisue/vim-gista', { 'on': 'Gista' }
  
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

  " 设定项目目录标志：除了 .git/.svn 外，还有 .root 文件
  let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']
  let g:gutentags_ctags_tagfile = '.tags'
  let g:gutentags_define_advanced_commands = 1

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
  Plug 'bps/vim-textobj-python', {'for': 'python'}

  " 提供 uri/url 的文本对象，iu/au 表示
  Plug 'jceb/vim-textobj-uri'
endif


"----------------------------------------------------------------------
" 文件类型扩展
"----------------------------------------------------------------------
if index(g:bundle_group, 'filetypes') >= 0

  " powershell 脚本文件的语法高亮
  " Plug 'pprovost/vim-ps1', { 'for': 'ps1' }

  " lua 语法高亮增强
  " Plug 'tbastos/vim-lua', { 'for': 'lua' }

  " C++ 语法高亮增强，支持 11/14/17 标准
  Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['c', 'cpp'] }

  " 额外语法文件
  Plug 'justinmk/vim-syntax-extra', { 'for': ['c', 'bison', 'flex', 'cpp'] }

  " python 语法文件增强
  " Plug 'vim-python/python-syntax', { 'for': ['python'] }

  " rust 语法增强
  " Plug 'rust-lang/rust.vim', { 'for': 'rust' }

  " vim org-mode
  " Plug 'jceb/vim-orgmode', { 'for': 'org' }
endif


"----------------------------------------------------------------------
" airline
"----------------------------------------------------------------------
if index(g:bundle_group, 'airline') >= 0
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  " powerline symbols
  if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif
  let g:airline_powerline_fonts = 1
"   let g:airline_left_sep = ''
"   let g:airline_left_alt_sep = ''
"   let g:airline_right_sep = ''
"   let g:airline_right_alt_sep = ''
  let g:airline_left_sep = ''
  let g:airline_left_alt_sep = ''
  let g:airline_right_sep = ''
  let g:airline_right_alt_sep = ''
  let g:airline_symbols.branch = ''
  let g:airline_symbols.readonly = ''
  let g:airline_symbols.linenr = '☰ '
  let g:airline_symbols.maxlinenr = ''
  let g:airline_symbols.dirty='⚡'

  let g:airline_exclude_preview = 1
"   let g:airline_section_b = '%n'
  let g:airline_theme='minimalist'
"   let g:airline_theme='angr'
  let g:airline#extensions#branch#enabled = 1
  let g:airline#extensions#syntastic#enabled = 0
  let g:airline#extensions#fugitiveline#enabled = 1
  let g:airline#extensions#csv#enabled = 1
  let g:airline#extensions#vimagit#enabled = 0

  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#show_tabs = 1
  let g:airline#extensions#tabline#show_buffers = 0
  let g:airline#extensions#tabline#buffer_idx_mode = 1
  let g:airline#extensions#tabline#tab_nr_type = 1
  let g:airline#extensions#tabline#show_splits = 1

  let g:airline_buffer_map = 0

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

" coc
if index(g:bundle_group, 'coc') >= 0
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " Plug 'tjdevries/coc-zsh'
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
    let g:coc_global_extensions = ['coc-json', 'coc-tsserver', 'coc-cmake', 'coc-html', 'coc-solargraph', 'coc-pyright', 'coc-jedi', 'coc-highlight', 'coc-yank', 'coc-vimlsp', 'coc-xml', 'coc-markdownlint', 'coc-vimtex', 'coc-sh']

    " scroll
    nnoremap <expr><C-f> coc#float#has_float() ? coc#float#scroll(1) : "\<C-f>"
    nnoremap <expr><C-b> coc#float#has_float() ? coc#float#scroll(0) : "\<C-b>"

    " coc-translator
    nnoremap <leader>e :<c-u>CocCommand translator.popup<cr>
    vnoremap <leader>e :<c-u>CocCommand translator.popup<cr>

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
    command! -nargs=? Fold :call     CocAction('fold', <f-args>)

    " use `:OR` for organize import of current buffer
    command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

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
  LoadPlug LeaderF
endif

if index(g:bundle_group, 'lsp') >= 0
  " Plug 'Shougo/deoplete.nvim'
  Plug 'prabirshrestha/vim-lsp'
  Plug 'mattn/vim-lsp-settings'
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'prabirshrestha/asyncomplete-buffer.vim'
  let g:lsp_settings_root_markers = [
        \ '.root',
        \ '.git',
        \ '.git/',
        \ '.svn',
        \ '.hg',
        \ '.bzr'
        \ ]
  let g:lsp_diagnostics_float_cursor = 1
  inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
  au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'buffer',
    \ 'allowlist': ['*'],
    \ 'blocklist': ['go'],
    \ 'completor': function('asyncomplete#sources#buffer#completor'),
    \ 'config': {
    \    'max_buffer_size': 5000000,
    \  },
    \ }))
  function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
endif


"-----------------------------------------------------------------------
" MarkDown插件安装
"-----------------------------------------------------------------------
if index(g:bundle_group, 'markdown') >= 0
  " sudo npm -g install instant-markdown-d
  Plug 'instant-markdown/vim-instant-markdown', { 'for': 'markdown' }
  " Plug 'godlygeek/tabular', { 'for': 'markdown'}
  " Plug 'gabrielelana/vim-markdown', { 'for': 'markdown' }
  " Plug 'joker1007/vim-markdown-quote-syntax', { 'for': 'markdown' }
  " Plug 'iamcco/markdown-preview.vim', { 'for': 'markdown' }

  " 预览快捷键
  " nmap <silent> <F11> <Plug>MarkdownPreview
  " imap <silent> <F11> <Plug>MarkdownPreview
  " nmap <silent> <F12> <Plug>StopMarkdownPreview
  " imap <silent> <F12> <Plug>StopMarkdownPreview
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
  " let g:vimtex_syntax_enabled = 0
  " let g:vimtex_syntax_autoload_packages = [
        " \ 'amsmath',
        " \ 'array',
        " \ 'beamer',
        " \ 'hyperref',
        " \ 'mathtools',
        " \ 'minted',
        " \ 'pgfplots',
        " \ 'tikz',
        " \]
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


" task
if index(g:bundle_group, 'task') >= 0
  Plug 'skywind3000/asyncrun.vim'
  Plug 'skywind3000/asynctasks.vim'
  nnoremap <silent><space>ae :AsyncTaskEdit!<cr>
  nnoremap <silent><space>al :AsyncTaskList!<cr>
  nnoremap <silent><space>am :AsyncTaskMacro<cr>
  function! s:runner_proc(opts)
    let curr_bufnr = floaterm#curr()
    if has_key(a:opts, 'silent') && a:opts.silent == 1
      FloatermHide!
    endif
    let cmd = 'cd ' . shellescape(getcwd())
    call floaterm#terminal#send(curr_bufnr, [cmd])
    call floaterm#terminal#send(curr_bufnr, [a:opts.cmd])
    stopinsert
    if &filetype == 'floaterm' && g:floaterm_autoinsert
      call floaterm#util#startinsert()
    endif
  endfunction

  " let g:asyncrun_runner = get(g:, 'asyncrun_runner', {})
  " let g:asyncrun_runner.floaterm = function('s:runner_proc')

  let g:asyncrun_rootmarks = ['.git', '.svn', '.root', '.project', '.hg']
  let g:asynctasks_term_pos = 'tab'
  let g:asynctasks_term_pos = 'fterm'
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

if index(g:bundle_group, 'clap') >= 0
  Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary!' }
  let g:clap_layout = {'relative': 'editor'}
endif

if index(g:bundle_group, 'float') >= 0
  Plug 'ZhiyuanLck/vim-float-terminal'
  noremap <silent><m-m> <cmd>FtermNew --cwd .<cr>
  let g:fterm_autoquit = 0
  let g:asyncrun_runner = get(g:, 'asyncrun_runner', {})
  let g:asyncrun_runner.fterm = function('fterm#async_runner')
  let g:fterm_highlights = {
        \ "fterm_hl_border": {
        \   "ctermfg": 10,
        \   },
        \ "fterm_hl_termline_info": {
        \   "ctermfg": 255,
        \   "ctermbg": 245,
        \   },
        \ "fterm_hl_termline_normal": {
        \   "ctermfg": 252,
        \   "ctermbg": 240,
        \   },
        \ "fterm_hl_termline_current": {
        \   "ctermfg": 0,
        \   "ctermbg": 84,
        \   },
        \ "fterm_hl_terminal_body": {
        \   "ctermfg": "fg",
        \   "ctermbg": "NONE",
        \   },
        \ "fterm_hl_termline_body": {
        \   "ctermfg": "fg",
        \   "ctermbg": "NONE",
        \   },
        \ }
  Plug 'ZhiyuanLck/vim-lf'
  nnoremap <silent>- <cmd>Lf .<cr>
  " let g:vlf_file_numbered = 1
  Plug 'ZhiyuanLck/vim-support'
  " Plug 'ZhiyuanLck/vim-session'
  Plug 'skywind3000/vim-cppman'
  let g:cppman_open_mode = "vert botright"
  Plug 'puremourning/vimspector'
  " let g:vimspector_enable_mappings = 'HUMAN'
  Plug 'ZhiyuanLck/vim-diary'
endif

if index(g:bundle_group, 'multi-cursor') >= 0
  Plug 'terryma/vim-multiple-cursors'
endif

if index(g:bundle_group, 'fcitx') >= 0
  Plug 'lilydjwg/fcitx.vim'
endif

if index(g:bundle_group, 'icon') >= 0
  " icons
  Plug 'ryanoasis/vim-devicons'
endif

"----------------------------------------------------------------------
" 结束插件安装
"----------------------------------------------------------------------
call plug#end()

noremap <silent><leader>vn <Plug>VimspectorContinue
noremap <silent><leader>vs <Plug>VimspectorStop
noremap <silent><leader>vr <Plug>VimspectorRestart
noremap <silent><leader>vp <Plug>VimspectorPause
noremap <silent><leader>vt <Plug>VimspectorToggleBreakpoint
noremap <silent><leader>vy <Plug>VimspectorToggleConditionalBreakpoint
noremap <silent><leader>vf <Plug>VimspectorAddFunctionBreakpoint
noremap <silent><leader>vg <Plug>VimspectorStepOver
noremap <silent><leader>vi <Plug>VimspectorStepInto
noremap <silent><leader>vo <Plug>VimspectorStepOut
noremap <silent><leader>vc <Plug>VimspectorRunToCursor
noremap <silent><leader>vv :call vimspector#Lauch()<cr>
