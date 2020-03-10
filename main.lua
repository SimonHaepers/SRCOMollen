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
	-- TODO
end

function love.update()
	-- TODO
end

function love.draw()
	state.level:draw()
	
	-- NOTE: onderstaande is een test voor pixelSoort
	for x = 1,250 do
		for y = 1,550 do
			if state.level:pixelSoort(x,y) then
				love.graphics.rectangle("fill",x,y,1,1)
			else
				--love.graphics.rectangle("fill",x,y,1,1)
			end
		end
	end
end
