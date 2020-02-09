" ======================================================================
"
" move.vim - 光标移动按键设置
"
"     - EMACS键位设置
"     - COMMAND模式快速移动
"     - CTRL+HJKL移动
"     - ALT键快速移动
"     - 异步滚动窗口
"
" Author: zhiyuan
" GitHub: https://github.com/ZhiyuanLck
" Creation Time: 2018-08-14 13:42:06
" Last Modified: 2018-08-15 15:01:46
"
" ======================================================================


" **********************************************************************
" INSERT 模式下使用 EMACS 键位
" **********************************************************************
inoremap <c-a> <home>
inoremap <c-e> <end>
inoremap <c-d> <del>
inoremap <c-_> <c-k>


" **********************************************************************
" COMMAND模式下快速移动
" **********************************************************************
cnoremap <c-h> <left>
cnoremap <c-j> <down>
cnoremap <c-k> <up>
cnoremap <c-l> <right>
cnoremap <c-a> <home>
cnoremap <c-e> <end>
cnoremap <c-f> <c-d>
cnoremap <c-b> <left>
cnoremap <c-d> <del>
cnoremap <c-_> <c-k>

" ALT+h/l 快速左右按单词移动（命令模式）
cnoremap <m-h> <c-left>
cnoremap <m-l> <c-right>


" **********************************************************************
" 设置 CTRL+HJKL 移动光标（INSERT 模式偶尔需要移动的方便些）
" 使用 SecureCRT/XShell 等终端软件需设置：Backspace sends delete
" 详见：http://www.skywind.me/blog/archives/2021
" **********************************************************************
noremap <C-h> <left>
noremap <C-j> <down>
noremap <C-k> <up>
noremap <C-l> <right>
inoremap <C-h> <left>
inoremap <C-j> <down>
inoremap <C-k> <up>
inoremap <C-l> <right>


" **********************************************************************
" ALT键快速移动
" **********************************************************************
" ALT+h/l 快速左右按单词移动（正常模式+插入模式）
noremap <m-h> b
noremap <m-l> w
inoremap <m-h> <c-left>
inoremap <m-l> <c-right>

" ALT+j/k 逻辑跳转下一行/上一行（按 wrap 逻辑换行进行跳转）
" noremap <m-j> gj
" noremap <m-k> gk
" inoremap <m-j> <c-\><c-o>gj
" inoremap <m-k> <c-\><c-o>gk



" **********************************************************************
" 异步滚动窗口
" **********************************************************************
" 0:up, 1:down, 2:pgup, 3:pgdown, 4:top, 5:bottom
function! Tools_PreviousCursor(mode)
	if winnr('$') <= 1
		return
	endif
	noautocmd silent! wincmd p
	if a:mode == 0
		exec "normal! \<c-y>"
	elseif a:mode == 1
		exec "normal! \<c-e>"
	elseif a:mode == 2
		exec "normal! ".winheight('.')."\<c-y>"
	elseif a:mode == 3
		exec "normal! ".winheight('.')."\<c-e>"
	elseif a:mode == 4
		normal! gg
	elseif a:mode == 5
		normal! G
	elseif a:mode == 6
		exec "normal! \<c-u>"
	elseif a:mode == 7
		exec "normal! \<c-d>"
	elseif a:mode == 8
		exec "normal! k"
	elseif a:mode == 9
		exec "normal! j"
	endif
	noautocmd silent! wincmd p
endfunc

noremap <silent> <m-u> :call Tools_PreviousCursor(6)<cr>
inoremap <silent> <m-u> <esc>:call Tools_PreviousCursor(6)<cr>a
noremap <silent> <m-d> :call Tools_PreviousCursor(7)<cr>
inoremap <silent> <m-d> <esc>:call Tools_PreviousCursor(7)<cr>a
