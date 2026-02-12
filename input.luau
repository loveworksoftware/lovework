local signal = require("@packages/signal")

export type MouseButton = "1" | "2" | "3" | "left" | "right" | "middle"

local function normalizeMouseButton(btn: MouseButton | number): string
	if btn == "1" or btn == "left" then
		return "1"
	elseif btn == "2" or btn == "right" then
		return "2"
	elseif btn == "3" or btn == "middle" then
		return "3"
	end
	return tostring(btn)
end

local input = {
	down = {},
	pressed = {},
	released = {},

	_keyPressedSignals = {},
	_keyReleasedSignals = {},

	_mousePressedSignals = {},
	_mouseReleasedSignals = {},
	_mouseScrollSignal = nil :: signal.Signal<number, number>?,
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

function inputImpl.getMouseButtonPressedEvent(mouseButton: MouseButton | number): signal.Signal<>
	local btn = normalizeMouseButton(mouseButton)
	local sig = input._mousePressedSignals[btn]

	if not sig then
		sig = signal.new()
		input._mousePressedSignals[btn] = sig
	end

	return sig
end

function inputImpl.getMouseButtonReleasedEvent(mouseButton: MouseButton | number): signal.Signal<>
	local btn = normalizeMouseButton(mouseButton)
	local sig = input._mouseReleasedSignals[btn]

	if not sig then
		sig = signal.new()
		input._mouseReleasedSignals[btn] = sig
	end

	return sig
end

function inputImpl.getMouseScrollEvent(): signal.Signal<number, number>
	if not input._mouseScrollSignal then
		input._mouseScrollSignal = signal.new()
	end

	return input._mouseScrollSignal
end

function inputImpl.beginFrame()
	input.pressed = {}
	input.released = {}
	input._mousePressedSignals = {}
	input._mouseReleasedSignals = {}
	input._mouseScrollSignal = nil
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

function inputImpl.mousePressed(button: number, x: number, y: number)
	local btn = normalizeMouseButton(button)
	input.down[btn] = true
	input.pressed[btn] = true

	local sig = input._mousePressedSignals[btn]
	if sig then
		sig:Fire(x, y)
	end
end

function inputImpl.mouseReleased(button: number, x: number, y: number)
	local btn = normalizeMouseButton(button)
	input.down[btn] = nil
	input.released[btn] = true

	local sig = input._mouseReleasedSignals[btn]
	if sig then
		sig:Fire(x, y)
	end
end

function inputImpl.mouseWheelMoved(x: number, y: number)
	if input._mouseScrollSignal then
		input._mouseScrollSignal:Fire(x, y)
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
