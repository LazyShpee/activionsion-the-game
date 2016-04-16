
function love.load(args)
	math.randomseed(os.time())
end

function random_color()
	return {math.random(255), math.random(255), math.random(255)}
end

function love.draw()
end

function love.keypressed(key)
	if key == 'z' then
    	--pass
    elseif key == 's' then
    	--pass
    elseif key == 'q' then
    	--pass
    elseif key == 'd' then
    	--pass
    end
end
