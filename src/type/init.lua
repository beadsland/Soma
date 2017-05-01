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
