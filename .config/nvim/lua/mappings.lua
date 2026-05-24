require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Theme toggle (uses the two themes from M.base46.theme_toggle in chadrc.lua)
map("n", "<leader>tt", function()
  require("base46").toggle_theme()
end, { desc = "Toggle theme" })

-- Transparency toggle
map("n", "<leader>tp", function()
  require("base46").toggle_transparency()
end, { desc = "Toggle transparency" })

