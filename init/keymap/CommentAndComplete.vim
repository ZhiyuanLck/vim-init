" ======================================================================
"
" CommentAndComplete.vim - 注释和手动补全
"
"     - ALT+/注释
"     - ALT+,补全

" Author: zhiyuan
" GitHub: https://github.com/ZhiyuanLck
" Creation Time: 2018-08-14 13:42:06
" Last Modified: 2018-08-14 20:15:43
"
" ======================================================================


" **********************************************************************
" ALT+/对当前行或者选中的行进行注释
" **********************************************************************
function s:comment_(mark) range
	let lnum = a:firstline
	let pos = getcurpos()
	let n = len(a:mark) + 1

	while lnum <= a:lastline
		let pat = match(trim(getline(lnum)), "^".a:mark)
		if pat == -1
			exe ''.lnum .'normal I' .a:mark .' '
			if lnum == a:firstline
				let pos[2] += n
			endif
		else
			exe ''.lnum .'normal ^d' .n .'l'
			if lnum == a:firstline
				let pos[2] -= n
			endif
		endif
		let lnum += 1
	endwhile

	call setpos('.', pos)
endfunc

function s:comment()
	" 自行添加不同文件的注释标记
	let mark_dict = {
		\'c': '//',
		\'cpp': '//',
		\'vim': '"',
		\'python': '#'}
	let mark = mark_dict[&ft]

	if mark == '"'
		let map_temp = maparg('"', 'i')
		exe 'iunmap <buffer> "'
	endif

	if index(["n", "niI", "i"], mode()) != -1
		call s:comment_(mark)
	elseif index(['v', 'V', 'CTRL-V', 's', 'S', 'CTRL-S'], mode()) != -1
		'<,'>call s:comment_(mark)
	endif

	if mark == '"'
		exe 'imap <buffer> " '.map_temp
	endif
endfunc

" <m-/>进行注释
augroup Comment
	autocmd!

	autocmd FileType c,cpp,python,vim noremap <silent> <m-/> :call <SID>comment()<cr>
	autocmd FileType c,cpp,python,vim inoremap <silent> <m-/> <esc>:call <SID>comment()<cr>a

augroup END


" **********************************************************************
" 输入关键字ALT+,自动补全
" **********************************************************************
function s:complete(mark, start, ...)
	let curl = getline('.')
	let n = len(a:mark)

	if &et
		let num = (len(curl)-n) / &ts
	else
		let num = len(curl) - n
	endif

	call setline('.', a:start)

	for iline in a:000
		call append(line('.')+index(a:000, iline), iline)
	endfor
	
	if num
		exe '.,.+' .a:0 .'normal V' .num .'>'
	endif
endfunc

" vimscript补全
function s:complete_vim()
	let vim_mark = {
			\'au': ['augroup ', 'augroup END'],
			\'if': ['if ', 'endif'],
			\'fo': ['for ', 'endfor'],
			\'wh': ['while ', 'endwhile'],
			\'fu': ['function ', 'endfunc']
			\}

	let curl = getline('.')
	let str = strpart(curl, col('.')-2, 2)

	if has_key(vim_mark, str)
		let pos = getcurpos()
		call call('s:complete', extend(['vi'], vim_mark[str]))
		call setpos('.', pos)
	endif
endfunc

augroup Complete_
	autocmd!
	au BufNewFile,BufRead *.vim
			\ inoremap <silent> <m-,> <esc>:call <SID>complete_vim()<cr>A
augroup END

