local keymap = vim.keymap
local uv = vim.uv

-- Save key strokes (now we do not need to press shift to enter command mode).
keymap.set({ "n", "x" }, ";", ":")

-- Turn the word under cursor to upper case
keymap.set("i", "<c-u>", "<Esc>viwUea")

-- Turn the current word into title case
keymap.set("i", "<c-t>", "<Esc>b~lea")

-- Paste non-linewise text above or below current line, see https://stackoverflow.com/a/1346777/6064933
keymap.set("n", "<leader>p", "m`o<ESC>p``", { desc = "paste below current line" })
keymap.set("n", "<leader>P", "m`O<ESC>p``", { desc = "paste above current line" })

-- Shortcut for faster save and quit
keymap.set("n", "<leader>w", "<cmd>update<cr>", { silent = true, desc = "save buffer" })

-- Saves the file if modified and quit
keymap.set("n", "<leader>q", "<cmd>x<cr>", { silent = true, desc = "quit current window" })

-- Quit all opened buffers
keymap.set("n", "<leader>Q", "<cmd>qa!<cr>", { silent = true, desc = "quit nvim" })

-- Close location list or quickfix list if they are present, see https://superuser.com/q/355325/736190
keymap.set("n", [[\x]], "<cmd>windo lclose <bar> cclose <cr>", {
  silent = true,
  desc = "close qf and location list",
})

-- Delete a buffer, without closing the window, see https://stackoverflow.com/q/4465095/6064933
keymap.set("n", [[\db]], "<cmd>bprevious <bar> bdelete #<cr>", {
  silent = true,
  desc = "Delete current buffer",
})

keymap.set("n", [[\dB]], function()
  local buf_ids = vim.api.nvim_list_bufs()
  local cur_buf = vim.api.nvim_win_get_buf(0)

  for _, buf_id in pairs(buf_ids) do
    -- do not Delete unlisted buffers, which may lead to unexpected errors
    if vim.api.nvim_get_option_value("buflisted", { buf = buf_id }) and buf_id ~= cur_buf then
      vim.api.nvim_buf_delete(buf_id, { force = true })
    end
  end
end, {
  desc = "Delete other buffers",
})

keymap.set("n", [[\dt]], "<cmd>tabclose<CR>", {
  silent = true,
  desc = "Delete current tab",
})

keymap.set("n", [[\dT]], "<cmd>tabonly<CR>", {
  silent = true,
  desc = "Delete other tabs",
})

-- Move the cursor based on physical lines, not the actual lines.
keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- Do not include white space characters when using $ in visual mode,
-- see https://vi.stackexchange.com/q/12607/15292
keymap.set("x", "$", "g_")

-- Go to start or end of line easier
keymap.set({ "n", "x" }, "H", "^")
keymap.set({ "n", "x" }, "L", "g_")

-- Continuous visual shifting (does not exit Visual mode), `gv` means
-- to reselect previous visual area, see https://superuser.com/q/310417/736190
keymap.set("x", "<", "<gv")
keymap.set("x", ">", ">gv")

-- Reselect the text that has just been pasted, see also https://stackoverflow.com/a/4317090/6064933.
keymap.set("n", "<leader>v", "printf('`[%s`]', getregtype()[0])", {
  expr = true,
  desc = "reselect last pasted area",
})

-- Always use very magic mode for searching
-- keymap.set("n", "/", [[/\v]])

-- Search in selected region
-- xnoremap / :<C-U>call feedkeys('/\%>'.(line("'<")-1).'l\%<'.(line("'>")+1)."l")<CR>

-- Change current working directory locally and print cwd after that,
-- see https://vim.fandom.com/wiki/Set_working_directory_to_the_current_file
keymap.set("n", "<leader>cd", "<cmd>lcd %:p:h<cr><cmd>pwd<cr>", { desc = "change cwd" })

-- Use Esc to quit builtin terminal
keymap.set("t", "<Esc>", [[<c-\><c-n>]])

-- Toggle spell checking
keymap.set("n", "<F11>", "<cmd>set spell!<cr>", { desc = "toggle spell" })
keymap.set("i", "<F11>", "<c-o><cmd>set spell!<cr>", { desc = "toggle spell" })

