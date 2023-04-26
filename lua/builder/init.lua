-- builder.lua

local telescope = require("telescope.builtin")
local build_json = vim.fn.json_decode(vim.fn.readfile(".build.json"))

local function execute_command(cmd)
  vim.cmd("enew | terminal " .. cmd)
end

local function select_command(commands)
  local items = {}

  for _, cmd in ipairs(commands) do
    table.insert(items, {
      display = cmd,
      cmd = cmd
    })
  end

  telescope
      .select_prompt({
        prompt_title = "Select a command",
        finder = function()
          return items
        end,
        sorter = function()
          return true
        end,
        attach_mappings = function(_, map)
          map("i", "<CR>", function(prompt_bufnr)
            local selection = telescope.actions.get_selected_entry(prompt_bufnr)
            execute_command(selection.cmd)
            return true
          end)
          return true
        end,
      })
end

local function build()
  if not vim.tbl_isempty(build_json.build) then
    select_command(build_json.build)
  else
    print("Build command not found in build.json")
  end
end

local function run()
  if not vim.tbl_isempty(build_json.run) then
    select_command(build_json.run)
  else
    print("Run command not found in build.json")
  end
end

local function test()
  if not vim.tbl_isempty(build_json.test) then
    select_command(build_json.test)
  else
    print("Test command not found in build.json")
  end
end

return {
  build = build,
  run = run,
  test = test,
}

