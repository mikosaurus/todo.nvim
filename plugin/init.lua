-- print("hello from init in plugin folder")
local ft = require'Comment.ft'
ft.set('todofiles', '#%s')
ft.set('todo', '#%s')
ft.set('TODO', '#%s')

vim.cmd([[hi @done guifg=#5CE65C]])
vim.cmd([[hi @cancelled guifg=#FF7081]])
