Plug 'Yggdroot/LeaderF'

" 最大历史文件保存 2048 个
let g:Lf_MruMaxFiles = 2048

" ui 定制
let g:Lf_StlSeparator = { 'left': '', 'right': '', 'font': '' }

" 如何识别项目目录，从当前文件目录向父目录递归知道碰到下面的文件/目录
let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git']
let g:Lf_WorkingDirectoryMode = 'Ac'
let g:Lf_WindowHeight = 0.30
let g:Lf_CacheDirectory = expand('~/.vim/cache')

" 显示绝对路径
let g:Lf_ShowRelativePath = 0

" 显示icon
let g:Lf_ShowDevIcons = 1
" https://github.com/ryanoasis/nerd-fonts
" let g:Lf_DevIconsFont = 'DroidSansMono Nerd Font Mono'

" 隐藏帮助
let g:Lf_HideHelp = 1

" 模糊匹配忽略扩展名
let g:Lf_WildIgnore = {
      \ 'dir': ['.svn','.git','.hg'],
      \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
      \ }

" MRU 文件忽略扩展名
let g:Lf_MruFileExclude = ['*.so', '*.exe', '*.py[co]', '*.sw?', '~$*', '*.bak', '*.tmp', '*.dll']
let g:Lf_StlColorscheme = 'powerline'

" 禁用 function/buftag 的预览功能，可以手动用 p 预览
let g:Lf_PreviewResult = {
        \ 'File': 0,
        \ 'Buffer': 0,
        \ 'Mru': 0,
        \ 'Tag': 1,
        \ 'BufTag': 1,
        \ 'Function': 1,
        \ 'Line': 1,
        \ 'Colorscheme': 1,
        \ 'Rg': 1,
        \ 'Gtags': 1
        \}

" 使用popup
let g:Lf_WindowPosition = 'popup'
let g:Lf_PreviewInPopup = 1

function! GetScript(args)
  let out = execute('scriptnames')
  let out = substitute(out, '\v\s*\d+:\s*', '', 'g')
  let out = split(out, '\n')
  return out
endfunction

function! ScriptAccept(line, args)
  exec "edit ".a:line
endfunction

function! GetRtp(args)
  return split(&rtp, ',')
endfunction

function! RtpAccept(line, args)
  exec "LeaderfFile ".a:line
endfunction

function! GetHighlight(args)
  return split(execute('highlight'), '\n')
endfunction

function! HighlightAccept(args)
endfunction

function! HighlightHighlight(args)
  let highlight = split(execute('highlight'), '\n')
  let ids = []
  for h in highlight
    let w = split(h)[0]
    let pattern = '\v('.w.'\s+)@<=xxx'
    if w != 'xxx'
      call add(ids, matchadd(w, pattern, 20))
    endif
  endfor
  return ids
endfunction

function! ColorCterm(args)
  let lines = []
  for i in range(32)
    let l = []
    for j in range(8)
      call add(l, printf(" %3s xxx", i * 8 + j))
    endfor
    call add(lines, join(l, ' '))
  endfor
  return lines
endfunction

function! ColorCtermAccept(args)
endfunction

function! ColorCtermHighlight(args)
  let ids = []
  for i in range(256)
    exec printf('highlight CtermColor%d ctermfg=%d ctermbg=%d', i, i, i)
    let pattern = '\v(\s+'.i.'\s+)@<=xxx'
    call add(ids, matchadd('CtermColor'.i, pattern , 20))
  endfor
  return ids
endfunction

" 自定义扩展
let g:Lf_Extensions = {
        \ "LoadOrder": {
        \       "source": "GetScript",
        \       "accept": "ScriptAccept",
        \ },
        \ "rtp": {
        \       "source": "GetRtp",
        \       "accept": "RtpAccept",
        \ },
        \ "highlight": {
        \       "source": "GetHighlight",
        \       "accept": "HighlightAccept",
        \       "highlight": "HighlightHighlight",
        \ },
        \ "ColorCterm": {
        \       "source": "ColorCterm",
        \       "accept": "ColorCtermAccept",
        \       "highlight": "ColorCtermHighlight",
        \ },
        \}

function! CallLeaderF(mode)
  if a:mode == 'p'
    exec "LeaderfFile"
  elseif a:mode == 'b'
    exec "LeaderfBuffer"
  elseif a:mode == 'ba'
    exec "LeaderfBufferAll"
  elseif a:mode == 'm'
    exec "LeaderfMru"
  elseif a:mode == 'mc'
    exec "LeaderfMruCwd"
  elseif a:mode == 't'
    exec "LeaderfTag"
  elseif a:mode == 'bt'
    exec "LeaderfBufTag"
  elseif a:mode == 'bta'
    exec "LeaderfBufTagAll"
  elseif a:mode == 'f'
    exec "LeaderfFunction"
  elseif a:mode == 'fa'
    exec "LeaderfFunctionAll"
  elseif a:mode == 'l'
    exec "LeaderfLine"
  elseif a:mode == 'la'
    exec "LeaderfLineAll"
  elseif a:mode == 'lo'
    exec "Leaderf LoadOrder"
  elseif a:mode == 'hc'
    exec "LeaderfHistoryCmd"
  elseif a:mode == 'hs'
    exec "LeaderfHistorySearch"
  elseif a:mode == 'h'
    exec "LeaderfHelp"
  elseif a:mode == 'hl'
    exec "Leaderf highlight"
  elseif a:mode == 'cs'
    exec "LeaderfColorscheme"
  elseif a:mode == 'cc'
    exec "Leaderf ColorCterm"
  elseif a:mode == 'cmd'
    exec "LeaderfCommand"
  elseif a:mode == 'q'
    exec "LeaderfQuickFix"
  elseif a:mode == 'rg'
    exec "Leaderf rg ".input('rg: ').' -tvim -tpy -ttex'
  elseif a:mode == 'rtp'
    exec "Leaderf rtp"
  elseif a:mode == 's'
    exec "LeaderfSelf"
  " vim plug file
  elseif a:mode == 'vp'
    exec "Leaderf file ".expand('~/.vim/bundles')
  " vim runtime path file
  elseif a:mode == 'vr'
    exec "Leaderf file ".expand('~/.vim/vim-init')
  elseif a:mode == 'w'
    exec "LeaderfWindow"
  endif
endfunction

noremap <silent><m-p> :call CallLeaderF(input('mode: '))<cr>
inoremap <silent><m-p> <esc>:call CallLeaderF(input('mode: '))<cr>
