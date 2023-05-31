return {
  -- add gruvbox
  { "ellisonleao/gruvbox.nvim" },
  { "tjdevries/colorbuddy.nvim" },
  { "bbenzikry/snazzybuddy.nvim" },
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  }
}
