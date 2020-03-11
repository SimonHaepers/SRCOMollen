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

	-- NOTE: Onderstaande is gewoon een test op Level:pixelSoort
	for n=1,80 do
		for m=1,56 do
			local x = 16*n
			local y = 16*m
			if state.level:pixelSoort(x,y) then
				love.graphics.rectangle("fill",3*n,3*m+19*32,3,3)
			else 
			end
		end
	end
	love.graphics.setColor(1,1,1,1)
end
