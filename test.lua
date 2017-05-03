#!/usr/bin/env clua

print"testing..."

require "DataDumper"
function dump(data, name) print(DataDumper(data, name..' -> ')) end

package.path = './?/init.lua;' .. package.path
util = require "src/util"
S    = require "src"

function keys(tab, name)
  local keys = {}
  local n = 0
  for k,_ in pairs(tab) do n=n+1; keys[n]=k end
  dump(keys, 'keys in '..name)
end


--keys(S, 'Soma')

local T = S.integer(1) -- S.integer works, not S.term
local T2 = S.integer(2) -- S.integer works, not S.term
mt = getmetatable(T)
keys(mt, 'metatable')

--print(mt.__tonumber(T))


print('is_somatype? ' .. tostring(S.is_somatype(T2)))
print('isa? ' .. tostring(S.isa(T2)))
print('is_integer? ' .. tostring(S.is_integer(T2)))
print('tostring? ' .. tostring(T2))
print('tonumber? ' .. tonumber(T2))

print('is_somatype? ' .. tostring(S.is_somatype(T)))
print('isa? ' .. tostring(S.isa(T)))
print('is_integer? ' .. tostring(S.is_integer(T)))
print('tostring? ' .. S.tostring(T))
print('tonumber? ' .. S.tonumber(T))
--print('just print?' .. T)
--]]
