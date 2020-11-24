monster_name_backup = 74812 -- nao mexer
monster_exp_backup = 74813 -- nao mexer
monster_loot_backup = 74814 -- nao mexer

config_boosted = {

    ["00:00:00"] = { -- Horario de cada dia que irá ocorrer a troca dos monstros
        pos_monster = {x=161,y=58,z=7, stackpos = 253}, -- a posição aonde ficara o monstro informando a quantidade de exp e loot
        time_effects = 2 -- tempo em segundos que ficará saindo os efeitos
    }
    
}

monsters_boosteds = { -- Configuracao dos monstros que irão ter exp e loot aumentados
	[1] = {monster_name = "Dwarf", exp = 5, loot = 7},
	[2] = {monster_name = "Goblin", exp = 15, loot = 5},
	[3] = {monster_name = "Orc", exp = 25, loot = 15},
    [4] = {monster_name = "Dwarf Soldier", exp = 35, loot = 10},
    --[5] = {monster_name = "NOME DO MONSTRO", exp = "PORCENTAGEM DE EXP", loot = "PORCENTAGEM DO LOOT"},
}

function onThink(interval, lastExecution)
	local current_hour = os.date("%X")
	if config_boosted[current_hour] then
		local time = config_boosted[current_hour]
		
		local monster = getTopCreature(time.pos_monster).uid
		local random_monster = monsters_boosteds[math.random(1, #monsters_boosteds)]
		if (monster >= 1) then
			doRemoveCreature(monster)
		end
		SummonMonster(time, random_monster)
		setGlobalStorageValue(monster_name_backup, random_monster.monster_name)
		setGlobalStorageValue(monster_exp_backup, random_monster.exp)
		setGlobalStorageValue(monster_loot_backup, random_monster.loot)
	end
	return true
end 	


function SummonMonster(time, monster)
	doCreateMonster(monster.monster_name, time.pos_monster)
	effectsMonster(time, monster)
end

function effectsMonster(time, monster)

	effectLoot(time.pos_monster, monster)
	effectExp(time.pos_monster, monster)
	doSendMagicEffect(time.pos_monster, 30)
	doSendAnimatedText(time.pos_monster, "Boosted", COLOR_DARKYELLOW)

	addEvent(function()
		effectsMonster(time, monster)
	end, time.time_effects * 1000)
end

function effectLoot(pos, monster)
	local pos_effect = {x=pos.x, y=pos.y-1, z=pos.z}
	doSendMagicEffect(pos_effect, 29)
	doSendAnimatedText(pos_effect, "Loot +"..monster.loot.."%", COLOR_DARKYELLOW)
end

function effectExp(pos, monster)
	local pos_effect = {x=pos.x, y=pos.y+1, z=pos.z}
	doSendMagicEffect(pos_effect, 29)
	doSendAnimatedText(pos_effect, "EXP +"..monster.exp.."%", COLOR_DARKYELLOW)
end

function onKill(cid, target, damage, flags)
	
	if not (isMonster(target)) then
		return true
	end

	if (string.lower(getCreatureName(target)) == string.lower(getGlobalStorageValue(monster_name_backup))) then
		local exp = tonumber(getGlobalStorageValue(74813))
		doPlayerSetRate(cid, SKILL__LEVEL, getExperienceStage(getPlayerLevel(cid))*(getGlobalStorageValue(monster_exp_backup) / 1000))
		addLoot(getCreaturePosition(target), getCreatureName(target), {})
	else
		doPlayerSetRate(cid, SKILL__LEVEL, 1)
	end

	return true
end

function addLoot(position, name, ignoredList)
    local check = false
    for i = 0, 255 do
        position.stackpos = i
        corpse = getTileThingByPos(position)
        if corpse.uid > 0 and isCorpse(corpse.uid) then
            check = true 
            break
        end
    end
	if check == true then
        local newRate = (1 + (getGlobalStorageValue(monster_loot_backup)/100)) * getConfigValue("rateLoot")
        local mainbp = doCreateItemEx(1987, 1)
        local monsterLoot = getMonsterLootList(name)
        for i, loot in pairs(monsterLoot) do
            if math.random(1, 100000) <= newRate * loot.chance then 
                if #ignoredList > 0 then
                    if (not isInArray(ignoredList, loot.id)) then
                        doAddContainerItem(mainbp, loot.id, loot.countmax and math.random(1, loot.countmax) or 1)
                    end
                else
                    doAddContainerItem(mainbp, loot.id, loot.countmax and math.random(1, loot.countmax) or 1)
                end
            end
        end
        doAddContainerItemEx(corpse.uid, mainbp)  
    end
end

registerCreatureEvent(cid, "BoostedMonster")

<globalevent name="boosted" interval="1000" event="script" value="boosted.lua"/>
<event type="kill" name="BoostedMonster" event="script" value="boosted.lua"/>