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
-- Implementation of immutable Elixir-style terms.
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

local math = math

local T = {} -- map of type constructors
local L = {} -- local functions and variables
local MT = {}
setmetatable(Me, MT)

-- Close the door
_ENV = nil

---
-- Given a Lua value, cast as an immutable Soma term.
--
-- <strong>STATUS</strong>: Top-down cast logic only.
-- Underlying target types have yet to be implemented.
--
-- We do our best to render any Lua data type thrown at us as the
-- nearest Elixir-style equivalent, as follows:
--
-- <table border="1">
-- <tr><th>Lau data</th><th>Soma term</th></tr>
-- <tr><td><code>nil</code></td>
-- <td><code>atom('<em>:undef</em>')</code></td></tr>
-- <tr><td><code>boolean</code>, <em>true</em></td>
-- <td><code>atom('<em>:true</em>')</code></td></tr>
-- <tr><td><code>boolean</code>, <em>false</em></td>
-- <td><code>atom('<em>:false</em>')</code></td></tr>
-- <tr><td><code>number</code>, <em>NaN</em></td>
-- <td><code>atom('<em>:nan</em>')</code></td></tr>
-- <tr><td><code>number</code>, <em>infinity</em></td>
-- <td><code>atom('<em>:inf</em>')</code></td></tr>
-- <tr><td><code>number</code>, <em>negative infinity</em></td>
-- <td><code>atom('<em>:-inf</em>')</code></td></tr>
-- <tr><td><code>number</code>, sans<em> mantissa</em></td>
-- <td><code>integer</code></td></tr>
-- <tr><td><code>number</code>, <em>otherwise</em></td>
-- <td><code>float</code></td></tr>
-- <tr><td><code>string</code>, <em>matching <code>/^:/</code></em></td>
-- <td><code>atom</code></td></tr>
-- <tr><td><code>string</code>, <em>matching <code>/^':.*'$/</code></em></td>
-- <td><code>atom</code></td></tr>
-- <tr><td><code>string</code>, <em>otherwise</em></td>
-- <td><code>string</code></td></tr>
-- <tr><td><code>userdata</code></td>
-- <td><em>error</em></td></tr>
-- <tr><td><code>function</code></td>
-- <td><code>function</code></td></tr>
-- <tr><td><code>thread</code></td>
-- <td><code>pid</code> (if known to scheduler, otherwise <em>error</em>)</td></tr>
-- <tr><td><code>table</code>, <em>is a Soma <code>term</code></em></td>
-- <td>the same <code>term</code></td></tr>
-- <tr><td><code>table</code>, <em>has <code>__call</code> metamethod</em></td>
-- <td><code>function</code></td></tr>
-- <tr><td><code>table</code>, <em>an array</em></td>
-- <td><code>list</code></td></tr>
-- <tr><td><code>table</code>, <em>empty</em></td>
-- <td><em>error</em></td></tr>
-- <tr><td><code>table</code>, <em>otherwise</em></td>
-- <td><code>map</code></td></tr>
-- </table>
--
-- Various exceptional type values afforded by Lua reduce to
-- <code>atom</code>s in Soma. Detection of <code>NaN</code> is best
-- effort and is not guaranteed to generate <code>:atom</code> in all
-- cases that Elixir would. [At some point, will need to look at how
-- the Erlang VM handles this under the hood.]
--
-- The <code>userdata</code> type is a beast peculiar to Lua's C API;
-- we don't even try to cast it.
-- Meanwhile, only those coroutine <code>thread</code>s spawned within
-- the Soma scheduler architecture will cast to an associated
-- <code>PID</code>. (Mixing and matching roll-your-own coroutines
-- with the Soma scheduler is not recommended.)
--
-- Arrays and other non-empty <code>table</code>s readily translate to
-- Soma <code>list</code>s and <code>map</code>s, with the
-- <code>__call</code> metamethod presenting a
-- special case. That said, no provision is made within Soma for
-- the casting, as terms, of those Lua <code>table</code>s with more
-- intensive behind-the-curtain jiggery-pokery.
-- (But then, if your problem domain leans heavily on the semantics
-- of Lua's highly extensible tables, it probably isn't something
-- you're want to be doing in Soma anyway.)
--
-- The one core Elixir-style type not represented here,
-- <code>tuple</code>s, is not readily cast from any Lua data type.
-- We'll rely directly on its constructor method rather than casting
-- it indirectly from Lua values.
--
-- @function term
-- @param value Any Lua value, excluding userdata and empty tables.
-- @return A table representing and immutable Soma term.
-- @raise Errors on attempting to cast either userdata or empty table.
-- Currently, type modules are not implemented, so will error out even
-- for valid types.
function MT.__call(self, value)
  if Soma.is_somatype(value) then return value
  else                            return L.luacast(value) end
end

function L.luacast(value)
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


--
-- protocol
--
util.peritable(Me).protocol = function(internal, checks)
  error('protocol not implemented yet')
end

---
-- Test if a given Lua value is a Soma term.
--
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

function Me.is_integer(value)
  local soma_mt = L.check_somatype(value)
  if not soma_mt then return false else return soma_mt.__isinteger end
end
