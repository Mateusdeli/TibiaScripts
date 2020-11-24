local config = {
	items = {
		[1] = {id = 2650, count = 1},
		[2] = {id = 2160, count = 15}, 
		[3] = {id = 2160, count = 26}, 
		[4] = {id = 2382, count = 2}
	}, 
}

function onSay(player, words, param)

	if not (player:getGroup():getAccess()) then
		return false
	end

	for _,pid in ipairs(getOnlinePlayers()) do
		local player = Player(pid)
		if (player:isPlayer() and not player:getGroup():getAccess()) then
			player:sendTextMessage(TALKTYPE_ORANGE_1, "Parabens, voce recebeu os seguintes items do ADM!")	
			for i=1, #config.items do
				player:addItem(config.items[i].id, config.items[i].count)
				local itemType = ItemType(config.items[i].id)
				player:sendTextMessage(3, "- "..config.items[i].count.." "..itemType:getName().."(s).")	
			end
		end
	end
end

-- XML 

<talkaction words="/items" separator=" " script="items.lua" />