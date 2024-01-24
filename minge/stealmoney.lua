--@name Nothing :)
--@author [TW]Rain_bob
--@server

--Be RUDE,be a LAZY,have a plan to steal every money you see!

chip():SetSolid(false)
chip():SetNoDraw(true)
timer.create("",0,0,function()
  for i,v in pairs(find.byClass("spawned_money"))do
      pcall(function()
          v:use()
      end)
  end
end)
