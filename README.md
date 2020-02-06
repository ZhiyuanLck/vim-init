vim-init: 轻量级Vim配置框架，全中文注释。
===

简介
----

- 轻量级 Vim 配置框架，全中文注释，fork自[vim-init](https://github.com/skywind3000/vim-init)
- 模块化配置，方便增改
- 默认禁用鼠标和方向键，快捷键`ALT+z`开启（关闭）

安装
----

将项目克隆到你喜欢的目录内，比如 `~/.vim` 内：

```bash
cd ~/.vim
git clone https://github.com/ZhiyuanLck/vim-init.git
```

然后创建你的 `~/.vimrc` 文件，里面只有一句话：

```VimL
source ~/.vim/vim-init/init.vim
```

请调整你的终端软件，确保对 ALT 键的支持，以及 Backspace 键发送正确扫描码：

[终端软件下正确支持 ALT 键和 Backspace 键](https://github.com/skywind3000/vim-init/wiki/Setup-terminals-to-support-ALT-and-Backspace-correctly)

然后启动 Vim，在命令行运行 `:PlugInstall` 安装依赖插件即可。

结构
----

本配置按顺序，由如下几个主要模块组成：

- **`init.vim`**: 配置入口，设置 runtimepath 检测脚本路径，加载其他脚本。
- **`init-basic.vim`**: 所有人都能同意的基础配置，去除任何按键和样式定义，保证能用于 `tiny` 模式（没有 `+eval`）。
- **`init-config.vim`**: 支持 +eval 的非 tiny 配置，初始化 ALT 键支持，功能键键盘码，备份，终端兼容等
- **`init-tabsize.vim`**: 制表符宽度，是否展开空格等，因为个人差异太大，单独一个文件好更改。
- **`init-plugin.vim`**: 插件，使用 vim-plug，按照设定的插件分组进行配置。
- **`init-style.vim`**: 色彩主题，高亮优化，状态栏，更紧凑的标签栏文字等和显示相关的东西。
- **`init-LoadKeymaps.vim`**: 快捷键配置入口，模块化更好修改。
- **`ex-formatfile.vim`**: 新建文件时创建文件头模板，保存文件时去除空行


快捷键配置
----

- **`move.vim`**：光标移动快捷键定义
  - `EMACS`键位设置
  - `COMMAND`模式快速移动
  - `CTRL+HJKL`快速移动
  - `ALT+KEY`快速移动
  - `ALT+u/d`异步滚动窗口
- **`edit.vim`**：编辑文本快捷键定义
- **`jump.vim`**：快速切换、编辑 `tab`, `buffer`, `window`
  - `tab`键位设置
  - `buffer`键位设置
  - `window`键位设置
  - 新窗口、新标签页打开目录
- **`CommentAndComplete.vim`**：注释和手动补全
  - `ALT+/`注释
  - `ALT+,`手动补全，目前只支持vim
- **`run.vim`**：编译和运行
  - 编译/运行c++项目
  - `F5`运行当前文件
- **`search.vim`**
  - `F2`查找光标下单词
- **`auxiliary.vim`**：其他辅助功能
  - `ALT+.`开启/关闭窗口半透明
  - `ALT+Z`开启/关闭鼠标和方向键的支持
