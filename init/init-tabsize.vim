"======================================================================
"
" init-tabsize.vim - 大部分人对 tabsize 都有自己的设置，改这里即可
"
" Modified by zhiyuan
" Last Modified: 2019-06-02 09:58:51
"
"======================================================================
" vim: set ts=4 sw=4 tw=78 noet :


"----------------------------------------------------------------------
" 默认缩进模式（可以后期覆盖）
"----------------------------------------------------------------------

" 设置缩进宽度
set sw=2

" 设置 TAB 宽度
set ts=2

" 展开 tab (noexpandtab)
set et

" 如果后面设置了 expandtab 那么展开 tab 为多少字符
set softtabstop=2


augroup PythonTab
    au!
    " 如果你需要 python 里用 tab，那么反注释下面这行字，否则vim会在打开py文件
    " 时自动设置成空格缩进。
    " au FileType python setlocal shiftwidth=4 tabstop=4 noexpandtab
augroup END

augroup TabTwo
    autocmd!
    autocmd FileType tex,cls,sty,bst setlocal sw=2 ts=2 et softtabstop=2
augroup END
