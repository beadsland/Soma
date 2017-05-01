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
-- Lua emulation of Elixir semantics.
--
-- @module soma
-- @author Beads Land-Trujillo
-- @copyright 2017
-- @license Apache 2.0
-- @release 0.0.1
----------

local Soma = {}
package.loaded[...] = Soma

-- Imports
local this = ...
Soma.util = require(this .. '.util')

Soma.util.importmodules(Soma, this, { 'term', 'type' })
Soma.util.importmethods(Soma, this, { 'term', 'type' })

-- Close the door
_ENV = nil
