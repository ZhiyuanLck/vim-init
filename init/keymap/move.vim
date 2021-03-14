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

" INSERT 模式下使用 EMACS 键位
inoremap <c-a> <esc>I
inoremap <c-e> <end>
inoremap <c-d> <del>
inoremap <c-_> <c-k>

" COMMAND模式下快速移动
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

" 插入模式下快速移动
inoremap <c-h> <left>
inoremap <c-j> <down>
inoremap <c-k> <up>
inoremap <c-l> <right>

" 互换j和gj，居中
noremap <silent>j  gj
noremap <silent>k  gk
noremap <silent>gj j
noremap <silent>gk k
" noremap <silent>n  nzz
" noremap <silent>N  Nzz
" noremap <silent>*  *zz
noremap <silent><space>hl :set nohlsearch<cr>

" 异步滚动窗口
" 0:up, 1:down, 2:pgup, 3:pgdown, 4:top, 5:bottom
function! Tools_PreviousCursor(mode)
  if winnr('$') <= 1
    return
  endif
  let l = line('.')
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
  elseif a:mode == 10
    exec "normal! " .l ."Gzz"
  endif
  noautocmd silent! wincmd p
endfunc

noremap <silent> <m-u> :call Tools_PreviousCursor(6)<cr>
inoremap <silent> <m-u> <esc>:call Tools_PreviousCursor(6)<cr>a
noremap <silent> <m-d> :call Tools_PreviousCursor(7)<cr>
inoremap <silent> <m-d> <esc>:call Tools_PreviousCursor(7)<cr>a
noremap <silent> <m-s> :call Tools_PreviousCursor(10)<cr>
inoremap <silent> <m-s> :call Tools_PreviousCursor(10)<cr>a

" 增大减小窗口尺寸
nnoremap <m--> <c-w>-
nnoremap <m-=> <c-w>+
nnoremap <m-,> <c-w><
nnoremap <m-.> <c-w>>
nnoremap <m-+> <c-w>=
