require 'waterlua'

local t = {}

local function createEncoding()
	local enc = {}

	--format 0
	local function maskFunc_0(root)
		root:add('format', 'int')

		wc3binaryFile.checkFormatVer('camMaskFunc', 0, root:getVal('format'))

		root:add('camCount', 'int')

		for i = 1, root:getVal('camCount'), 1 do
			local tree = root:addNode('cam'..i)

			tree:add('targetX', 'float')
			tree:add('targetY', 'float')
			tree:add('zOffset', 'float')
			tree:add('rotation', 'float')
			tree:add('angleOfAttack', 'float')
			tree:add('dist', 'float')
			tree:add('roll', 'float')
			tree:add('fieldOfView', 'float')
			tree:add('farZ', 'float')
			tree:add('unknown', 'float')
			tree:add('cinematicName', 'string')
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

local encoding = createEncoding

t.encoding = encoding

local function create()
	local this = {}

	this.cams = {}

	function this:addCam()
		local cam = {}

		local index = #this.cams + 1

		this.cams[index] = cam
		cam.index = index

		function cam:setTarget(x, y)
			cam.targetX = x or 0
			cam.targetY = y or 0
		end

		function cam:setZOffset(z)
			cam.zOffset = z or 0
		end

		function cam:setRotation(val)
			cam.rot = val or 0
		end

		function cam:setAngleOfAttack(val)
			cam.angleOfAttack = val or 0
		end

		function cam:setRoll(val)
			cam.roll = val or 0
		end

		function cam:setDist(val)
			cam.dist = val or 0
		end

		function cam:setFieldOfView(val)
			cam.fieldOfView = val or 0
		end

		function cam:setFarZ(val)
			cam.farZ = val or 0
		end

		function cam:setUnknown(val)
			cam.unknown = val or 0
		end

		function cam:setCinematicName(val)
			cam.cinematicName = val or 0
		end

		function cam:remove()
			this.cams[cam.index] = this.cams[#this.cams]

			cam.index = nil
			this.cams[#this.cams] = nil
		end

		return cam
	end

	function this:toBin()
		require 'wc3binaryFile'

		local root = wc3binaryFile.create()

		for i = 1, #this.cams, 1 do
			local camNode = root:addNode('cam'..i)

			camNode:setVal('targetX', camNode.targetX)
			camNode:setVal('targetY', camNode.targetY)
			camNode:setVal('zOffset', camNode.zOffset)

			camNode:setVal('rotation', camNode.rot)
			camNode:setVal('angleOfAttack', camNode.angleOfAttack)
			camNode:setVal('roll', camNode.roll)

			camNode:setVal('dist', camNode.dist)
			camNode:setVal('fieldOfView', camNode.fieldOfView)
			camNode:setVal('farZ', camNode.farZ)

			camNode:setVal('unknown', camNode.unknown)
			if (camNode.cinematicName ~= nil) then
				camNode:setVal('cinematicName', camNode.cinematicName)
			else
				camNode:setVal('cinematicName', '')
			end
		end

		return root
	end

	function this:fromBin(root)
		assert(root, 'no root')

		local camCount = root:getVal('camCount')

		for i = 1, camCount, 1 do
			local camNode = root:getSub('cam'..i)

			local cam = this:addCam()

			cam:setTarget(camNode:getVal('targetX'), camNode:getVal('targetY'))
			cam:setZOffset(camNode:getVal('zOffset'))

			cam:setRotation(camNode:getVal('rotation'))
			cam:setAngleOfAttack(camNode:getVal('angleOfAttack'))
			cam:setDist(camNode:getVal('dist'))

			cam:setRoll(camNode:getVal('roll'))
			cam:setFieldOfView(camNode:getVal('fieldOfView'))
			cam:setFarZ(camNode:getVal('farZ'))

			cam:setUnknown(camNode:getVal('unknown'))
			cam:setCinematicName(camNode:getVal('cinematicName'))
		end
	end

	function this:writeToFile(path)
		assert(path, 'no path')

		this:toBin():writeToFile(path, maskFunc_auto)
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

expose('wc3cam', t)