require 'waterlua'

local t = {}

local function createEncoding()
	--format 11
	local function maskFunc_11(root, mode)
		root:add('startToken', 'id')

		root:add('formatVersion', 'int')

		wc3binaryFile.checkFormatVer('envMaskFunc', 11, root:getVal('formatVersion'))

		root:add('mainTileset', 'char')
		root:add('customTilesetsFlag', 'int')

		root:add('groundTilesetsUsed', 'int')
		for i = 1, root:getVal('groundTilesetsUsed'), 1 do
			root:add('groundTileset'..i..'id', 'id')
		end

		root:add('cliffTilesetsUsed', 'int')
		for i = 1, root:getVal('cliffTilesetsUsed'), 1 do
			root:add('cliffTileset'..i..'id', 'id')
		end

		root:add('width', 'int')
		root:add('height', 'int')
		root:add('centerX', 'float')
		root:add('centerY', 'float')

		flagsTable = {'tex', 'tex', 'tex', 'tex', 'ramp', 'blight', 'water', 'boundary2'}
		cliffFlagsTable = {'layer', 'layer', 'layer', 'layer', 'cliffTex', 'cliffTex', 'cliffTex', 'cliffTex'}
		waterLevelFlagsTable = {[15] = 'boundary'}

		local tilesCount = root:getVal('height') * root:getVal('width')

		local loadDisplay

		if (mode == 'reading') then
			loadDisplay = createLoadPercDisplay(tilesCount, 'reading tiles...')
		else
			loadDisplay = createLoadPercDisplay(tilesCount, 'writing tiles...')
		end

		local format = string.format

		local function createTile(index)
			local tile = root:addNode(format('%i', index))

			tile:add('groundHeight', 'short')
			--tile:add('waterLevel', 'short', waterLevelFlagsTable)
			tile:add('waterLevel', 'short')
			--tile:add('flags', 'byte', flagsTable)
			tile:add('flags', 'byte')
			tile:add('textureDetails', 'byte')
			--tile:add('cliff', 'byte', cliffFlagsTable)
			tile:add('cliff', 'byte')

			loadDisplay:inc()
		end

		for i = 1, tilesCount, 1 do
			createTile(i)
		end
	end

	--format 11
	local function maskFuncEx_11(root, mode, stream)
		root:add('startToken', 'id')

		root:add('formatVersion', 'int')

		wc3binaryFile.checkFormatVer('envMaskFunc', 11, root:getVal('formatVersion'))

		root:add('mainTileset', 'char')
		root:add('customTilesetsFlag', 'int')

		root:add('groundTilesetsUsed', 'int')
		for i = 1, root:getVal('groundTilesetsUsed'), 1 do
			root:add('groundTileset'..i..'id', 'id')
		end

		root:add('cliffTilesetsUsed', 'int')
		for i = 1, root:getVal('cliffTilesetsUsed'), 1 do
			root:add('cliffTileset'..i..'id', 'id')
		end

		root:add('width', 'int')
		root:add('height', 'int')
		if (mode == 'writing') then
			root:setVal('minX', root:getVal('centerX') - (root:getVal('width') - 1) / 2 * 128)
			root:setVal('minY', root:getVal('centerY') - (root:getVal('height') - 1) / 2 * 128)
		end
		root:add('minX', 'float')
		root:add('minY', 'float')
		if (mode == 'reading') then
			root:setVal('centerX', root:getVal('centerX') + (root:getVal('width') - 1) / 2 * 128)
			root:setVal('centerY', root:getVal('centerY') + (root:getVal('height') - 1) / 2 * 128)
		end

		flagsTable = {'tex', 'tex', 'tex', 'tex', 'ramp', 'blight', 'water', 'boundary2'}
		cliffFlagsTable = {'layer', 'layer', 'layer', 'layer', 'cliffTex', 'cliffTex', 'cliffTex', 'cliffTex'}
		waterLevelFlagsTable = {[15] = 'boundary'}

		local tilesCount = root:getVal('height') * root:getVal('width')

		local loadDisplay

		if (mode == 'reading') then
			loadDisplay = createLoadPercDisplay(tilesCount, 'reading tiles...')
		else
			loadDisplay = createLoadPercDisplay(tilesCount, 'writing tiles...')
		end

		local c = 1

		root.tiles = {}

		local function createTile(index)
			local tile = {}

			root.tiles[c] = tile

			tile.groundHeight = stream:read('short')
			tile.waterLevel = stream:read('short')
			tile.flags = stream:read('byte')
			tile.textureDetails = stream:read('byte')
			tile.cliff = stream:read('byte')

			c = c + 1

			loadDisplay:inc()
		end

		for i = 1, tilesCount, 1 do
			createTile(i)
		end
	end

	--format 11
	local function maskFunc_onlyHeader_11(root, mode, stream)
		root:add('startToken', 'id')

		root:add('formatVersion', 'int')

		wc3binaryFile.checkFormatVer('envMaskFunc', 11, root:getVal('formatVersion'))

		root:add('mainTileset', 'char')
		root:add('customTilesetsFlag', 'int')

		root:add('groundTilesetsUsed', 'int')
		for i = 1, root:getVal('groundTilesetsUsed'), 1 do
			root:add('groundTileset'..i..'id', 'id')
		end

		root:add('cliffTilesetsUsed', 'int')
		for i = 1, root:getVal('cliffTilesetsUsed'), 1 do
			root:add('cliffTileset'..i..'id', 'id')
		end

		root:add('width', 'int')
		root:add('height', 'int')
		if (mode == 'writing') then
			root:setVal('minX', root:getVal('centerX') - (root:getVal('width') - 1) / 2 * 128)
			root:setVal('minY', root:getVal('centerY') - (root:getVal('height') - 1) / 2 * 128)
		end
		root:add('centerX', 'float')
		root:add('centerY', 'float')

		if (mode == 'reading') then
			root:setVal('centerX', root:getVal('centerX') + (root:getVal('width') - 1) / 2 * 128)
			root:setVal('centerY', root:getVal('centerY') + (root:getVal('height') - 1) / 2 * 128)
		end
	end

	local maskFuncs = {}

	maskFuncs[11] = maskFunc_11

	local maskFuncs_onlyHeader = {}

	maskFuncs_onlyHeader[11] = maskFunc_onlyHeader_11

	local function getMaskFunc(version, onlyHeader)
		if onlyHeader then
			return maskFuncs_onlyHeader[version]
		end

		return maskFuncs[version]
	end

	enc.getMaskFunc = getMaskFunc

	local function maskFunc_auto(version)
		root:add('formatVersion', 'int')

		local version = root:getVal('formatVersion')

		local f = getMaskFunc(version, false)

		assert((f ~= nil), string.format('unknown format %i', version))

		f(root)
	end

	local function maskFunc_auto_onlyHeader(version)
		root:add('formatVersion', 'int')

		local version = root:getVal('formatVersion')

		local f = getMaskFunc(version, true)

		assert((f ~= nil), string.format('unknown format %i', version))

		f(root)
	end

	enc.maskFunc = maskFunc

	return enc
