--@name JG SCORE HUD
--@author [TW]Rain_bob
--@client 

--Bad code warning!

if player() == owner() then
    enableHud( owner(), true )
end
local font = render.createFont( "Verdana", 16, 800, true )
local ply=owner()
local mx,my=0,0
hook.add("mousemoved","hudoffset",function(x,y)
    mx,my=mx+x*-0.18,my+y*-0.18
end)
function formatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local remainingSeconds = seconds % 60

    return string.format("%02d:%02d:%02d", hours, minutes, remainingSeconds)
end

local totallytimeused=0
local timeused=0
local yobestscore=0
hook.add("drawhud","jbscore",function()
    local _, y = render.getResolution()
    local size=0
    render.setFont(font)
    local bestscore=0
    for i,v in pairs(find.allPlayers())do
        local s=(v:getNWVar("JBScore") or 0)
        if(s>bestscore)then
            bestscore=s
        end
    end
    local score=player():getNWVar("JBScore") or 0
    local TTS = formatTime(math.round(totallytimeused))
    local TS = formatTime(math.round(timeused))
    local strs={
        "Current best score in server:"..bestscore,
        "Owner's Score: " .. (ply:getNWVar("JBScore") or 0),
        "Your Score: " .. score,
        "Your Best Score: ".. yobestscore,
        "Your Velocity:" .. (math.round(player():getVelocity():getLength(),3)),
        "Your Totally playing time:" .. (TTS) .."\n(only records if you enabled hud)",
        "\nYour playing time:" .. (TS) .."\n(only records if you enabled hud)"
        }
    if(yobestscore<score)then
        yobestscore=score
    end
    if(score>0)then
        timeused=timeused+timer.frametime()
        totallytimeused=totallytimeused+timer.frametime()
    else
        timeused=0
    end
    for i,v in pairs(strs) do
        if(render.getTextSize(v)>size)then
            size=render.getTextSize(v)
        end
    end
    local ys=0
    for i,v in pairs(strs)do
        local xsi,ysi=render.getTextSize(v)
        ys=ys+ysi
    end
    mx,my=mx*0.6,my*0.6
    render.setColor( Color( 20, 20, 20, 220 ) )
    render.drawRect( 180+mx, y / 2+my, (size + 15), ys+65)
    render.setColor( Color() )
    local ys=0
    for i,v in pairs(strs)do
        local xsi,ysi=render.getTextSize(v)
        ys=ys+ysi
        render.drawText(185+mx, y / 2 + ys+my, v )
    end
end)
