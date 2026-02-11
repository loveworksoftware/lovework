local signal = require("@packages/signal")

-- internal state
local input = {
	down = {},
	pressed = {},
	released = {},

	_keyPressedSignals = {},
	_keyReleasedSignals = {},
}

local inputImpl = {}

function inputImpl.getKeyPressedEvent(keyName: string): signal.Signal<>
	local sig = input._keyPressedSignals[keyName]

	if not sig then
		sig = signal.new()
		input._keyPressedSignals[keyName] = sig
	end

	return sig
end

function inputImpl.getKeyReleasedEvent(keyName: string): signal.Signal<>
	local sig = input._keyReleasedSignals[keyName]

	if not sig then
		sig = signal.new()
		input._keyReleasedSignals[keyName] = sig
	end

	return sig
end

function inputImpl.beginFrame()
	input.pressed = {}
	input.released = {}
end

function inputImpl.keyPressed(key)
	input.down[key] = true
	input.pressed[key] = true

	local sig = input._keyPressedSignals[key]
	if sig then
		sig:Fire()
	end
end

function inputImpl.keyReleased(key)
	input.down[key] = nil
	input.released[key] = true

	local sig = input._keyReleasedSignals[key]
	if sig then
		sig:Fire()
	end
end

function inputImpl.isDown(key)
	return input.down[key] == true
end

function inputImpl.wasPressed(key)
	return input.pressed[key] == true
end

function inputImpl.wasReleased(key)
	return input.released[key] == true
end

return inputImpl
