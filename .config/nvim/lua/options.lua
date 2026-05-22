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

