local chance = {

    chance_gold = 30, -- chance de 1 a 100 para conseguir o item (Quanto menor o numero mais dificil)
    chance_platinum = 15, -- chance de 1 a 100 para conseguir o item (Quanto menor o numero mais dificil)
    chance_crystal = 5  -- chance de 1 a 100 para conseguir o item (Quanto menor o numero mais dificil)
    }
    
    local itens = {
    
    interval = 20,   -- Intervalo para ser criada a pedra em SEGUNDOS..
    reward_1 = 2148, -- recompensa 1
    reward_2 = 2152, -- recompensa 2
    reward_3 = 2160 -- recompensa 3
    
    }
    
    
    function onUse(cid, item, fromPos, itemEx, toPos)
     
     if itemEx.itemid == 5622 and math.random (1, 100) <= chance.chance_gold then
              doSendMagicEffect(toPos, 28)
               doSendAnimatedText(getThingPos(cid), "Mining", 35)
                doTransformItem (itemEx.uid, 2148, 1)
                addEvent(doCreateItem, itens.interval * 1000, 5622, 1, toPos)
              
              else
                doSendAnimatedText(getThingPos(cid), "Fail", 30)
     end
               
           if itemEx.itemid == 5622 and math.random (1, 100) <= chance.chance_platinum then
                    doSendMagicEffect(toPos, 1)
                     doSendAnimatedText(getThingPos(cid), "Mining", 36)
                      doTransformItem (itemEx.uid, 2152, 1)
                       addEvent(doCreateItem, itens.interval * 1000, 5622, 1, toPos)
           end       
               if itemEx.itemid == 5622 and math.random (1, 100) <= chance.chance_crystal then
                    doSendMagicEffect(toPos, 30)
                     doSendAnimatedText(getThingPos(cid), "Mining", 31)
                      doTransformItem (itemEx.uid, 2160, 1)
                       addEvent(doCreateItem, itens.interval * 1000, 5622, 1, toPos)
               end
           return true
    end

<action actionid="6969" event="script" value="mineracao.lua"/>