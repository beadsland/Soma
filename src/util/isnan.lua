----------
-- Test if number evaluates as NaN.
--
-- Copyright © 2012 Ian Boyd, licensed under CC-BY-SA 3.0
--
-- See https://meta.stackexchange.com/questions/271080/the-mit-license-clarity-on-using-code-on-stack-overflow-and-stack-exchange
-- For license, see https://creativecommons.org/licenses/by-sa/3.0/
--
-- @submodule soma.util
----------

local M = {}
package.loaded[...] = M

-- Imports
local this = ...

-- Close the door
_ENV = nil

---
-- Given a Lua number, attempt to determine if it evaluates to the
-- mathematical value NaN.
--
-- Lua doesn't provide a math library function to test for NaN
-- (<em>i.e.</em>, Not a Number).  Further, it would seem that there
-- is more than one way for floating point representations to encode
-- NaN, not all of which are translated consistently into Lua.
--
-- This method, therefore, is a best effort. Results are not guaranteed.
--
-- See further discussion on
-- <a href="http://stackoverflow.com/questions/12102222/how-to-test-for-1-ind-indeterminate-in-lua]">
-- Stack Overflow</a>
-- @param x number
-- @return boolean
--
-- @warning local nanString = (tostring((-1) ^ 0.5)); --sqrt(-1) is also NaN.
-- Unfortunately,
--    tostring((-1)^0.5))       = "-1.#IND"
--    x = tostring((-1)^0.5))   = "0"
-- With this bug in LUA we can't use this optimization
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
