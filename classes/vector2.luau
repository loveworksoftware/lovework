local Vector2 = {}

local Vector2Impl = {}
Vector2Impl.__index = Vector2Impl

function Vector2.new(x: number?, y: number?): Vector2
	return setmetatable({
		X = x or 0,
		Y = y or 0,
	}, Vector2Impl) :: any
end

Vector2.zero = Vector2.new(0, 0)
Vector2.one = Vector2.new(1, 1)

function Vector2Impl:__tostring(): string
	return string.format("Vector2(%g, %g)", self.X, self.Y)
end

function Vector2Impl:__eq(v: Vector2): boolean
	return self.X == v.X and self.Y == v.Y
end

function Vector2Impl:__add(v: Vector2): Vector2
	return Vector2.new(self.X + v.X, self.Y + v.Y)
end

function Vector2Impl:__sub(v: Vector2): Vector2
	return Vector2.new(self.X - v.X, self.Y - v.Y)
end

function Vector2Impl:__mul(v: number | Vector2): Vector2
	if type(v) == "number" then
		return Vector2.new(self.X * v, self.Y * v)
	else
		return Vector2.new(self.X * v.X, self.Y * v.Y)
	end
end

function Vector2Impl:__div(v: number | Vector2): Vector2
	if type(v) == "number" then
		return Vector2.new(self.X / v, self.Y / v)
	else
		return Vector2.new(self.X / v.X, self.Y / v.Y)
	end
end

function Vector2Impl:Magnitude(): number
	return math.sqrt(self.X * self.X + self.Y * self.Y)
end

function Vector2Impl:Unit(): Vector2
	local mag = self:Magnitude()
	if mag == 0 then
		return Vector2.zero
	end
	return self / mag
end

function Vector2Impl:Dot(v: Vector2): number
	return self.X * v.X + self.Y * v.Y
end

function Vector2Impl:Lerp(v: Vector2, alpha: number): Vector2
	return self + (v - self) * alpha
end

function Vector2Impl:Clone(): Vector2
	return Vector2.new(self.X, self.Y)
end

function Vector2Impl:ToTuple(): (number, number)
	return self.X, self.Y
end

export type Vector2 = {
	X: number,
	Y: number,

	Magnitude: (self: Vector2) -> number,
	Unit: (self: Vector2) -> Vector2,
	Dot: (self: Vector2, v: Vector2) -> number,
	Lerp: (self: Vector2, v: Vector2, alpha: number) -> Vector2,
	Clone: (self: Vector2) -> Vector2,
	ToTuple: (self: Vector2) -> (number, number),
}

return Vector2 :: {
	new: (x: number?, y: number?) -> Vector2,
	zero: Vector2,
	one: Vector2,
}
