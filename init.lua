vim.g.mapleader = "º"
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.smarttab = false
vim.o.undofile = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.keymap.set("n", "<up>", "gk")
vim.keymap.set("n", "<down>", "gj")
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.updatetime = 100
vim.opt.autoread = true



-- Trigger `autoread` when files change on disk
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    pattern = "*",
    command = 'if mode() != "c" | checktime | endif'
})

utils = require("utils")
require("game_gd_story").register_cmd()



vim.api.nvim_set_keymap("n", "<leader>rr", "<cmd>lua vim.lsp.buf.references()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ww', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<CR>", { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>y', ':silent! !echo -n % | pbcopy<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>cd', ':cd %:p:h<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fr', '<cmd>lua require("telescope.builtin").lsp_references()<CR>', { noremap = true, silent = true })
vim.opt.incsearch = true
vim.api.nvim_set_keymap('n', '<leader>fi', ':e <C-R>=expand("%:p:h") . "/" <CR>', { noremap = true, silent = false })



vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
    command = "checktime",
})

vim.api.nvim_set_keymap('n', '<F4>', ':NvimTreeToggle<CR>', {noremap = true, silent = true})

vim.api.nvim_set_keymap("n", "<F6>", ":UndotreeToggle<CR>", {noremap = true, silent = true})




vim.api.nvim_create_autocmd("FileType", {
    pattern = {"python", "lua", "cpp", "cxx", "cc", "ino", "arduino", "go"},
    callback = function()
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer=true})
    end
})








vim.keymap.set('n', '<leader>e', function()
    vim.diagnostic.open_float(nil, {focus=false})
end, { noremap = true, silent = true })

-- bootstrap packer.nvim
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
end



local p = "~/.config/nvim/personal/"