-- Change text without putting it into the vim register,
-- see https://stackoverflow.com/q/54255/6064933
keymap.set("n", "c", '"_c')
keymap.set("n", "C", '"_C')
keymap.set("n", "cc", '"_cc')
keymap.set("x", "c", '"_c')

-- Remove trailing whitespace characters
keymap.set(
  "n",
  "<leader><space>",
  "<cmd>StripTrailingWhitespace<cr>",
  { desc = "remove trailing space" }
)

-- Copy entire buffer.
keymap.set("n", "<leader>y", "<cmd>%yank<cr>", { desc = "yank entire buffer" })

-- Toggle cursor column
keymap.set(
  "n",
  "<leader>cl",
  "<cmd>call utils#ToggleCursorCol()<cr>",
  { desc = "toggle cursor column" }
)

-- Move current line up and down
keymap.set(
  "n",
  "<A-k>",
  '<cmd>call utils#SwitchLine(line("."), "up")<cr>',
  { desc = "move line up" }
)
keymap.set(
  "n",
  "<A-j>",
  '<cmd>call utils#SwitchLine(line("."), "down")<cr>',
  { desc = "move line down" }
)

-- Move current visual-line selection up and down
keymap.set("x", "<A-k>", '<cmd>call utils#MoveSelection("up")<cr>', { desc = "move selection up" })

keymap.set(
  "x",
  "<A-j>",
  '<cmd>call utils#MoveSelection("down")<cr>',
  { desc = "move selection down" }
)

-- Replace visual selection with text in register, but not contaminate the register,
-- see also https://stackoverflow.com/q/10723700/6064933.
keymap.set("x", "p", '"_c<Esc>p')

-- Go to a certain buffer
keymap.set("n", "gb", '<cmd>call buf_utils#GoToBuffer(v:count, "forward")<cr>', {
  desc = "go to buffer (forward)",
})
keymap.set("n", "gB", '<cmd>call buf_utils#GoToBuffer(v:count, "backward")<cr>', {
  desc = "go to buffer (backward)",
})

-- Switch windows

-- Text objects for URL
keymap.set({ "x", "o" }, "iu", "<cmd>call text_obj#URL()<cr>", { desc = "URL text object" })

-- Text objects for entire buffer
keymap.set({ "x", "o" }, "iB", ":<C-U>call text_obj#Buffer()<cr>", { desc = "buffer text object" })

-- Do not move my cursor when joining lines.
keymap.set("n", "J", function()
  vim.cmd([[
      normal! mzJ`z
      delmarks z
    ]])
end, {
  desc = "join lines without moving cursor",
})

keymap.set("n", "gJ", function()
  -- we must use `normal!`, otherwise it will trigger recursive mapping
  vim.cmd([[
      normal! mzgJ`z
      delmarks z
    ]])
end, {
  desc = "join lines without moving cursor",
})

-- Break inserted text into smaller undo units when we insert some punctuation chars.
local undo_ch = { ",", ".", "!", "?", ";", ":" }
for _, ch in ipairs(undo_ch) do
  keymap.set("i", ch, ch .. "<c-g>u")
end

-- insert semicolon in the end
keymap.set("i", "<A-;>", "<Esc>miA;<Esc>`ii")

-- Go to the beginning and end of current line in insert mode quickly
keymap.set("i", "<C-A>", "<HOME>")
keymap.set("i", "<C-E>", "<END>")

-- Go to beginning of command in command-line mode
keymap.set("c", "<C-A>", "<HOME>")

-- Delete the character to the right of the cursor
keymap.set("i", "<C-D>", "<DEL>")

keymap.set("n", "<leader>cb", function()
  local cnt = 0
  local blink_times = 7
  local timer = uv.new_timer()
  if timer == nil then
    return
  end

  timer:start(
    0,
    100,
    vim.schedule_wrap(function()
      vim.cmd([[
      set cursorcolumn!
      set cursorline!
    ]])

      if cnt == blink_times then
        timer:close()
      end

      cnt = cnt + 1
    end)
  )
end, { desc = "show cursor" })

keymap.set("n", "q", function()
  vim._log("q is remapped to Q in Normal mode!", vim.log.levels.WARN)
end)
keymap.set("n", "Q", "q", {
  desc = "Record macro",
})

