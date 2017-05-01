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

local math = math
local bc = require("bc")  -- lbc - a self-contained big number library

local L = {}
local MT = {}
setmetatable(Me, MT)

-- Close the door
_ENV = nil

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
  local mt     = L.protocol(bignum, checks)
  local self   = {}
  setmetatable(self, mt)
  return self
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
