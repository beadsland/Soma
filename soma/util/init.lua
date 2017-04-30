----------
-- Utility methods for use within Soma.
--
-- @module soma.util
----------

local M = {}
package.loaded[...] = M

-- Imports
local this = ...

for _,name in ipairs({ 'isnan' }) do
  local sub = require(this .. '.' .. name)
  for f,v in pairs(sub) do
    M[f] = v
  end
end

-- Close the door
_ENV = nil
