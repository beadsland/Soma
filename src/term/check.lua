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
-- Test if a given Lua value is a Soma term.
--
-- @function is_somatype
-- @param value Any Lua value.
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
-- Test if a given Lua value is a Soma integer.
--
-- @function is_integer
-- @param value Any Lua value.
-- @return boolean
function Me.is_integer(value) return L.is(integer, value) end

function L.is(type, value)
  local soma_mt = L.check_somatype(value)
  if not soma_mt then
    return false
  else
    return soma_mt['__is' .. type]
  end
end
