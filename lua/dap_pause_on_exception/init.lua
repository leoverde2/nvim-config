local dap = require("dap")
local dapui = require("dapui")

local M = {}

local function escape_string(str)
	local final = str:gsub("\\", "\\\\"):gsub("\"", "\\\""):gsub("\n", "\\n")
	return final
end


local function remove_premature_linebreaks(str)
	-- Remove line breaks, preserving intentional breaks after sentences
	return str:gsub("([^.!?:])%s*\n%s*", function(cap)
		if cap == "/" or cap == ")" then
			return cap
		else
			return cap .. " "
		end
	end)
end

function M.open_wt_with_content(content)
	-- Remove trailing tabs from each line
    content = content:gsub("%t+$", ""):gsub("%t+\n", "\n")
    -- Trim leading and trailing whitespace from the entire content
    content = content:match("^%s*(.-)%s*$")
    -- Remove excessive spaces at the beginning of lines (more than 2)
    content = content:gsub("\n%s%s%s+", "\n  ")

	local filename = vim.fn.expand("~/.local/share/nvim/dap_console_output.log")
	local file = io.open(filename, "a")
	file:write(content)
	file:write("\n" .. "\n" .. "\n" .. "\n")
	file:close()

	local tmp_file = os.tmpname()
	local file = io.open(tmp_file, "w")
	file:write(content)
	file:close()

	local script_path = vim.fn.expand("~/.config/nvim/lua/dap_pause_on_exception/show_exception.sh")
	local cmd = string.format([[ wt.exe wsl bash -c '%s "%s"' ]], script_path, tmp_file)
	print("Executing command: ".. cmd)
	os.execute(cmd)
end

function M.get_dapui_console_content()
	local console_bufnr = dapui.elements.console.buffer()
	if console_bufnr then
		local lines_table = vim.api.nvim_buf_get_lines(console_bufnr, 0, -1, false)
		local lines = table.concat(lines_table, "\n")
		return lines
	end
end


function M.copy_console_to_wt(attempts, last)
	attempts = attempts or 0
	local content = M.get_dapui_console_content()

	if content ~= last then
		open_wt_with_content(content)
	elseif attempts < 10 then
		vim.defer_fn(function()
			M.copy_console_to_wt(attempts + 1, content)
		end, 100)
	end
end


return M
