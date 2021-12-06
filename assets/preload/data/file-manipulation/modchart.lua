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
end