require('packer').startup(function()

    use 'wbthomason/packer.nvim' -- Package manager



    use {p .. "save_load_dapui_watches"}
    --	use {p .. "dap_pause_on_exception"}

    use 'kyazdani42/nvim-tree.lua' -- File explorer
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    use 'nvim-treesitter/playground'
    use "nvim-treesitter/nvim-treesitter-refactor"
    use {
        'neovim/nvim-lspconfig',
        requires = { "nvim-lua/plenary.nvim"}
    }
    use {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup {}
        end
    }
    use "ojroques/nvim-lspfuzzy"
    use {'hrsh7th/nvim-cmp', requires = {
        {'hrsh7th/cmp-buffer'},
        {'hrsh7th/cmp-nvim-lsp'},
        {'onsails/lspkind-nvim'},
        -- Add other sources as needed
    }}
    use {
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
    }
    use "jose-elias-alvarez/null-ls.nvim"
    use {
        'mfussenegger/nvim-dap',  -- Debugger Adapter Protocol for Neovim
        requires = {
            'rcarriga/nvim-dap-ui',  -- UI for debugging
            'theHamsta/nvim-dap-virtual-text',  -- Virtual text for showing debug information
        }
    }
    use {'folke/lazydev.nvim'}
    use { "nvim-neotest/nvim-nio" }
    use { 'rcarriga/nvim-dap-ui', requires = {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio"} 
    }
    use { 'theHamsta/nvim-dap-virtual-text' }
    use {
        'nvim-telescope/telescope.nvim',
        requires = { {'nvim-lua/plenary.nvim'} }
    }
    use {
        'nvim-telescope/telescope-file-browser.nvim',
        requires = { {'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim'} }
    }
    use {
        'dense-analysis/ale',
        config = function()
            vim.g.ale_linters = {
                cpp = {'clangtidy'}
            }
            vim.g.ale_fixers = {
                cpp = {'clang-format'}
            }
            vim.g.ale_cpp_clangtidy_executable = '/usr/bin/clang-tidy' -- Path to clang-tidy
        end
    }

    use { "mbbill/undotree" }
    use { "rcarriga/nvim-notify" }
    use 'mhinz/neovim-remote'
    use { 'nvim-telescope/telescope-dap.nvim' }
    use { 'mfussenegger/nvim-dap-python' }
    use {"artemave/workspace-diagnostics.nvim"} 
    use "narutoxy/dim.lua"
    use { 'junegunn/fzf', dir = '~/.fzf', run = './install --all' }
    use { 'junegunn/fzf.vim' }
    use 'gruvbox-community/gruvbox'
    use 'folke/tokyonight.nvim'
    use 'overcache/NeoSolarized'
    use 'EdenEast/nightfox.nvim'
    use 'NTBBloodbath/doom-one.nvim'
    use 'bluz71/vim-moonfly-colors'
end)
vim.cmd [[colorscheme moonfly]]


-- Setup nvim-tree
local nvim_tree = require('nvim-tree').setup {
    update_focused_file = {
        enable = true, -- Update the focused file on `BufEnter`
    },
    diagnostics = {
        enable = true,
    },
}




vim.cmd([[
autocmd VimEnter * NvimTreeToggle
]])

vim.cmd('autocmd VimEnter * wincmd w')

local api = require "nvim-tree.api"
vim.keymap.set('n', '<leader>º', api.tree.change_root_to_node, { noremap = true, silent = true, desc = "Change root to node" })


vim.api.nvim_set_keymap("n", "<leader>cw", "<cmd>lua change_working_directory()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>cn", "<cmd>lua change_nvim_root()<CR>", { noremap = true, silent = true })


function change_working_directory()
    -- Get the current buffer name and file type
    local current_file = vim.fn.bufname("%")
    local file_type = vim.api.nvim_buf_get_option(0, 'filetype')

    -- Check if the buffer is a file and not NvimTree
    if current_file ~= '' and file_type ~= 'NvimTree' then
        -- Get the directory of the current file
        local file_directory = vim.fn.fnamemodify(current_file, ":h")

        -- Change the working directory to the file's directory
        vim.cmd("cd " .. file_directory)
    end
end


function change_nvim_root()
    local current_file = vim.fn.bufname("%")
    local file_directory = vim.fn.fnamemodify(current_file, ":h")

    api.tree.change_root(file_directory)
end


function change_nvim_tree_root()
    local args = vim.fn.argv()
    if #args > 0 then
        local target_path = args[1]

        if vim.fn.filereadable(target_path) == 1 then
            local parent_dir = vim.fn.fnamemodify(target_path, ":h")
            if parent_dir == "." then
                return
            end
            api.tree.change_root("/" .. parent_dir)

        end
    end
end



vim.cmd [[ autocmd VimEnter * lua change_nvim_tree_root() ]]







vim.api.nvim_set_keymap('n', '<C-Left>',  ':vertical resize -2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-Right>', ':vertical resize +2<CR>', { noremap = true, silent = true })







require('dim').setup({
    disable_lsp_decorations = false,
    modules = {
        dim_unused_imports = {
            enabled = true,
            highlight = "UnusedImport",
        },
    },
})


-- Treesitter configuration
require'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "cpp", "lua", "python", "javascript", "go", "arduino" },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true
    },
}

-- LSP configuration
local lspconfig = require('lspconfig')
local lspfuzzy = require("lspfuzzy")

function setup_workspace_diagnostics()
    local client = vim.lsp.buf_get_clients()[1]
    local bufnr = vim.api.nvim_get_current_buf()
    if client == nil or bufnr == nil then
        return
    end
    local buf_name = vim.api.nvim_buf_get_name(bufnr)
    local buf_file_type = vim.api.nvim_buf_get_option(bufnr, "filetype")
    require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
end


local path = vim.split(package.path, ";")
table.insert(path, "lua/?.lua")
table.insert(path, "lua/?/init.lua")

local new_package_path = table.concat(path, ";")
package.path = new_package_path

local lua_settings = {
    Lua = {
        runtime = {
            version = 'LuaJIT',
            path = path,
        },
        diagnostics = {
            globals = { 'vim', 'use' }, -- Add 'use' and 'vim' to globals
        },
        workspace = {
            library = {
                [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                ["/home/ubuntu/.local/share/nvim/site/pack/packer/start"] = true,
                ["/home/ubuntu/.local/share/nvim/site/pack/packer/opt"] = true,
                ["/usr/local/share/lua/5.1"] = true,
                ["/home/ubuntu/.config/nvim/personal"] = true,
            },
        },
    },
}

local f = require("dap_pause_on_exception")

lspconfig.lua_ls.setup{
    settings = lua_settings
}

--local null_ls = require("null-ls")
--null_ls.setup({
--    sources = {
--        null_ls.builtins.diagnostics.pylint}})

-- Example configuration for Python with workspace-diagnostics.nvim
lspconfig.pyright.setup({
    root_dir = lspconfig.util.root_pattern('.git', 'setup.py', 'pyproject.toml', 'poetry.lock'),
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true
            }
        }
    },
    on_attach = function(client, bufnr)
        setup_workspace_diagnostics()
        vim.cmd([[autocmd DirChanged * lua setup_workspace_diagnostics()]])
    end
})


