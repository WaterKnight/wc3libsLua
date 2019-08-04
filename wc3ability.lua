require 'waterlua'

local t = {}

local function createSlk()
	local this = {}

	require 'slkLib'

	local rawSlk = slkLib.create()

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

		local obj = {}

		objs:set(id, obj)

		function obj:set(field, val)
			assert(field, 'no field')

			local slkObj = rawSlk:getObj(id) or rawSlk:addObj(id)

			rawSlk:addField(field)

			slkObj:set(field, val)
		end

		local code = '0000'

		function obj:setCode(val)
			code = val
		end

		local hero = 0

		function obj:setHero(val)
			hero = val or 0
		end

		local item = 0

		function obj:setItem(val)
			item = val or 0
		end

		local race = ''

		function obj:setRace(val)
			race = val
		end

		local checkDep = 0

		function obj:setCheckDep(val)
			checkDep = val or 0
		end

		local levels = 1

		function obj:setLevels(val)
			levels = val or 1
		end

		local reqLevel = 0

		function obj:setReqLevel(val)
			reqLevel = val or 0
		end

		local levelSkip = 0

		function obj:setLevelSkip(val)
			levelSkip = val or 0
		end

		local prio = 0

		function obj:setPrio(val)
			prio = val or 0
		end

		local targs = collections.createArray()

		function obj:setTargs(val, level)
			level = level or 1

			assert((level >= 1) and (level <= 4), 'level must be between 1 and 4 but got '..tostring(level))

			targs[level] = val or 0
		end

		local castTime = collections.createArray()

		function obj:setCastTime(val, level)
			level = level or 1

			assert((level >= 1) and (level <= 4), 'level must be between 1 and 4 but got '..tostring(level))

			castTime[level] = val or 0
		end

		local dur = collections.createArray()

		function obj:setDur(val, level)
			level = level or 1

			assert((level >= 1) and (level <= 4), 'level must be between 1 and 4 but got '..tostring(level))

			dur[level] = val or 0
		end

		local heroDur = collections.createArray()

		function obj:setHeroDur(val, level)
			level = level or 1

			assert((level >= 1) and (level <= 4), 'level must be between 1 and 4 but got '..tostring(level))

			heroDur[level] = val or 0
		end

		local cooldown = collections.createArray()

		function obj:setCooldown(val, level)
			level = level or 1

			assert((level >= 1) and (level <= 4), 'level must be between 1 and 4 but got '..tostring(level))

			cooldown[level] = val or 0
		end

		local manaCost = collections.createArray()

		function obj:setManaCost(val, level)
			level = level or 1

			assert((level >= 1) and (level <= 4), 'level must be between 1 and 4 but got '..tostring(level))

			manaCost[level] = val or 0
		end

		local area = collections.createArray()

		function obj:setArea(val, level)
			level = level or 1

			assert((level >= 1) and (level <= 4), 'level must be between 1 and 4 but got '..tostring(level))

			area[level] = val or 0
		end

		local range = collections.createArray()

		function obj:setRange(val, level)
			level = level or 1

			assert((level >= 1) and (level <= 4), 'level must be between 1 and 4 but got '..tostring(level))

			range[level] = val or 0
		end

		local data = {}

		for i = 0, 8, 1 do
			data[i] = {}
		end

		function obj:setData(dataPt, val, level)
			dataPt = dataPt or 0

			assert((dataPt >= 0) and (dataPt <= 9), 'dataPointer must be between 0 and 8 but got '..tostring(dataPt))

			level = level or 1

			assert((level >= 1) and (level <= 4), 'level must be between 1 and 4 but got '..tostring(level))

			data[dataPt][level] = val
		end

		local unitId = collections.createArray()

		function obj:setUnitId(val, level)
			level = level or 1

			assert((level >= 1) and (level <= 4), 'level must be between 1 and 4 but got '..tostring(level))

			unitId[level] = val or 0
		end

		local buffId = collections.createArray()

		function obj:setBuffId(val, level)
			level = level or 1

			assert((level >= 1) and (level <= 4), 'level must be between 1 and 4 but got '..tostring(level))

			buffId[level] = val or 0
		end

		local effectId = collections.createArray()

		function obj:setEffectId(val, level)
			level = level or 1

			assert((level >= 1) and (level <= 4), 'level must be between 1 and 4 but got '..tostring(level))

			effectId[level] = val or 0
		end

		return obj
	end

	function this:toSlk()
		require 'slkLib'

		local slk = slkLib.create()

		slk:addField('alias')

		slk:addField('code')

		slk:addField('comments')

		slk:addField('version')
		slk:addField('useInEditor')

		slk:addField('hero')
		slk:addField('item')

		slk:addField('sort')
		slk:addField('race')

		slk:addField('checkDep')

		slk:addField('levels')

		slk:addField('reqLevel')
		slk:addField('levelSkip')

		slk:addField('priority')

		for i = 1, 4, 1 do
			slk:addField(string.format('targs%i', i))
			slk:addField(string.format('Cast%i', i))
			slk:addField(string.format('Dur%i', i))
			slk:addField(string.format('HeroDur%i', i))
			slk:addField(string.format('Cool%i', i))
			slk:addField(string.format('Cost%i', i))
			slk:addField(string.format('Area%i', i))
			slk:addField(string.format('Rng%i', i))
			for dataPt = 0, 8, 1 do
				slk:addField(string.format('Data%s%i', string.char(string.byte('A') + dataPt), i))
			end
			slk:addField(string.format('UnitID%i', i))
			slk:addField(string.format('BuffID%i', i))
			slk:addField(string.format('EfctID%i', i))
		end

		slk:addField('InBeta')

		for objId, obj in objs:pairs() do
			local slkObj = slk:addObj(objId)

			slkObj:set('code', obj.code)

			slkObj:set('hero', obj.hero)
			slkObj:set('item', obj.item)
			slkObj:set('race', obj.race)

			slkObj:set('checkDep', obj.checkDep)

			slkObj:set('levels', obj.levels)
			slkObj:set('reqLevel', obj.reqLevel)
			slkObj:set('levelSkip', obj.levelSkip)

			slkObj:set('priority', obj.prio)

			for i = 1, 4, 1 do
				slkObj:set(string.format('targs%i', i), obj.targs[i])
				slkObj:set(string.format('Cast%i', i), obj.castTime[i])
				slkObj:set(string.format('Dur%i', i), obj.dur[i])
				slkObj:set(string.format('HeroDur%i', i), obj.heroDur[i])
				slkObj:set(string.format('Cool%i', i), obj.cooldown[i])
				slkObj:set(string.format('Cost%i', i), obj.manaCost[i])
				slkObj:set(string.format('Area%i', i), obj.area[i])
				slkObj:set(string.format('Rng%i', i), obj.range[i])

				for dataPt = 0, 8, 1 do
					slkObj:set(string.format('Data%s%i', string.char(string.byte('A') + dataPt), i), obj.data[dataPt][i])
				end

				slkObj:set(string.format('UnitID%i', i), obj.unitId[i])
				slkObj:set(string.format('BuffID%i', i), obj.buffId[i])
				slkObj:set(string.format('EfctID%i', i), obj.effectId[i])
			end
		end

		slk:merge(rawSlk)

		return slk
	end

	function this:writeToFile(path)
		assert(path, 'no path')

		this:toSlk():writeToFile(path)
	end

	function this:readFromFile(path)
		assert(path, 'no path')

		require 'slkLib'

		local slk = createSlk()

		slk:readFromFile(path)

		for id, objData in slk.:getObjs():pairs() do
			local obj = this:addObj(id)

			obj:setCode(objData.vals['code'])

			obj:setHero(objData.vals['hero'])
			obj:setItem(objData.vals['item'])
			obj:setRace(objData.vals['race'])

			obj:setCheckDep(objData.vals['checkDep'])

			obj:setLevels(objData.vals['levels'])
			obj:setReqLevel(objData.vals['reqLevel'])
			obj:setLevelSkip(objData.vals['levelSkip'])

			obj:setPrio(objData.vals['priority'])

			for i = 1, 4, 1 do
				obj:setTargs(i, objData.vals[string.format('targs%i', i)])
				obj:setCastTime(i, objData.vals[string.format('Cast%i', i)])
				obj:setDur(i, objData.vals[string.format('Dur%i', i)])
				obj:setHeroDur(i, objData.vals[string.format('HeroDur%i', i)])
				obj:setCooldown(i, objData.vals[string.format('Cool%i', i)])
				obj:setManaCost(i, objData.vals[string.format('Cost%i', i)])
				obj:setArea(i, objData.vals[string.format('Area%i', i)])
				obj:setRange(i, objData.vals[string.format('Rng%i', i)])
				for dataPt = 0, 8, 1 do
					obj:setData(dataPt, i, objData.vals[string.format('Data%s%i', string.char(string.byte('A') + dataPt), i)])
				end
				obj:setUnitId(i, objData.vals[string.format('UnitID%i', i)])
				obj:setBuffId(i, objData.vals[string.format('BuffID%i', i)])
				obj:setEffectId(i, objData.vals[string.format('EfctID%i', i)])
			end
		end
	end

	return this
