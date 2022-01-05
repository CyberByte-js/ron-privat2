local funny = false

function setDefault(id)
    _G['defaultStrum'..id..'X'] = getActorX(id)
end

function start (song)

end

function update (elapsed)
    local currentBeat = (songPos / 1000)*(bpm/60)
    if funny then
        for i=0,7 do
            setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat + i*0.25) * math.pi), i)
        end
		setWindowPos(24 * math.sin(currentBeat * math.pi) + 327, 24 * math.sin(currentBeat * 3) + 160)
    end
end

function stepHit(step)
    if curStep >= 538 then
        funny = true
    end
	if curStep >= 816 and curStep <= 848 and curStep % 2 == 0 then
		cameraZoom = cameraZoom + 0.025
	end
	if curStep >= 880 and curStep <= 912 and curStep % 2 == 0 then
		cameraZoom = cameraZoom + 0.025	
	end
	if curStep == 913 then
		cameraZoom = 0.9
	end
end