
center = {}
size = 40

function love.load()
	sound = love.audio.newSource("Boom_epic_win.ogg")
	love.audio.play(sound)
end

function love.draw()
	
	center.x = 200;
	center.y = 200;
	
	love.graphics.clear()
	love.graphics.setColor(255,255,255)
	
	for  i=1,6,1 
	do
		x1, y1 = hex_cornor(center, size, i-1)
		x2, y2 = hex_cornor(center, size, i)
		draw_hex_edge(x1, y1, x2, y2)
	end

end


function hex_cornor(center, size, i)
	local angle_deg = 60 * i
	local angle_rad = math.pi/180 * angle_deg
	return center.x + size * math.cos(angle_rad), center.y + size * math.sin(angle_rad)
end

function draw_hex_edge(x1, y1, x2, y2)
	love.graphics.line(x1, y1, x2, y2)
end