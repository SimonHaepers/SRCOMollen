Level = require("level")

--- Laad en return de huidige level
-- Op dit moment laadt deze functie gewoon level 1
-- @return De huidige level
function laadLevel()
	return Level.new(1)	
end

function love.load()
	state = { }
	state.level = laadLevel()
	achtergrond = love.graphics.newImage("graphics/wolken.png")
	-- TODO
end

function love.update()
	-- TODO
end

function love.draw()
	state.level:draw()
	-- TODO
end
