--[[
	Copyright (C) 2018  Fuhrbolg - Hyjal

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>

	Author's note: Under no circumstances should this Addon be used under any situation.
	It is dangerous and will cause significant harm to your computer. You have been warned.
--]]

--[[
 -	Import variables from other MongoMon source files here.
--]]
local ADDON_NAME, T = ...

--[[
 -	Utility function used for sorting.
 -
 - 	An ordered sort. This is exceptionally handy and is used to order
 - 	the battleground participants by killing blows then defaults to 
 - 	lower number of deaths in the event of a tie. This particular
 - 	function is a generic sort. The man who wrote this must be jesus
 - 	because I have no idea what's going on. It just works. Praise Hillary.
 -
 - 	http://stackoverflow.com/questions/15706270/sort-a-table-in-lua
 -
 -	@param table t
 -	@param function order
 -	@return function(key, value)
--]]
local function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

--[[
 - 	Converts long numbers into an abreviated format, e.g. 46,387,123 into 46M
 - 	Hijacked from the internet.
 -
 -	@param number num
 -	@return string
--]]
local function prettyNumber(num)
	if num <= 9999 then
		return num
	elseif num >= 1000000000 then
		return format("%.1f bil", num/1000000000)
	elseif num >= 1000000 then
		return format("%.1f mil", num/1000000)
	elseif num >= 10000 then
		return format("%.1fk", num/1000)
	end
	return num
end

--[[
 -	Counts the number of elements in a table.
 -	table.getn doesn't work with key / values like a map apparently.
 -	
 -	@param table T
 -	@return integer
--]]
local function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

--[[
 -	http://lua-users.org/wiki/SimpleRound
 -
 -	@param integer num
 -	@param integer idp
 -	@return integer
--]]
local function round(num, idp)
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

--[[
 - 	Split text into a list consisting of the strings in text,
 - 	separated by strings matching delimiter (which may be a pattern). 
 - 	example: strsplit(",%s*", "Anna, Bob, Charlie,Dolores")
 -
 -
 -	@param string
 -	@param string
 -	@return table
--]]
local function strsplit(delimiter, text)
	local list = {}
	local pos = 1
	if strfind("", delimiter, 1) then -- this would result in endless loops
		error("delimiter matches empty string!")
	end
	while 1 do
		local first, last = strfind(text, delimiter, pos)
		if first then -- found?
			tinsert(list, strsub(text, pos, first-1))
			pos = last+1
		else
			tinsert(list, strsub(text, pos))
			break
		end
	end
	return list
end

--[[
-	Clones a table so we can work on it.
-
-	@param table
-	@param table (only needed for recursion)
-	@return table
--]]
local function clone(obj, seen)
	  if type(obj) ~= 'table' then return obj end
	  if seen and seen[obj] then return seen[obj] end
	  local s = seen or {}
	  local res = setmetatable({}, getmetatable(obj))
	  s[obj] = res
	  for k, v in pairs(obj) do res[clone(k, s)] = clone(v, s) end
	  return res
end

--[[
 -	Export variables that may be used by other MongoMon source files.
--]]
T["spairs"] = spairs
T["prettyNumber"] = prettyNumber
T["tablelength"] = tablelength
T["round"] = round
T["strsplit"] = strsplit
T["clone"] = clone