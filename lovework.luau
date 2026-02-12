local class = require("./class")
local activeClasses = require("./data/activeClasses")
local vector2 = require("./classes/vector2")
local input = require("./input")
local anim8 = require("./libraries/anim8")

local lovework = {
	core = {},

	systems = {
		_systems = {},
	},

	class = class,
	input = input,
	animation = anim8,

	utils = {
		timer = require("./utils/timer"),
		debug = require("./utils/debug"),
		viewport = require("./utils/viewport"),
	},

	vector2 = vector2,

	version = "0.1.3",
}

function lovework.systems.add(whenToCall: "draw" | "update", name: string, system: (dt: number?) -> ())
	if lovework.systems._systems[name] then
		error("system already exists!")
	end
	lovework.systems._systems[name] = {
		run = system,
		type = whenToCall,
	}
end

function lovework.systems.remove(name: string)
	if not lovework.systems._systems[name] then
		error("system doesn't exist! no system to remove!")
	end
	lovework.systems._systems[name] = nil
end

function lovework.core.update(dt: number)
	lovework.utils.timer.update(dt)
	input.beginFrame()

	for i, v in activeClasses do
		if v.Update then
			v:Update(dt)
		end
	end

	for i, v in lovework.systems._systems do
		if v.type == "update" then
			v.run(dt)
		end
	end
end

function lovework.core.draw()
	for i, v in activeClasses do
		if v.Draw then
			v:Draw()
		end
	end

	for i, v in lovework.systems._systems do
		if v.type == "draw" then
			v.run()
		end
	end
end

export type vector2 = vector2.Vector2
export type baseClass = class.Base
export type anim8 = anim8.Anim8
export type grid = anim8.Grid
export type animation = anim8.Animation

return lovework
