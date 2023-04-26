-- builder.lua

-- Read the build.json file
local build_json = vim.fn.json_decode(vim.fn.readfile(".build.json"))


-- Execute build command
local function build()
  if not vim.tbl_isempty(build_json.build) then
    local cmd = table.concat(build_json.build, " ")
    vim.cmd("terminal " .. cmd)
  else
    print("Build command not found in build.json")
  end
end

-- Execute run command
local function run()
  if not vim.tbl_isempty(build_json.run) then
    local cmd = table.concat(build_json.run, " ")
    vim.cmd("terminal " .. cmd)
  else
    print("Run command not found in build.json")
  end
end

-- Execute test command
local function test()
  if not vim.tbl_isempty(build_json.test) then
    local cmd = table.concat(build_json.test, " ")
    vim.cmd("terminal " .. cmd)
  else
    print("Test command not found in build.json")
  end
end

local M = {}

M.build = build
M.run = run
M.test = test

return M
