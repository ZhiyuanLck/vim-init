" ======================================================================
"
" edit.vim - 快捷键快速编辑代码
"
" Author: zhiyuan
" GitHub: https://github.com/ZhiyuanLck
" Creation Time: 2018-08-14 13:42:06
" Last Modified: 2018-08-14 22:35:14
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
noremap <silent> <leader>i :exe "call append('.', '') \| call append(line('.')-1, '')"<cr>

" ALT+w/q快速保存退出
noremap <silent> <m-w> mm:w!<cr>`m:delmark m<cr>
noremap <m-q> :q!<cr>
inoremap <silent> <m-w> <esc>mm:w!<cr>`m:delmark m<cr>
inoremap <m-q> <esc>:q!<cr>

