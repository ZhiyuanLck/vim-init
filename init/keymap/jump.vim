" ======================================================================
"
" jump.vim - 快速切换编辑tab, buffer, window
"     - tab键位设置
"     - buffer键位设置
"     - window键位设置
"     - 新窗口标签页打开目录
"
" Author: zhiyuan
" GitHub: https://github.com/ZhiyuanLck
" Creation Time: 2018-08-14 13:42:06
" Last Modified: 2018-08-14 20:24:38
"
" ======================================================================


" **********************************************************************
" TAB键位设置
" **********************************************************************

" <leader>+数字键 切换tab
noremap <silent><leader>1 1gt<cr>
noremap <silent><leader>2 2gt<cr>
noremap <silent><leader>3 3gt<cr>
noremap <silent><leader>4 4gt<cr>
noremap <silent><leader>5 5gt<cr>
noremap <silent><leader>6 6gt<cr>
noremap <silent><leader>7 7gt<cr>
noremap <silent><leader>8 8gt<cr>
noremap <silent><leader>9 9gt<cr>
noremap <silent><leader>0 10gt<cr>

" 如果没有使用airline或者在插件之前加载
" if exists(g:airline_buffer_map) || g:airline_buffer_map == 0
if get(g:, 'airline_buffer_map', 0) < 1

  " ALT+N 切换 tab
  noremap <silent><m-1> :tabn 1<cr>
  noremap <silent><m-2> :tabn 2<cr>
  noremap <silent><m-3> :tabn 3<cr>
  noremap <silent><m-4> :tabn 4<cr>
  noremap <silent><m-5> :tabn 5<cr>
  noremap <silent><m-6> :tabn 6<cr>
  noremap <silent><m-7> :tabn 7<cr>
  noremap <silent><m-8> :tabn 8<cr>
  noremap <silent><m-9> :tabn 9<cr>
  noremap <silent><m-0> :tabn 10<cr>
  inoremap <silent><m-1> <ESC>:tabn 1<cr>
  inoremap <silent><m-2> <ESC>:tabn 2<cr>
  inoremap <silent><m-3> <ESC>:tabn 3<cr>
  inoremap <silent><m-4> <ESC>:tabn 4<cr>
  inoremap <silent><m-5> <ESC>:tabn 5<cr>
  inoremap <silent><m-6> <ESC>:tabn 6<cr>
  inoremap <silent><m-7> <ESC>:tabn 7<cr>
  inoremap <silent><m-8> <ESC>:tabn 8<cr>
  inoremap <silent><m-9> <ESC>:tabn 9<cr>
  inoremap <silent><m-0> <ESC>:tabn 10<cr>

  " MacVim 允许 CMD+数字键快速切换标签
  if has("gui_macvim")
    set macmeta
    noremap <silent><d-1> :tabn 1<cr>
    noremap <silent><d-2> :tabn 2<cr>
    noremap <silent><d-3> :tabn 3<cr>
    noremap <silent><d-4> :tabn 4<cr>
    noremap <silent><d-5> :tabn 5<cr>
    noremap <silent><d-6> :tabn 6<cr>
    noremap <silent><d-7> :tabn 7<cr>
    noremap <silent><d-8> :tabn 8<cr>
    noremap <silent><d-9> :tabn 9<cr>
    noremap <silent><d-0> :tabn 10<cr>
    inoremap <silent><d-1> <ESC>:tabn 1<cr>
    inoremap <silent><d-2> <ESC>:tabn 2<cr>
    inoremap <silent><d-3> <ESC>:tabn 3<cr>
    inoremap <silent><d-4> <ESC>:tabn 4<cr>
    inoremap <silent><d-5> <ESC>:tabn 5<cr>
    inoremap <silent><d-6> <ESC>:tabn 6<cr>
    inoremap <silent><d-7> <ESC>:tabn 7<cr>
    inoremap <silent><d-8> <ESC>:tabn 8<cr>
    inoremap <silent><d-9> <ESC>:tabn 9<cr>
    inoremap <silent><d-0> <ESC>:tabn 10<cr>
  endif

  " TAB：创建，关闭，上一个，下一个，左移，右移
  noremap <silent> <leader>tc :tabnew<cr>
  noremap <silent> <leader>tq :tabclose<cr>
  noremap <silent> <leader>tn :tabnext<cr>
  noremap <silent> <leader>tp :tabprev<cr>

  " 左移 tab
  function! Tab_MoveLeft()
    let l:tabnr = tabpagenr() - 2
    if l:tabnr >= 0
      exec 'tabmove '.l:tabnr
    endif
  endfunc

  " 右移 tab
  function! Tab_MoveRight()
    let l:tabnr = tabpagenr() + 1
    if l:tabnr <= tabpagenr('$')
      exec 'tabmove '.l:tabnr
    endif
  endfunc

  noremap <silent><leader>tl :call Tab_MoveLeft()<cr>
  noremap <silent><leader>tr :call Tab_MoveRight()<cr>
  noremap <silent><m-left> :call Tab_MoveLeft()<cr>
  noremap <silent><m-right> :call Tab_MoveRight()<cr>

