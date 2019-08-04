require 'waterlua'

local t = {}

local function createEncoding()
	local enc = {}

	--format 18
	 local function maskFunc_18(root)
		wc3binaryFile.checkFormatVer('infoFileMaskFunc', 18, root:getVal('formatVersion'))

		root:add('savesAmount', 'int')
		root:add('editorVersion', 'int')
		root:add('mapName', 'string')
		root:add('mapAuthor', 'string')
		root:add('mapDescription', 'string')
		root:add('playersRecommendedAmount', 'string')
		for i = 1, 8, 1 do
			root:add('cameraBounds'..i, 'float')
		end
		root:add('boundaryMarginLeft', 'int')
		root:add('boundaryMarginRight', 'int')
		root:add('boundaryMarginBottom', 'int')
		root:add('boundaryMarginTop', 'int')
		root:add('mapWidthWithoutBoundaries', 'int')
		root:add('mapHeightWithoutBoundaries', 'int')
		root:add('flags', 'int', {
						'hideMinimap',
						'modifyAllyPriorities',
						'meleeMap',
						'initialMapSizeLargeNeverModified',
						'maskedAreasPartiallyVisible',
						'fixedPlayerForceSetting',
						'useCustomForces',
						'useCustomTechtree',
						'useCustomAbilities',
						'useCustomUpgrades',
						'mapPropertiesWindowOpenedBefore',
						'showWaterWavesOnCliffShores',
						'showWaterWavesOnRollingShores',
						'unknownA',
						'unknownB',
						'unknownC'
					})

		root:add('tileset', 'char')
		root:add('campaignBackgroundIndex', 'int')
		root:add('loadingScreenText', 'string')
		root:add('loadingScreenTitle', 'string')
		root:add('loadingScreenSubtitle', 'string')
		root:add('loadingScreenIndex', 'int')
		root:add('prologueScreenText', 'string')
		root:add('prologueScreenTitle', 'string')
		root:add('prologueScreenSubtitle', 'string')

		root:add('maxPlayers', 'int')

		local function createPlayer(index)
			local p = root:addNode('player'..index)

			p:add('num', 'int')
			p:add('type', 'int')
			p:add('race', 'int')
			p:add('startPosFixed', 'int')
			p:add('name', 'string')
			p:add('startPosX', 'float')
			p:add('startPosY', 'float')

			local t = {}

			for i = 1, root:getVal('maxPlayers'), 1 do
				t[i] = 'player'..i
			end

			p:add('allyLowPriorityFlags', 'int', t)
			p:add('allyHighPriorityFlags', 'int', t)
		end

		for i = 1, root:getVal('maxPlayers'), 1 do
			createPlayer(i)
		end

		root:add('maxForces', 'int')

		local function createForce(index)
			local f = root:addNode('force'..index)

			f:add('flags', 'int', {'allied', 'alliedVictory', 'sharedVision', 'shareUnitControl', 'shareUnitControlAdvanced'})

			local t = {}

			for i = 1, root:getVal('maxPlayers'), 1 do
				t[i] = 'player'..i
			end

			f:add('players', 'int', t)

			f:add('name', 'string')
		end

		for i = 1, root:getVal('maxForces'), 1 do
			createForce(i)
		end

		root:add('upgradeModsAmount', 'int')

		local function createUpgradeMod(index)
			local u = root:addNode('upgrade'..index)

			local t = {}

			for i = 1, root:getVal('maxPlayers'), 1 do
				t[i] = 'player'..i
			end

			u:add('players', 'int', t)
			u:add('id', 'id')
			u:add('level', 'int')
			u:add('availability', 'int')
		end

		for i = 1, root:getVal('upgradeModsAmount'), 1 do
			createUpgradeMod(i)
		end

		root:add('techModsAmount', 'int')

		local function createTechMod(index)
			local tech = root:addNode('tech'..index)

			local t = {}

			for i = 1, root:getVal('maxPlayers'), 1 do
				t[i] = 'player'..i
			end

			tech:add('players', 'int', t)

			tech:add('id', 'id')
		end

		for i = 1, root:getVal('techModsAmount'), 1 do
			createTechMod(i)
		end

		root:add('unitTablesAmount', 'int')

		local function createUnitTable(index)
			local t = root:addNode('unitTable'..index)

			t:add('index', 'int')

			t:add('name', 'string')

			t:add('positionsAmount', 'int')

			for i = 1, t:getVal('positionsAmount'), 1 do
				t:add('positionType'..i, 'int')
			end

			t:add('setsAmount', 'int')

			local function createSet(index)
				local s = t:addNode('set'..index)

				s:add('chance', 'int')

				for i = 1, t:getVal('positionsAmount'), 1 do
					s:add('id'..i, 'id')
				end
			end

			for i = 1, t:getVal('setsAmount'), 1 do
				createSet(i)
			end
		end

		for i = 1, root:getVal('unitTablesAmount'), 1 do
			createUnitTable(i)
		end
	end

	--format 25
	local function maskFunc_25(root)
		wc3binaryFile.checkFormatVer('infoFileMaskFunc', 25, root:getVal('formatVersion'))

		root:add('savesAmount', 'int')
		root:add('editorVersion', 'int')
		root:add('mapName', 'string')
		root:add('mapAuthor', 'string')
		root:add('mapDescription', 'string')
		root:add('playersRecommendedAmount', 'string')
		for i = 1, 8, 1 do
			root:add('cameraBounds'..i, 'float')
		end
		root:add('boundaryMarginLeft', 'int')
		root:add('boundaryMarginRight', 'int')
		root:add('boundaryMarginBottom', 'int')
		root:add('boundaryMarginTop', 'int')
		root:add('mapWidthWithoutBoundaries', 'int')
		root:add('mapHeightWithoutBoundaries', 'int')
		root:add('flags', 'int', {
						'hideMinimap',
						'modifyAllyPriorities',
						'meleeMap',
						'initialMapSizeLargeNeverModified',
						'maskedAreasPartiallyVisible',
						'fixedPlayerForceSetting',
						'useCustomForces',
						'useCustomTechtree',
						'useCustomAbilities',
						'useCustomUpgrades',
						'mapPropertiesWindowOpenedBefore',
						'showWaterWavesOnCliffShores',
						'showWaterWavesOnRollingShores'
					})

		root:add('tileset', 'char')
		root:add('loadingScreenIndex', 'int')
		root:add('loadingScreenModelPath', 'string')
		root:add('loadingScreenText', 'string')
		root:add('loadingScreenTitle', 'string')
		root:add('loadingScreenSubtitle', 'string')
		root:add('gameData', 'int')
		root:add('prologueScreenPath', 'string')
		root:add('prologueScreenText', 'string')
		root:add('prologueScreenTitle', 'string')
		root:add('prologueScreenSubtitle', 'string')
		root:add('terrainFogType', 'int')
		root:add('terrainFogStartZHeight', 'float')
		root:add('terrainFogEndZHeight', 'float')
		root:add('terrainFogDensity', 'float')
		root:add('terrainFogBlue', 'byte')
		root:add('terrainFogGreen', 'byte')
		root:add('terrainFogRed', 'byte')
		root:add('terrainFogAlpha', 'byte')
		root:add('globalWeatherId', 'id')
		root:add('soundEnvironment', 'string')
		root:add('tilesetLightEnvironment', 'char')
		root:add('waterBlue', 'byte')
		root:add('waterGreen', 'byte')
		root:add('waterRed', 'byte')
		root:add('waterAlpha', 'byte')

		root:add('maxPlayers', 'int')

		local function createPlayer(index)
			local p = root:addNode('player'..index)

			p:add('num', 'int')
			p:add('type', 'int')
			p:add('race', 'int')
			p:add('startPosFixed', 'int')
			p:add('name', 'string')
			p:add('startPosX', 'float')
			p:add('startPosY', 'float')

			local t = {}

			for i = 1, root:getVal('maxPlayers'), 1 do
				t[i] = 'player'..i
			end

			p:add('allyLowPriorityFlags', 'int', t)
			p:add('allyHighPriorityFlags', 'int', t)
		end

		for i = 1, root:getVal('maxPlayers'), 1 do
			createPlayer(i)
		end

		root:add('maxForces', 'int')

		local function createForce(index)
			local f = root:addNode('force'..index)

			f:add('flags', 'int', {'allied', 'alliedVictory', 'sharedVision', 'shareUnitControl', 'shareUnitControlAdvanced'})

			local t = {}

			for i = 1, root:getVal('maxPlayers'), 1 do
				t[i] = 'player'..i
			end

			f:add('players', 'int', t)

			f:add('name', 'string')
		end

		for i = 1, root:getVal('maxForces'), 1 do
			createForce(i)
		end

		root:add('upgradeModsAmount', 'int')

		local function createUpgradeMod(index)
			local u = root:addNode('upgrade'..index)

			local t = {}

			for i = 1, root:getVal('maxPlayers'), 1 do
				t[i] = 'player'..i
			end

			u:add('players', 'int', t)
			u:add('id', 'id')
			u:add('level', 'int')
			u:add('availability', 'int')
		end

		for i = 1, root:getVal('upgradeModsAmount'), 1 do
			createUpgradeMod(i)
		end

		root:add('techModsAmount', 'int')

		local function createTechMod(index)
			local tech = root:addNode('tech'..index)

			local t = {}

			for i = 1, root:getVal('maxPlayers'), 1 do
				t[i] = 'player'..i
			end

			tech:add('players', 'int', t)

			tech:add('id', 'id')
		end

		for i = 1, root:getVal('techModsAmount'), 1 do
			createTechMod(i)
		end

		root:add('unitTablesAmount', 'int')

		local function createUnitTable(index)
			local t = root:addNode('unitTable'..index)

			t:add('index', 'int')

			t:add('name', 'string')

			t:add('positionsAmount', 'int')

			for i = 1, t:getVal('positionsAmount'), 1 do
				t:add('positionType'..i, 'int')
			end

			t:add('setsAmount', 'int')

			local function createSet(index)
				local s = t:addNode('set'..index)

				s:add('chance', 'int')

				for i = 1, t:getVal('positionsAmount'), 1 do
					s:add('id'..i, 'id')
				end
			end

			for i = 1, t:getVal('setsAmount'), 1 do
				createSet(i)
			end
		end

		for i = 1, root:getVal('unitTablesAmount'), 1 do
			createUnitTable(i)
		end

		root:add('itemTablesAmount', 'int')

		local function createItemTable(index)
			local t = root:addNode('itemTable'..index)

			t:add('index', 'int')
			t:add('name', 'string')
			t:add('setsAmount', 'int')

			local function createSet(index)
				local s = t:addNode('set'..index)

				s:add('itemsAmount', 'int')

				local function createItem(index)
					local i = s:addNode('item'..index)

					i:add('chance', 'int')
					i:add('id', 'id')
				end

				for i = 1, s:getVal('itemsAmount'), 1 do
					createItem(i)
				end
			end

			for i = 1, t:getVal('setsAmount'), 1 do
				createSet(i)
			end
		end

		for i = 1, root:getVal('itemTablesAmount'), 1 do
			createItemTable(i)
		end
	end

	local maskFuncs = {}

	maskFuncs[18] = maskFunc_18
	maskFuncs[25] = maskFunc_25

	local function getMaskFunc(version)
		return maskFuncs[version]
	end

	enc.getMaskFunc = getMaskFunc

	local function maskFunc_auto(root)
		root:add('formatVersion', 'int')

		local version = root:getVal('formatVersion')

		local f = getMaskFunc(version, onlyHeader)

		assert((f ~= nil), string.format('unknown format %i', version))

		f(root)
	end

	enc.maskFunc_auto = maskFunc_auto

	return enc