-- Play macro @q
keymap.set("n", "Q", "@q", { noremap = true, desc = "Play macro @q" })

-- Switch buffer (Nvim-Switch-Buffer)
keymap.set("n", "S", ":SwitchBuffer<CR>", { noremap = true, silent = true, desc = "Switch buffer" })
keymap.set("n", "<F4>", ":SwitchBuffer<CR>", { noremap = true, silent = true, desc = "Switch buffer" })

keymap.set("n", "<Esc>", function()
  vim.cmd("fclose!")
end, {
  desc = "close floating win",
})

-- Backup section 7 bindings; conflicts with existing keys use <leader>7.
local function toggle_show_whitespace()
  vim.wo.list = not vim.wo.list
  print(vim.wo.list and "show Whitespace" or "hide Whitespace")
end

keymap.set("n", ";u", "<cmd>source $MYVIMRC<cr>", { silent = true, desc = "Reload init.lua" })
keymap.set("n", ";v", "<cmd>edit $MYVIMRC<cr>", { silent = true, desc = "Edit init.lua" })

keymap.set("n", "<F2>", "<cmd>write!<cr>", { desc = "Save buffer" })
keymap.set("n", "<F3>", "<cmd>bdelete!<cr>", { desc = "Close buffer" })
keymap.set("n", "<A-q>", "<cmd>bdelete!<cr>", { desc = "Close buffer" })
keymap.set("n", ";q", "<cmd>quit!<cr>", { silent = true, desc = "Quit window" })
keymap.set("c", "w!!", "w !sudo tee %", { desc = "Sudo write" })

