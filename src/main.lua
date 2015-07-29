
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
	
	for i=0,9,1
	do
		for j=0,7,1
		do
			local hex_odd = hex(i,j)
			hex_center = center_odd_q(hex_odd)
			draw_hex(hex_center, HEX_SIZE)
		end	
	end

end


function draw_hex(center, size)
		for  i=0,5,1 
	do
		x1, y1 = hex_cornor(center, size, i)
		x2, y2 = hex_cornor(center, size, i+1)
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



----cube coordination caculation
function cube_direction(dir)
	direction = CUBE_DIRECTIONS[dir+1]
	return cube(direction[1], direction[2], direction[3])
end

function cube_neighbor(hex, direction)
	dir = cube_direction(direction)
	return cube_add(hex_to_cube(hex), dir)
end


function cube_add(cube1, cube2)
	return cube(cube1.x+cube2.x, 
							cube1.y+cube2.y, 
							cube1.z+cube2.z)
end


function center_odd_q(hex)
	x = hex.q * HEX_W * 0.75 + 0.5 * HEX_W
	y = hex.r * HEX_H  + (hex.q%2)*0.5*HEX_H  + 0.5 * HEX_H
	return point(x, y)
end








----coordination conversion
function cube_to_hex(cx, cy, cz)
	return cx, cz
end

function hex_to_cube(q, r)
	return q, -x-z, z
end

function cube_to_oddq(cube)
	return hex(cube.x,  cube.z + (cube.x - cube.x%2)/2)
end

function oddq_to_cube(hex)
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