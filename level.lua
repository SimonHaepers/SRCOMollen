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
		local counter = set.firstgid
		if set.image then	-- tileset op basis van 1 afbeelding
			local afbeelding = love.graphics.newImage(string.sub(set.image,4,-1))
			for rij = 1, set.tilecount / set.columns do
				for kolom = 1,set.columns do
					tiles[counter] = { afbeelding=afbeelding, quad = love.graphics.newQuad((kolom-1)*set.tilewidth,(rij-1)*set.tileheight,set.tilewidth,set.tileheight,set.imagewidth,set.imageheight) }
					counter = counter + 1  
				end
			end
		else -- tileset op basis van meerdere afbeeldingen
			for objectnr = 1, set.tilecount do
				local tile = set.tiles[objectnr]
				local afbeelding = love.graphics.newImage(string.sub(tile.image,4,-1))
				tiles[counter] = { afbeelding=afbeelding, width=tile.width, height=tile.height }
				debugPrint("Voeg object toe op counter "..counter.." ("..string.sub(tile.image,4,-1)..")")
				counter = counter + 1
			end
		end
	end
	return tiles
end

local function laadObjecten(map,layer)
	local objecten = { }
	for n,object in ipairs(layer.objects) do
		objecten[n] = {x=object.x,y=object.y,id=object.gid}	-- NOTE: geen idee waarom die -1 er moet staan...
	end
	return objecten
end

--- Laad de map met tiles uit een Tiled map
-- @param map De map waaruit de informatie gehaald wordt.
local function laadTilemap(map,layer)
	local tilemap = { }
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
	-- Tiles en objecten inlezen
	level.tiles = laadTileset(map)

	-- Achtergrondlaag
	local achtergrond = map.layers[1]
	assert(achtergrond.name == "Achtergrond")
	level.achtergrond = love.graphics.newImage(string.sub(achtergrond.image,4,-1))

	-- Achtergrondobjecten
	local achtergrondobjecten = map.layers[2]
	assert(achtergrondobjecten.name == "AchtergrondObjecten")
	level.achtergrondobjecten = laadObjecten(map,achtergrondobjecten)
	
	-- Gamelaag
	level.game = map.layers[3]
	assert(level.game.name == "Game")
	level.gametiles = laadTilemap(map,level.game)

	-- Voorgrondobjecten
	local voorgrondobjecten = map.layers[4]
	assert(voorgrondobjecten.name == "VoorgrondObjecten")
	level.voorgrondobjecten = laadObjecten(map,voorgrondobjecten)
	
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
	level.map = require("levels/level"..levelnr.."map")
	laadTiledMap(level,level.map)
	
	setmetatable(level,Level)
	return level
end

function Level:draw()
	love.graphics.draw(self.achtergrond)
	for _,o in ipairs(self.achtergrondobjecten) do
		love.graphics.draw(self.tiles[o.id].afbeelding,o.x,o.y-self.tiles[o.id].height)
	end
	for _,t in ipairs(self.gametiles) do
		love.graphics.draw(self.tiles[t.id].afbeelding,self.tiles[t.id].quad,t.x,t.y)	
	end
	for _,o in ipairs(self.voorgrondobjecten) do
		love.graphics.draw(self.tiles[o.id].afbeelding,o.x,o.y-self.tiles[o.id].height)
	end
end

function Level:pixelSoort(x,y)
	-- Vraag de corresponderende tile op
	local tilekolom = math.ceil(x / self.map.tilewidth)
	local tilerij = math.ceil(y / self.map.tileheight)
	local tile = self.game.data[(tilerij-1)*self.map.width+tilekolom]
	
	-- Kijk de goede pixel in die tile na
	-- TODO
	
	-- NOTE: voorlopige versie
	if tile and tile > 0 then
		return 1
	else
		return false
	end
end

return Level
