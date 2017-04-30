----------
-- Implementation of immutable Elixir-style terms.
--
-- @submodule soma
----------

local M = {}
package.loaded[...] = M

-- Imports
local this = ...
local proj = string.match(this, '^[^\.]*') -- i.e., "soma"
local S =    require(proj)
local util = require(proj .. "util")

local math = math

local T = {} -- map of type constructors
local L = {} -- local functions and variables

-- Close the door
_ENV = nil

---
-- Given a Lua value, cast as an immutable Soma term.
--
-- @warning Top-down cast logic only. Underlying target types have
-- yet to be implemented.
function S.cast(value) return T[type(value)] end


T['nil'] =      function(_) return S.atom('undef') end
T['function'] = function(v) return S['function'](v) end

function T.thread(v)   return S.pid(v) end
function T.userdata(_) return error("userdata: no type to cast") end

function T.boolean(v)
  if v == true  then return S.atom('true') end
  if v == false then return S.atom('false') end
                     error('not a boolean: ' .. v)
end

function T.number(v)
  -- TODO refactor these guards to S.float for type safety
  if v == math.huge()   then return S.atom('inf') end
  if v == -math.huge()  then return S.atom('-inf') end
  if util.isnan(v)      then return S.atom('nan') end
  if v == math.floor(v) then return S.integer(v) end
                             return S.float(value)
end

function T.string(v)
  -- TODO refactor these guards to S.string for type safety
  local f = string.byte(v)
  local f2 = string.byte(v,2)
  local l = string.byte(v,-1)
  if f == ':'                            then return S.atom(v) end
  if f == "'" and f2 == ':' and l == "'" then return S.atom(v) end

  return S.string(v)
end

function T.table(v)
  -- TODO mirror these guards in S.map and S.list as appropriate

  local mt = get_metatable(v)
  local status, result = pcall(type(mt.__call))
  if status and result == 'function' then return S['function'](v) end

  local count
  for k,_ in pairs (v) do
    if not S.is_integer(S.term(k))   then return S.map(v) end
    count = count + 1
  end

  if count == 0 then error('table: empty has no implicit type') end

  -- Finally, if none of the other conditions are met...
                                          return S.list(v)
end
