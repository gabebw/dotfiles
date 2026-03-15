local M = {}

-- A session name, based on the git directory name (e.g. "dotfiles").
-- Returns `nil` if it's not in a Git repo.
--- @return string|nil
function M.name()
  -- Example result: { code = 0, stdout = "/something/somewhere/\n" }
  -- Note the trailing "\n" in `stdout`.
  local cmd_result = vim.system({ "git", "rev-parse", "--show-toplevel" }, { text = true }):wait()

  if cmd_result.code == 0 then
    local git_root = vim.trim(cmd_result.stdout)
    return vim.fs.basename(git_root)
  else
    return nil
  end
end

return M
