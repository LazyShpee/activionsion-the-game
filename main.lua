function love.load(args)
	math.randomseed(os.time())

    canvas = love.graphics.newCanvas( )
    cdata = canvas:newImageData()
    map = love.graphics.newImage( "res/maptest1.png" )
 
end

function renderGame()
    local w, h = love.graphics.getDimensions()
    local rectangle = love.graphics.rectangle
    
    love.graphics.setBackgroundColor({144, 144, 144})
    love.graphics.setColor({0, 0, 0})
    love.graphics.draw(map)
    rectangle("fill", w/2, h/2, 5, 5)
end

function random_color()
	return {math.random(255), math.random(255), math.random(255), 255}
end

function love.draw()
    love.graphics.setDefaultFilter("nearest")

    love.graphics.setCanvas(canvas)
    canvas:setFilter("nearest")

    renderGame()

    love.graphics.setCanvas()
    local w, h = love.graphics.getDimensions()
    love.graphics.draw(canvas)
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
