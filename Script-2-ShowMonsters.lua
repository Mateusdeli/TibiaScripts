local config = {
	items = {2767, 5545}, -- Id dos items
	time = 1, -- Tempo em segundos para aparecer o boss
	effect = 10, -- Efeito que ira sair quando o boss aparecer
	remover_item_clicado = true, -- true = Remover o Item que foi dado o Use, false = Não remover
	remover_item_player = true, -- true = Remover o Item que foi usado, false = Não remover
	bosses_name = {"demon", "orc", "wolf"}, -- Nome dos bosses
}

function onUse(cid, item, frompos, itemEx, topos)

	for i=1, #config.items do 
		if (config.items[i] == itemEx.itemid) then

			if (getPlayerItemCount(cid, item.itemid) < 1) then
				return false
			end

			if (config.remover_item_player) then
				if (item.itemid > 0) then
					doPlayerRemoveItem(cid, item.itemid, 1)
				end
			end

			if (config.remover_item_clicado) then
				if (itemEx.uid > 0) then
					doRemoveItem(itemEx.uid, 1)
				end
			end
			
			addEvent(function()
				doCreateMonster(config.bosses_name[math.random(1, #config.bosses_name)], topos)
				doSendMagicEffect(topos, config.effect)
			end, config.time*1000)
		end
	end
end

-- XML

<action actionid="100" event="script" value="ankha.lua" />
