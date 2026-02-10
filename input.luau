local signal = require("@packages/signal")

local input = {
	down = {},
	pressed = {},
	released = {},

	_keyPressedSignals = {}, -- internal
}

function input.getKeyPressedEvent(keyName: string): signal.Signal<>
	local sig = input._keyPressedSignals[keyName]

	if not sig then
		sig = signal.new()
		input._keyPressedSignals[keyName] = sig
	end

	return sig
end

function input.beginFrame()
	input.pressed = {}
	input.released = {}
end

function input.keyPressed(key)
	input.down[key] = true
	input.pressed[key] = true

	local sig = input._keyPressedSignals[key]
	if sig then
		sig:Fire()
	end
end

function input.keyReleased(key)
	input.down[key] = nil
	input.released[key] = true
end

function input.isDown(key)
	return input.down[key] == true
end

function input.wasPressed(key)
	return input.pressed[key] == true
end

function input.wasReleased(key)
	return input.released[key] == true
end

return input
