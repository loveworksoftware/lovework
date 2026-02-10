local vector2 = require("../classes/vector2")

local viewport = {}

function viewport.getViewportSize(): vector2.Vector2
	return vector2.new(love.graphics.getDimensions())
end

function viewport.getViewportCenter(): vector2.Vector2
	local viewportSize = viewport.getViewportSize()

	return viewportSize / 2
end

return viewport
