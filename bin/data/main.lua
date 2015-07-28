function love.load()
	sound = love.audio.newSource("Boom_epic_win.ogg")
	love.audio.play(sound)
end

function love.draw()
	var center = {};
	center.x = 200;
	center.y = 200;
	var size = 20;
	
	var p1,p2;
	for  i=1,6,1 
	do
		x1, y1 = hex_cornor(center, size, i-1)
		p2 = hex_cornor(center, size, i)
		draw_hex_edge(p1,p2)
	end

end


function hex_cornor(center, size, i)
	var angle_deg = 60 * i
	var angle_rad = PI/180 * angle_deg
	return center.x + size * math.cos(angle_rad), center.y + size * math.sin(angle_rad)
end

function draw_hex_edge(x1, y1, x2, y2)
	love.graphics.line(x1, y1, x2, y2)
end