end

local encoding = createEncoding()

t.encoding = encoding

local playerControl = {
	USER = 1,
	CPU = 2,
	NEUTRAL = 3,
	RESCUABLE = 4
}

local playerRace = {
	HUMAN = 1,
	ORC = 2,
	UNDEAD = 3,
	ELF = 4
}

local function create()
	local info = {}
	
	local players = collections.createSet()

	function info:getPlayers()
		return players
	end

	function info:addPlayer()
		local p = {}

		players:add(p)

		local index = players:getIndex(p)

		function p:getIndex()
			return index
		end
		
		function p:setIndex(val)
			index = val
		end
		
		local control = playerControl.USER
		
		function p:getControl()
			return control
		end
		
		function p:setControl(val)
			control = val
		end

		local race = playerRace.HUMAN
		
		function p:getRace()
			return race
		end
		
		function p:setRace(val)
			race = val
		end

		local name = ''
		
		function p:getName()
			return name
		end
		
		function p:setName(val)
			name = val
		end
		
		local startPos = {
			x = 0,
			y = 0,
			fixed = false
		}
		
		function p:getStartPos()
			return startPos.x, startPos.y, startPos.fixed
		end
		
		function p:setStartPos(x, y, fixed)
			startPos.x = x
			startPos.y = y
			startPos.fixed = fixed
		end
		
		local allyLowPrioFlags = 0
		
		function p:getAllyLowPrioFlags()
			return allyLowPrioFlags
		end
		
		function p:setAllyLowPrioFlags(val)
			allyLowPrioFlags = val
		end

		local allyHighPrioFlags = 0
		
		function p:getAllyHighPrioFlags()
			return allyHighPrioFlags
		end
		
		function p:setAllyHighPrioFlags(val)
			allyHighPrioFlags = val
		end

		return p
	end

	local forces = collections.createSet()
	
	local forceFlags = {
		ALLIED = 0x1,
		ALLIED_VICTORY = 0x2,
		SHARED_VISION = 0x4,
		SHARE_UNIT_CONTROL = 0x10,
		SHARE_UNIT_CONTROL_ADVANCED = 0x20,
	}

	function info:addForce(index)
		local f = {}
		
		forces[#forces + 1] = f
		
		f.name = nil
		
		function f:getName()
			return f.name
		end
		
		function f:setName(name)
			f.name = name
		end

		local flagStates = {}
		
		for name, state in pairs(forceFlags) do
			flagStates[state] = false
		end
		
		function getFlags()
			local ret = 0

			local function boolToInt(b)
				if b then
					return 1
				end

				return 0
			end

			for name, addVal in pairs(forceFlags) do
				if (boolToInt(flagStates[name]) ~= 0) then
					ret = ret + addVal
				end
			end
			
			return ret
		end

		function f:isFlag(state)
			assert((flagStates[state] ~= nil), 'force has no flag '..tostring(state))

			return flagStates[state]
		end
		
		function f:setFlag(state, val)
			flagStates[state] = (val == true) or false
		end

		local players = collections.createSet()
		
		function f:addPlayer(p)
			assert(not players:contains(p), 'player already in force')

			players:add(p)
		end

		function f:removePlayer(p)
			assert(players:contains(p), 'player not in force')

			players:remove(p)
		end

		return f
	end
	
	local upgradeAvail = {
		UNAVAIL = 0,
		AVAIL = 1,
		RESEARCHED = 2
	}
	
	t.upgradeAvail = upgradeAvail
	
	local upgrades = collections.createSet()
	local upgradesById = collections.createSet()
	
	function info:getUpgrades()
		return upgrades
	end
	
	function info:addUpgradeMod(id)
		assert(not upgradesById:contains(id), 'id '..tostring(id)..' already used')

		local upg = {}
		
		upgrades:add(upg)
		
		upg.id = id
		
		upgradesById:add(id)
		
		function upg:remove()
			upgrades:remove(upg)
			upgradesById:remove(upg.id)
		end
		
		upg.level = 1
		
		function upg:getLevel()
			return upg.level
		end

		function upg:setLevel(val)
			upg.level = val or 1
		end
		
		upg.avail = upgradeAvail.AVAIL
		
		function upg.getAvail()
			return upg.avail
		end
		
		function upg:setAvail(val)
			upg.avail = val
		end
		
		local players = collections.createSet()
		
		function f:addPlayer(p)
			assert(not players:contains(p), 'player already in force')

			players:add(p)
		end

		function f:removePlayer(p)
			assert(players:contains(p), 'player not in force')

			players:remove(p)
		end
		
		return upg
	end

	local techs = collections.createSet()
	local techsById = collections.createSet()
	
	function info:getTechs()
		return techs
	end
	
	function info:addTech(id)
		assert(not techsById:contains(id), 'id '..tostring(id)..' already used')

		local tech = {}
		
		techs:add(tech)
		
		tech.id = id
		
		techsById:add(id)
		
		function tech:remove()
			techs:remove(tech)
			techsById:remove(tech.id)
		end
		
		local players = collections.createSet()
		
		function f:addPlayer(p)
			assert(not players:contains(p), 'player already in force')

			players:add(p)
		end

		function f:removePlayer(p)
			assert(players:contains(p), 'player not in force')

			players:remove(p)
		end
		
		return tech
	end
	
	local unitTable = {
		types = {
			UNIT = 0,
			STRUCTURE = 1,
			ITEM = 2
		}
	}
	
	local unitTables = collections.createSet()
	
	function info:getUnitTables()
		return unitTables
	end
	
	function info:addUnitTable()
		local tab = {}
		
		unitTables:add(tab)
	
		function tab:remove()
			unitTables:remove(tab)
		end
		
		local index = 0
		
		function tab:getIndex()
			return index
		end
	
		function tab:setIndex(val)
			index = val or 0
		end
	
		local name = nil

		function tab:getName()
			return name
		end
		
		function tab:setName(val)
			name = val
		end
		
		local sets = collections.createSet()
		
		function tab:getSets()
			return sets
		end

		function tab:addSet()
			local set = {}
			
			sets:add(set)

			local chance = 0
			
			function set:getChance(val)
				return chance
			end
			
			function set:setChance(val)
				chance = val
			end
			
			local objs = {}

			function set:getObjs()
				return objs
			end
			
			function set:setObj(pos, id)					
				local obj = {}

				objs[pos] = obj

				local id = id

				function obj:getId()
					return id
				end

				function obj:setId(val)
					id = val
				end
				
				return obj
			end
			
			return set
		end

		local posTypes = {}

		tab.posTypes = posTypes

		function tab:getPosType(index)
			return posTypes[index]
		end

		function tab:setPosType(index, val)
			posTypes[index] = val
		end

		return tab
	end

	local itemTables = collections.createSet()
	
	function info:getItemTables()
		return itemTables
	end
	
	function info:addItemTable()
		local tab = {}
		
		itemTables:add(tab)
	
		function tab:remove()
			itemTables:remove(tab)
		end
		
		local index = 0
		
		function tab:getIndex()
			return index
		end
	
		function tab:setIndex(val)
			index = val or 0
		end
	
		local name = nil

		function tab:getName()
			return name
		end
		
		function tab:setName(val)
			name = val
		end

		local sets = collections.createSet()
		
		function tab:getSets()
			return sets
		end

		function tab:addSet()
			local set = {}
			
			sets:add(set)

			local objs = collections.createSet()

			function set:getObjs()
				return objs
			end
			
			function set:addObj(id)
				local obj = {}
				
				objs:add(obj)
				
				local id = id
				
				function obj:getId()
					return id
				end

				function obj:setId(val)
					id = val
				end
				
				local chance = 0
				
				function obj:getChance(val)
					return chance
				end
				
				function obj:setChance(val)
					chance = val
				end
				
				return obj
			end
			
			return set
		end

		return tab
	end

	local cameraBounds = {
		x1 = 0,
		y1 = 0,
		x2 = 0,
		y2 = 0,
		x3 = 0,
		y3 = 0,
		x4 = 0,
		y4 = 0
	}
	
	function info:getCameraBounds()
		return cameraBounds.x1, cameraBounds.y1, cameraBounds.x2, cameraBounds.y2, cameraBounds.x3, cameraBounds.y3, cameraBounds.x4, cameraBounds.y4
	end

	function info:setCameraBounds(x1, y1, x2, y2, x3, y3, x4, y4)
		x1 = x1 or 0
		y1 = y1 or 0
		x2 = x2 or 0
		y2 = y2 or 0
		x3 = x3 or 0
		y3 = y3 or 0
		x4 = x4 or 0
		y4 = y4 or 0
		
		cameraBounds.x1 = x1
		cameraBounds.y1 = y1
		cameraBounds.x2 = x2
		cameraBounds.y2 = y2
		cameraBounds.x3 = x3
		cameraBounds.y3 = y3
		cameraBounds.x4 = x4
		cameraBounds.y4 = y4
	end

	local states = {
		savesAmount = 'int',
		editorVersion = 'int',
		mapName = 'string',
		mapAuthor = 'string',
		mapDescription = 'string',
		playersRecommendedAmount = 'string',

		boundaryMarginLeft = 'int',
		boundaryMarginRight = 'int',
		boundaryMarginBottom = 'int',
		boundaryMarginTop = 'int',
		mapWidthWithoutBoundaries = 'int',
		mapHeightWithoutBoundaries = 'int',

		tileset = 'char',
		campaignBackgroundIndex = 'int',
		loadingScreenModelPath = 'string',
		loadingScreenText = 'string',
		loadingScreenTitle = 'string',
		loadingScreenSubtitle = 'string',
		loadingScreenIndex = 'int',
		
		gameData = 'int',
		
		prologueScreenPath = 'string',
		prologueScreenText = 'string',
		prologueScreenTitle = 'string',
		prologueScreenSubtitle = 'string',

		terrainFogType = 'int',
		terrainFogStartZHeight = 'float',
		terrainFogEndZHeight = 'float',
		terrainFogDensity = 'float',
		terrainFogBlue = 'byte',
		terrainFogGreen = 'byte',
		terrainFogRed = 'byte',
		terrainFogAlpha = 'byte',
		
		globalWeatherId = 'id',
		soundEnvironment = 'string',
		tilesetLightEnvironment = 'char',
		
		waterBlue = 'byte',
		waterGreen = 'byte',
		waterRed = 'byte',
		waterAlpha = 'byte'
	}
	
	for i = 1, 8, 1 do
		states[string.format('cameraBounds%i', i)] = 'float'
	end
	
	local flagStates = {
		hideMinimap = 0x1,
		modifyAllyPriorities = 0x2,
		meleeMap = 0x4,
		initialMapSizeLargeNeverModified = 0x8,
		maskedAreasPartiallyVisible = 0x10,
		fixedPlayerForceSetting = 0x20,
		useCustomForces = 0x40,
		useCustomTechtree = 0x80,
		useCustomAbilities = 0x100,
		useCustomUpgrades = 0x200,
		mapPropertiesWindowOpenedBefore = 0x400,
		showWaterWavesOnCliffShores = 0x800,
		showWaterWavesOnRollingShores = 0x1000,
		unknownA = 0x2000,
		unknownB = 0x4000,
		unknownC = 0x8000,
	}
	
	local stateVals = {}

	function info:getState(name)
		assert(table.containsKey(states, name) or table.containsKey(flagStates, name), 'state '..tostring(name)..' not available')

		return stateVals[name]
	end

	function info:setState(name, val)
		assert(table.containsKey(states, name) or table.containsKey(flagStates, name), 'state '..tostring(name)..' not available')

		stateVals[name] = val
	end
	
	local function getFlags()		
		local ret = 0

		local function boolToInt(b)
			if b then
				return 1
			end

			return 0
		end

		for name, addVal in pairs(flagStates) do
			if (boolToInt(stateVals[name]) ~= 0) then
				ret = ret + addVal
			end
		end
		
		return ret
	end

	function info:toBin()
		require 'wc3binaryFile'

		local root = wc3binaryFile.create()

		root:add('formatVersion', 'int')
		root:setVal('formatVersion', 25)

		for name, valType in pairs(states) do
			root:add(name, valType)
			root:setVal(name, info:getState(name))
		end
		
		root:add('flags', 'int')
		root:setVal('flags', getFlags())
		
		root:add('maxPlayers', 'int')
		root:setVal('maxPlayers', players:size())
		for p in players:iter() do
			local playerNode = root:addNode(string.format('player%i', players:getIndex(p)))

			playerNode:add('num', 'int')
			playerNode:setVal('num', p:getIndex())
			
			playerNode:add('name', 'string')
			playerNode:setVal('name', p:getName())
			
			playerNode:add('type', 'int')
			playerNode:setVal('type', p:getControl())

			playerNode:add('race', 'int')
			playerNode:setVal('race', p:getRace())
			
			local startPosX, startPosY, startPosFixed = p:getStartPos()
			
			playerNode:add('startPosX', 'float')
			playerNode:setVal('startPosX', startPosX)
			playerNode:add('startPosY', 'float')
			playerNode:setVal('startPosY', startPosX)
			playerNode:add('startPosFixed', 'int')
			playerNode:setVal('startPosFixed', startPosFixed)
			
			playerNode:add('allyLowPriorityFlags', 'int')
			playerNode:setVal('allyLowPriorityFlags', p:getAllyLowPrioFlags())
			playerNode:add('allyHighPriorityFlags', 'int')
			playerNode:setVal('allyHighPriorityFlags', p:getAllyHighPrioFlags())
		end

		root:add('maxForces', 'int')
		root:setVal('maxForces', forces:size())
		for f in forces:iter() do
			local forceNode = root:addNode(string.format('force%i', f:getIndex()))
			
			forceNode:add('name', 'string')
			forceNode:setVal('name', f:getName())
			
			forceNode:add('flags', 'int')
			forceNode:setVal('flags', f:getFlags())
		end

		root:add('upgradeModsAmount', 'int')
		root:setVal('upgradeModsAmount', upgrades:size())
		for upg in upgrades:iter() do
			local upgNode = root:addNode(string.format('upgrade%i', upgrades:getIndex(upg)))

			upgNode:add('id', 'id')
			upgNode:setVal('id', upg:getId())
			
			upgNode:add('level', 'int')
			upgNode:setVal('level', upg:getLevel())
			upgNode:add('availability', 'int')
			upgNode:setVal('availability', upg:getAvail())
			upgNode:add('players', 'int')
			upgNode:setVal('players', upg:getPlayers())
		end

		root:add('techModsAmount', 'int')
		root:setVal('techModsAmount', techs:size())
		for tech in techs:iter() do
			local techNode = root:addNode(string.format('tech%i', techs:getIndex(tech)))
			
			techNode:add('players', 'int')
			techNode:setVal('players', tech:getPlayers())
		end

		root:add('unitTablesAmount', 'int')
		root:setVal('unitTablesAmount', unitTables:size())
		for tab in unitTables:iter() do
			local tabNode = root:addNode(string.format('unitTable%i', unitTables:getIndex(tab)))
			
			tabNode:add('index', 'int')
			tabNode:setVal('index', tab:getIndex())
			
			tabNode:add('name', 'string')
			tabNode:setVal('name', tab:getName())
			
			local sets = tab:getSets()
			local maxPos = 0

			tabNode:add('setsAmount', 'int')
			tabNode:setVal('setsAmount', sets:size())
			for set in sets:iter() do
				local setNode = tabNode:addNode(string.format('set%i', sets:getIndex(set)))

				setNode:add('chance', 'float')
				setNode:setVal('chance', set:getChance())

				local objs = set:getObjs()

				for pos, obj in pairs(objs) do
					setNode:add(string.format('id%i', pos), 'id')
					setNode:setVal(string.format('id%i', pos), obj:getId())

					if (pos > maxPos) then
						maxPos = pos
					end
				end
			end

			tabNode:add('positionsAmount', 'int')
			tabNode:setVal('positionsAmount', maxPos)
			for pos = 1, maxPos, 1 do
				tabNode:add(string.format('positionType%i', pos), 'int')
				tabNode:setVal(string.format('positionType%i', pos), tab:getPosType(pos))
			end
		end

		root:add('itemTablesAmount', 'int')
		root:setVal('itemTablesAmount', itemTables:size())
		for tab in itemTables:iter() do
			local tabNode = root:addNode(string.format('itemTable%i', itemTables:getIndex(tab)))

			tabNode:add('index', 'int')
			tabNode:setVal('index', tab:getIndex())

			tabNode:add('name', 'string')
			tabNode:setVal('name', tab:getName())

			local sets = tab:getSets()

			tabNode:add('setsAmount', 'int')
			tabNode:setVal('setsAmount', sets:size())
			for set in sets:iter() do
				local setNode = tabNode:addNode(string.format('set%i', sets:getIndex(set)))

				local objs = set:getObjs()

				setNode:add('itemsAmount', 'int')
				setNode:setVal('itemsAmount', objs:size())
				for obj in objs:iter() do
					local objNode = setNode:addNode(string.format('item%i', objs:getIndex(obj)))

					objNode:add('id', 'id')
					objNode:setVal('id', obj:getId())

					objNode:add('chance', 'int')
					objNode:setVal('chance', obj:getChance())
				end
			end
		end

		return root
	end

	function info:fromBin(root)
		assert(root, 'no root')

		for name, valType in pairs(states) do
			info:setState(name, root:getVal(name, true))
		end

		if (info:getState('campaignBackgroundIndex') == nil) then
			info:setState('campaignBackgroundIndex', 0)
		end
		
		local t = {}

		for i = 1, 8, 1 do
			t[i] = root:getVal(string.format('cameraBounds%i', i))
		end
		
		info:setCameraBounds(unpack(t))
		
		local flagNode = root:getSub('flags')

		for name, valType in pairs(flagStates) do
			local val = flagNode:getVal(name) or false

			info:setState(name, val)
		end
		
		for i = 1, root:getVal('maxPlayers'), 1 do
			local playerNode = root:getSub(string.format('player%i', i))

			local player = info:addPlayer(playerNode:getVal('num'))
			
			player:setIndex(playerNode:getVal('num'))

			player:setControl(playerNode:getVal('type'))
			player:setRace(playerNode:getVal('race'))
			player:setStartPos(playerNode:getVal('startPosX'), playerNode:getVal('startPosY'), playerNode:getVal('startPosFixed'))
			
			player:setAllyLowPrioFlags(playerNode:getVal('allyLowPriorityFlags'))
			player:setAllyHighPrioFlags(playerNode:getVal('allyHighPriorityFlags'))
		end

		for i = 1, root:getVal('maxForces'), 1 do
			local forceNode = root:getSub(string.format('force%i', i))

			local force = info:addForce(i)
			
			force:setName(forceNode:getVal('name'))
			
			force:setFlag(forceFlags.ALLIED, forceNode:getSub('flags'):getVal('allied'))
			force:setFlag(forceFlags.ALLIED_VICTORY, forceNode:getSub('flags'):getVal('alliedVictory'))
			force:setFlag(forceFlags.SHARE_UNIT_CONTROL, forceNode:getSub('flags'):getVal('shareUnitControl'))
			force:setFlag(forceFlags.SHARE_UNIT_CONTROL_ADVANCED, forceNode:getSub('flags'):getVal('shareUnitControlAdvanced'))
		end
		
		for i = 1, root:getVal('upgradeModsAmount'), 1 do
			local upgNode = root:getSub(string.format('upgrade%i', index))
			
			local upg = info:addUpgradeMod(upgNode:getVal('id'))
			
			upg:setLevel(upgNode:getVal('level'))
			upg:setAvail(upgNode:getVal('availability'))
			upg:setPlayers(upgNode:getVal('players'))
		end

		for i = 1, root:getVal('techModsAmount'), 1 do
			local techNode = root:getSub(string.format('tech%i', i))
			
			local tech = info:addTech(techNode:getVal('id'))

			tech:setPlayers(techNode:getVal('players'))
		end

		for i = 1, root:getVal('unitTablesAmount'), 1 do
			local tabNode = root:getSub(string.format('unitTable%i', i))
			
			local tab = info:addUnitTable()

			tab:setIndex(tabNode:getVal('index'))
			tab:setName(tabNode:getVal('name'))
			
			for pos = 1, tabNode:getVal('positionsAmount'), 1 do
				tab:setPosType(pos, tabNode:getVal(string.format('positionType%i', pos)))
			end
			
			for j = 1, tabNode:getVal('setsAmount'), 1 do
				local setNode = tabNode:getSub(string.format('set%i', j))

				local set = tab:addSet()

				set:setChance(setNode:getVal('chance'))

				for l = 1, tabNode:getVal('positionsAmount'), 1 do
					set:setObj(l, setNode:getVal(string.format('id%i', l)))
				end
			end
		end
		
		local itemTablesAmount = root:getVal('itemTablesAmount', true) or 0

		for i = 1, itemTablesAmount, 1 do
			local tabNode = root:getSub(string.format('itemTable%i', i))
			
			local tab = info:addItemTable()
			
			tab:setIndex(tabNode:getVal('index'))
			tab:setName(tabNode:getVal('name'))
			
			for j = 1, tabNode:getVal('setsAmount'), 1 do
				local setNode = tabNode:getSub(string.format('set%i', j))

				local set = tab:addSet()

				for k = 1, setNode:getVal('itemsAmount'), 1 do
					local itemNode = setNode:getSub(string.format('item%i', k))

					local item = set:addObj(itemNode:getVal('id'))

					item:setChance(itemNode:getVal('chance'))
				end
			end
		end
	end

	function info:writeToFile(path)
		assert(path, 'no path')

		info:toBin():writeToFile(path, encoding.maskFunc_auto)
	end

	function info:readFromFile(path)
		assert(path, 'no path')

		require 'wc3binaryFile'

		local root = wc3binaryFile.create()

		root:readFromFile(path, encoding.maskFunc_auto)

		info:fromBin(root)
	end

	return info
end

t.create = create

expose('wc3info', t)