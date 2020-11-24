-- Configurações --

effect_invoke_banner = 10 -- efeito que saira no banner quando ele for colocado no chao
effect_decay_banner = 2 -- efeito que saira no banner quando o tempo dele acabar
effect_kill_banner = 36 -- efeito que saira no banner quando o player matar um monstro e ganhar o bonus de exp

banner_radius_x = 5 -- distancia maxima em x que ira ocorreu o bonus
banner_radius_y = 5 -- distancia maxima em y que ira ocorreu o bonus

time_in_minutes = 60 -- configurado em minutos (caso queira em horas só colocar 60 * 60)
remove_banner_item = false -- Se estiver TRUE o item de criacao do banner sera removido do player, caso esteja FALSE o item não sera removido. 

config_banner = {

    --[ID DO ITEM CRIAR O BANNER] = {banner_id = ID DO BANNER, exp_bonus = % EXP PLAYER IRA GANHAR, time_left = TEMPO PARA SUBIR O BANNER},
	[4865] = {banner_id = 8617, exp_bonus = 20, time_left = 20},
	[4866] = {banner_id = 8618, exp_bonus = 25, time_left = 10},
	[4867] = {banner_id = 8619, exp_bonus = 35, time_left = 15},
	[4868] = {banner_id = 8620, exp_bonus = 45, time_left = 20},

}

-- Não Mexer --
time_banner = 7899987 
player_use_banner = 78999788 
storage_banner_x = 7889911 
storage_banner_y = 7889912 
storage_banner_z = 7889913 
storage_banner_id = 7884544 
storage_exp = 7889915 
rate_level = SKILL__LEVEL

function onUse(cid, item, frompos, itemEx, topos)

	if (getPlayerStorageValue(cid, player_use_banner) >= 1) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Voce ja esta usando o banner.")
		return true
	end
	
	if (config_banner[item.itemid]) then
		local banner = config_banner[item.itemid]
		if (remove_banner_item == true or remove_banner_item == TRUE) then
			doPlayerRemoveItem(cid, item.itemid, 1)
		end
		CreateBanner(cid, banner, itemEx)
		TimeBannerCheck(cid, banner, getThingPos(itemEx.uid))
		EffectBanner(getThingPos(itemEx.uid))
	end

end

function CreateBanner(cid, banner, itemEx)
	doCreateItem(banner.banner_id, getThingPos(itemEx.uid))
	doSendMagicEffect(getThingPos(itemEx.uid), effect_invoke_banner)
	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Voce usou o banner de ["..banner.exp_bonus.."% EXP], ele tem duração de "..banner.time_left.." minuto(s).")
	setPlayerStorageValue(cid, storage_banner_x, getThingPos(itemEx.uid).x)
	setPlayerStorageValue(cid, storage_banner_y, getThingPos(itemEx.uid).y)
	setPlayerStorageValue(cid, storage_banner_z, getThingPos(itemEx.uid).z)
	setPlayerStorageValue(cid, storage_banner_id, banner.banner_id)
	setPlayerStorageValue(cid, storage_exp, banner.exp_bonus)
	setPlayerStorageValue(cid, player_use_banner, 1)
	setPlayerStorageValue(cid, time_banner, os.time() + (banner.time_left * time_in_minutes))
end

function TimeBannerCheck(cid, banner, banner_pos)
	if not isCreature(cid) then
		doRemoveItem(getTileItemById(banner_pos, banner.banner_id).uid)
		doSendMagicEffect(banner_pos, effect_decay_banner)
		return true
	end

	if (getPlayerStorageValue(cid, time_banner) == os.time()) then
		doRemoveItem(getTileItemById(banner_pos, banner.banner_id).uid)
		doSendMagicEffect(banner_pos, effect_decay_banner)
		setPlayerStorageValue(cid, player_use_banner, -1)
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "O Banner de ["..banner.exp_bonus.."% EXP] terminou.")
		return true
	end

	addEvent(function()
		TimeBannerCheck(cid, banner, banner_pos)
	end, 1000)
end

function onKill(cid, target)
	
	if not isMonster(target) then
		return true
	end

	if (getPlayerStorageValue(cid, storage_banner_id) <= -1) then
		return true
	end

	local banner_pos = {x=getPlayerStorageValue(cid, storage_banner_x), y=getPlayerStorageValue(cid, storage_banner_y), z=getPlayerStorageValue(cid, storage_banner_z)}

	if (getTileItemById(banner_pos, getPlayerStorageValue(cid, storage_banner_id)).uid >= 1) then
		if not (CheckPlayerInArea(cid, banner_pos)) then
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Voce esta fora da area do bonus.")
		end
	else
		doPlayerSetRate(cid, rate_level,1)
	end

	
	return true
end

function CheckPlayerInArea(cid, banner_pos)
	for x=banner_pos.x-banner_radius_x, banner_pos.x+banner_radius_x do
		for y=banner_pos.y-banner_radius_y, banner_pos.y+banner_radius_y do
			local banner_area = {x=x,y=y,z=banner_pos.z}
			local player = getTopCreature(banner_area).uid
			if (isPlayer(player)) then
				AddBonusExp(cid, banner_pos)
				return true
			end
		end
	end
end

function AddBonusExp(cid, banner_pos)
	doPlayerSetExperienceRate(cid, (1+(getPlayerStorageValue(cid, storage_exp)/100))+(getPlayerExtraExpRate(cid)/100))
	doSendMagicEffect(banner_pos, effect_kill_banner)
end

function getPlayerExtraExpRate(cid)
    return (getPlayerRates(cid)[rate_level]-1)*100
end

registerCreatureEvent(cid, "BannerExp")
	if (getPlayerStorageValue(cid, 78999788) >= 1) then
		setPlayerStorageValue(cid, 78999788, -1)
	end

-- XMLS

<action itemid="4865" script="bannerexp.lua"/>
<event type="kill" name="BannerExp" event="script" value="bannerexp.lua"/>