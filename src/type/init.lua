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
-- Elixir-style immutable types.
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

util.importmodules(Me, this, { 'integer' } )

-- Close the door
_ENV = nil
