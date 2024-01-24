--@name cheat-test
--@author [TW]Rain_bob
--@shared

--Stand on first platform,place this chip,AND DONE!
--Have fun!

if(SERVER)then
local platforms={}
local first
local startingindex=0
local current=1
for i,v in pairs(find.byClass("ent_jgplatform"))do
    local tr=trace.hull(owner():getPos(),owner():getPos()-Vector(0,0,2),Vector(-11.322998046875,-11.2880859375,1),Vector(11.322998046875,11.2880859375,1),{owner()},nil,nil,false)
    --print(tr.Entity)
    if(not first and tr.Entity and tr.Entity==v)then
        startingindex=v:getCreationID()
        print(startingindex)
        first=v
    end
    if(v:getCreationID()>(startingindex)+10)then
        continue
    end
    --print(v:getCreationID())
    platforms[#platforms+1]=v--so we will start looping it!
end 
hook.add("think","start",function()
    local ent=platforms[current]
    if(isValid(ent))then
        local targetpos=ent:getPos()+Vector(0,0,ent:obbMaxs().z-0.05)
        local opos=owner():getPos()
        local pos=opos+( (targetpos-opos):getNormalized()*780*timer.frametime() )
        owner():setPos(pos)
        local opos=owner():getPos()
        owner():setVelocity(owner():getVelocity()*-1+Vector(15,15,0))
        if(targetpos:getDistance(opos)<20)then
            current=current+1
            if(current>10)then
                current=1
                return
            end
        end
    end
end)
end
