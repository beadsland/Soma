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

local subproj = string.match(this, "(.-)[^%.]+$")
local common  = require(subproj .. ".common")

local L = {} -- local functions and variables

-- Close the door
_ENV = nil

--
-- Autogenerate check methods based on ldoc @function tags.
--
local __DATA__ -- special token for selfloader

function L.autogenerate(func)
  local coerce = '__' .. func
  Me[func] = function(term) return L.to(coerce, term) end
end

local fh = util.DATA_fh()
common.parse_ldocdata(fh, L.autogenerate) -- Create isa and the to* coercion methods
fh:close()

--
-- Logic for all coerce funcitons
--
function L.to(func, term)
  local soma_mt = common.check_somatype(term)
  if not soma_mt then return nil
  else                return soma_mt[func]()
  end
end

__DATA__ = true

---
-- @function tostring
-- @param term A Soma term.
-- @return String representation of term, or `nil` if not a Soma term.

---
-- @function tonumber
-- @param term A Soma term.
-- @return Numerical coercion of term, or `nil` if not a Soma term.
