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


" ALT+a删除到行首非空白字符
noremap <m-a> d^x
inoremap <m-a> d^s

" ALT+y 删除到行末
noremap <m-y> d$
inoremap <m-y> <c-\><c-o>d$

" ALT+c清空当前行
noremap <m-c> ^d$
inoremap <m-c> <esc>^c$

" INSERT模式下ALT+o/O快速插入新行编辑
inoremap <m-o> <esc>o
inoremap <m-O> <esc>O

" ALT+i/I在下方/上方插入空白行
noremap <silent> <m-i> :call append('.', '')<cr>
inoremap <silent> <m-i> <esc>:call append('.', '')<cr>
noremap <silent> <m-I> :call append(line('.')-1, '')<cr>
inoremap <silent> <m-I> <esc>:call append(line('.')-1, '')<cr>

" LEADER+i在当前行的上下方分别插入空白行
noremap <silent> <leader>i vi{s  <esc>hp

" ALT+w/q快速保存退出
noremap <silent> <m-w> mb:w!<cr>`b:delmark b<cr>
noremap <m-q> :q!<cr>
" noremap <m-q> :bd<cr>
inoremap <silent> <m-w> <esc>mb:w!<cr>`b:delmark b<cr>
inoremap <m-q> <esc>:q!<cr>
" inoremap <m-q> <esc>:bd<cr>

" surround
nmap <space>mw ysw$
nmap <space>mW ysW$
nmap <space>m( ysa($
nmap <space>m{ ysa{$
nmap <space>m[ ysa[$
vmap <space>m S$

" copy and paste
nnoremap <space>y "+y
vnoremap <space>y "+y
nnoremap <space>p "+p
vnoremap <space>p "+p
nnoremap <space>P "+P
vnoremap <space>P "+P

function! MyPaste(ex)
  let save_reg = @"
  let reg = v:register
  let l:count = v:count1
  let save_map = maparg('_', 'v', 0, 1)
  exec 'vnoremap _ '.a:ex
  exec 'normal gv"'.reg.l:count.'_'
  call mapset('v', 0, save_map)
  let @" = save_reg
endfunction
" p不替换无名寄存器内容
vmap p :<c-u>call MyPaste('p')<cr>
vmap P :<c-u>call MyPaste('P')<cr>

" 宏操作
for i in range(97, 122)
  let s:char = nr2char(i)
  exec 'nmap <space><space>'.s:char.' @'.s:char
endfor
