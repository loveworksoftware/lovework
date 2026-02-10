# Lovework 0.1.0
Easy-to-use Kaledis framework.

## Requirements:
- Kaledis (>=2.0.4)
- Pesde (>=0.7.1)

## Pesde packages:
```toml
maid = { name = "ewdev/maid", version = "^0.1.0" }
signal = { name = "ewdev/signal", version = "^0.1.0" }
```

## Adding lovework to your submodules
```zsh
git submodule add https://github.com/loveworksoftware/lovework.git submodules/lovework
```

## Updating your .luaurc
Add:
```json
"lovework": "submodules/lovework"
```
To your .luaurc aliases.

*Make sure you have a "packages" alias pointing to your pesde packages.*

## Project Structure
Lovework isn't too strict about this, but usually you'd want a structure like:

project/
├── src/
│   ├── main.luau
│   ├── utils
│   │   └── ...
│   ├── systems
│   │   └── ...
│   │   data
│   │   └── ...
│   │   config
│   │   └── ...
│   └── classes
│       └── ...
├── submodules/
│   └── lovework/
│       └── ...
└── assets/
    └── ...

# Examples

*main.luau*
```luau
local lovework = require("@lovework/lovework")

function love.load() end

function love.update(dt)
	-- This will run every frame
	lovework.core.update(dt)
end

function love.draw()
	-- This will run every time a new frame will be drawn
	lovework.core.draw()
end

```

## Classes

*class.luau*
```luau
local lovework = require("@lovework/lovework")

local myClass = lovework.class("myClass")

function myClass.new(myArg): myClass
    local self: myClass = lovework.class.init(myClass)

    self.myArg = myArg

    return self
end

-- Automatically called by lovework.core.draw
function myClass:Draw()
    --love.graphics.rectangle(...)
end

-- Automatically called by lovework.core.update
function myClass:Update(dt)
    print("dt", self.myArg)
    self.myArg += 1
end

function myClass:Destroy()
    self.maid:Destroy() -- automatically given to you by lovework.class
    self._destroy() -- automatically given to you by lovework.class
end

export type myClass = lovework.class.Base & {
    myArg: number,

    Update: (myClass, number) -> (),
    Draw: (myClass) -> (),

    Destroy: (myClass) -> ()
}

return myClass :: {new: (number) -> myClass}
```

*inherited.luau*
```luau
local lovework = require("@lovework/lovework")
local myClass = require("path/to/myClass")

local myOtherClass = lovework.class("myOtherClass", myClass) -- inherits from myClass

function myOtherClass.new(myNewArg): myClass
    local self: myOtherClass = lovework.class.init(myOtherClass, myNewArg + 3) -- myNewArg + 3 will be passed into myClass.new
    -- self.myArg is inherited from myClass
    self.myNewArg = myNewArg + self.myArg

    return self
end

-- Automatically called by lovework.core.draw
function myOtherClass:Draw()
    --love.graphics.rectangle(...)
end

-- Automatically called by lovework.core.update
-- overrides myClass:Update
function myOtherClass:Update(dt)
    print("dt", self.myArg, self.myNewArg)
    self.myNewArg += 1
end

function myOtherClass:Destroy()
    self.maid:Destroy() -- automatically given to you by lovework.class
    self._destroy() -- automatically given to you by lovework.class
end

export type myOtherClass = myClass & {
    myNewArg: number

    Update: (myOtherClass, number) -> (),
    Draw: (myOtherClass) -> (),

    Destroy: (myOtherClass) -> ()
}

return myOtherClass :: {new: (number) -> myOtherClass}
```

Using those classes:
```luau
local myOtherClass = require("path/to/myOtherClass")
local lovework = require("@lovework/lovework")

function love.load()
    local newClass = myOtherClass.new(1)
    print(newClass.myArg, newClass.myNewArg) -- 4, 1

    lovework.utils.timer.after(5, function()
        newClass:Destroy()
        print(newClass) -- nil
    end)
end
```

## Systems

*myUpdateSystem.luau*
```luau
return function(dt)
    print(dt, " from myUpdateSystem!")
end
```
then you'll add it (usually in main.luau) by doing:

```luau
local lovework = require("@lovework/lovework")

function love.load()
    lovework.systems.add("update", "myUpdateSystem", require("path/to/myUpdateSystem"))

    lovework.utils.timer.after(5, function() -- on 60 fps, myUpdateSystem will run 300 times and then stop.
        lovework.systems.remove("myUpdateSystem")
    end)
end
```

## Utils
Lovework has a couple of built-in utils, including:

### Timer
Timer library from [knife.timer](https://github.com/airstruck/knife/blob/master/knife/timer.lua)

```luau
local lovework = require("@lovework/lovework")

lovework.utils.timer.after(5, function() -- Similar to Roblox's task.delay
    print("Hello!")
end)
```

### Debug
Useful functions for debugging

```luau
local lovework = require("@lovework/lovework")

local myTable = {
    Hello1 = {
        "Hi"
    },
    Hello = "World!",
    prints = function(hi)
        print(hi)
    end
}

print(myTable) -- will print out the memory address for the table, not every useful...
lovework.utils.debug.dumpTable(myTable) -- prints out the entire table, showing its members, and even functions!
```

## Classes
Lovework's built-in classes.

### Vector2
Useful for positions, sizes, anything that needs an X and a Y value.

```luau
local lovework = require("@lovework/lovework")
local vector2 = lovework.vector2

print(vector2.new(1, 2)) -- output: Vector2(1, 2)
print(vector2.new(1, 1) * 2) -- output: Vector2(2, 2)
print(vector2.new(1, 1) * vector2.new(2, 2)) -- output: Vector2(2, 2)
```