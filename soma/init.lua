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
Soma.util = require(this..'.util')

Soma.util.importmodules(Soma, this, { 'term' } )

-- Close the door
_ENV = nil
