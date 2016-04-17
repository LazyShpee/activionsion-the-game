function love.load(args)
	math.randomseed(os.time())

	mapImage = love.graphics.newImage("res/maptest1.png")
	mapImage:setFilter("nearest")
	mapData = mapImage:getData()
	print(unpack(execPixel(mapImage, mapData, 8, 716)))

	player = {
		x = -1,
		y = -1,
		cols = {
			{2, 0},
			{-2, 0},
			{2, 5},
			{-2, 5}
		},
		step = 0
	}
	print(unpack(findPixel(mapImage, mapData, {1, 0, 0, 255})))
end

function collide(image, data, x, y, col)

end

function findPixel(image, data, pixel, opt)
	-- opt -> remove, ignoreAlpha
	local w, h = image:getDimensions()
	opt = opt or {}
	data = data or image:getData()
	local pos
	for x = 0, w - 1 do
		for y = 0, h - 1 do
			local r, g, b, a = data:getPixel(x, y)
			if r == pixel[1] and g == pixel[2] and b == pixel[3] and (opt.ignoreAlpha or a == pixel[4]) then
				pos = {x, y, x = x, y = y}
				if opt.remove then
					data:setPixel(x, y, 0, 0, 0, 0)
				end
			end
		end
	end
	return pos
end

-- 1 - player
-- 200 - wire

function inTable(item, tab)
	for k, v in pairs(tab) do
		if item == v then
			return k, v
		end
	end
	return nil, nil
end

function isLogic(pixel)
	local logic = {2, 200}
	return inTable(pixel[1], logic)
end

function execPixel(image, data, x, y, opt)
	-- opt -> erase
	opt = opt or {}
	local w, h = image:getDimensions()
	if x < 0 or y < 0 or w <= x or h <= y then
		return false
	end
	local pixel = {data:getPixel(x, y)}
	if not isLogic(pixel) then
		return false
	end

	data:setPixel(x, y, 0, 0, 0, 255)
	local ret = execPixel(image, data, x + 1, y, opt) or execPixel(image, data, x - 1, y, opt) or execPixel(image, data, x, y + 1, opt) or execPixel(image, data, x, y - 1, opt) or pixel
	if not opt.erase then
		data:setPixel(x, y, unpack(pixel))
	end
	return ret
end

function renderGame()
	local w, h = love.graphics.getDimensions()
	local rectangle = love.graphics.rectangle

	love.graphics.setColor({255, 255, 255})
	love.graphics.draw(mapImage)
	love.graphics.setBackgroundColor({144, 144, 144})
	love.graphics.setColor({0, 0, 0})
end

function random_color()
	return {math.random(255), math.random(255), math.random(255), 255}
end

function love.draw()
	love.graphics.setDefaultFilter("nearest")
	love.graphics.scale(10, 10)
	love.graphics.translate(0, -648)
	renderGame()

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