endif

" **********************************************************************
" 缓存：插件 unimpaired 中定义了 [b, ]b 来切换缓存
" **********************************************************************
noremap <silent> <leader>bn :bn<cr>
noremap <silent> <leader>bp :bp<cr>


" **********************************************************************
" 窗口切换：ALT+SHIFT+hjkl
" 传统的 CTRL+hjkl 移动窗口不适用于 vim 8.1 的终端模式，CTRL+hjkl 在
" bash/zsh 及带文本界面的程序中都是重要键位需要保留，不能 tnoremap 的
" **********************************************************************
noremap <m-h> <c-w>h
noremap <m-l> <c-w>l
noremap <m-j> <c-w>j
noremap <m-k> <c-w>k
inoremap <m-h> <cmd>exec "norm! \<c-w>h"
inoremap <m-l> <cmd>exec "norm! \<c-w>l"
inoremap <m-j> <cmd>exec "norm! \<c-w>j"
inoremap <m-k> <cmd>exec "norm! \<c-w>k"

if has('terminal') && exists(':terminal') == 2 && has('patch-8.1.1')
  " vim 8.1 支持 termwinkey ，不需要把 terminal 切换成 normal 模式
  " 设置 termwinkey 为 CTRL 加减号（GVIM），有些终端下是 CTRL+?
  " 后面四个键位是搭配 termwinkey 的，如果 termwinkey 更改，也要改
  set termwinkey=<c-_>
  tnoremap <m-H> <c-_>h
  tnoremap <m-L> <c-_>l
  tnoremap <m-J> <c-_>j
  tnoremap <m-K> <c-_>k
  tnoremap <m-q> <c-\><c-n>
elseif has('nvim')
  " neovim 没有 termwinkey 支持，必须把 terminal 切换回 normal 模式
  " tnoremap <m-h> <c-\><c-n><c-w>h
  " tnoremap <m-l> <c-\><c-n><c-w>l
  " tnoremap <m-j> <c-\><c-n><c-w>j
  " tnoremap <m-k> <c-\><c-n><c-w>k
  " tnoremap <m-q> <c-\><c-n>
endif


" **********************************************************************
" 新建标签页窗口打开目录
" **********************************************************************
function s:new_edit(mode)
  if a:mode == 'r'
    exe "vsp \| normal -"
  elseif a:mode == 'l'
    exe "vsp \| normal \<m-H>-"
  elseif a:mode == 't'
    exe "sp \| normal -"
  elseif a:mode == 'b'
    exe "sp \| normal \<m-J>-"
  elseif a:mode == 'c'
    let s:path = fnamemodify(bufname('%'), ':p')
    tabnew
    exec 'Clap filer '.s:path
  elseif a:mode == 'o'
    exe "tabnew \| LeaderfMru"
  endif
endfunc

noremap <silent> <tab>r :call <SID>new_edit('r')<cr>
noremap <silent> <tab>l :call <SID>new_edit('l')<cr>
noremap <silent> <tab>t :call <SID>new_edit('t')<cr>
noremap <silent> <tab>b :call <SID>new_edit('b')<cr>
noremap <silent> <tab>c :call <SID>new_edit('c')<cr>
noremap <silent> <tab>o :call <SID>new_edit('o')<cr>

" tab pre next
noremap <silent> <tab>n :tabn<cr>
noremap <silent> <tab>p :tabp<cr>


" **********************************************************************
" cancle highlight when search
" **********************************************************************
" noremap <silent> <space>hl :set nohlsearch<cr>
" noremap <silent> n :set hlsearch<cr>n
" noremap <silent> N :set hlsearch<cr>N
" noremap <silent> / :set hlsearch<cr>/
" noremap <silent> ? :set hlsearch<cr>?
" noremap <silent> * *:set hlsearch<cr>

