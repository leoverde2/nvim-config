local dapui = require("dapui")
local dap = require("dap")
local json = require("dkjson")
local watch_file = vim.fn.stdpath("data") .. "/dap_watches.json"


local function write_json_file(data)
	local file = assert(io.open(watch_file, "w"))
	local json_data = json.encode(data, { indent = true })
	file:write(json_data)
	file:close()
end


local function get_file_as_table()
	local file = assert(io.open(watch_file, "r"))
	local json_data = file:read("*a")
	file:close()
	if json_data then
		local decoded = json.decode(json_data)
		if decoded then
			return decoded
		else
			return {}
		end
	else
		return {}
	end
end

local function UpdateJson(hash, watches)
	local data_table = get_file_as_table()
	data_table[hash] = watches
	write_json_file(data_table)
end

local function get_git_hash(path)
	local command = "git -C " .. path .. " log --pretty=format:%H | tail -1"
	local handle = io.popen(command)
	if not handle then
		return
	end
	local hash = handle:read("*a")
	handle:close()
	return hash
end


local function is_git_repo(path)
	local command = "git -C " .. path .. " rev-parse --is-inside-work-tree 2>/dev/null"
	local handle = io.popen(command)
	if handle then
		local result = handle:read("*a")
		handle:close()
		return result:match("true") ~= nil
	end
end


local function save_watches()
	local path = dap.session().config.cwd
	if not is_git_repo(path) then
		return
	end
	local hash = get_git_hash(path)
	if not hash then
		return
	end
	local watches = dapui.elements.watches.get()
	UpdateJson(hash, watches)
end


local function load_watches()
	local path = dap.session().config.cwd
	if not is_git_repo(path) then
		return
	end
	local hash = get_git_hash(path)
	if not hash then
		return
	end

	if not dapui.elements.watches then
		return
	end
	local watches = dapui.elements.watches.get()
	for idx = #watches, 1, -1 do
		dapui.elements.watches.remove(idx)
	end

	local data_table = get_file_as_table()
	local final_table = data_table[hash]

	for _, watch in ipairs(final_table) do
		dapui.elements.watches.add(watch.expression)
	end

end

dap.listeners.after.event_initialized["load_watches_handler"] = load_watches
dap.listeners.before.event_terminated["save_watches_handler"] = save_watches





















