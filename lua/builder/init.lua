-- builder.lua

-- Read the build.json file
local telescope = require("telescope.builtin")
local build_json = vim.fn.json_decode(vim.fn.readfile(".build.json"))

-- Use Telescope to select a command to execute
local function execute_command(commands)
  local items = {}

  for _, cmd in ipairs(commands) do
    table.insert(items, {
      display = cmd,
      cmd = cmd
    })
  end

  telescope.vim_buffer_list({
    prompt_title = "Select a command",
    entries = items,
    attach_mappings = function(_, map)
      map('i', '<CR>', function(prompt_bufnr)
        local selection = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
        vim.cmd("enew | terminal " .. selection.cmd)
        return true
      end)
      return true
    end
  })
end

-- Execute build command
local function build()
  if not vim.tbl_isempty(build_json.build) then
    execute_command(build_json.build)
  else
    print("Build command not found in build.json")
  end
end

-- Execute run command
local function run()
  if not vim.tbl_isempty(build_json.run) then
    execute_command(build_json.run)
  else
    print("Run command not found in build.json")
  end
end

-- Execute test command
local function test()
  if not vim.tbl_isempty(build_json.test) then
    execute_command(build_json.test)
  else
    print("Test command not found in build.json")
  end
end

local M = {}

M.build = build
M.run = run
M.test = test

return M
