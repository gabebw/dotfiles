local M = {}

--- @return boolean
function M.in_git_repo()
  vim.fn.system "git rev-parse --is-inside-work-tree 2> /dev/null"
  return vim.v.shell_error == 0
end

return M
