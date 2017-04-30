----------
-- Utility methods for use within Soma.
--
-- @module soma.util
----------

local Me = {}
package.loaded[...] = Me

-- Imports
local this = ...

-- Define this here so we can use it, but also make it available to
-- other modules.
function Me.importmethods(Thou, prefix, mods)
  for _,name in ipairs(mods) do
    local sub = require(prefix .. '.' .. name)
    for f,v in pairs(sub) do
      Thou[f] = v
    end
  end
end

Me.importmethods(Me, this, { 'isnan' } )

-- Close the door
_ENV = nil

function Me.importmodules(Thou, prefix, mods)
  for _, name in ipairs(mods) do
    Thou[name] = require(prefix .. '.' .. name)
  end
end
