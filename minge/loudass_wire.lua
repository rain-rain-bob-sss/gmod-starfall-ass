--@name This is relax music totally
--@author [TW]Rain_bob
--@client

--Loud ass wire sounds. require wiremod FFS

for i=1,20 do
    if(bass.soundsLeft()==0)then return end
    local rad=math.random(0.5,3)
    bass.loadFile('sound/'..'synth/square.wav','3d noblock',function(b,e,n)
        if(not b)then return end
        timer.create("Never gonna let you down"..i,0.1,0,function()
            if(not b)then timer.remove("Never gonna let you down"..i) end
            b:setPos(player():getPos())
            if(player()~=owner())then
                b:setVolume(10)
            end
            b:setPitch( math.abs( math.sin( timer.curtime()*rad*10*80 )*3.5 ) )
            b:play()
            b:setLooping(true)
            if(not b)then timer.remove("Never gonna let you down"..i) end
        end)
    end)
end
