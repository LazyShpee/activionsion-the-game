local isDown = love.keyboard.isDown

function debug()
	love.graphics.setColor(180,180,180,255)
	love.graphics.rectangle("fill", 0,0, 400,200)
	love.graphics.setColor(220,0,0,255)
	love.graphics.print(player.x.." - "..player.y, 1, 1)
	for k, v in ipairs(player.cols) do
		local r, g, b, a = mapData:getPixel(math.floor(player.x + v[1]), math.floor(player.y + v[2]))
		love.graphics.print(r, 1, 15 * k)
	end
end

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
			{2, -5},
			{-2, -5}
		},
		vert = {
			{2, 0},
			{-2, 0},
			{-2, -5},
			{2, -5}
		},
		step = 0,
		speed = 10
	}
	player.x, player.y = unpack(findPixel(mapImage, mapData, {1, 0, 0, 255}, {remove = true}))
	player.x = player.x + 0.5
	player.y = player.y + 0.5
end

function collide(image, data, x, y, col)
	local colPixels = {}
	for k, v in ipairs(col) do
		local r, g, b, a = mapData:getPixel(math.floor(x + v[1]), math.floor(y + v[2]))
		if a > 0 then
			colPixels[#colPixels + 1] = {r, g, b, a, x = math.floor(x + v[1]), y = math.floor(y + v[2])}
		end
	end
	return colPixels
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
					image:refresh()
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

function addVerts(verts, x, y)
	local vert = {}
	for k, v in ipairs(verts) do
		vert[(k - 1) * 2 + 1] = v[1] + x
		vert[(k - 1) * 2 + 2] = v[2] + y
	end
	return vert
end

function renderPlayer()
	love.graphics.setLineWidth(0)
	love.graphics.polygon("line", addVerts(player.vert, player.x, player.y))

	love.graphics.points(player.x, player.y)
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
	love.graphics.push()
	love.graphics.scale(10, 10)
	love.graphics.translate(0, -648)

	renderGame()
	renderPlayer()

	love.graphics.pop()
	debug()
end

function tryMove(image, data, obj, x, y, step, mode)
	if x ~= 0 and #collide(image, data, obj.x + x, obj.y, obj.cols) == 0 then
		obj.x = obj.x + x
	end
	if y ~= 0 and #collide(image, data, obj.x, obj.y + y, obj.cols) == 0 then
		obj.y = obj.y + y
	end
end

function love.update(dt)
	if isDown("left") then
		tryMove(mapImage, mapData, player, -player.speed * dt, 0)
	elseif isDown("right") then
		tryMove(mapImage, mapData, player, player.speed * dt, 0)
	end
	tryMove(mapImage, mapData, player, 0, player.speed * dt)
end

function love.keypressed(key)
	if key == 'z' then
		player.y = player.y - 3
	elseif key == 's' then
		player.y = player.y + 1
	elseif key == 'q' then
		player.x = player.x - 1
	elseif key == 'd' then
		player.x = player.x + 1
	end
end
