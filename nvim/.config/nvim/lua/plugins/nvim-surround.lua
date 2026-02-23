return {
  pack = {
    src = "https://github.com/kylechui/nvim-surround",
  },
  lazy = {
    "nvim-surround",
    event = "DeferredUIEnter",
    after = function()
      require("nvim-surround").setup()
    end
  }

}
