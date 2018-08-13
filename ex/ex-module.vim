"=======================================================================
"
" Author: zhiyuan
" GitHub: https://github.com/ZhiyuanLck
" Creation Time: 2018-08-13 13:23:27
" Last Modified: 2018-08-13 13:51:21
"
"=======================================================================


function! Create_message()
	let mark = {
		\'c': '//',
		\'cpp': '//',
		\'vim': '"',
		\'python': '#'}
	let str_0 = mark[&ft].repeat('=', 71)
	let str_1 = 'Author: zhiyuan'
	let str_2 = 'GitHub: https://github.com/ZhiyuanLck'
	let str_3 = 'Creation Time: ' .strftime('%Y-%m-%d %T')
	let str_4 = 'Last Modified: ' .strftime('%Y-%m-%d %T')
	call setline(1, [str_0, mark[&ft], str_1, str_2, str_3, str_4, mark[&ft], str_0])
	exe '3,$-2normal I' .mark[&ft] .' '
endfunc

function! Last_mode()
	if line('$') > 20
		let l = 20
	else
		let l = line('$')
	endif
	exe "1," . l . "g/Last Modified: /s/Last Modified: .*/Last Modified: "
			\ .strftime('%Y-%m-%d %T')
endfunc

augroup My_messages
	au!
	au BufNewFile *.* call Create_message()
	au BufWritePre *.* ks|call Last_mode()|'s
augroup END
