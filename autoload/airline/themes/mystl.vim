let g:airline#themes#mystl#palette = {}
hi DiffAdd ctermfg=174

function! airline#themes#mystl#refresh()

    let s:N1 = airline#themes#get_highlight('StatusLine')
    let s:N2 = airline#themes#get_highlight('Folded')
    let s:N3 = airline#themes#get_highlight('CursorLine')
    let g:airline#themes#mystl#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)

    let modified_group = airline#themes#get_highlight('Statement')
    let g:airline#themes#mystl#palette.normal_modified = {
                \ 'airline_c': ['', '', 174, '', '']
                \ }

    let warning_group = airline#themes#get_highlight('DiffChange')
    let g:airline#themes#mystl#palette.normal.airline_warning = warning_group
    let g:airline#themes#mystl#palette.normal_modified.airline_warning = warning_group

    let error_group = airline#themes#get_highlight('DiffDelete')
    let g:airline#themes#mystl#palette.normal.airline_error = error_group
    let g:airline#themes#mystl#palette.normal_modified.airline_error = error_group

"     let s:I1 = airline#themes#get_highlight('DiffAdd')
    let s:I1 = ['', '', 174, 0, '']
    let s:I2 = s:N2
    let s:I3 = s:N3
    let g:airline#themes#mystl#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
    let g:airline#themes#mystl#palette.insert_modified = g:airline#themes#mystl#palette.normal_modified
    let g:airline#themes#mystl#palette.insert.airline_warning = g:airline#themes#mystl#palette.normal.airline_warning
    let g:airline#themes#mystl#palette.insert_modified.airline_warning = g:airline#themes#mystl#palette.normal_modified.airline_warning
    let g:airline#themes#mystl#palette.insert.airline_error = g:airline#themes#mystl#palette.normal.airline_error
    let g:airline#themes#mystl#palette.insert_modified.airline_error = g:airline#themes#mystl#palette.normal_modified.airline_error

    let s:R1 = airline#themes#get_highlight('DiffChange')
    let s:R2 = s:N2
    let s:R3 = s:N3
    let g:airline#themes#mystl#palette.replace = airline#themes#generate_color_map(s:R1, s:R2, s:R3)
    let g:airline#themes#mystl#palette.replace_modified = g:airline#themes#mystl#palette.normal_modified
    let g:airline#themes#mystl#palette.replace.airline_warning = g:airline#themes#mystl#palette.normal.airline_warning
    let g:airline#themes#mystl#palette.replace_modified.airline_warning = g:airline#themes#mystl#palette.normal_modified.airline_warning
    let g:airline#themes#mystl#palette.replace.airline_error = g:airline#themes#mystl#palette.normal.airline_error
    let g:airline#themes#mystl#palette.replace_modified.airline_error = g:airline#themes#mystl#palette.normal_modified.airline_error

    let s:V1 = airline#themes#get_highlight('Cursor')
    let s:V2 = s:N2
    let s:V3 = s:N3
    let g:airline#themes#mystl#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
    let g:airline#themes#mystl#palette.visual_modified = g:airline#themes#mystl#palette.normal_modified
    let g:airline#themes#mystl#palette.visual.airline_warning = g:airline#themes#mystl#palette.normal.airline_warning
    let g:airline#themes#mystl#palette.visual_modified.airline_warning = g:airline#themes#mystl#palette.normal_modified.airline_warning
    let g:airline#themes#mystl#palette.visual.airline_error = g:airline#themes#mystl#palette.normal.airline_error
    let g:airline#themes#mystl#palette.visual_modified.airline_error = g:airline#themes#mystl#palette.normal_modified.airline_error

    let s:IA = airline#themes#get_highlight('StatusLineNC')
    let g:airline#themes#mystl#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)
    let g:airline#themes#mystl#palette.inactive_modified = {
                \ 'airline_c': [ '', '', 255, 237, '' ],
                \ 'airline_x': [ '', '', 12, 237, '' ],
                \ }

    let g:airline#themes#mystl#palette.accents = {
                \ 'red': airline#themes#get_highlight('Constant'),
                \ }

    " Extra tabline colors
    let s:TS = airline#themes#get_highlight('TabLineSel')
    let g:airline#themes#mystl#palette.tabline = {
      \ 'airline_tabmod':   ['', '',  255, 0, ''],
      \ }
    let g:airline#themes#mystl#palette.tabline.airline_tabsel = s:TS
    let g:airline#themes#mystl#palette.tabline.airline_tabsel_right = s:TS

endfunction

call airline#themes#mystl#refresh()
