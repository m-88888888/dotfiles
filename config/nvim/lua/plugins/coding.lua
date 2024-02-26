return {
  { 'mtdl9/vim-log-highlighting' },
  { 'tpope/vim-commentary' },
  {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end,
    event = 'ModeChanged'
  },
  { 'nicwest/vim-camelsnek' },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
    config = function()
      vim.keymap.set("n", "<Leader>md", ":MarkdownPreview<CR>")
    end
  },
  { 'github/copilot.vim', config = function()
    -- ---- yamlやmarkdown,gitcommitのときにもcopilotを有効にする
    vim.g.copilot_filetypes = { markdown = true, gitcommit = true, yaml = true }
  end },
}
