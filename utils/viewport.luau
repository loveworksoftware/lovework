local lovework = require("@lovework/lovework")
local vector2 = lovework.vector2

local viewport = {}

function viewport.getViewportSize(): lovework.vector2
	return vector2.new(love.graphics.getDimensions())
end

function viewport.getViewportCenter(): lovework.vector2
	local viewportSize = viewport.getViewportSize()

	return viewportSize / 2
end

return viewport
