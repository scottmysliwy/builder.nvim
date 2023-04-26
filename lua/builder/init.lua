-- builder.lua


local telescope = require("telescope.builtin")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local build_json = vim.fn.json_decode(vim.fn.readfile(".build.json"))

local function execute_and_display2(command)
  local output_file = "/tmp/command_output.txt"
  os.execute(command .. " > " .. output_file .. " 2>&1")

  telescope.find_files({
    prompt_title = "Command Output",
    cwd = "/tmp",
    find_command = { "find", "-type", "f", "-name", "command_output.txt" },
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.cmd("edit " .. entry.path)
      end)

      return true
    end
  })
end


local function execute_and_display(command)
  local temp_file = os.tmpname()
  local output_file = temp_file .. "_command_output.txt"
  os.execute(command .. " > " .. output_file .. " 2>&1")

  local file = io.open(output_file, "r")
  if file ~= nil then
    io.close(file)
    telescope.find_files({
      prompt_title = "Command Output",
      cwd = vim.fn.fnamemodify(output_file, ":h"),
      find_command = {"find", "-type", "f", "-name", vim.fn.fnamemodify(output_file, ":t")},
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local entry = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          vim.cmd("edit " .. entry.path)
        end)

        return true
      end
    })
  else
    print("No output file found")
  end





local function build()
  if not vim.tbl_isempty(build_json.build) then
    execute_and_display(table.concat(build_json.build, " "))
  else
    print("Build command not found in build.json")
  end
end

local function run()
  if not vim.tbl_isempty(build_json.run) then
    execute_and_display(table.concat(build_json.run, " "))
  else
    print("Run command not found in build.json")
  end
end

local function test()
  if not vim.tbl_isempty(build_json.test) then
    execute_and_display(table.concat(build_json.test, " "))
  else
    print("Test command not found in build.json")
  end
end



return {
  build = build,
  run = run,
  test = test,
}
