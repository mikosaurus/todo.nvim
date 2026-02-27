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
  local function set_highlights()
    vim.api.nvim_set_hl(0, "@task", { fg = "white" })
    vim.api.nvim_set_hl(0, "@done", { fg = "#5CE65C" })
    vim.api.nvim_set_hl(0, "@cancelled", { fg = "#FF7081" })
    vim.api.nvim_set_hl(0, "@tag.started", { fg = "#57B9FF" })
    vim.api.nvim_set_hl(0, "@tag.done", { fg = "#5CE65C" })
    vim.api.nvim_set_hl(0, "@tag.cancelled", { fg = "#FF7081" })
    vim.api.nvim_set_hl(0, "@task.todofiles", { link = "@task" })
    vim.api.nvim_set_hl(0, "@done.todofiles", { link = "@done" })
    vim.api.nvim_set_hl(0, "@cancelled.todofiles", { link = "@cancelled" })
    vim.api.nvim_set_hl(0, "@tag.started.todofiles", { link = "@tag.started" })
    vim.api.nvim_set_hl(0, "@tag.done.todofiles", { link = "@tag.done" })
    vim.api.nvim_set_hl(0, "@tag.cancelled.todofiles", { link = "@tag.cancelled" })
  end

  set_highlights()
  vim.api.nvim_create_autocmd("ColorScheme", { callback = set_highlights })
end

M.setup = function(opts)
  if opts == nil then
    opts = {}
  end
  setupTodofilesFiletype(opts)
end

local function getTime()
  return os.date("%y-%m-%d %H:%M")
end

local function stripExistingTags()
  vim.cmd("s/ \\?@\\(open\\|done\\|cancelled\\)([^)]*)//ge")
  vim.cmd("s/ \\+$//e")
end

M.set_task_open = function()
  stripExistingTags()
  vim.cmd("s/\\([ \\t]*\\)\\([☐|✔|☒|#|] \\)\\?\\(.*\\)/\\1☐ \\3")
end

M.set_task_done = function()
  stripExistingTags()
  vim.cmd("s/\\([ \\t]*\\)\\([☐|✔|☒|#|] \\)\\?\\(.*\\)/\\1✔ \\3 @done(" .. getTime() .. ")")
end

M.set_task_cancelled = function()
  stripExistingTags()
  vim.cmd("s/\\([ \\t]*\\)\\([☐|✔|☒|#|] \\)\\?\\(.*\\)/\\1☒ \\3 @cancelled(" .. getTime() .. ")")
end

M.set_task_started = function()
  stripExistingTags()
  vim.cmd("s/\\([ \\t]*\\)\\([☐|✔|☒|#|] \\)\\?\\(.*\\)/\\1☐ \\3 @started(" .. getTime() .. ")")
end

M.clear_task = function()
  vim.cmd("s/\\([ \\t]*\\)\\([☐|✔|☒|#|] \\)\\?\\(.*\\)/\\1\\3")
end

return M
