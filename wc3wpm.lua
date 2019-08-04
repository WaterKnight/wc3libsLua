local t = {}

local function createEncoding()
	local enc = {}

	--format 0
	local function maskFunc_0(root)
		root:add('startToken', 'id')
		root:add('format', 'int')

		wc3binaryFile.checkFormatVer('wpmMaskFunc', 0, root:getVal('format'))

		root:add('width', 'int')
		root:add('height', 'int')

		local flagsTable = {'unknown', 'walk', 'fly', 'build', 'unknown2', 'blight', 'water', 'unknown3'}

		local c = 1

		for y = 0, root:getVal('height') - 1, 1 do
			for x = 0, root:getVal('width') - 1, 1 do
				local cell = root:addNode('cell'..c)

				--cell:add('flags', 'byte', flagsTable)
				cell:add('flags', 'byte')

				c = c + 1
			end
		end
	end

	--format 0
	local function maskFuncEx_0(root, mode, stream)
		root:add('startToken', 'id')
		root:add('format', 'int')

		wc3binaryFile.checkFormatVer('wpmMaskFunc', 0, root:getVal('format'))

		root:add('width', 'int')
		root:add('height', 'int')

		local streamPos = stream.pos

		if (mode == 'reading') then
			local c = 1
			local til = root:getVal('height') * root:getVal('width')

			root.cellFlags = {}

			for c = 1, til, 1 do
				root.cellFlags[c] = stream:getAbs(streamPos + c - 1)
			end
		else
			local c = 1
			local til = root:getVal('height') * root:getVal('width')

			for c = 1, til, 1 do
				stream:setAbs(streamPos + c - 1, root.cellFlags[c])
			end

			stream.pos = streamPos + til
		end
	end

	local maskFuncs = {}

	maskFuncs[0] = maskFunc_0

	local maskFuncExs = {}

	maskFuncExs[0] = maskFuncEx_0

	local function getMaskFunc(version, ex)
		if ex then
			return maskFuncExs[version]
		end

		return maskFuncs[version]
	end

	enc.getMaskFunc = getMaskFunc

	local function maskFunc_auto(root)
		root:add('format', 'int')

		local version = root:getVal('format')

		local f = getMaskFunc(version, false)

		assert((f ~= nil), string.format('unknown format %i', version))

		f(root)
	end

	enc.maskFunc_auto = maskFunc_auto

	local function maskFuncEx_auto(root)
		root:add('format', 'int')

		local version = root:getVal('format')

		local f = getMaskFunc(version, true)

		assert((f ~= nil), string.format('unknown format %i', version))

		f(root)
	end

	enc.maskFuncEx_auto = maskFuncEx_auto

	return enc
end

local encoding = createEncoding

t.encoding = encoding

local pathingTypes = {
	FLAG_UNKNOWN = 0x1,
	FLAG_WALK = 0x2,
	FLAG_FLY = 0x4,
	FLAG_BUILD = 0x8,
	FLAG_UNKNOWN2 = 0x10,
	FLAG_BLIGHT = 0x20,
	FLAG_WATER = 0x40,
	FLAG_UNKNOWN3 = 0x80
}

t.pathingTypes = pathingTypes

local function create()
	local wpm = {}

	wpm.cells = {}

	function wpm:getFlags(x, y)
		assert(x, 'no x')
		assert(y, 'no y')

		if (wpm.cells[x] == nil) then
			return 0
		end

		local res = wpm.cells[x][y] or 0

		return res
	end

	function wpm:isFlag(x, y, flag)
		return (bit.band(wpm:getFlags(x, y), flag) == flag)
	end

	function wpm:setFlags(x, y, flags)
		assert(x, 'no x')
		assert(y, 'no y')
		assert(flags, 'no flags')

		if (wpm.cells[x] == nil) then
			wpm.cells[x] = {}
		end

		wpm.cells[x][y] = flags
	end

	function wpm:addFlag(x, y, flag)
		assert(x, 'no x')
		assert(y, 'no y')
		assert(flag, 'no flag')

		wpm:setFlags(x, y, bit.bor(wpm:getFlags(x, y), flag))
	end

	function wpm:getFromCoords(x, y)
		assert(x, 'no x')
		assert(y, 'no y')
		assert(wpm.baseTerrain, 'no baseTerrain set')

		local mapMinX = wpm.baseTerrain:getMinX()
		local mapMinY = wpm.baseTerrain:getMinY()

		return math.floor((x - mapMinX) / 32), math.floor((y - mapMinY) / 32)
	end

	function wpm:setBaseTerrain(terrain)
		wpm.baseTerrain = terrain
	end

	function wpm:fromBin(root)
		assert(root, 'no root')

		local width = root:getVal('width')
		local height = root:getVal('height')

		wpm.width = width
		wpm.height = height

		local c = 1

		for y = 0, height - 1, 1 do
			for x = 0, width - 1, 1 do
				wpm:setFlags(x, y, root.cellFlags[c])

				c = c + 1
			end
		end
	end

	function wpm:toBin()
		require 'wc3binaryFile'

		local root = wc3binaryFile.create()

		root:add('startToken', 'id')
		root:setVal('startToken', 'MP3W')

		root:add('format', 'int')
		root:setVal('format', 0)

		root:add('width', 'int')
		root:setVal('width', wpm.width)
		root:add('height', 'int')
		root:setVal('height', wpm.height)

		local function boolToInt(b)
			if b then
				return 1
			end

			return 0
		end

		local c = 1

		root.cellFlags = {}

		for y = 0, wpm.height - 1, 1 do
			for x = 0, wpm.width - 1, 1 do
				root.cellFlags[c] = wpm:getFlags(x, y)

				c = c + 1
			end
		end

		return root
	end

	function wpm:writeToFile(path)
		assert(path, 'no path')

		wpm:toBin():writeToFile(path, maskFuncEx_auto)
	end

	function wpm:readFromFile(path)
		assert(path, 'no path')

		require 'wc3binaryFile'

		local root = wc3binaryFile.create()

		root:readFromFile(path, maskFuncEx_auto)

		wpm:fromBin()
	end

	return wpm
end

t.create = create

expose('wc3wpm', t)