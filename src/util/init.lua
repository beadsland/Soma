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

local L = {}
L.Peri = {}

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

---
-- Access fields associated with, but not stored in, a table.
--
-- A peritable provides for quasi-protected scope without polluting
-- either its table proper or that table's metatable. The keys of a
-- peritable are not exposed for inspection, thus only those keys
-- known to the caller are accessible.
--
-- On the other hand, a peritable makes explicit that its members are
-- hidden, unlike the spooky action-at-a-distance of assigning an
-- <code>__index</code> method to a table's metatable, nor the brute
-- obfuscation of stashing values in that metatable.
--
-- @function peritable
-- @param table A table to which a peritable is associated.
-- @return The peritable associated with table.
function Me.peritable(table, key, value)
  local peri = L.Peri[table]
  if not peri then
    peri = {};
    L.Peri[table] = peri

    local hidden = {}
    local mt = { __index    = function(_,k) return hidden[k] end,
                 __newindex = function(_,k,v) hidden[k] = v end }
    setmetatable(peri, mt)
  end
  return peri
end
