" ======================================================================
"
" run.vim - 编译运行项目相关快捷键
"    - 编译运行 C/C++ 项目
"    - F5运行当前文件
"
" Author: zhiyuan
" GitHub: https://github.com/ZhiyuanLck
" Creation Time: 2018-08-14 13:42:06
" Last Modified: 2019-06-08 11:56:42
"
" ======================================================================

" 重载配置
command So source ~/.vim/vim-init/init.vim

" vim运行选中行
nnoremap <silent><space>r :exec getline('.')<cr>
vnoremap <silent><space>r :<c-u>exec join(getline("'<", "'>"), '<bar>')<cr>
