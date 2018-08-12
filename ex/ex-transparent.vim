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

noremap <m-,> :call Transparent_toggle()<cr>
inoremap <m-,> <esc>:call Transparent_toggle()<cr>a
