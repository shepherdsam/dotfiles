require "nvchad.options"

-- add yours here!

vim.opt.linebreak = true
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.fixendofline = false

vim.api.nvim_create_autocmd({"VimEnter", "BufDelete"}, {
  callback = function()
    local bufs = vim.t.bufs
    if #bufs == 1 then
      local buf = bufs[1]
      local name = vim.api.nvim_buf_get_name(buf)
      local ft = vim.bo[buf].filetype
      if name == "" or ft == "netrw" or vim.fn.isdirectory(name) == 1 then
        vim.cmd "Nvdash"
      end
    end
  end,
})

vim.filetype.add({
  extension = {
    kjs = "javascript",
  },
})

vim.api.nvim_create_user_command("ThemeToggle", function()
  require("base46").toggle_theme()
end, { desc = "Toggle between the two themes defined in chadrc.lua" })

vim.api.nvim_create_user_command("TransparencyToggle", function()
  require("base46").toggle_transparency()
end, { desc = "Toggle background transparency" })

