return {
  pack = {
    src = "https://github.com/kylechui/nvim-surround",
  },
  lazy = {
    "nvim-surround",
    event = "DeferredUIEnter",
    keys = {
      {
        's',
        mode = 'v',
        "<Plug>(nvim-surround-visual)",
        desc = "Add a surrounding pair around a visual selection"
      }
    },
    after = function()
      require("nvim-surround").setup()
    end
  }
}
