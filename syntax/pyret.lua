-- Translated to Lua from https://github.com/brownplt/pyret-lang/blob/horizon/tools/vim/syntax/pyret.vim

vim.cmd("syntax clear")

vim.cmd("set syntax=pyret")

-- Delimiters
vim.cmd([[syn match pyretDelimeter '!']])
vim.cmd([[syn match pyretDelimeter '\.']])
vim.cmd([[syn match pyretDelimeter '|']])
vim.cmd([[syn match pyretDelimeter '(']])
vim.cmd([[syn match pyretDelimeter ')']])
vim.cmd([[syn match pyretDelimeter '->']])
vim.cmd([[syn match pyretDelimeter '=']])
vim.cmd([[syn match pyretDelimeter '=>']])
vim.cmd([[syn match pyretDelimeter ':=']])
vim.cmd([[syn match pyretDelimeter '\[']])
vim.cmd([[syn match pyretDelimeter '\]']])
vim.cmd([[syn match pyretDelimeter '{']])
vim.cmd([[syn match pyretDelimeter '}']])
vim.cmd([[syn match pyretDelimeter ':']])
vim.cmd([[syn match pyretDelimeter '::']])

-- Keywords
vim.cmd([[syn keyword pyretBasic var fun end with: sharing: data include import provide as try: except when]])
vim.cmd([[syn keyword pyretBasic for from check: where: doc: and or not else: if else cases]])
vim.cmd([[syn keyword pyretBasic is is== is=~ is<=> is-not is-not== is-not=~ is-not<=> raises]])
vim.cmd([[syn keyword pyretBasic deriving ref graph: m-graph: block: satisfies violates shadow lam type type-let provide-types newtype]])
vim.cmd([[syn keyword pyretBasic let rec letrec ask: table: extend using row: select extract order sieve by spy]])

-- Operators
vim.cmd([[syn match pyretOp ' + ']])
vim.cmd([[syn match pyretOp ' - ']])
vim.cmd([[syn match pyretOp ' / ']])
vim.cmd([[syn match pyretOp ' \* ']])
vim.cmd([[syn match pyretOp ' > ']])
vim.cmd([[syn match pyretOp ' < ']])
vim.cmd([[syn match pyretOp ' >= ']])
vim.cmd([[syn match pyretOp ' <= ']])
vim.cmd([[syn match pyretOp ' <> ']])

-- Line Comments
vim.cmd([[syn match pyretComment '\#.*$']])

-- Block comments
vim.cmd([[syn region pyretComment start=/#|/ skip=/\./ end=/|#/]])

-- Strings
vim.cmd([[syn region pyretString start=/"/ skip=/\\./ end=/"/]])
vim.cmd([[syn region pyretString start=/'/ skip=/\\./ end=/'/]])
vim.cmd([[syn region pyretString start=/```/ end=/```/]])

-- Numbers
vim.cmd([[syn match pyretNumber "\(^\|[^[:alnum:]_-]\)\@<=-\?\d\+\([^[:alnum:]_.-]\|$\)\@="]])
vim.cmd([[syn match pyretNumber "\(^\|[^[:alnum:]_-]\)\@<=-\?\d\+\.\d*\([^[:alnum:]_.-]\|$\)\@="]])
vim.cmd([[syn match pyretNumber "\(^\|[^[:alnum:]_-]\)\@<=-\?\d*\.\d\+\([^[:alnum:]_.-]\|$\)\@="]])

-- Highlight links
vim.cmd([[hi def link pyretComment Comment]])
vim.cmd([[hi def link pyretBasic Function]])
vim.cmd([[hi def link pyretDelimeter PreProc]])
vim.cmd([[hi def link pyretOp Label]])
vim.cmd([[hi def link pyretString Constant]])
vim.cmd([[hi def link pyretNumber Constant]])

vim.cmd("let b:current_syntax = 'pyret'")

vim.bo.indentexpr = "v:lua.require('config.pyret_indent').get_pyret_indent(v:lnum)"
vim.bo.indentkeys = "0{,0},!,o,O,=|,=case,=catch,=else,=elseif,=end"

vim.bo.iskeyword = vim.bo.iskeyword .. ",-,:"