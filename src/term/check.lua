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
-- Soma methods to check types of Soma terms.
--
-- @submodule soma
----------

local Me = {}
package.loaded[...] = Me

-- Imports
local this = ...
local proj = string.match(this, '^[^\.]*')
local Soma = require(proj)
local util = require(proj .. ".util")

local L = {} -- local functions and variables

-- Close the door
_ENV = nil

---
-- Test if a given Lua value/table is a Soma term.
--
-- @function is_somatype
-- @param value Any Lua value or table.
-- @return boolean
function Me.is_somatype(value)
  local soma_mt = L.check_somatype(value)
  if not soma_mt then return false else return true end
end

function L.check_somatype(value)
  if type(value) ~= 'table' then return nil end
  local mt = getmetatable(value)
  if type(mt) ~= 'table' then    return nil end
  if mt.__issomatype then        return mt
  else                           return nil end
end

---
-- Return the Soma type of a given Lua value/table, if any.
--
-- @function isa
-- @param value Any Lua value or table.
-- @return A string representation of the Soma type, or else `nil`.
function Me.isa(value)
  local soma_mt = L.check_somatype(value)
  if not soma_mt then return false
  else                return soma_mt['__isa']
  end
end

---
-- Test if a given Lua value/table is a Soma boolean.
--
-- Soma has no discrete boolean type. Instead, the atoms `:true` and
-- `:false` are treated as boolean values. This method returns the
-- Lua boolean value `true` for either atom, `false` otherwise.
--
-- @function is_boolean(value)
-- @param value Any Lua value or table.
-- @return boolean
function Me.is_boolean(value)
  if not L.check_somatype(value) then    return false
  else
    if Soma.atom(':true') == value then  return true end
    if Soma.atom(':false') == value then return true end
                                         return false
  end
end

--
-- Autogenerate check methods based on ldoc @function tags.
--
local __DATA__ -- special token for selfloader

function L.parse_ldocdata()
  local f = util.DATA_fh()
  local pattern = "^-- +@function "
  for line in f:lines() do
    if string.match(line, pattern) then
      local func = string.gsub(line, pattern, ""):match("^%s*(.-)%s*$")
      L.autogenerate(func)
    end
  end
  f:close()
end

function L.autogenerate(func)
  if func:match("^is_") then
    local type = func:match("^is_(.*)$")
    Me[func] = function(value) return L.is(type, value) end
  else
    error("failed to autogenerate: unknown function: ".. func)
  end
end

L.parse_ldocdata() -- Create an is_* check for each ldoc declaration.

--
-- Logic for all check funcitons
--
function L.is(type, value)
  local soma_mt = L.check_somatype(value)
  if not soma_mt then
    return false
  else
    if soma_mt['__is' .. type] then return true else return false end
  end
end

__DATA__ = true
---
-- @function is_integer
-- @param value Any Lua value or table.

---
-- @function is_float
-- @param value Any Lua value or table.

---
-- @function is_number
-- @param value Any Lua value or table.

---
-- @function is_atom
-- @param value Any Lua value or table.

---
-- @function is_string
-- @param value Any Lua value or table.

---
-- @function is_list
-- @param value Any Lua value or table.

---
-- @function is_tuple
-- @param value Any Lua value or table.

---
-- @function is_map
-- @param value Any Lua value or table.
