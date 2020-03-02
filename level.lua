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

--- Laad tileset informatie uit een Tiled map
-- @param map De map waaruit de informatie gehaald wordt.
-- @return Een tabel die tile-id's linkt aan afbeeldingen.
local function laadTileset(map)
	local tiles = { }
	for _,set in ipairs(map.tilesets) do
		local afbeelding = love.graphics.newImage(string.sub(set.image,4,-1))
		local counter = set.firstgid
		for rij = 1, set.tilecount / set.columns do
			for kolom = 1,set.columns do
				tiles[counter] = { afbeelding=afbeelding, quad = love.graphics.newQuad((kolom-1)*set.tilewidth,(rij-1)*set.tileheight,set.tilewidth,set.tileheight,set.imagewidth,set.imageheight) }
				counter = counter + 1  
			end
		end
	end
	return tiles
end

--- Laad de map met tiles uit een Tiled map
-- @param map De map waaruit de informatie gehaald wordt.
local function laadTilemap(map)
	local tilemap = { }
	local layer = map.layers[3]
	assert(layer.name == "Game")
	for rij = 1,layer.height do
		for kolom = 1,layer.width do
			local id = layer.data[(rij-1)*layer.width+kolom]
			if id ~= 0 then
				local x = (kolom-1)*map.tilewidth
				local y = (rij-1)*map.tileheight
				table.insert(tilemap,{x=x,y=y,id=id})
			end
		end
	end
	return tilemap
end

--- Laad informatie uit een Tiled map naar een level
-- @param level De level waarnaar geladen wordt
-- @param map De map die geladen wordt
-- @return nil
local function laadTiledMap(level,map)
	-- Achtergrondlaag
	local achtergrond = map.layers[1]
	assert(achtergrond.name == "Achtergrond")
	level.achtergrond = love.graphics.newImage(string.sub(achtergrond.image,4,-1))

	-- TODO Achtergrondobjecten
	
	-- Gamelaag
	local game = map.layers[3]
	assert(game.name == "Game")
	level.tiles = laadTileset(map)
	level.gametiles = laadTilemap(map)

	-- TODO Voorgrondobjecten
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
	for _,t in ipairs(self.gametiles) do
		love.graphics.draw(self.tiles[t.id].afbeelding,self.tiles[t.id].quad,t.x,t.y)	
	end
end

return Level
