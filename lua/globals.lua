local utils = require("utils")
local logging = require("logging")

vim.g.log_level = logging.get_log_level()

-- python3_host_prog is needed for python plugins, see also https://jdhao.github.io/2026/05/11/nvim_python_provider_setup/
local config_path = vim.fn.stdpath("config")
local is_win = utils.has("win32") or utils.has("win64")
local python3_path = is_win
    and vim.fs.joinpath(config_path, ".venv", "Scripts", "python.exe")
  or vim.fs.joinpath(config_path, ".venv", "bin", "python3")
if is_win and not utils.executable(python3_path) then
  python3_path = [[C:\Python313\python.exe]]
end
python3_path = vim.g.python3_host_prog or python3_path
if utils.executable(python3_path) then
  vim.g.python3_host_prog = python3_path
else
  vim._log(
    string.format(
      "Python provider interpreter not found: %s\n  Create a config .venv and install pynvim, or set g:python3_host_prog.",
      python3_path
    ),
    vim.log.levels.WARN
  )
end

------------------------------------------------------------------------
--                          custom variables                          --
------------------------------------------------------------------------
vim.g.is_win = (utils.has("win32") or utils.has("win64")) and true or false
vim.g.is_linux = (utils.has("unix") and (not utils.has("macunix"))) and true or false
vim.g.is_mac = utils.has("macunix") and true or false

------------------------------------------------------------------------
--                         builtin variables                          --
------------------------------------------------------------------------
vim.g.loaded_perl_provider = 0 -- Disable perl provider
vim.g.loaded_ruby_provider = 0 -- Disable ruby provider
vim.g.loaded_node_provider = 0 -- Disable node provider
vim.g.did_install_default_menus = 1 -- do not load menu

-- Custom mapping <leader> (see `:h mapleader` for more info)
vim.g.mapleader = ","

-- Enable highlighting for lua HERE doc inside vim script
vim.g.vimsyn_embed = "l"

-- Use English as main language
vim.cmd([[language en_US.UTF-8]])

-- Disable loading certain plugins

-- Whether to load netrw by default, see https://github.com/bling/dotvim/issues/4
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.netrw_liststyle = 3
if vim.g.is_win then
  vim.g.netrw_http_cmd = "curl --ssl-no-revoke -Lo"
end

-- Do not load tohtml.vim
vim.g.loaded_2html_plugin = 1

-- Do not load zipPlugin.vim, gzip.vim and tarPlugin.vim (all these plugins are
-- related to checking files inside compressed files)
vim.g.loaded_zipPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_tarPlugin = 1

-- Do not load the tutor plugin
vim.g.loaded_tutor_mode_plugin = 1

-- Do not use builtin matchit.vim and matchparen.vim since we use vim-matchup
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1

-- Disable sql omni completion, it is broken.
vim.g.loaded_sql_completion = 1

-- control how to show health check window
vim.g.health = { style = nil }
