" ======================================================================
"
" edit.vim - 快捷键快速编辑代码
"
" Author: zhiyuan
" GitHub: https://github.com/ZhiyuanLck
" Creation Time: 2018-08-14 13:42:06
" Last Modified: 2018-09-13 22:28:26
"
" ======================================================================

" INSERT模式下ALT+o/O快速插入新行编辑
inoremap <m-o> <esc>o
inoremap <m-O> <esc>O

" ALT+i/I在下方/上方插入空白行
noremap <silent> <m-i> :call append('.', '')<cr>
inoremap <silent> <m-i> <esc>:call append('.', '')<cr>


" ALT+w/q快速保存退出
noremap <silent> <m-w> mb:w!<cr>`b:delmark b<cr>
noremap <m-q> :q!<cr>
" noremap <m-q> :bd<cr>
inoremap <silent> <m-w> <esc>mb:w!<cr>`b:delmark b<cr>
inoremap <m-q> <esc>:q!<cr>
" inoremap <m-q> <esc>:bd<cr>

inoremap <s-tab> <c-v><tab>

" copy and paste
set clipboard=unnamedplus
" noremap <silent>y y<cmd>call setreg('*', getreg('0'), getregtype('0'))<cr>
" noremap <silent>p p<cmd>call setreg('*', getreg('0'), getregtype('0'))<cr>
" noremap <silent>P P<cmd>call setreg('*', getreg('0'), getregtype('0'))<cr>
noremap P o<esc>p
vnoremap p p<cmd>call setreg('+', getreg('0'), getregtype('0'))<cr>
map Y y$
map L $

" 宏操作
for i in range(97, 122)
  let s:char = nr2char(i)
  exec 'nmap <space><space>'.s:char.' @'.s:char
endfor

function! s:align_left_and_right() abort
  let list = split(getline('.'), '\v([*|]\zs\s+|\s+\ze[*|])')
  let space_lenth = 78 - len(list[0]) - len(list[1])
  call setline(line('.'), list[0].repeat(' ', space_lenth).list[1])
endfunction

function! s:set_vim_doc() abort
  noremap <m-;> :call <sid>align_left_and_right()<cr>
  inoremap <m-;> <esc>:call <sid>align_left_and_right()<cr>
  noremap <m-'> :call append(line('.'), repeat('=', 78))<cr>
  inoremap <m-'> <esc>:call append(line('.'), repeat('=', 78))<cr>
  setlocal tw=78 scl=no
endfunction

augroup VimDocEdit
  autocmd!
  autocmd BufNew,BufRead *.txt call s:set_vim_doc()
augroup END
