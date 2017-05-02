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
-- Soma methods to convert Soma terms to Lua values (or tables).
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

--
-- Parse ldoc lines of a file, passsing each to autogeneration function.
--
function Me.parse_ldocdata(f, auto)
  local pattern = "^-- +@function "
  for line in f:lines() do
    if string.match(line, pattern) then
      local func = string.gsub(line, pattern, ""):match("^%s*(.-)%s*$")
      auto(func)
    end
  end
end

--
-- Test is a value is a Soma term, returning its metatable if true.
--
function Me.check_somatype(value)
  if type(value) ~= 'table' then return nil end
  local mt = getmetatable(value)
  if type(mt) ~= 'table' then    return nil end
  if mt.__issomatype then        return mt
  else                           return nil end
end