end

t.createSlk = createSlk

local function createMod()
	local this = {}

	local rawMod = wc3objMod.create()

	local objs = collections.createMap()

	function this:getObjs()
		return objs
	end

	function this:getObj(id)
		assert(id, 'no id')

		return objs:get(id)
	end

	function this:addObj(id, baseId)
		assert(id, 'no id')

		assert(not objs:containsKey(id), 'objId '..tostring(id)..' already used')

		local obj = {}

		objs:set(id, obj)

		local baseId = baseId

		function obj:getBaseId()
			return baseId
		end

		function obj:set(field, val, level)
			local modObj = rawMod:getObj(id) or rawMod:addObj(id)

			modObj:set(field, val, level)
		end

		local name = nil

		function obj:setName(val)
			name = val
		end

		local editorSuffix = nil

		function obj:setEditorSuffix(val)
			editorSuffix = val
		end

		local isHero = 0

		function obj:setHero(val)
			isHero = val or 0
		end

		local isItem = 0

		function obj:setItem(val)
			isItem = val or 0
		end

		local race = nil

		function obj:setRace(val)
			race = val
		end

		local buttonPosX = 0
		local buttonPosY = 0

		function obj:setButtonPos(x, y)
			buttonPosX = x or 0
			buttonPosY = y or 0
		end

		local buttonUnPosX = 0
		local buttonUnPosY = 0

		function obj:setButtonUnPos(x, y)
			buttonUnPosX = x or 0
			buttonUnPosY = y or 0
		end

		local buttonResearchPosX = 0
		local buttonResearchPosY = 0

		function obj:setButtonResearchPos(x, y)
			buttonResearchPosX = x or 0
			buttonResearchPosY = y or 0
		end

		local icon = nil

		function obj:setIcon(val)
			icon = val
		end

		local iconUn = nil

		function obj:setIconUn(val)
			iconUn = val
		end

		local iconResearch = nil

		function obj:setIconResearch(val)
			iconResearch = val
		end

		local casterEffect = nil

		function obj:setCasterEffect(val)
			casterEffect = val
		end

		local targetEffect = nil

		function obj:setTargetEffect(val)
			targetEffect = val
		end

		local specialEffect = nil

		function obj:setSpecialEffect(val)
			specialEffect = val
		end

		local effect = nil

		function obj:setEffect(val)
			effect = val
		end

		local areaEffect = nil

		function obj:setAreaEffect(val)
			areaEffect = val
		end

		local bolt = nil

		function obj:setBolt(val)
			bolt = val
		end

		local missileArt = nil

		function obj:setMissileArt(val)
			missileArt = val
		end

		local missileSpeed = 0

		function obj:setMissileSpeed(val)
			missileSpeed = val or 0
		end

		local missileArc = 0

		function obj:setMissileArc(val)
			missileArc = val or 0
		end

		local missileHoming = 0

		function obj:setMissileHoming(val)
			missileHoming = val or 0
		end

		local argetAttachCount = 0

		function obj:setTargetAttachCount(val)
			targetAttachCount = val or 0
		end

		local targetAttach = collections.createArray()

		function obj:setTargetAttach(index, val)
			targetAttach[index] = val
		end

		local casterAttachCount = 0

		function obj:setCasterAttachCount(val)
			casterAttachCount = val or 0
		end

		local casterAttach = nil

		function obj:setCasterAttach(val)
			casterAttach = val
		end

		local casterAttach1 = nil

		function obj:setCasterAttach1(val)
			casterAttach1 = val
		end

		local specialAttach = nil

		function obj:setSpecialAttach(val)
			specialAttach = val
		end

		local anim = nil

		function obj:setAnim(val)
			anim = val
		end

		local tooltips = collections.createArray()

		function obj:setTooltip(val, level)
			tooltips[level] = val
		end

		local tooltipUns = collections.createArray()

		function obj:setTooltipUn(val, level)
			tooltipUns[level] = val
		end

		local uberTooltips = collections.createArray()

		function obj:setUberTooltip(val, level)
			uberTooltips[level] = val
		end

		local uberTooltipUns = collections.createArray()

		function obj:setUberTooltipUn(val, level)
			uberTooltipUn[level] = val
		end

		local tooltipResearch = nil

		function obj:setTooltipResearch(val)
			tooltipResearch = val
		end

		local uberTooltipResearch = nil

		function obj:setUberTooltipResearch(val)
			uberTooltipResearch = val
		end

		local hotkeyResearch = nil

		function obj:setHotkeyResearch(val)
			hotkeyResearch = val
		end

		local hotkey = nil

		function obj:setHotkey(val)
			hotkey = val
		end

		local hotkeyUn = nil

		function obj:setHotkeyUn(val)
			hotkeyUn = val
		end

		local requirement = collections.createArray()

		function obj:setRequirement(val)
			requirement = val
		end

		local requirementsAmount = 0

		function obj:setRequirementsAmount(val)
			requirementsAmount = val or 0
		end

		local checkDep = 0

		function obj:setCheckDep(val)
			checkDep = val or 0
		end

		local prio = nil

		function obj:setPrio(val)
			prio = val
		end

		local order = nil

		function obj:setOrder(val)
			order = val
		end

		local orderUn = nil

		function obj:setOrderUn(val)
			orderUn = val
		end

		local orderOn = nil

		function obj:setOrderOn(val)
			orderOn = val
		end

		local orderOff = nil

		function obj:setOrderOff(val)
			orderOff = val
		end

		local sound = nil

		function obj:setSound(val)
			sound = val
		end

		local soundLoop = nil

		function obj:setSoundLoop(val)
			soundLoop = val
		end

		local levels = 1

		function obj:setLevels(val)
			levels = val or 1
		end

		local levelReq = 0

		function obj:setLevelReq(val)
			levelReq = val or 0
		end

		local levelSkip = 0

		function obj:setLevelSkip(val)
			levelSkip = val or 0
		end

		local targets = collections.createArray()

		function obj:setTargets(val, level)
			targets[level] = val
		end

		local castTime = collections.createArray()

		function obj:setCastTime(val, level)
			castTime[level] = val or 0
		end

		local duration = collections.createArray()

		function obj:setDuration(val, level)
			duration[level] = val or 0
		end

		local heroDuration = collections.createArray()

		function obj:setHeroDuration(val, level)
			heroDuration[level] = val or 0
		end

		local cooldown = collections.createArray()

		function obj:setCooldown(val, level)
			cooldown[level] = val or 0
		end

		local manaCost = collections.createArray()

		function obj:setManaCost(val, level)
			manaCost[level] = val or 0
		end

		local area = collections.createArray()

		function obj:setArea(val, level)
			area[level] = val or 0
		end

		local range = collections.createArray()

		function obj:setRange(val, level)
			range[level] = val or 0
		end

		local buffId = collections.createArray()

		function obj:setBuffId(val, level)
			buffId[level] = val or 0
		end

		local effectId = collections.createArray()

		function obj:setEffectId(val, level)
			effectId[level] = val or 0
		end

		function obj:merge(other)
			assert(other, 'no other')

			local t = {

			}

			for i = 0, 5, 1 do
				t[#t + 1] = string.format('targetAttach%i', i)
			end

			for _, var in pairs(t) do
				obj[var] = other[var]
			end
		end

		return obj
	end

	function this:merge(other)
		assert(other, 'no other')

		for objId, otherObj in other.getObjs():pairs() do
			local obj = objs:get(objId) or this:addObj(objId, otherObj:getBaseId())

			obj:merge(otherObj)
		end
	end

	function this:reduceToSlk()
		local slk = slk.create()
		local objMod = objMod.create()

		
	end

	function this:toObjMod()
		require 'wc3objMod'

		local objMod = wc3objMod.create()

		for objId, obj in objs:pairs() do
			local modObj = objMod:addObj(objId, obj:getBaseId())

			modObj:set('anam', obj.name)
			modObj:set('ansf', obj.editorSuffix)
			modObj:set('aher', obj.isHero)
			modObj:set('aite', obj.isItem)

			modObj:set('arac', obj.race)
			modObj:set('abpx', obj.buttonPosX)
			modObj:set('abpy', obj.buttonPosY)
			modObj:set('aupx', obj.buttonUnPosX)
			modObj:set('aupy', obj.buttonUnPosY)
			modObj:set('arpx', obj.buttonResearchPosX)
			modObj:set('arpy', obj.buttonResearchPosY)

			modObj:set('aart', obj.icon)
			modObj:set('auar', obj.iconUn)
			modObj:set('arar', obj.iconResearch)

			modObj:set('acat', obj.casterEffect)
			modObj:set('atat', obj.targetEffect)
			modObj:set('asat', obj.specialEffect)
			modObj:set('aeat', obj.effect)
			modObj:set('aaea', obj.areaEffect)

			modObj:set('alig', obj.bolt)

			modObj:set('amat', obj.missileArt)
			modObj:set('amsp', obj.missileSpeed)
			modObj:set('amac', obj.missileArc)
			modObj:set('amho', obj.missileHoming)

			modObj:set('atac', obj.targetAttachCount)

			for i = 0, 5, 1 do
				modObj:set(string.format('ata%i', i), obj.targetAttach[i])
			end

			modObj:set('acac', obj.casterAttachCount)
			modObj:set('acap', obj.casterAttach)
			modObj:set('aca1', obj.casterAttach1)
			modObj:set('aspt', obj.specialAttach)

			modObj:set('aani', obj.anim)

			for level, val in obj:getTooltips():pairs() do
				modObj:set('atp1', val, level)
			end
			for level, val in obj:getTooltipUns():pairs() do
				modObj:set('aut1', val, level)
			end
			for level, val in obj:getUberTooltips():pairs() do
				modObj:set('aub1', val, level)
			end
			for level, val in obj:getUberTooltipUns():pairs() do
				modObj:set('auu1', val, level)
			end

			modObj:set('aret', obj.tooltipResearch)
			modObj:set('arut', obj.uberTooltipResearch)

			modObj:set('arhk', obj.hotkeyResearch)
			modObj:set('ahky', obj.hotkey)
			modObj:set('auhk', obj.hotkeyUn)

			modObj:set('areq', obj.requirement)
			modObj:set('arqa', obj.requirementsAmount)
			modObj:set('achd', obj.checkDep)

			modObj:set('apri', obj.prio)
			modObj:set('aord', obj.order)
			modObj:set('aoru', obj.orderUn)
			modObj:set('aoro', obj.orderOn)
			modObj:set('aorf', obj.orderOff)

			modObj:set('aefs', obj.sound)
			modObj:set('aefl', obj.soundLoop)

			modObj:set('alev', obj.levels)
			modObj:set('arlv', obj.levelReq)
			modObj:set('alsk', obj.levelSkip)

			for level, val in obj:getTargets():pairs() do
				modObj:set('atar', val, level)
			end
			for level, val in obj:getCastTimes():pairs()  do
				modObj:set('acas', val, level)
			end
			for level, val in obj:getDurations():pairs()  do
				modObj:set('adur', val, level)
			end
			for level, val in obj:getHeroDurations():pairs()  do
				modObj:set('ahdu', val, level)
			end
			for level, val in obj:getCooldowns():pairs()  do
				modObj:set('acdn', val, level)
			end
			for level, val in obj:getManaCosts():pairs()  do
				modObj:set('amcs', val, level)
			end
			for level, val in obj:getAreas():pairs()  do
				modObj:set('aare', val, level():pairs() 
			end
			for level, val in obj:getRanges():pairs()  do
				modObj:set('aran', val, level)
			end
			for level, val in obj:getBuffIds():pairs()  do
				modObj:set('abuf', val, level)
			end
			for level, val in obj:getEffectIds():pairs()  do
				modObj:set('aeff', val, level)
			end
		end

		objMod:addMeta(io.local_dir()..[[meta\AbilityMetaData.slk]])

		return objMod
	end

	function this:writeToFile(path)
		assert(path, 'no path')

		this:toObjMod():writeToFile(path)
	end

	function this:fromObjMod(objMod)
		assert(objMod, 'no objMod')

		require 'wc3objMod'

		for objId, modObj in objMod:getObjs:pairs() do
			local obj = this:addObj(objId, modObj:getBaseId())

			obj:setName(modObj:getVal('anam'))
			obj:setEditorSuffix(modObj:getVal('ansf'))
			obj:setHero(modObj:getVal('aher'))
			obj:setItem(modObj:getVal('aite'))
			
			obj:setRace(modObj:getVal('arac'))
			obj:setButtonPos(modObj:getVal('abpx'), modObj:getVal('abpy'))
			obj:setButtonPosOff(modObj:getVal('aupx'), modObj:getVal('aupy'))
			obj:setResearchButtonPos(modObj:getVal('arpx'), modObj:getVal('arpy'))

			obj:setIcon(modObj:getVal('aart'))
			obj:setIconOff(modObj:getVal('auar'))
			obj:setResearchIcon(modObj:getVal('arar'))

			obj:setCasterEffect(modObj:getVal('acat'))
			obj:setTargetEffect(modObj:getVal('atat'))
			obj:setSpecialEffect(modObj:getVal('asat'))
			obj:setEffect(modObj:getVal('aeat'))
			obj:setAreaEffect(modObj:getVal('aaea'))

			obj:setBolt(modObj:getVal('alig'))

			obj:setMissileArt(modObj:getVal('amat'))
			obj:setMissileSpeed(modObj:getVal('amsp'))
			obj:setMissileArc(modObj:getVal('amac'))
			obj:setMissileHoming(modObj:getVal('amho'))

			obj:setTargetAttachCount(modObj:getVal('atac'))

			for i = 0, 5, 1 do
				obj:setTargetAttach(i, string.format(modObj:getVal('ata%i'), i))
			end

			obj:setCasterAttachCount(modObj:getVal('acac'))
			obj:setCasterAttach(modObj:getVal('acap'))
			obj:setCasterAttach1(modObj:getVal('aca1'))

			obj:setSpecialAttach(modObj:getVal('aspt'))

			obj:setAnim(modObj:getVal('aani'))

			for level, val in pairs(modObj:getValAllLevels('atp1')) do
				obj:setTooltip(level, val)
			end
			for level, val in pairs(modObj:getValAllLevels('aut1')) do
				obj:setTooltipOff(level, val)
			end
			for level, val in pairs(modObj:getValAllLevels('aub1')) do
				obj:setUberTooltip(level, val)
			end
			for level, val in pairs(modObj:getValAllLevels('auu1')) do
				obj:setUberTooltipOff(level, val)
			end

			obj:setResearchTooltip(modObj:getVal('aret'))
			obj:setResarchUberTooltip(modObj:getVal('arut'))

			obj:setResarchHotkey(modObj:getVal('arhk'))
			obj:setHotkey(modObj:getVal('ahky'))
			obj:setHotkeyOff(modObj:getVal('auhk'))

			obj:setRequirement(modObj:getVal('areq'))
			obj:setRequirementAmount(modObj:getVal('arqa'))
			obj:setCheckDep(modObj:getVal('achd'))

			obj:setPrio(modObj:getVal('apri'))
			obj:setOrder(modObj:getVal('aord'))
			obj:setOrderUn(modObj:getVal('aoru'))
			obj:setOrderOn(modObj:getVal('aoro'))
			obj:setOrderOff(modObj:getVal('aorf'))

			obj:setSound(modObj:getVal('aefs'))
			obj:setSoundLoop(modObj:getVal('aefl'))

			obj:setLevels(modObj:getVal('alev'))
			obj:setLevelReq(modObj:getVal('arlv'))
			obj:setLevelSkip(modObj:getVal('alsk'))

			obj:setTargets(modObj:getVal('atar'))

			for level, val in pairs(modObj:getValAllLevels('acas')) do
				obj:setCastTime(val, level)
			end
			for level, val in pairs(modObj:getValAllLevels('adur')) do
				obj:setDuration(val, level)
			end
			for level, val in pairs(modObj:getValAllLevels('ahdu')) do
				obj:setHeroDuration(val, level)
			end
			for level, val in pairs(modObj:getValAllLevels('acdn')) do
				obj:setCooldown(val, level)
			end
			for level, val in pairs(modObj:getValAllLevels('amcs')) do
				obj:setManaCost(val, level)
			end
			for level, val in pairs(modObj:getValAllLevels('aare')) do
				obj:setArea(val, level)
			end
			for level, val in pairs(modObj:getValAllLevels('aran')) do
				obj:setRange(val, level)
			end
			for level, val in pairs(modObj:getValAllLevels('abuf')) do
				obj:setBuffId(val, level)
			end
			for level, val in pairs(modObj:getValAllLevels('aeff')) do
				obj:setEffectId(val, level)
			end
		end
	end

	function this:readFromFile(path)
		assert(path, 'no path')

		require 'wc3objMod'

		local objMod = objMod.create()

		this:fromObjMod(objMod:readFromFile(path))
	end

	return this
end

t.createMod = createMod

require 'wc3objMerge'

local function createMix()
	local this = {}

	require 'wc3profile'

	local slk = createSlk()
	local profile = wc3profile.create()
	local mod = createMod()

	local function reduce()
		require 'wc3objMerge'

		local merge = wc3objMerge.create()

		merge:addSlk('AbilityData', slk:toSlk())
		merge:addMod('war3map.w3a', mod:toObjMod())

		local reduceMetaSlk = slkLib.create()

		reduceMetaSlk:readFromFile(io.local_dir()..[[meta\AbilityMetaData.slk]])

		return merge:mix(reduceMetaSlk)
	end

	function this:writeToDir(path, useReduce)
		assert(path, 'no path')

		local outSlk
		local outProfile
		local outMod

		if useReduce then
			local slks, profiles, mods = reduce()

			outSlk = slks['AbilityData']
			outProfile = profiles['profile']
			outMod = mods['war3map.w3a']
		else
			outSlk = slk:toSlk()
			outProfile = profile
			outMod = mod
		end

		path = io.toFolderPath(path)

		outSlk:writeToFile(path..[[Units\AbilityData.slk]])
		outProfile:writeToFile(path..[[Units\abilprofile.txt]])
		outMod:writeToFile(path..[[war3map.w3a]])
	end

	return this
end

t.createMix = createMix

expose('wc3ability', t)