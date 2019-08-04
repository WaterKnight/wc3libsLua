require 'waterlua'

local t = {}

local function createEncoding()
	local enc = {}

	--format 1
	local function maskFunc(root)
		root:add('format', 'int')

		checkFormatVer('impMaskFunc', 1, root:getVal('format'))

		root:add('impsCount', 'int')

		for i = 1, root:getVal('impsCount'), 1 do
			local imp = root:addNode('imp'..i)

			imp:add('stdFlag', 'byte')
			imp:add('path', 'string')
		end
	end

	local maskFuncs = {}

	maskFuncs[0] = maskFunc_0

	local function getMaskFunc(version)
		return maskFuncs[version]
	end

	enc.getMaskFunc = getMaskFunc

	local function maskFunc_auto()
		root:add('format', 'int')

		local version = root:getVal('format')

		local f = getMaskFunc(version, false)

		assert((f ~= nil), string.format('unknown format %i', version))

		f(root)
	end

	enc.maskFunc_auto = maskFunc_auto

	return enc
end

local encoding = createEncoding()

t.encoding = encoding

local function create()
	local this = {}

	this.impsByPath = {}

	this.STD_FLAG_STD = 5
	this.STD_FLAG_CUSTOM = 10

	function this:addImp(path, stdFlag)
		assert(path, 'no path')

		assert((this.impsByPath[path] == nil), 'path '..tostring(path)..' already used')

		if (stdFlag == nil) then
			stdFlag = this.STD_FLAG_CUSTOM
		end

		local impData = {}

		impData.path = path
		impData.stdFlag = stdFlag

		this.impsByPath[path] = impData
	end

	function this:merge(otherImpFile)
		assert(otherImpFile, 'no other impFile')

		for _, impData in pairs(otherImpFile.impsByPath) do
			if (this.impsByPath[impData.path] == nil) then
				this:addImp(impData.path, impData.stdFlag)
			end
		end
	end

	function this:fromBin(root)
		assert(root, 'no root')

		for i = 1, root:getVal('impsCount') do
			local imp = root:getSub('imp'..i)

			local path = imp:getVal('path')
			local stdFlag = imp:getVal('stdFlag')

			if (this.impsByPath[path] == nil) then
				this:addImp(path, stdFlag)
			end
		end
	end

	function this:toBin()
		require 'wc3binaryFile'

		local root = wc3binaryFile.create()

		root:add('format', 'int')
		root:setVal('format', 1)

		local impsCount = getTableSize(this.impsByPath)

		root:add('impsCount', 'int')
		root:setVal('impsCount', impsCount)

		local c = 0

		for _, impData in pairs(this.impsByPath) do
			c = c + 1

			local impNode = root:addNode('imp'..c)

			impNode:add('path', 'string')
			impNode:setVal('path', impData.path)
			impNode:add('stdFlag', 'byte')
			impNode:setVal('stdFlag', impData.stdFlag)
		end

		return root
	end

	function this:writeToFile(path)
		assert(path, 'no path')

		this:toBin():writeToFile(path, maskFunc)
	end

	function this:readFromFile(path)
		assert(path, 'no path')

		require 'wc3binaryFile'

		local root = wc3binaryFile.create()

		root:readFromFile(path, maskFunc)

		this:fromBin(root)
	end

	return this
end

t.create = create

expose('wc3imp', t)