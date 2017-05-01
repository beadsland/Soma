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

local Me = {}
package.loaded[...] = Me

-- Imports
local this = ...
local proj = string.match(this, '^[^\.]*')
local Soma = require(proj)
local util = require(proj .. ".util")

local T = {} -- map of type constructors

local MT = {}
setmetatable(Me, MT)

-- Close the door
_ENV = nil

--
-- Internal term method to cast a Lua value
-- to an Elixir-style Soma term.
--
function MT.__call(_self, value)
  local luatype = type(value)
  local status, result = pcall(function() T[luatype](value) end)
  if status then return result
  else error("cast failed for " .. luatype .. ": " .. result)
  end
end

--
-- Casting logic
--
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
  if v == math.huge     then return S.atom('inf') end
  if v == -math.huge    then return S.atom('-inf') end
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

  local mt = getmetatable(v)
  local status, result = pcall(function() type(mt.__call) end)
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
