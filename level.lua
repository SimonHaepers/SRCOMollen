--
-- LEVEL.LUA
-- Dit bestand is onderdeel van SRCOMollen
-- (c) Sint-Romboutscollege Mechelen
--

require("common")

--- Klasse Level
local Level = { }
Level.__index = Level

--- Basisconfiguratie voor levels
-- Kan overschreven worden door een levels/level<nr>conf.lua bestand
local basisConfiguratie = {
	aantalMollen = 10,
	aantalRedden = 5
}

--- Laad informatie uit een Tiled map naar een level
-- @param level
-- @param map
local function laadTiledMap(level,map)
	-- Achtergrondlaag
	local achtergrond = map.layers[1]
	assert(achtergrond.name == "Achtergrond")
	level.achtergrond = love.graphics.newImage(string.sub(achtergrond.image,4,-1))

	-- TODO Andere lagen
end

function Level.new(levelnr)
	local level = { }

	-- Kopieer de basisconfiguratie
	for eigenschap, waarde in pairs(basisConfiguratie) do
		level[eigenschap] = waarde
	end

	-- Lees specifieke configuratie 
	local specifiekeConfiguratie = require("levels/level"..levelnr.."conf")
	for eigenschap, waarde in pairs(specifiekeConfiguratie) do
		assert(level[eigenschap])
		level[eigenschap] = waarde
		debugPrint("Overschrijf eigenschap "..eigenschap.." met waarde "..waarde.." in level "..levelnr..".")
	end

	-- Lees tiled bestand
	local map = require("levels/level"..levelnr.."map")
	laadTiledMap(level,map)
	
	setmetatable(level,Level)
	return level
end

function Level:draw()
	love.graphics.draw(self.achtergrond)
end

return Level
