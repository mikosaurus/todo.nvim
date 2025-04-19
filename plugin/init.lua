local ft = require'Comment.ft'

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

parser_config.todofiles = {
  install_info = {
    url = "~/github.com/mikosaurus/tree-sitter-todofiles",
    files = { "src/parser.c" },
    branch = "main",
    generate_requires_npm = false,
    requires_generate_from_grammar = false,
  },
  filetype = "todo",
}

vim.treesitter.language.register("todofiles", "TODO")

vim.filetype.add({
  extension = {
    todo = 'todofiles',
    TODO = 'todofiles',
  },
})

ft.set('todofiles', '#%s')
ft.set('todo', '#%s')
ft.set('TODO', '#%s')

vim.cmd([[hi @done guifg=#5CE65C]])
vim.cmd([[hi @cancelled guifg=#FF7081]])

