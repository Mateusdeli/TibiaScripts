local config = {
    ids = {2157, 2159},                        --ID do item.
    drop_effect = false                    --Efeito que aparecerá em cima da corpse (apenas para o dono da corpse). OPCIONAL! Se não quiser, coloque false.
}
 
function examine(cid, position, corpse_id, name)
    if not isPlayer(cid) then return true end
    local corpse = getTileItemById(position, corpse_id).uid
    
    if corpse <= 1 or not (corpse) then return true end
 
    for slot = 0, getContainerSize(corpse) - 1 do
        local item = getContainerItem(corpse, slot)
        if item.uid <= 1 then return true end
        

        for i=1, #config.ids do
            if (item.itemid == config.ids[i]) then
                doBroadcastMessage("[LOOT MENSAGEM]: O jogador ("..getCreatureName(cid)..") dropou um "..string.lower(getItemNameById(config.ids[i])).." de um ("..name..").", 19)
                    if config.drop_effect then
                        doSendMagicEffect(position, config.drop_effect, cid)
                    end
            end
        end
    end
end
 
function onKill(cid, target)
    if not isMonster(target) then return true end
    local monster_name = getCreatureName(target)
    
    local corpse_id = getMonsterInfo(monster_name).lookCorpse
 
    addEvent(examine, 5, cid, getThingPos(target), corpse_id, monster_name)
    return true
end