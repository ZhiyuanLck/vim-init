"=======================================================================
"
" Author: zhiyuan
" GitHub: https://github.com/ZhiyuanLck
" Creation Time: 2018-08-13 13:23:27
" Last Modified: 2018-08-13 16:13:13
"
"=======================================================================

function! Create_message()
	let str_0 = repeat('=', 71)
	let str_1 = 'Author: zhiyuan'
	let str_2 = 'GitHub: https://github.com/ZhiyuanLck'
	let str_3 = 'Creation Time: ' .strftime('%Y-%m-%d %T')
	let str_4 = 'Last Modified: ' .strftime('%Y-%m-%d %T')
	call setline(1, [str_0, '', str_1, str_2, str_3, str_4, '', str_0])
	exe "%normal \<m-/>"
	exe "%s/ $//g"
endfunc

function! Last_mode()
	if expand('%') == 'ex-module.vim'
		return
	endif

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
	au BufWritePre *.* ks|call Last_mode()|'s|delmark s
augroup END
