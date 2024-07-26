local function check_for_file_changes()
	vim.cmd("checktime")
	vim.cmd("redraw!")
end

local function start_file_changes_check()
	check_for_file_changes()
	vim.defer_fn(start_file_changes_check, 1000)
end

start_file_changes_check()
