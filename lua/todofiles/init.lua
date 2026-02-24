local M = {}

M.builtin = {}

-- Setup for todofiles treesitter related stuff
local function setupTodofilesFiletype(opts)
  local ft = require("Comment.ft")

  if opts.treesitter_path ~= nil then
    -- Expand path if it starts with ~
    local expanded_path = vim.fn.expand(opts.treesitter_path)
    local branch = "main"
    if opts.branch ~= nil then
      branch = opts.branch
    end

    vim.api.nvim_create_autocmd("User", {
      pattern = "TSUpdate",
      callback = function()
        require("nvim-treesitter.parsers").todofiles = {
          install_info = {
            url = expanded_path,
            files = { "src/parser.c" },
            branch = branch,
          },
        }
      end,
    })
  end

  vim.treesitter.language.register("todofiles", "todofiles")
  vim.treesitter.language.register("todofiles", "TODO")

  vim.filetype.add({
    extension = {
      todo = "todofiles",
      TODO = "todofiles",
    },
  })

  -- Enable treesitter highlighting for todofiles
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "todofiles",
    callback = function()
      vim.treesitter.start()
    end,
  })

  ft.set("todofiles", "#%s")
  ft.set("todo", "#%s")
  ft.set("TODO", "#%s")

  -- Set up highlight groups for custom captures
  vim.api.nvim_set_hl(0, "@task", { fg = "white", default = true })
  vim.api.nvim_set_hl(0, "@done", { fg = "#5CE65C", default = true })
  vim.api.nvim_set_hl(0, "@cancelled", { fg = "#FF7081", default = true })

  -- Also set namespaced versions for nvim-treesitter main branch
  vim.api.nvim_set_hl(0, "@task.todofiles", { link = "@task", default = true })
  vim.api.nvim_set_hl(0, "@done.todofiles", { link = "@done", default = true })
  vim.api.nvim_set_hl(0, "@cancelled.todofiles", { link = "@cancelled", default = true })
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
