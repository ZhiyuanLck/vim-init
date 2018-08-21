" ======================================================================
"
" auxiliary.vim - 想起来就增加的辅助功能
"     - ALT+.窗口半透明
"     - ALT+z禁用/开启鼠标和方向键
"
" Author: zhiyuan
" GitHub: https://github.com/ZhiyuanLck
" Creation Time: 2018-08-14 13:42:06
" Last Modified: 2018-08-21 12:00:16
"
" ======================================================================


" **********************************************************************
" ALT+.窗口半透明
" **********************************************************************
let g:transparency = 255
let g:half_tr = 140

function! Transparent_toggle()
	if g:transparency == 255
		let g:transparency = g:half_tr
	else
		let g:transparency = 255
	endif

py3 << EOF
import win32con
import win32gui
import vim

alpha = int(vim.eval('g:transparency'))
hwnd = win32gui.FindWindow('Vim', None)
s = win32gui.GetWindowLong(hwnd,win32con.GWL_EXSTYLE)
win32gui.SetWindowLong(hwnd, win32con.GWL_EXSTYLE, s | win32con.WS_EX_LAYERED)
win32gui.SetLayeredWindowAttributes(hwnd, 0, alpha, win32con.LWA_ALPHA)
EOF

endfunc

if (has('win32') || has('win64')) && has('gui_running')
	noremap <silent> <m-.> :call Transparent_toggle()<cr>
	inoremap <silent> <m-.> <esc>:call Transparent_toggle()<cr>a
endif


" **********************************************************************
" ALT+z禁用/开启鼠标和方向键
" **********************************************************************
" 0关闭，1开启
let s:mode = 1

function s:change_mode()
	if !s:mode
		set mouse=a
		map <left> <left>
		map <right> <right>
		map <up> <up>
		map <down> <down>
		map! <left> <left>
		map! <right> <right>
		map! <up> <up>
		map! <down> <down>
		let s:mode = 1
	else
		set mouse=
		map <left> <nop>
		map <right> <nop>
		map <up> <nop>
		map <down> <nop>
		map! <left> <nop>
		map! <right> <nop>
		map! <up> <nop>
		map! <down> <nop>
		let s:mode = 0
	endif
endfunc

silent call s:change_mode()

noremap <silent> <m-z> :call <SID>change_mode()<cr>
inoremap <silent> <m-z> <esc>:call <SID>change_mode()<cr>a
