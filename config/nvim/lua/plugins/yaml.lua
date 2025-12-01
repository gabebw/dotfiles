local function read_file(filepath)
  local file = io.open(filepath, "r")
  if file then
    local content = file:read "*a"
    io.close(file)
    return content
  else
    vim.notify("Error: Could not open file " .. filepath, vim.log.levels.ERROR)
    return nil
  end
end

--[[
Turn this:

```lua
{
  a = {
    b = 1,
    c = {
      d = 2,
      e = 3
    }
  },
  f = 4
}
```

Into this:

```lua
{
  ["a.b"] = 1,
  ["a.c.d"] = 2,
  ["a.c.e"] = 3,
  f = 4
}
]]
--- @param value table|string|number|boolean
--- @param key_so_far string|nil
local function flatten(value, key_so_far)
  if type(value) == "table" then
    local result = {}
    for k, v in pairs(value) do
      local new_key
      if key_so_far == nil or key_so_far == "" then
        -- When starting out, don't do ".a", just "a"
        new_key = k
      else
        new_key = key_so_far .. "." .. k
      end
      result = vim.tbl_extend("force", result, flatten(v, new_key))
    end
    return result
  else
    -- leaf node
    return { [key_so_far] = value }
  end
end

local function read_yaml(filepath)
  local contents = read_file(filepath)
  if contents then
    local yaml = require("lyaml").load(contents)
    if yaml.en then
      -- Strip off leading "en." from all keys
      return flatten(yaml.en)
    else
      return flatten(yaml)
    end
  end
end

-- Plain text keys and values, ready to be passed in to Snacks
--- @return snacks.picker.Item[]
local function plain_text_items(tbl)
  return vim
    .iter(tbl)
    :map(function(k, v)
      return {
        text = k,
        preview = { text = v },
      }
    end)
    :totable()
end

--- @param tbl snacks.picker.Item[]
--- @param key string
--- @return snacks.picker.Item[]
local function sorted_ascending_by(tbl, key)
  local copied = tbl
  table.sort(copied, function(one, two)
    return one[key] < two[key]
  end)
  return copied
end

function RailsYamlPicker()
  Snacks.picker.pick({
    format = "text",
    finder = function()
      local rails_root = vim.fn["rails#app"]()._root
      local yml_files = vim.split(vim.fn.glob(rails_root .. "/config/locales/**/*.yml"), "\n", { trimempty = true })
      local results = {}
      for _, filepath in pairs(yml_files) do
        results = vim.tbl_extend("force", results, flatten(read_yaml(filepath)))
      end
      return sorted_ascending_by(plain_text_items(results), "text")
    end,
    confirm = function(picker, item)
      picker:close()
      if item then
        local register = "a"
        vim.fn.setreg(register, item.text)
        vim.notify("Copied to register " .. register .. ": " .. item.text)
      end
    end,
    -- override default preview, which assumes there is a `file` key with a file path
    preview = "preview",
  })
end

---@module "lazy.types"
---@type LazySpec[]
return {
  -- lyaml prints warnings on install, but it does work with Lua > 5.1, so ignore them :shrug:
  {
    "gvvaughan/lyaml",
    dependencies = { "folke/snacks.nvim" },
    build = "rockspec",
    init = function()
      -- Run only in Rails files, as detected by rails.vim ("User Rails" autocmd group)
      vim.api.nvim_create_autocmd({ "User" }, {
        pattern = "Rails",
        callback = function()
          vim.keymap.set({ "n" }, "gyy", function()
            RailsYamlPicker()
          end, { buffer = true, remap = false, desc = "Pick a yaml string" })
        end,
      })
    end,
  },
}
