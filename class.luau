local Maid = require("@packages/maid")
local activeClasses = require("./data/activeClasses")
type Metatable = typeof(setmetatable({}, {}))
type Class = Metatable

export type Base = {
	maid: Maid.Maid,
	_destroy: () -> (),
}

local _Class = setmetatable({}, {
	__call = function(_, Name: string, Extends: Class?)
		local Meta = setmetatable({}, {
			__tostring = function()
				return Name
			end,
			__type = "LOVEWORKCLASS",
			__call = function(_, self, ...)
				self.maid = Maid.new()

				self._destroy = function()
					self.maid:DoCleaning()

					table.remove(activeClasses, table.find(activeClasses, self))

					setmetatable(self, nil)
				end

				if Extends and (Extends["new"] or Extends[tostring(Extends)]) then
					local Constructor = (Extends["new"] or Extends[tostring(Extends)])
					rawset(self, "__inherited", Constructor(...))
				end
			end,
			__index = function(self, Index)
				if rawget(self :: any, Index) ~= nil then
					return rawget(self, Index)
				elseif Extends and Extends[Index] ~= nil then
					return Extends[Index]
				else
					return nil
				end
			end,
		})
		Meta.__extends = Extends
		Meta.__index = function(self, Index)
			if rawget(Meta :: any, Index) ~= nil then
				return rawget(Meta, Index)
			elseif rawget(self, "__inherited") and (rawget(self, "__inherited") :: any)[Index] ~= nil then
				return (rawget(self, "__inherited") :: any)[Index]
			else
				return nil
			end
		end
		Meta.__newindex = function(self, Index, Value)
			if rawget(self, "__inherited") and (rawget(self, "__inherited") :: any)[Index] ~= nil then
				(rawget(self, "__inherited") :: any)[Index] = Value
			else
				rawset(self, Index, Value)
			end
		end

		return Meta
	end,
})

local Class: typeof(_Class) = _Class

function Class.init(c, ...)
	local mt = setmetatable({}, c)
	c(mt, ...)

	table.insert(activeClasses, mt)

	return mt
end

function Class.extendsFrom(ClassA: Class, ClassB: Class): boolean
	local MetatableA = getmetatable(ClassA)
	local IsSimpleExtend = MetatableA.__extends == ClassB or MetatableA == ClassB

	if IsSimpleExtend then
		return true
	end

	local CurrentClass = MetatableA.__extends
	repeat
		local Metatable = getmetatable(CurrentClass)

		if not Metatable then
			return false
		end

		if Metatable.__extends == nil then
			return false
		elseif Metatable.__extends == ClassB then
			return true
		end

		CurrentClass = Metatable
	until false
end

return Class