end

local encoding = createEncoding()

t.encoding = encoding

local function create()
	local env = {}

	env.tileset = nil

	function env:setTileset(tileset)
		env.tileset = tileset
	end

	env.groundTypes = {}

	function env:addGroundType(val)
		assert(val, 'no val')

		env.groundTypes[#env.groundTypes + 1] = val
	end

	env.cliffTypes = {}

	function env:addCliffType(val)
		assert(val, 'no val')

		env.cliffTypes[#env.cliffTypes + 1] = val
	end

	function env:getMinX()
		return (env.centerX - (env.width - 1) * 128 / 2)
	end

	function env:getMinY()
		return (env.centerY - (env.height - 1) * 128 / 2)
	end

	function env:getMaxX()
		return (env.centerX + (env.width - 1) * 128 / 2)
	end

	function env:getMaxY()
		return (env.centerY + (env.height - 1) * 128 / 2)
	end

	function env:setSize(x, y)
		env.width = x or 0
		env.height = y or 0
	end

	function env:setCenter(x, y)
		env.centerX = x or 0
		env.centerY = y or 0
	end

	function env:indexByXY(x, y)
		assert(env.width and env.height, 'no dimensions set')

		return (y * env.width + x)
	end

	env.heights = {}

	function env:setHeight(x, y, val)
		env.heights[indexByXY(x, y)] = val or 0
	end

	env.waterHeights = {}

	function env:setWaterHeight(x, y, val)
		env.waterHeights[indexByXY(x, y)] = val or 0
	end

	env.waterBoundary = {}

	function env:setWaterBoundary(x, y, val)
		env.waterBoundary[indexByXY(x, y)] = val or 0
	end

	env.tex = {}

	function env:setTex(x, y, val)
		env.tex[indexByXY(x, y)] = val or 0
	end

	env.ramp = {}

	function env:setRamp(x, y, val)
		env.ramp[indexByXY(x, y)] = val or 0
	end

	env.blight = {}

	function env:setBlight(x, y, val)
		env.blight[indexByXY(x, y)] = val or 0
	end

	env.water = {}

	function env:setWater(x, y, val)
		env.water[indexByXY(x, y)] = val or 0
	end

	env.boundary = {}

	function env:setBoundary(x, y, val)
		env.boundary[indexByXY(x, y)] = val or 0
	end

	env.texDetails = {}

	function env:setTexDetails(x, y, val)
		env.texDetails[indexByXY(x, y)] = val or 0
	end

	env.cliffLayer = {}

	function env:setCliffLayer(x, y, val)
		env.cliffLayer[indexByXY(x, y)] = val or 0
	end

	env.cliffTex = {}

	function env:setCliffTex(x, y, val)
		env.cliffTex[indexByXY(x, y)] = val or 0
	end

	function env:addImp(path, stdFlag)
		assert(path, 'no path')

		assert((env.impsByPath[path] == nil), 'path '..tostring(path)..' already used')

		if (stdFlag == nil) then
			stdFlag = env.STD_FLAG_CUSTOM
		end

		local impData = {}

		impData.path = path
		impData.stdFlag = stdFlag

		env.impsByPath[path] = impData
	end

	function env:merge(otherImpFile)
		assert(otherImpFile, 'no other impFile')

		for _, impData in pairs(otherImpFile.impsByPath) do
			if (env.impsByPath[impData.path] == nil) then
				env:addImp(impData.path, impData.stdFlag)
			end
		end
	end

	--format 11
	local groundZero = 0x2000
	local waterZero = 89.6
	local cliffHeight = 0x0200

	local function rawToFinalGroundHeight(rawVal, cliffLevel)
		return ((rawVal - groundZero + (cliffLevel - 2) * cliffHeight) / 4)
	end

	local function finalGroundToRawHeight(finalVal, cliffLevel)
		return (finalVal * 4 - (cliffLevel - 2) * cliffHeight + groundZero)
	end

	local function rawToFinalWaterHeight(rawVal)
		return ((rawVal - groundZero) / 4) - waterZero
	end

	local function finalWaterToRawHeight(finalVal)
		return ((finalVal + waterZero) * 4 + groundZero)
	end

	function env:toBin()
		require 'wc3binaryFile'

		local root = wc3binaryFile.create()

		root:setVal('mainTileset', env.tileset)
		root:setVal('customTilesetsFlag', env.hasCustomTiles)

		root:setVal('groundTilesetsUsed', #env.groundTypes)
		for i = 1, #env.groundTypes, 1 do
			root:setVal(string.format('groundTileset%iid', i))
		end

		root:setVal('cliffTilesetsUsed', #env.cliffTypes)
		for i = 1, #env.cliffTypes, 1 do
			root:setVal(string.format('cliffTileset%iid', i))
		end

		root:setVal('width', env.width)
		root:setVal('height', env.height)

		root:setVal('centerX', env.centerX)
		root:setVal('centerY', env.centerY)

		local tilesCount = width * height

		for i = 1, tilesCount, 1 do
			local tileNode = root:addNode('tile'..format('%i', i))

			tileNode:setVal('groundHeight', env.height[i])
			tileNode:setVal('waterLevel', env.waterHeight[i])
			tileNode:setVal('boundary', env.waterBoundary[i])

			tileNode:setVal('tex', env.tex[i])
			tileNode:setVal('ramp', env.ramp[i])
			tileNode:setVal('blight', env.blight[i])
			tileNode:setVal('water', env.water[i])
			tileNode:setVal('boundary2', env.boundary[i])

			tileNode:setVal('texDetails', env.texDetails[i])
			tileNode:setVal('layer', env.cliffLayer[i])
			tileNode:setVal('cliffTex', env.cliffTex[i])
		end

		return root
	end

	function info:fromBin(root)
		assert(root, 'no root')

		env:setTileset(root:getVal('mainTileset'))
		env.hasCustomTiles = (root:getVal('customTilesetsFlag'))

		for i = 1, root:getVal('groundTilesetsUsed'), 1 do
			env:addGroundType(root:getVal('groundTileset'..i..'id'))
		end

		for i = 1, root:getVal('cliffTilesetsUsed'), 1 do
			env:addCliffType(root:getVal('cliffTileset'..i..'id'))
		end

		local width = root:getVal('width')
		local height = root:getVal('height')

		env:setSize(width, height)
		env:setCenter(root:getVal('centerX'), root:getVal('centerY'))

		if onlyHeader then
			return
		end

		local tilesCount = width * height

		for i = 1, tilesCount, 1 do
			local tileNode = root:getSub('tile'..format('%i', i))

			env:setHeightByIndex(i, tileNode:getVal('groundHeight'))
			env:setWaterHeightByIndex(i, tileNode:getVal('waterLevel'))
			env:setWaterBoundaryByIndex(i, tileNode:getVal('boundary'))

			env:setTexByIndex(i, tileNode:getVal('tex'))
			env:setRampByIndex(i, tileNode:getVal('ramp'))
			env:setBlightByIndex(i, tileNode:getVal('blight'))
			env:setWaterByIndex(i, tileNode:getVal('water'))
			env:setBoundaryByIndex(i, tileNode:getVal('boundary2'))

			env:setTexDetailsByIndex(i, tileNode:getVal('textureDetails'))
			env:setCliffLayerByIndex(i, tileNode:getVal('layer'))
			env:setCliffTexByIndex(i, tileNode:getVal('cliffTex'))
		end
	end

	function env:writeToFile(path)
		assert(path, 'no path')

		env:toBin():writeToFile(path, encoding.maskFunc_auto)
	end

	function env:readFromFile(path, onlyHeader)
		assert(path, 'no path')

		require 'wc3binaryFile'

		local root = wc3binaryFile.create()

		if onlyHeader then
			root:readFromFile(path, encoding.maskFunc_auto_onlyHeader)
		else
			root:readFromFile(path, encoding.maskFunc_auto)
		end

		env:fromBin(root)
	end

	return env
end

t.create = create

expose('wc3env', t)