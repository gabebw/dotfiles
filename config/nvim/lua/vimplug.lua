-- From: https://dev.to/vonheikemen/neovim-using-vim-plug-in-lua-3oom
-- I added some stuff, like `dependencies`.

local configs = {
  lazy = {},
  start = {}
}

local Plug = {
  begin = vim.fn['plug#begin'],

  -- "end" is a keyword, need something else
  ends = function()
    vim.fn['plug#end']()

    for i, config in pairs(configs.start) do
      config()
    end
  end
}

local apply_config = function(plugin_name)
  local fn = configs.lazy[plugin_name]
  if type(fn) == 'function' then fn() end
end

local plug_name = function(repo)
  return repo:match("^[%w-]+/([%w-_.]+)$")
end

-- "Meta-functions"
local meta = {

  -- Function call "operation"
  __call = function(self, repo, opts)
    opts = opts or vim.empty_dict()

    -- -- Super basic, doesn't even accept opts yet, but doesn't need to (yet).
    if opts.dependencies then
      for _, dependency in pairs(opts.dependencies) do
        vim.call('plug#', dependency, vim.empty_dict())
      end
    end

    -- we declare some aliases for `do` and `for`
    opts['do'] = opts.run
    opts.run = nil

    opts['for'] = opts.ft
    opts.ft = nil

    vim.call('plug#', repo, opts)

    -- Add basic support to colocate plugin config
    if type(opts.config) == 'function' then
      local plugin = opts.as or plug_name(repo)

      if opts['for'] == nil and opts.on == nil then
        configs.start[plugin] = opts.config
      else
        configs.lazy[plugin] = opts.config
        -- vim-plug calls `User` autocommands based on the name of the plugin
        -- https://github.com/junegunn/vim-plug/blob/baa66bcf349a6f6c125b0b2b63c112662b0669e1/plug.vim#L630-L646
        -- So we hook into that here.
        vim.api.nvim_create_autocmd('User', {
          pattern = plugin,
          once = true,
          callback = function()
            apply_config(plugin)
          end,
        })
      end
    end
  end
}

-- Meta-tables are awesome
return setmetatable(Plug, meta)
