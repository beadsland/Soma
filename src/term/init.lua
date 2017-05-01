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

util.importmethods(Me, this, { 'check' })
local luacast = require(this .. ".cast")

local math = math

local L = {} -- local functions and variables
local MT = {}
setmetatable(Me, MT)

-- Close the door
_ENV = nil

---
-- Given a Lua value or table, cast as an immutable Soma term.
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
function MT.__call(_self, value)
  if Soma.is_somatype(value) then return value
  else                            return luacast(value) end
end

--
-- protocol
--
util.peritable(Me).protocol = function(internal, checks)
  error('protocol not implemented yet')
end