lspconfig.arduino_language_server.setup {
    cmd = {
        "arduino-language-server",
        "-cli-config",
        vim.fn.expand("~/.arduino15/arduino-cli.yaml"),
        "-cli",
        "arduino-cli",
        "-clangd",
        "clangd",
        "-fqbn",
        "esp8266:esp8266:generic"
    },
    root_dir = lspconfig.util.find_git_ancestor,
    filetypes = { "arduino", "ino" },
}

lspconfig.gopls.setup({})



lspfuzzy.setup({})
require("trouble").setup({
    mode = "workspace"
})

local root_dir = function(filename)
    local root = lspconfig.util.root_pattern(".git")(filename)
    return root
end

local project_root = utils.find_project_root()

local function compilation_db_path()
    if project_root then
        local final = project_root .. "/compile_commands.json"
        return final
    end
    return nil
end


lspconfig.clangd.setup{}


vim.o.omnifunc = 'v:lua.vim.lsp.omnifunc'
-- Enable file watching for LSP servers
vim.lsp.handlers["textDocument/didChange"] = function(_, _, bufnr, content_changes)
    vim.api.nvim_buf_set_text(bufnr, 0, 0, vim.fn.line("$"), {}, content_changes)
end


-- Example configuration for JavaScript/TypeScript
lspconfig.tsserver.setup{}


local function is_modified_buffer_open(buffers)
    for _, v in pairs(buffers) do
        if v.name:match("NvimTree_") == nil then
            return true
        end
    end
    return false
end






local cmp = require('cmp')

cmp.setup({
    mapping = {
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),
    },
    sources = {
        { name = 'nvim_lsp' }, -- LSP sources
        { name = 'buffer' },   -- Buffers
        -- Add more sources as needed
    },
    window = {
        documentation = {
            border = "rounded",  -- Add borders with rounded corners
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",  -- Highlight configuration for the floating window
            maxwidth = 80,  -- Maximum width of the floating window
            maxheight = 12,  -- Maximum height of the floating window
        },
    },
    formatting = {
        format = function(entry, vim_item)
            vim_item.menu = ({
                nvim_lsp = "[LSP]",
                buffer = "[Buffer]",
            })[entry.source.name]
            return vim_item
        end,
    },
})












-- Configure diagnostics globally for all files
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        -- Enable underline, use default values
        underline = true,
        -- Enable virtual text
        virtual_text = true,
        -- Disable a few kinds of diagnostics
        signs = true,
        update_in_insert = false,
    }
)










local dap = require('dap')
local dapui = require("dapui")


