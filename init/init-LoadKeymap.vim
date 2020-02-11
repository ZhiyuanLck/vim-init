" =======================================================================
"
" Author: zhiyuan
" GitHub: https://github.com/ZhiyuanLck
" Creation Time: 2018-08-14 10:23:17
" Last Modified: 2018-08-14 19:16:47
"
" =======================================================================


" 取得本文件所在的目录
let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')

" 定义一个命令用来加载文件
command! -nargs=1 LoadKeymap exec 'so '.s:home.'/keymap/'.'<args>'

" 光标移动
LoadKeymap move.vim

" 代码编辑
LoadKeymap edit.vim

" 缓存、tab与窗口编辑与跳转
LoadKeymap jump.vim

" 编译运行
" LoadKeymap run.vim

" 文档、定义搜索与跳转
LoadKeymap search.vim

" 其他辅助功能
LoadKeymap auxiliary.vim
