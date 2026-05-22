-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
  transparency = true,

	theme = "one_light",
	hl_override = {
	   gitcommitComment = {
	     fg = "#a9a9aa", 
	     italic = true 
	   },
	},
}

-- M.nvdash = { load_on_startup = true }
-- M.ui = {
--       tabufline = {
--          lazyload = false
--      }
-- }
--

return M