keymap.set("n", "<F12>", "<cmd>bnext<cr>", { desc = "Next buffer" })
keymap.set("n", "<C-Right>", "<cmd>bnext<cr>", { desc = "Next buffer" })
keymap.set("n", "<C-Left>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
keymap.set("n", ";p", "<cmd>bprevious<cr>", { silent = true, desc = "Previous buffer" })
keymap.set("n", ";bn", "<cmd>bnext<cr>", { silent = true, desc = "Next buffer" })
keymap.set("n", ";n", "<cmd>tabnew<cr>", { silent = true, desc = "New tab" })

keymap.set("n", "<F5>", "*", { desc = "Search word forward" })
keymap.set("n", "<S-F5>", "#", { desc = "Search word backward" })
keymap.set("n", "<S-F7>", function()
  local word = vim.fn.escape(vim.fn.expand("<cword>"), [[\/]])
  vim.cmd("vimgrep! /\\V" .. word .. "/j **")
  vim.cmd.cwindow()
end, { desc = "Search current word in files" })

keymap.set("n", "<leader>7<F9>", function()
  vim.cmd("!python " .. vim.fn.shellescape(vim.fn.expand("%:p"), true))
end, { desc = "Run current file with Python" })

local single_tab = false
keymap.set("n", "<S-F9>", function()
  single_tab = not single_tab
  if single_tab then
    vim.cmd.tabonly()
  else
    vim.cmd("tab ball")
    vim.cmd.tabnext()
  end
end, { silent = true, desc = "Toggle single tab or tabs for all buffers" })

keymap.set("n", "<F10>", function()
  vim.bo.modifiable = not vim.bo.modifiable
end, { desc = "Toggle buffer modifiable" })

keymap.set("n", "<S-F11>", "<cmd>mksession! ~/vim_session<cr>", { desc = "Save session" })
keymap.set("n", "<leader>7<F11>", "<cmd>source ~/vim_session<cr>", { desc = "Load session" })
keymap.set("n", ";w", toggle_show_whitespace, { silent = true, desc = "Toggle whitespace" })
keymap.set("n", "<A-F12>", toggle_show_whitespace, { desc = "Toggle whitespace" })
keymap.set("n", "<C-F12>", function()
  vim.cmd("write!")
  vim.cmd("!aspell check " .. vim.fn.shellescape(vim.fn.expand("%:p"), true))
  vim.cmd("edit!")
end, { desc = "Check spelling with Aspell" })

keymap.set("n", "<leader>7H", function()
  vim.o.hlsearch = not vim.o.hlsearch
end, { silent = true, desc = "Toggle search highlighting" })
keymap.set("n", "<leader>7N", function()
  vim.wo.number = not vim.wo.number
end, { silent = true, desc = "Toggle line numbers" })
keymap.set("n", ";m", "<cmd>marks<cr>", { silent = true, desc = "Show marks" })
keymap.set("n", ";dm", "<cmd>delmarks A-Z0-9<cr>", { silent = true, desc = "Delete global and numbered marks" })
keymap.set({ "n", "v" }, "<leader>7p", "%", { desc = "Jump to matching bracket" })
keymap.set("n", "<C-a>", "<cmd>%yank +<cr>", { desc = "Yank buffer to clipboard" })
keymap.set("n", "<S-CR>", "o<Esc>", { desc = "New line below" })
keymap.set("n", "<C-CR>", "@q", { desc = "Play macro @q" })
keymap.set("n", ";as", "gggqG", { silent = true, desc = "Format buffer" })
keymap.set("n", ";gs", "<cmd>!git status<cr>", { silent = true, desc = "Git status" })

if vim.g.is_win then
  keymap.set("n", ";dl", [[<cmd>!start c:\jmv\bat\dellog.bat<cr>]], {
    silent = true,
    desc = "Delete log files",
  })
  keymap.set("n", ";0", function()
    vim.o.guifont = "Consolas:h11"
  end, { silent = true, desc = "Font Consolas 11" })
  keymap.set("n", ";5", function()
    vim.o.guifont = "Courier_New:h9"
  end, { silent = true, desc = "Font Courier 9" })
end

keymap.set("n", ";b", function()
  vim.o.background = vim.o.background == "light" and "dark" or "light"
end, { silent = true, desc = "Toggle dark/light background" })
keymap.set("n", ";M", "<cmd>setlocal noexpandtab tabstop=8 softtabstop=4 shiftwidth=4<cr>", {
  silent = true,
  desc = "Mixed tabs",
})
keymap.set("n", ";3", "<cmd>setlocal expandtab tabstop=3 shiftwidth=2<cr>", {
  silent = true,
  desc = "Mini tabs",
})
keymap.set("n", ";4", "<cmd>setlocal expandtab tabstop=4 shiftwidth=4<cr>", {
  silent = true,
  desc = "Normal tabs",
})
keymap.set("n", ";8", "<cmd>setlocal expandtab tabstop=8 shiftwidth=8<cr>", {
  silent = true,
  desc = "Big tabs",
})
keymap.set("n", ";rb", function()
  return ":Rename " .. vim.fn.fnameescape(vim.fn.expand("%"))
end, { expr = true, desc = "Rename buffer" })

keymap.set("n", "<leader>7gv", "<cmd>vimgrep /fail/g %<cr><cmd>cwindow<cr>", {
  silent = true,
  desc = "Search fail in buffer",
})
keymap.set("n", "<leader>7gt", "<cmd>vimgrep /Traceback/g %<cr><cmd>cwindow<cr>", {
  silent = true,
  desc = "Search Traceback in buffer",
})
keymap.set("n", "<leader>7gd", "<cmd>vimgrep /There w/g %<cr><cmd>cwindow<cr>", {
  silent = true,
  desc = "Search There w in buffer",
})
keymap.set("n", "<leader>7gc", "<cmd>g/SysFailLTest/d<cr>", {
  silent = true,
  desc = "Delete SysFailLTest lines",
})
keymap.set("n", "<leader>7ga", "<cmd>g/Seen branch in repository/d<cr>", {
  silent = true,
  desc = "Delete Seen branch lines",
})
keymap.set("n", "<leader>7gs", [[<cmd>%s/^.\{0,27\}//<cr>]], {
  silent = true,
  desc = "Strip Jenkins timestamps",
})
keymap.set("n", "<leader>h", "<cmd>g/Requirement already satisfied/d<cr>", {
  silent = true,
  desc = "Delete pip satisfied lines",
})
keymap.set("n", "<leader>H", function()
  vim.wo.foldmethod = "manual"
  vim.cmd("%foldopen!")
  vim.cmd("v//normal! zf")
end, { silent = true, desc = "Fold non-matching lines" })
