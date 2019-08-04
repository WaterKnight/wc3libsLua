require 'waterlua'

local t = {}

local function create(path)
	local this = {}

	if path then
		if (io.getFileExtension(path) == nil) then
			path = path..'.slk'
		end
	end

	local path = path

	function this:getPath()
		return path
	end

	local fields = collections.createMap()

	function this:getFields()
		return fields
	end

	function this:containsField(field)
		assert(field, 'no field')

		return fields:containsKey(field)
	end

	local pivotField

	function this:getPivotField()
		return pivotField
	end

	function this:addField(field, defVal)
		local fieldData = fields:get(field)

		if (fieldData ~= nil) then
			fieldData.defVal = defVal

			return
		end

		--assert((fieldData == nil), 'field '..tostring(field)..' already used')

		fieldData = {}

		if (pivotField == nil) then
			pivotField = field
		end

		fields:set(field, fieldData)

		fieldData.defVal = defVal
	end

	local objs = collections.createMap()

	function this:getObjs()
		return objs
	end

	function this:getObj(id)
		assert(id, 'no id')

		return objs:get(id)
	end

	function this:addObj(id)
		assert(id, 'no id')

		local obj = objs:get(id)

		assert((obj == nil), 'obj '..tostring(id)..' already used')

		obj = {}

		objs:set(id, obj)

		obj.vals = {}

		function obj:getVal(field, ignoreError)
			assert((field ~= nil), 'no field')

			if not ignoreError then
				assert(fields:containsKey(field), 'field '..tostring(field)..' not available')
			end

			return obj.vals[field]
		end

		function obj:set(field, val)
			assert((field ~= nil), 'no field')

			assert(fields:containsKey(field), 'field '..tostring(field)..' not available')

			obj.vals[field] = val
		end

		function obj:merge(otherObj, overwrite)
			assert(otherObj, 'no otherObj')

			for field, val in pairs(otherObj.vals) do
				if (overwrite or (obj:getVal(field, true) == nil)) then
					if not this:containsField(field) then
						this:addField(field)
					end

					obj:set(field, val)
				end
			end
		end

		return obj
	end

	function this:merge(otherSlk, overwrite)
		assert(otherSlk, 'no other slk')

		if (pivotField == nil) then
			pivotField = otherSlk.getPivotField()
		end

		for field, fieldData in otherSlk.getFields():pairs() do
			this:addField(field, fieldData.defVal)
		end

		for objId, otherObj in otherSlk:getObjs():pairs() do
			local obj = this:getObj(objId) or this:addObj(objId)

			obj:merge(otherObj, overwrite)
		end
	end

	function this:writeToFile(path)
		assert(path, 'no path')

		if (io.getFileExtension(path) == nil) then
			path = path..'.slk'
		end

		io.createDir(getFolder(path))

		local file = io.open(path, 'w+')

		if (file == nil) then
			print('writeSlk: cannot create file at '..path)

			return
		end

		file:write('ID;PWXL;N;E')

		file:write('\n'..'B;Y'..(objs:size() + 1)..';X'..fields:size()..';D0')

		local c = 1
		local fieldX = {}

		local fieldsByX = {}

		local function addField(field)
			fieldsByX[c] = field
			fieldX[field] = c

			c = c + 1
		end

		assert(pivotField, 'no pivotField')

		addField(pivotField)

		for field in fields:pairs() do
			if (field ~= pivotField) then
				addField(field)
			end
		end

		local y = 1

		local slkCurX = 0
		local slkCurY = 0

		local function writeCell(x, y, val)
			if val then
				if (type(val) == 'boolean') then
					if val then
						val = 1
					else
						val = 0
					end
				elseif (type(val) == 'string') then
					val = val:quote()
				end
			else
				val = [["-"]]
			end

			if ((val == false) or (val == 0) or (val == '') or (val == [[""]]) or (val == [["0"]]) or (val == [["-"]])) then
				return
			end

			local t = {'C'}

			if (x ~= slkCurX) then
				t[#t + 1] = 'X'..x

				slkCurX = x
			end

			if (y ~= slkCurY) then
				t[#t + 1] = 'Y'..y

				slkCurY = y
			end

			t[#t + 1] = 'K'..val

			file:write('\n'..table.concat(t, ';'))
		end

		for x = 1, #fieldsByX, 1 do
			local field = fieldsByX[x]

			writeCell(x, 1, field)
		end

		for objId, obj in objs:pairs() do
			y = y + 1

			writeCell(1, y, objId)

			for x = 2, #fieldsByX, 1 do
				local field = fieldsByX[x]

				local val = obj.vals[field]

				if (val == nil) then
					local defVal = fields:get(field).defVal

					if (defVal ~= nil) then
						writeCell(x, y, defVal)
					end
				else
					writeCell(x, y, val)
				end
			end
		end

		file:write('\n'..'E')

		file:close()
	end

	function this:readFromFile(path, onlyHeader)
		assert(path, 'no path')

		if (io.getFileExtension(path) == nil) then
			path = path..'.slk'
		end

		local data = {}
		local file = io.open(path, 'r')

		local curX = 0
		local curY = 0
		local maxX = 0
		local maxY = 0

		if (file == nil) then
			printTrace('readSlk: could not open '..path)

			return
		end

		for line in file:lines() do
			line = line:split(';')

			if (line[1] == 'C') then
				local c = 1
				local val
				local x
				local y

				while (line[c] ~= nil) do
					local symbole = line[c]:sub(1, 1)

					if (symbole == 'X') then
						x = tonumber(line[c]:sub(2, line[c]:len()))
					end
					if (symbole == 'Y') then
						y = tonumber(line[c]:sub(2, line[c]:len()))
					end
					if (symbole == 'K') then
						val = line[c]:sub(2, line[c]:len())

						if (val:sub(1, 1) == [["]]) then
							val = val:sub(2, val:len() - 1)
						elseif tonumber(val) then
							val = tonumber(val)
						end
					end

					c = c + 1
				end

				if (x == nil) then
					x = curX
				end
				if (y == nil) then
					y = curY
				end

				if (data[y] == nil) then
					data[y] = {}
				end

				if (x > maxX) then
					maxX = x
				end
				if (y > maxY) then
					maxY = y
				end
				data[y][x] = val

				curX = x
				curY = y
			end
		end

		for x, val in pairs(data[1]) do
			this:addField(val)
		end

		pivotField = data[1][1]

		if onlyHeader then
			return
		end

		local c = 2

		while data[c] do
			local objId = data[c][1]

			if objId then
				for x, val in pairs(data[c]) do
					local field = data[1][x]

					if field then
						local obj = objs:get(objId) or this:addObj(objId)

						obj:set(field, val)
					end
				end
			end

			c = c + 1
		end
	end

	return this
end

t.create = create

expose('slkLib', t)