
hex_center = {}
HEX_SIZE = 40
HEX_W = HEX_SIZE * 2
HEX_H = HEX_W * math.sqrt(3)*0.5

CUBE_DIRECTIONS = { 
	{1, -1, 0}, 	{1, 0, -1}, 	{0, 1, -1}, 
	{-1, 1, 0}, 	{-1, 0, 1},  {0, -1, 1}
}

HEX_DIRECTIONS = { 
	{1, 0}, 	{1, -1}, 	{0, -1}, 
	{-1,  0}, 	{-1, 1}, 	{0, 1}
}

HEX_ZERO = {}
HEX_ZERO.x = 0
HEX_ZERO.y = 0


function love.load()
	-- sound = love.audio.newSource("Boom_epic_win.ogg")
	-- love.audio.play(sound)
end

function love.draw()
	
	-- love.graphics.clear()
	
	for i=0,12,1
	do
		for j=0,7,1
		do
			local hex_odd = hex(i,j)
			hex_center = get_hex_center(hex_odd)
			draw_hex(hex_center, HEX_SIZE, color(0, 127, 127))
		end	
	end
	
	
	--draw neighbor
	hx1 = hex(6, 3) 
	center_pt = get_hex_center(hx1)
	draw_hex(center_pt, HEX_SIZE, color(127,0, 0))
	
	cb1 = oddq_to_cube(hx1)
	for i=0,5,1
	do
		cb_neighbor = cube_neighbor(cb1,i)
		-- print("x=", cb_neighbor.x, "\ty=", cb_neighbor.y, "\tz =", cb_neighbor.z)
		-- debug.debug()
		hx_neighbor = cube_to_oddq(cb_neighbor)
		if(hx_neighbor.q>=0 and hx_neighbor.q<=12 and hx_neighbor.r>=0 and hx_neighbor.r<=7)
		then
			neighbor_center_pt = get_hex_center(hx_neighbor)
			draw_hex(neighbor_center_pt, HEX_SIZE, color(0, 127, 0))		
		end
	end
	

end


function hex_cornor(center, size, i)
	local angle_deg = 60 * i
	local angle_rad = math.pi/180 * angle_deg
	return center.x + size * math.cos(angle_rad), center.y + size * math.sin(angle_rad)
end

function draw_hex_outline(x1, y1, x2, y2)
	love.graphics.line(x1, y1, x2, y2)
end

function draw_hex(center, size, color)
	if(color == nil)
	then
		color = color(255,255,255)
	end
	
	for i=0,5,1
	do
		local x1, y1 = hex_cornor(center, size, i)
		local x2, y2 = hex_cornor(center, size, i+1)
		
		love.graphics.setColor(color.r, color.g, color.b, color.a)
		draw_hex_polygon(center, point(x1,y1), point(x2, y2))
		
		love.graphics.setColor(255,255,255)
		draw_hex_outline(x1, y1, x2, y2)
	end
end

function draw_hex_polygon( center, pt1, pt2)
	love.graphics.polygon('fill', center.x, center.y, pt1.x, pt1.y, pt2.x, pt2.y)
end



----cube coordination caculation
function cube_direction(dir)
	local direction = CUBE_DIRECTIONS[dir+1]
	return cube(direction[1], direction[2], direction[3])
end

function cube_neighbor(cube, direction)
	local dir = cube_direction(direction)
	return cube_add(cube, dir)
end


function cube_add(cube1, cube2)
	return cube(cube1.x+cube2.x, 
							cube1.y+cube2.y, 
							cube1.z+cube2.z)
end


function hex_direction(dir)
	local direction = HEX_DIRECTIONS[dir+1]
	return hex(direction[1], direction[2])
end

function hex_neighbor(hex1, direction)
	local dir = hex_direction(direction)
	return hex(hex1.q + dir.q, hex1.r + dir.r)
end

-- get center x,y of a hexagon. (odd-q type)
function get_hex_center(hex)
	x = hex.q * HEX_W * 0.75 + 0.5 * HEX_W
	y = hex.r * HEX_H  + (hex.q%2)*0.5*HEX_H  + 0.5 * HEX_H
	return point(x, y)
end








----coordination conversion
-- function cube_to_hex(cx, cy, cz)
	-- return cx, cz
-- end

-- function hex_to_cube(q, r)
	-- return q, -x-z, z
-- end

function cube_to_oddq(cube)
	return hex(cube.x,  cube.z + (cube.x - cube.x%2)/2)
end

function oddq_to_cube(hex)
	x = hex.q
	z = hex.r - ( hex.q - hex.q%2)/2
	y = -x-z
	return cube(x, y, z)
end

function hex(q, r)
	local hex = {}
	hex.q = q
	hex.r = r
	return hex
end

function cube(x, y, z)
	local cube = {}
	cube.x = x
	cube.y = y
	cube.z = z
	return cube
end

function point(x,y)
	local point = {}
	point.x = x
	point.y = y
	return point
end

function color(r, g, b, a)
	local color = {};
	color.r = r
	color.g = g
	color.b = b
	color.a = a
	return color
end