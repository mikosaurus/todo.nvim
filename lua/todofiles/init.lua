local M = {}

M.builtin = {}

-- Setup for todofiles treesitter related stuff
local function setupTodofilesFiletype(opts)
  local ft = require'Comment.ft'

  if opts.treesitter_path ~= nil then
    -- Expand path if it starts with ~
    local expanded_path = vim.fn.expand(opts.treesitter_path)

    -- Support both old (master) and new (main) nvim-treesitter API
    local parser_configs = require("nvim-treesitter.parsers")

    -- Try new API first (main branch)
    local ok = pcall(function()
      if parser_configs.list then
        parser_configs.list.todofiles = {
          install_info = {
            url = expanded_path,
            files = { "src/parser.c" },
            branch = "main",
            generate_requires_npm = false,
            requires_generate_from_grammar = false,
          },
          filetype = "todo",
        }
        return true
      end
      return false
    end)

    -- Fallback to old API (master branch) if new API doesn't exist
    if not ok then
      local get_configs = parser_configs.get_parser_configs
      if get_configs then
        local parser_config = get_configs()
        parser_config.todofiles = {
          install_info = {
            url = expanded_path,
            files = { "src/parser.c" },
            branch = "main",
            generate_requires_npm = false,
            requires_generate_from_grammar = false,
          },
          filetype = "todo",
        }
      end
    end
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
  vim.cmd([[s/\([ \t]*\)\([☐|✔|☒|#|] \)\?\(.*\)/\1☐ \3]])
end

M.set_task_done = function()
  vim.cmd([[s/\([ \t]*\)\([☐|✔|☒|#|] \)\?\(.*\)/\1✔ \3]])
end

M.set_task_cancelled = function()
  vim.cmd([[s/\([ \t]*\)\([☐|✔|☒|#|] \)\?\(.*\)/\1☒ \3]])
end

M.clear_task = function()
  vim.cmd([[s/\([ \t]*\)\([☐|✔|☒|#|] \)\?\(.*\)/\1\3]])
end

return M
