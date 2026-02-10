local activeClasses = require("../data/activeClasses")

local debug = {}

function debug.dumpTable(t, indent, seen)
	indent = indent or 0
	seen = seen or {}

	-- critical guard
	if type(t) ~= "table" then
		print(string.rep("  ", indent) .. tostring(t) .. " (" .. type(t) .. ")")
		return
	end

	if seen[t] then
		print(string.rep("  ", indent) .. "*circular*")
		return
	end
	seen[t] = true

	local spacing = string.rep("  ", indent)

	-- direct fields
	for k, v in pairs(t) do
		if type(v) == "table" then
			print(spacing .. tostring(k) .. " (table):")
			debug.dumpTable(v, indent + 1, seen)
		else
			print(spacing .. tostring(k) .. " (" .. type(v) .. ")")
		end
	end

	-- metatable / methods
	local mt = getmetatable(t)
	if mt and type(mt.__index) == "table" then
		print(spacing .. "__index (methods):")
		for k, v in pairs(mt.__index) do
			print(spacing .. "  " .. tostring(k) .. " (" .. type(v) .. ")")
		end
	end
end

function debug.getActiveClasses(v: any)
	return activeClasses
end

return debug
