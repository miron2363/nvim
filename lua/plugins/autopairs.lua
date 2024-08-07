return  {
    'windwp/nvim-autopairs',
    dependency = {
    "hrsh7th/nvim-cmp",
    },
    event = 'InsertEnter',
    config = function()
      require("nvim-autopairs").setup {
        check_ts = true,
        enable_check_bracket_line = true,
      }

      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )
    end,
  }