" **********************************************************************
" any jump

" lr=1 left: right | lr=0 right: left
function! s:get_dic(lr) abort
  let pair_dic = {}
  for [ft, pairs] in items(s:pair)
    let tmp_dic = {}
    for pair in pairs
      if a:lr
        let tmp_dic[pair[0]] = pair[1]
      else
        let tmp_dic[pair[1]] = pair[0]
      endif
    endfor
    let pair_dic[ft] = tmp_dic
  endfor
  for [ft, pairs] in items(pair_dic)
    if ft != '*'
      let pair_dic[ft] = pair_dic['*']->extend(pair_dic[ft])
    endif
  endfor
  return pair_dic
endfunction

function! s:get_del_list(left) abort
  let dels = {}
  let ft_pair_dic = a:left == 1 ? s:lrpair : s:rlpair
  for [ft, pair_dic] in ft_pair_dic->items()
    let dels[ft] = pair_dic->keys()
  endfor
  return dels
endfunction

function! s:is_left(ldel) abort
  let ldels = get(s:ldels, &ft, s:ldels['*'])
  return match(ldels, a:ldel) != -1
endfunction

function! s:jump_any(str, left) abort
  let insert = mode() == 'i'
  let pattern = printf('\V%s', a:str->substitute("\\", "\\\\", 'g'))
  let flags = a:left ? 'b' : 'e'
  let flags .= insert && !a:left ? 'c' : ''
  let flags .= 'nW'
" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  " avoid match the same place in insert mode
  if a:left && insert && col('.') > 1
    let cur_col = col('.')
    let [lnum, col] = searchpos(pattern, 'becnW')
    let pre_ch = strcharpart(getline('.')[cur_col - 2:], 0, 1)
    if s:is_left(pre_ch)
      let pre_lnum = line('.') > 1 ? line('.') - 1 : line('.')
      let pre_col = line('.') > 1 ? getline('.')->len() : col('.')
      let lnum = cur_col == 2 ? pre_lnum : line('.')
      let col = cur_col == 2 ? pre_col : col('.') - 2
      call setpos('.', [0, lnum, col, 0])
    endif
  endif
  let [lnum, col] = searchpos(pattern, flags)
  if lnum == 0 && col == 0
    return
  endif
  if insert
    let col += 1
  endif
  call setpos('.', [0, lnum, col, 0])
endfunction

function! s:jump(left) abort
  let insert = mode() == 'i'
  let ft_dels = a:left == 1 ? s:ldels : s:rdels
  let dels = get(ft_dels, &ft, ft_dels['*'])
  let escape = ']'
  let pattern = '['
  for deli in dels
    if stridx(escape, deli) != -1
      let deli = '\'.deli
    endif
    let pattern .= deli
  endfor
  let pattern .= ']'
  let flags = a:left ? 'b' : ''
  let flags .= insert ? 'c' : ''
  let flags .= 'nW'
  " avoid match the same place in insert mode
  if a:left && insert && col('.') > 1
    let cur_col = col('.')
    let pre_ch = strcharpart(getline('.')[cur_col - 2:], 0, 1)
    if s:is_left(pre_ch)
      let pre_lnum = line('.') > 1 ? line('.') - 1 : line('.')
      let pre_col = line('.') > 1 ? getline('.')->len() : col('.')
      let lnum = cur_col == 2 ? pre_lnum : line('.')
      let col = cur_col == 2 ? pre_col : col('.') - 2
      call setpos('.', [0, lnum, col, 0])
    endif
  endif
  let [lnum, col] = searchpos(pattern, flags)
  if lnum == 0 && col == 0
    return
  endif
  if insert
    let col += 1
  endif
  call setpos('.', [0, lnum, col, 0])
endfunction

let s:pair = {'*': ['""', "''", '()', '[]', '{}'], 'tex': ['$$']}
let s:lrpair = s:get_dic(1)
let s:rlpair = s:get_dic(0)
let s:ldels = s:get_del_list(1)
let s:rdels = s:get_del_list(0)

" inoremap <silent><m-l> <cmd>call <sid>jump(0)<cr>
" inoremap <silent><m-h> <cmd>call <sid>jump(1)<cr>
" noremap <silent><m-l> <cmd>call <sid>jump(0)<cr>
" noremap <silent><m-h> <cmd>call <sid>jump(1)<cr>

" 自动居中
augroup AutoCenter
  autocmd!
  autocmd CursorMoved,CursorMovedI * norm! zz
augroup END
