--@client
if(owner()~=player())then return end
enableHud(nil,true)
hook.add("drawhud","example",function()
    local mat=Matrix()
    local dist=player():getShootPos():getDistance(chip():getPos())
    local pos=chip():getPos():toScreen()
    
    mat:translate(Vector(pos.x,pos.y))--pos
    mat:scale(Vector(1/dist*500,1/dist*500,1))--scale
    
    render.pushMatrix(mat,false)
    
    render.drawText(0,0,"test",TEXT_ALIGN.CENTER)
    
    render.popMatrix()
end)
