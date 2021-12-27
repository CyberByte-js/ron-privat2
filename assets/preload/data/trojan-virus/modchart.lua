local moveing = false

function update (elapsed)
    local currentBeat = (songPos / 1000)*(bpm/60)
    if moveing then
        for i=0,7 do
            setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat + i*0.25) * math.pi), i)
        end
    else
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 16 * math.sin((currentBeat/4 + i*0.25) * math.pi), i)
		end
	end
end

function stepHit(step)
	if curStep == 384 then
		moveing = true
	end
    if curStep == 640 then
		moveing = false
    end
end