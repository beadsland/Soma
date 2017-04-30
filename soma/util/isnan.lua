----------
-- Test if number evaluates as NaN.
--
-- @submodule soma.util
-- @see http://stackoverflow.com/questions/12102222/how-to-test-for-1-ind-indeterminate-in-lua
--
-- Copyright © 2012 Ian Boyd, licensed under CC-BY-SA 3.0
-- @see https://meta.stackexchange.com/questions/271080/the-mit-license-clarity-on-using-code-on-stack-overflow-and-stack-exchange
-- @see https://creativecommons.org/licenses/by-sa/3.0/
----------

local M = {}
package.loaded[...] = M

-- Imports
local this = ...

-- Close the door
_ENV = nil

--local nanString = (tostring((-1) ^ 0.5)); --sqrt(-1) is also NaN.
--Unfortunately,
--  tostring((-1)^0.5))       = "-1.#IND"
--  x = tostring((-1)^0.5))   = "0"
--With this bug in LUA we can't use this optimization
function M.isnan(x)
  if (x ~= x) then
      --print(string.format("NaN: %s ~= %s", x, x));
      return true; --only NaNs will have the property of not being equal to themselves
  end;

  --but not all NaN's will have the property of not being equal to themselves

  --only a number can not be a number
  if type(x) ~= "number" then
     return false;
  end;

  --fails in cultures other than en-US, and sometimes fails in enUS depending on the compiler
--  if tostring(x) == "-1.#IND" then

  --Slower, but works around the three above bugs in LUA
  if tostring(x) == tostring((-1)^0.5) then
      --print("NaN: x = sqrt(-1)");
      return true;
  end;

  --i really can't help you anymore.
  --You're just going to have to live with the exception

  return false;
end
