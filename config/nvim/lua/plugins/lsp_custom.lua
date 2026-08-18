return {
  --   'nvim-java/nvim-java',
  --   dependencies = {
  --     'nvim-java/nvim-java-core', -- core LSP & JDT integration
  --     'lua-async-await', -- internal async library used by nvim-java
  --     'mfussenegger/nvim-jdtls', -- the actual LSP client (JDT LS)
  --     'williamboman/mason.nvim', -- installs jdtls via Mason
  --     'williamboman/mason-lspconfig.nvim', -- connects mason <-> lspconfig
  --     'neovim/nvim-lspconfig', -- base LSP framework
  --   },
  --   config = function()
  --     require('java').setup {
  --       jdk = {
  --         auto_install = true,
  --       },
  --     }
  --   end,
}
