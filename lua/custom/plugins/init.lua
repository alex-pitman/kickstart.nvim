-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'ray-x/go.nvim',
    dependencies = { -- optional packages
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      -- lsp_keymaps = false,
      -- other options
    },
    config = function(lp, opts)
      require('go').setup(opts)
      local format_sync_grp = vim.api.nvim_create_augroup('GoFormat', {})
      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = '*.go',
        callback = function()
          require('go.format').goimports()
        end,
        group = format_sync_grp,
      })
    end,
    event = { 'CmdlineEnter' },
    ft = { 'go', 'gomod' },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'leoluz/nvim-dap-go',
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      require('dapui').setup()
      require('dap-go').setup()

      -- automatically open/close ui
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end

      -- keybindings
      vim.keymap.set('n', '<f5>', dap.continue, { desc = 'debug: start/continue' })
      vim.keymap.set('n', '<f10>', dap.step_over, { desc = 'debug: step over' })
      vim.keymap.set('n', '<f11>', dap.step_into, { desc = 'debug: step into' })
      vim.keymap.set('n', '<f12>', dap.step_out, { desc = 'debug: step out' })
      vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'debug: toggle breakpoint' })
      vim.keymap.set('n', '<leader>B', function()
        dap.set_breakpoint(vim.fn.input 'breakpoint condition: ')
      end, { desc = 'debug: set conditional breakpoint' })
      vim.keymap.set('n', '<leader>dt', function()
        require('dap-go').debug_test()
      end, { desc = 'debug go: debug test' })
    end,
  },
}
