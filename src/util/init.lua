-- Copyright © 2017 Beads Land-Trujillo
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--    http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing,
-- software distributed under the License is distributed on an
-- "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
-- either express or implied. See the License for the specific
-- language governing permissions and limitations under the License.

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
  for _, name in ipairs(subs) do
    parent[name] = require(prefix .. '.' .. name)
  end
end

---
-- Access fields associated with, but not members of a base table.
--
-- A peritable provides for quasi-protected scope without polluting
-- either its base table proper or that base table's metatable. The
-- keys of a peritable are not exposed for inspection, thus only
-- those keys known to the caller are accessible.
--
-- On the other hand, a peritable makes explicit that its members are
-- hidden, unlike the spooky action-at-a-distance of assigning an
-- <code>__index</code> method to a table's metatable, nor the brute
-- obfuscation of stashing items in that metatable.
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

---
-- File handle for the pseudo-__FILE__ section of a module or script.
--
-- A sometimes useful Perlism.
--
-- Usage:
--    local __FILE__
--    local fh = Soma.util.FILE_fh()
--
--      * statements and comments as usual here *
--
--    __FILE__ = true
--
--      * lines to be read here *
--
-- @function DATA_fh
-- @return A file handle representing the __FILE__ section of the
-- module that invokes it.
function Me.DATA_fh()
  local __file__ = string.sub(debug.getinfo(2).source, 2)
  local fh = assert(io.open(__file__, "r"))
  for line in fh:lines() do
    if string.match(line, "^__DATA__") then break end
  end
  return fh
end
