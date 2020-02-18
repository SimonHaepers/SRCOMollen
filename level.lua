--
-- LEVEL.LUA
-- Dit bestand is onderdeel van SRCOMollen
-- (c) Sint-Romboutscollege Mechelen
--

local Level = { }

local basisConfiguratie = {
	aantalMollen = 10,
	redPercentage = 50
}

local function Level.new(levelnr)
	local level = { }
	-- Kopieer de basisconfiguratie
	for eigenschap, waarde in pairs(basisConfiguratie) do
		level[eigenschap] = waarde
	end
	-- Lees specifieke configuratie 
	local specifiekeConfiguratie = require("levels/level"..levelnr.."conf")
	for eigenschap, waarde in pairs(specifiekeConfiguratie) do
		level[eigenschap] = waarde
	end
	-- Lees tiled bestand
	-- TODO
	return level
end

return Level
