----------
-- Utility methods for use within Soma.
--
-- @module soma.util
----------

local Me = {}
package.loaded[...] = Me

-- Imports
local this = ...

---
-- Import the fields from each of a list of submodules.
-- @function importmethods
-- @param parent The table to receive imported fields.
-- @param prefix A string to be applied to each submodule name.
-- @param subs Array of submodule names from which to import fields.
function Me.importmethods(parent, prefix, subs)
  for _,name in ipairs(subs) do
    local sub = require(prefix .. '.' .. name)
    for f,v in pairs(sub) do
      parent[f] = v
    end
  end
end

Me.importmethods(Me, this, { 'isnan' } )

-- Close the door
_ENV = nil

---
-- Import each of a list of submodules.
-- @function importmodules
-- @param parent The table to receive imported submodules.
-- @param prefix A string to be applied to each submodule name.
-- @param subs Array of submodule names to be imported.
function Me.importmodules(parent, prefix, subs)
  for _, name in ipairs(parent) do
    parent[name] = require(prefix .. '.' .. name)
  end
end
