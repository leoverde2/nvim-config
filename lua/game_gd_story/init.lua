local json = require("JSON")

local M = {}


local regex_pattern = "%[%d+%]"
local target_dir = "/home/ubuntu/games/turn-based/assets/story/"

local function switch_file(file_path)
    vim.cmd("edit" .. vim.fn.fnameescape(file_path))
end

local function in_target_dir()
    local buf_path = vim.api.nvim_buf_get_name(0)
    local final = buf_path:find(target_dir, 1, true) == 1
    return final
end

---@param direction string The direction to search("forwards" or "backwards")
---@param line string The line to search within
---@return number|nil The found number or nil if not found
local function pattern_found(direction, line)
    local found = nil
    local matched
    if line:match(regex_pattern) ~= nil then
        if direction == "forwards" then
            matched = line:match(regex_pattern)
        else
            for match in line:gmatch(regex_pattern) do
                matched = match
            end
        end
        found = matched:gsub("%D", "")
        return found
    end
end

local function iterate_lines(direction)
    local current_win = vim.api.nvim_get_current_win()
    local current_buf = vim.api.nvim_get_current_buf()
    local num_lines = vim.api.nvim_buf_line_count(current_buf)

    local cursor_pos = vim.api.nvim_win_get_cursor(current_win)
    local cursor_line_num = cursor_pos[1]
    local cursor_col = cursor_pos[2]

    local end_line
    local step
    if direction == "forwards" then
        end_line = num_lines
        step = 1
    else
        end_line = 1
        step = -1
    end

    local found = nil
    local start
    local start_line_final
    for i = cursor_line_num, end_line, step do
        local current_line = vim.api.nvim_buf_get_lines(current_buf, i - 1, i + 1, false)[1]
        local final = current_line
        if i == cursor_line_num then
            if direction == "forwards" then
                start = cursor_col
                start_line_final = #current_line
            else
                start = 1
                start_line_final = cursor_col
            end
            final = string.sub(current_line, start, start_line_final)
        end
        found = pattern_found(direction, final)
        if found ~= nil then
            return found
        end
    end
    return found
end

---@param num number
local function get_file_from_number(num)
    local bufnr = vim.api.nvim_get_current_buf()
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local base_name = filename:match("(.+)%..*$")
    local json_file = base_name .. ".json"
    return json_file
end

function change_active_file()
    local backwards_match = iterate_lines("backwards")
    local forwards_match = iterate_lines("forwards")
    num = tonumber(backwards_match)
    if backwards_match ~= nil and forwards_match ~= nil then
        local file_name = get_file_from_number(backwards_match)
        local file = io.open(file_name, "r")
        if not file then
            return nil, "File not found or cannot be opened"
        end
        local content = file:read("*all")
        file:close()

        local parsed_data = json:decode(content)
        if not parsed_data then
            return nil
        end
        local decision = parsed_data.decisions[num + 1]
        local destination = decision.destination 

        local final_file = target_dir .. destination .. ".txt"
        switch_file(final_file)
    end
end


function M.register_cmd()
    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*.txt",
        callback = function()
            if in_target_dir() then
                vim.api.nvim_buf_set_keymap(0, "n", "gd", ":lua change_active_file()<CR>", { noremap = true, silent = true })
                end
            end
    })
end

return M
