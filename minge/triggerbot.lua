--@name trigger
--@author
--@client
--this is a dumb triggerbot
--this uses concmd
--have fun with getting ban
if not player()==owner() then return end
local button = KEY.G
local t=false
-------------------------------------------

hook.add("InputPressed", "", function(key)
    if key ~= button then return end
    t=true
end)

hook.add("InputReleased", "", function(key)
    if key ~= button then return end
    t=false
end)
ha = hook.add
hn = "triggerbot"
--Ass things
trace.glualine = function(tbl)
    local r = trace.line(tbl.start,tbl.endpos,tbl.filter,tbl.mask,tbl.collisiongroup,tbl.ignoreworld)
    return r
end
trace.gluahull = function(tbl)
    local r = trace.hull(tbl.start,tbl.endpos,tbl.mins,tbl.maxs,tbl.filter,tbl.mask,tbl.collisiongroup,tbl.ignoreworld)
    return r
end
ha("think",hn,function()
    if(not t)then return end
    local tr = trace.glualine({
        start=owner():getShootPos(),
        endpos=owner():getShootPos()+owner():getAimVector()*50000,filter={owner()}
        ,ignoreworld=false,
        mask=MASK.SHOT})
    if(tr.Entity==nil)then
        local tr = trace.gluahull({
        start=owner():getShootPos(),
        mins=Vector(-0.1),
        maxs=Vector(0.1),
        endpos=owner():getShootPos()+owner():getAimVector()*50000,filter={owner()}
        ,ignoreworld=false,
        mask=MASK.SHOT})
    end
    if(tr.Hit)then
        if(tr.Entity)then
            pcall(function()
                if(tr.Entity:isPlayer() or tr.Entity:isNPC())then
                    local wep = owner():getActiveWeapon()
                    if(wep:maxClip1()>0 or wep:maxClip2()>0)then
                        if(wep:clip1()==0 or wep:clip2()==0)then
                            return
                        end
                    end
                    concmd("+attack")
                    timer.create("-attackdelay",0.02,1,function()
                        concmd('-attack')
                    end)
                end
            end)
        end
    end
end)
