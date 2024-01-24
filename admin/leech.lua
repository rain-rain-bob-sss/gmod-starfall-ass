--@name leech
--@author [TW]Rain_bob
--@server
local timers={} --timerex
local first=false
timerex=class("timerex")
function timerex:initialize(name,time,times,func)
    if(not first)then
        first=true
    end
    timers[name]=self
    self.name=name
    self.time=time
    self.nexttime=timer.curtime()+time
    self.func=func
    self.remain=times or nil
    self.stop=false
end
function timerex:check()
    if(self.remain!=nil)then
        if(self.remain<1)then
            timers[self.name]=nil
            self=nil
            --print("noo")
            return false
        end
        self.remain=self.remain-1
    end
    return true
end
function timerex:destory()
    timers[self.name]=nil
    self=nil
end
function timerex:stop()
    self.stop=true
end
function timerex:start()
    self.stop=false
end
function timerex:think()
    if(timers[self.name])then
        if(self.nexttime<=timer.curtime())then
            if(self:check() and (not self.stop))then
                self.nexttime=self.time+timer.curtime()
                local r=self.func(self.remain)
                if(r==true)then
                    self:destory()
                    self.func=function() end
                end
            end
        end
        --print'e'
    end
    --print(self.nexttime<timer.curtime())
end
local funcs = {}
function funcs.simpletime(time,func)
    local timerex = timerex:new(math.random(-9999,9999).."ye"..math.random(-500,500),time,1,func)
    return timerex
end
function funcs.advtime(name,time,times,func)
    local te = timerex:new(name,time,times,func)
    if(timers[name])then
        timers[name]=te
    end
    return te
end
function funcs.remove(name)
    if(timers[name])then
        --print("ok")
        timers[name]:destory()
    end
end
function funcs.getTbl()
    return timers
end
function funcs.dohook()
    hook.add("think","timerexthink",function()
        for i,v in pairs(timers)do
            if(v)then
                xpcall(function()
                    local e=hook.run("TimerEXShouldRun",v)
                    if(e==false)then return end
                    v:think()
                    --print(v)
                    hook.run("TimerEXThink",v)
                end,function(e,st)
                    --print(e,st)
                    hook.run("TimerEXERROR",v,e,st)
                end)
            end
        end
        --print("noo2")
    end)
end
ft = timer.frametime
ct=timer.curtime
function funcs.frametime()
    return ft()
end
function funcs.curtime()
    return ct()
end
local tm=funcs
tm.dohook()
function AddTask(tm,name,Stop,Run)
    local ended=false
    tm.advtime(name,0,nil,function()
        if(ended)then return end
        if(not Stop())then
            if(Run())then
                ended=true
                tm.remove(name)
            end
        end
    end)
end
--Leech shit starts
local leeches={}
for i=1,20 do
    local holo=hologram.create(chip():getPos(),chip():getAngles(),"models/leech.mdl")
    leeches[i]={holo=holo}
    AddTask(tm,"leachsnd"..i,function()
        return not sound.canCreate()
    end,function()
        local snd=sound.create(holo,"ambient/creatures/leech_bites_loop1.wav")
        snd:stop()
        leeches[i].snd=snd
        return true
    end)
    holo:setAnimation("attackloop"..math.random(1,4),0,math.random(0.4,3.5))
end
AddTask(tm,"done",function()
    local count=0
    for i,v in pairs(leeches)do
        if(v.snd)then
            count=count+1
            print(count)
        end
    end
    return count~=20
end
,function()
    done()
    return true
end)
local whTick = 0
function done()
function WaterHurts()
    if true then
        if whTick < timer.curtime() then
            for _, v in pairs(find.allPlayers()) do
                if v:getWaterLevel() >= 1 and v:isAlive() then
                    pcall(function()
                        v:applyDamage(v:getHealth()/8+2,chip(),game.getWorld(),268435456,v:getPos())
                        local index=v:entIndex()
                        leeches[index].holo:setPos(v:getPos()+Vector(0,0,20))
                        leeches[index].snd:play()
                        local i=0
                        if(not timer.exists("goback..index"))then
                            timer.create("goback"..index,0.01,50,function()
                                i=i+1
                                if(i==50)then
                                    leeches[index].holo:setPos(chip():getPos())
                                    leeches[index].snd:stop()
                                end
                            end)
                        end
                        --v:setEyeAngles(v:getEyeAngles()*1.255)
                        --v:stripAmmo()
                    end)
                end
            end    
            for _, v in pairs(find.byClass("npc_*")) do
                if bit.band(trace.pointContents(v:getPos()),32)==32 then
                    pcall(function()
                        v:applyDamage(v:getHealth()/8+2,game.getWorld(),game.getWorld(),268435456,v:getPos())
                    end)
                end
            end 
            whTick = timer.curtime() + 0.1
        end
    end
end
hook.add("Tick", "flood waterhurt function",WaterHurts)
end