vim.api.nvim_set_keymap('n', '<F2>', "<Cmd>lua require'dap'.step_into()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F3>', "<Cmd>lua require'dap'.step_over()<CR>", { noremap = true, silent = true })


-- Function to find venv directory
local function find_venv_dir(start_dir)
    local current_dir = start_dir or vim.fn.getcwd()
    while current_dir ~= '/' do
        local venv_path = current_dir .. '/venv/bin/python'
        if vim.fn.executable(venv_path) == 1 then
            return venv_path
        end
        current_dir = vim.fn.fnamemodify(current_dir, ':h')
    end
    return nil
end

-- Function to get Python path
local function get_python_path()
    local venv_path = find_venv_dir(vim.fn.expand('%:p:h'))
    if venv_path then
        return venv_path
    else
        return vim.fn.exepath('python3')
    end
end

dap.adapters.python = {
    type = 'executable',
    command = get_python_path(),
    args = { '-m', 'debugpy.adapter' },
}

dap.configurations.python = {
    {
        type = 'python',
        request = 'launch',
        name = 'Debug Python File',
        program = "${workspaceFolder}/main.py",
        pythonPath = get_python_path,
        cwd = "${workspaceFolder}",
        env = {
            PYTHONPATH = "${workspaceFolder}${pathSeparator}${env:PYTHONPATH}"
        },
        console = "integratedTerminal",
    },
    {
        type = 'python',
        request = 'launch',
        name = 'Debug Current Python File',
        program = vim.fn.expand("%"),
        pythonPath = "/usr/bin/python3",
        cwd = "${workspaceFolder}",
        env = {
            PYTHONPATH = "${workspaceFolder}${pathSeparator}${env:PYTHONPATH}"
        },
        console = "integratedTerminal",
    },
}


dap.adapters.cppdbg = {
    id = "cppdbg",
    type = "executable",
    command = vim.fn.expand("~/opt/cppdbg/extension/debugAdapters/bin/OpenDebugAD7"),
}

dap.configurations.cpp = {
    {
        name = "Debug C++",
        type = 'cppdbg',
        request = 'launch',
        program = function ()
            local root = utils.find_project_root()
            local executable_name_file = io.open(root .. "/build/executable_name.txt", "r")
            local executable_name = executable_name_file:read()
            executable_name_file:close()
            return root .. "/build/" .. executable_name
        end,
        args = {}, -- Optional: Additional arguments passed to the program being debugged
        env = {},
        cwd = utils.find_project_root(),
        console = "integratedTerminal",
        runInTerminal = true,
        MIMode = "gdb", -- Adjust this based on your debugger (e.g., 'lldb' for LLDB)
        MIDebuggerPath = 'gdb', -- Path to the debugger executable
    },
}

local telescope = require('telescope.builtin')


dap.configurations.cpp = {
    {
        name = "specify name C++",
        type = 'cppdbg',
        request = 'launch',
        program = function ()
            local filepath = vim.fn.input("Relative path: ", "", "file")
            return vim.fn.expand(filepath)
        end,
        args = {}, -- Optional: Additional arguments passed to the program being debugged
        env = {},
        cwd = vim.fn.expand("%:p:h"),
        console = "integratedTerminal",
        runInTerminal = true,
        MIMode = "gdb", -- Adjust this based on your debugger (e.g., 'lldb' for LLDB)
        MIDebuggerPath = 'gdb', -- Path to the debugger executable
    },
}


dap.configurations.go = {
    {
        type = 'go',
        name = 'Debug Arduino Language Server',
        request = 'attach',
        mode = 'remote',
        remotePath = '',  -- if needed, specify the remote path
        port = 2345,
        host = '127.0.0.1',
        program = "${workspaceFolder}",
        dlvToolPath = vim.fn.exepath('dlv'),  -- Adjust to where delve is installed
    },
}

dap.adapters.go = {
    type = 'server',
    host = '127.0.0.1',
    port = 2345, -- This port should match the port used in your Delve command
}



dapui.setup({
    layouts = {
        {
            elements = {
                "watches",
                "repl",
                "console"
            },
            size = 40,
            position = "left"
        }
    }
})





local dap_pause = require("dap_pause_on_exception")
local utils = require("utils")


dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

dap.listeners.after.event_stopped["exception_detector"] = function(session, body)
    if body.reason == "exception" then
        session:request("exceptionInfo", {threadId = body.threadId}, function(err, response)
            if err then
                print("Error getting exception info: " .. vim.inspect(err))
            else
                local exception_info = string.format([[
    Exception type: %s
    Exception message: %s

    %s
    ]],
                    response.exceptionId or "Unknown",
                    response.description or "No description available",
                    response.details and response.details.stackTrace or "No stack trace available"
                )
                dap_pause.open_wt_with_content(exception_info)
            end
        end
        )
        vim.defer_fn(dap.continue, 300)
    end
end









vim.api.nvim_set_keymap('n', '<F5>', '<cmd>lua require("dap").continue()<CR>', { noremap = true, silent = true })


vim.api.nvim_set_keymap('n', '<leader>db', '<cmd>lua require("dap").toggle_breakpoint()<CR>', { noremap = true, silent = true })









require("telescope").load_extension("file_browser")

vim.api.nvim_set_keymap("n", "<leader>fcf", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", { noremap = true, silent = true })







---- Enable ALE
--vim.g.ale_linters = {
--  cpp = {'clangtidy'}
--}
--
---- Set path to clang-tidy
--vim.g.ale_cpp_clangtidy_executable = '/usr/bin/clang-tidy'
--
---- Set additional clang-tidy options if necessary
--vim.g.ale_cpp_clangtidy_options = '-checks=*'
--
--vim.g.ale_history_log_output = 1
--vim.g.ale_log_to_file = 1
--vim.g.ale_log_file_path = vim.fn.expand('~/.cache/nvim/ale.log')
