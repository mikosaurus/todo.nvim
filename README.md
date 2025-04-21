# todo.nvim

Installation
```lua
{
    "mikosaurus/todo.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function() 
        todofiles = require('todofiles')
        -- Set the treesitter path to wherever the treesitter repo is cloned
        -- Having an empty setup function will default to no treesitter parser
        -- Also, have to run TSInstall todofiles manually
        todofiles.setup({ 
            treesitter_path = "~/github.com/mikosaurus/tree-sitter-todofiles" 
        })

        -- add keymaps for todofile buffers only
        vim.api.nvim_create_autocmd('FileType', {
            desc = 'set keybinds for todofiles',
            pattern = 'todofiles',
            group = vim.api.nvim_create_augroup('todofiles-keybinds', { clear = true }),
            callback = function(opts)
                vim.keymap.set("n", "<M-n>", todofiles.set_task_open, { buffer = true })
                vim.keymap.set("n", "<M-d>", todofiles.set_task_done, { buffer = true })
                vim.keymap.set("n", "<M-c>", todofiles.set_task_cancelled, { buffer = true })
                vim.keymap.set("n", "<M-N>", todofiles.clear_task, { buffer = true }) end
        })
    end
}
```
