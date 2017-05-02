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
-- Elixir-style type integer
--
-- @submodule soma
----------

local Me = {}
package.loaded[...] = Me

-- Imports
local this = ...
local proj = string.match(this, '^[^\.]*')
local Soma = require(proj)
local util = Soma.util

local create = util.peritable(Soma.term).create

local math = math
local bc = require("bc")  -- lbc - a self-contained big number library

local L = {}
local MT = {}
setmetatable(Me, MT)

-- Close the door
_ENV = nil

---
-- Cast a Lua (whole) number as a Soma integer.
--
-- __PORTABILITY__: Requires lbc big number library, which includes
-- C API components. Will need a pure Lua alternative for use on
-- Corona architecture.
--
-- @function Soma.integer
function MT.__call(self, v)
  if Soma.is_integer(v)     then return value end
  if Soma.is_somatype(v)    then return L.recast(v) end
  if type(v) ~= 'number'    then L.casterror(type(v)) end
  if util.isnan(v)          then L.casterror('floating point: NaN') end
  if v == math.huge or
     v == -math.huge        then L.casterror('floating point: infinity') end
  if v ~= math.floor(v)     then L.casterror('floating point') end

  local bignum = bc.number(v)

  local checks = { isnumber = true,
                   isinteger = true,
                   isa = 'integer' }
  local ops = { tostring = function() return bc.tostring(bignum) end,
                tonumber = function() return bc.tonumber(bignum) end }
  return create(bignum, checks, ops)
end

function L.recast(value)
  local number = tonumber(value)
  if not number then
    return L.casterror('not a number: ' .. tostring(value))
 else
    local status, result = pcall(function() Soma.integer(number) end)
    if status then return result
    else           error(result)
    end
  end
end

function L.casterror(str) error('not an integer: ' .. str) end
