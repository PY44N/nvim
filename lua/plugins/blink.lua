return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "enter", -- Keeps default Enter behavior if you want both
      ["<Tab>"] = { "select_and_accept", "fallback" },
    },
  },
}
