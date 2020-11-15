function! s:show_cterm_color()
  call popup_clear()
  let winid = popup_create('', {})
  let bufnr = winbufnr(winid)
  for i in range(256)
    exec printf('highlight! CtermColor%d ctermfg=%d ctermbg=%d', i, i, i)
    call prop_type_add('CtermColor'.i, {'bufnr': bufnr, 'highlight': 'CtermColor'.i})
  endfor
  for i in range(16)
    let line = ''
    for j in range(16)
      let line .= printf("%3s xxx%s", i * 16 + j, j == 15 ? '' : " ")
    endfor
    call setbufline(bufnr, i, line)
  endfor
  for i in range(1, 16)
    for j in range(16)
      let index = 16 * (i - 1) + j
      call prop_add(i, j*8+5, {'length': 3, 'bufnr': bufnr, 'type': 'CtermColor'.index})
    endfor
  endfor
  call win_execute(winid, 'call cursor(1, 1)')
endfunction

function! s:show_cterm_color_map()
  nnoremap <silent><space>sc :<c-u>call <SID>show_cterm_color()<cr>
  vnoremap <silent><space>sc :<c-u>call <SID>show_cterm_color()<cr>
endfunction

augroup Show
  autocmd!
  autocmd BufRead,BufNewFile *.vim silent call s:show_cterm_color_map()
augroup END
