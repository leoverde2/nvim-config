local M = {}


function M.print_table(t, indent)
    indent = indent or 0
    local formatting = string.rep("  ", indent)
    if type(t) ~= "table" then
        print(formatting .. tostring(t))
        return
    end

    print(formatting .. "{")
    for key, value in pairs(t) do
        local key_str = string.format("[%s]", tostring(key))
        if type(value) == "table" then
            print(formatting .. "  " .. key_str .. " = ")
            print_table(value, indent + 1)
        else
            local value_str = string.format("[%s]", tostring(value))
            print(formatting .. "  " .. key_str .. " = " .. value_str)
        end
    end
    print(formatting .. "}")
end

function M.find_project_root()
    local current_dir = vim.api.nvim_buf_get_name(0)
    while true do
        local git_dir = current_dir .. "/.git"
        if vim.fn.isdirectory(git_dir) == 1 then
            return current_dir
        end
        local parent_dir = vim.fn.fnamemodify(current_dir, ":h")
        if parent_dir == current_dir then
            break
        end
        current_dir = parent_dir
    end
end

function M.get_project_name(project_path)
    if project_path then
        local directory_name = project_path:match("([^/]+)$")
        return directory_name
    end
end

return M
