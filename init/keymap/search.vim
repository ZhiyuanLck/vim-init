" ======================================================================
"
" search.vim - 文本、定义查找与跳转
"    - F2 Grip光标下单词
"
" Author: zhiyuan
" GitHub: https://github.com/ZhiyuanLck
" Creation Time: 2018-08-14 13:42:06
" Last Modified: 2018-08-14 17:05:14
"
" ======================================================================

command -nargs=1 Sd execute "py3 print([(s.trigger, s.location) for s in UltiSnips_Manager._snips('<args>', True)])"
