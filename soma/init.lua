----------
-- Lua emulation of Elixir semantics.
--
-- @module soma
-- @author Beads Land-Trujillo
-- @copyright 2017
-- @license Apache 2.0
-- @release 0.0.0
----------

local S = {}
package.loaded[...] = S

-- Imports
local this = ...
S.term = require(this..'.term')

-- Close the door
_ENV = nil
