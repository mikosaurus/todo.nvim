local M = {}

M.builtin = {}

-- Setup for todofiles treesitter related stuff
local function setupTodofilesFiletype(opts)
  local ft = require'Comment.ft'

  if opts.treesitter_path ~= nil then
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

    parser_config.todofiles = {
      install_info = {
        -- url = "~/github.com/mikosaurus/tree-sitter-todofiles",
        url = opts.treesitter_path,
        files = { "src/parser.c" },
        branch = "main",
        generate_requires_npm = false,
        requires_generate_from_grammar = false,
      },
      filetype = "todo",
    }
  end


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

  vim.cmd([[hi @task guifg=white]])
  vim.cmd([[hi @done guifg=#5CE65C]])
  vim.cmd([[hi @cancelled guifg=#FF7081]])
end

M.setup = function(opts)
  if opts == nil then
    opts = {}
  end
  setupTodofilesFiletype(opts)
end

M.set_task_open = function()
  vim.cmd([[s/\(\t*\)\([☐|✔|☒|#|] \)\?\(.*\)/\1☐ \3]])
end

M.set_task_done = function()
  vim.cmd([[s/\(\t*\)\([☐|✔|☒|#|] \)\?\(.*\)/\1✔ \3]])
end

M.set_task_cancelled = function()
  vim.cmd([[s/\(\t*\)\([☐|✔|☒|#|] \)\?\(.*\)/\1☒ \3]])
end

M.clear_task = function()
  vim.cmd([[s/\(\t*\)\([☐|✔|☒|#|] \)\?\(.*\)/\1\3]])
end

return M
