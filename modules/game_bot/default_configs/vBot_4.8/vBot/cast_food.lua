setDefaultTab("HP")
if voc() ~= 1 and voc() ~= 11 then
    macro(500, "Cast Food", function()
        if player:getRegenerationTime() <= 400 then
            cast("exevo pan", 5000)
        end
    end)
end
