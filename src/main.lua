--



----------------------[[CLASS TYPES]]----------------------

function Hex(q, r)
	local hex = {}
	hex.q = q
	hex.r = r
	return hex
end

function Point(x,y)
	local point = {}
	point.x = x
	point.y = y
	return point
end

function Color(r, g, b, a)
	local color = {};
	color.r = r
	color.g = g
	color.b = b
	color.a = a
	return color
end
function Cube(x, y, z)
	local cube = {}
	cube.x = x
	cube.y = y
	cube.z = z
	return cube
end

function round(x)
	return x + 0.5 - (x + 0.5)%1
end

----------------------[[CONSTANTS]]----------------------

HEX_SIZE = 40
HEX_W = HEX_SIZE * 2
HEX_H = HEX_W * math.sqrt(3)*0.5

CUBE_DIRECTIONS = {
	{1, -1, 0}, 	{1, 0, -1}, 	{0, 1, -1},
	{-1, 1, 0}, 	{-1, 0, 1},  {0, -1, 1}
}

HEX_DIRECTIONS = {
	Hex{1, 0}, 		Hex{1, -1}, 	Hex{0, -1},
	Hex{-1,  0}, 	Hex{-1, 1}, 	Hex{0, 1}
}

CUBE_DIAGONALS = {
   Cube(2, -1, -1), Cube(1, 1, -2), Cube(-1, 2, -1),
   Cube(-2, 1, 1), Cube(-1, -1, 2), Cube(1, -2, 1)
}

HEX_ZERO = Point(0,0)









----------------------[[LOVE2d Methods]]----------------------

function love.load()
	-- sound = love.audio.newSource("Boom_epic_win.ogg")
	-- love.audio.play(sound)
end

function love.draw()

	-- love.graphics.clear()

	--draw hexagons
	for i=0,12,1
	do
		for j=0,7,1
		do
			local hex_odd = Hex(i,j)
			local hex_center = get_hex_center(hex_odd)
			draw_hex(hex_center, HEX_SIZE, Color(127, 127, 127))
			draw_hex_coordinate(hex_odd)
		end
	end


	--draw center
	hx1 = Hex(4, 4)
	center_pt = get_hex_center(hx1)
	draw_hex(center_pt, HEX_SIZE, Color(127,0, 0))
	cb1 = oddq_to_cube(hx1)

	--draw neighbor
	for i=0,5,1
	do
		cb_neighbor = cube_neighbor(cb1,i)
		-- print("x=", cb_neighbor.x, "\ty=", cb_neighbor.y, "\tz =", cb_neighbor.z)
		-- debug.debug()
		hx_neighbor = cube_to_oddq(cb_neighbor)
		if(hx_neighbor.q>=0 and hx_neighbor.q<=12 and hx_neighbor.r>=0 and hx_neighbor.r<=7)
		then
			neighbor_center_pt = get_hex_center(hx_neighbor)
			draw_hex(neighbor_center_pt, HEX_SIZE, Color(0, 127, 0))
		end
	end

	--draw diagonal neighbors
	for i=0,5,1
	do
		cb_neighbor = cube_diagonal_neighbor(cb1,i)
		-- debug.debug()
		hx_neighbor = cube_to_oddq(cb_neighbor)
		-- print("q=",hx_neighbor.q, "r=",hx_neighbor.r)
		if(hx_neighbor.q>=0 and hx_neighbor.q<=12 and hx_neighbor.r>=0 and hx_neighbor.r<=7)
		then
			neighbor_center_pt = get_hex_center(hx_neighbor)
			draw_hex(neighbor_center_pt, HEX_SIZE, Color(0, 0, 127))
		end
	end

	--draw hexagon line
	local hx2 = Hex(11, 7)
	local cb2 = oddq_to_cube(hx2)
	local line_table = cube_linedraw(cb1, cb2)
	for i=1,table.getn(line_table),1
	do
		local hx = cube_to_oddq(line_table[i])
		hx_center = get_hex_center(hx)
		draw_hex(hx_center, HEX_SIZE, Color(127, 0, 127))
	end


	--draw hexagon range
	-- draw_hex_range(hx1, 2, Color(127, 127, 127))




	--draw intersection between two cube areas
	local range1=2
	local range2=2
	hx1 = Hex(3,3)
	hx2 = Hex(6,4)
	draw_hex_range(hx1, range1, Color(127, 127, 0))
	draw_hex_range(hx2, range2, Color(0, 127, 127))

	draw_hex_intersection(hx1, range1, hx2, range2, Color(75, 0, 0))



	--draw coordinates
	for i=0,12,1
	do
		for j=0,7,1
		do
			local hex_odd = Hex(i,j)
			draw_hex_coordinate(hex_odd)
		end
	end

end











----------------------[[draw shapes]]----------------------


function draw_hex_outline(x1, y1, x2, y2)
	-- love.graphics.setColor(0,0,0)
	-- love.graphics.line(x1, y1+2, x2, y2+2)
	love.graphics.setColor(255,255,255)
	love.graphics.line(x1, y1, x2, y2)
end

function draw_hex_coordinate(hex)
	local text = hex.q .. "," .. hex.r
	local center = get_hex_center(hex)
	love.graphics.setColor(255,255,255)
	love.graphics.print(text, center.x-10, center.y)
end

function draw_hex(center, size, color)
	if(color == nil)
	then
		color = Color(255,255,255)
	end

	for i=0,5,1
	do
		local x1, y1 = hex_cornor(center, size, i)
		local x2, y2 = hex_cornor(center, size, i+1)

		love.graphics.setColor(color.r, color.g, color.b, color.a)
		draw_hex_polygon(center, Point(x1,y1), Point(x2, y2))

		draw_hex_outline(x1, y1, x2, y2)
	end
end

function draw_hex_polygon( center, pt1, pt2)
	love.graphics.polygon('fill', center.x, center.y, pt1.x, pt1.y, pt2.x, pt2.y)
end

function draw_hex_range(hex, range, color)
	local cube = oddq_to_cube(hex)
	local range_table = cube_range(cube, range)
	for i=1,table.getn(range_table),1
	do
		local hx = cube_to_oddq(range_table[i])
		if(hx.q>=0 and hx.q<=12 and hx.r>=0 and hx.r<=7)
		then
			hx_center = get_hex_center(hx)
			draw_hex(hx_center, HEX_SIZE, color)
		end
	end
end

function draw_hex_intersection(hex1, range1, hex2, range2, color)
	local cube1 = oddq_to_cube(hex1)
	local cube2 = oddq_to_cube(hex2)
	local intersection_table = cube_intersection(cube1, range1, cube2, range2)
	for i=1,table.getn(intersection_table),1
	do
		local hx = cube_to_oddq(intersection_table[i])
		if(hx.q>=0 and hx.q<=12 and hx.r>=0 and hx.r<=7)
		then
			hx_center = get_hex_center(hx)
			draw_hex(hx_center, HEX_SIZE, color)
		end
	end
end





----------------------CALCULATIONS----------------------

--===HEX===--

function hex_cornor(center, size, i)
	local angle_deg = 60 * i
	local angle_rad = math.pi/180 * angle_deg
	return center.x + size * math.cos(angle_rad), center.y + size * math.sin(angle_rad)
end

-- get center x,y of a hexagon. (odd-q type)
function get_hex_center(hex)
	x = hex.q * HEX_W * 0.75 + 0.5 * HEX_W
	y = hex.r * HEX_H  + (hex.q%2)*0.5*HEX_H  + 0.5 * HEX_H
	return Point(x, y)
end

function hex_direction(dir)
	return HEX_DIRECTIONS[dir+1]
end

function hex_neighbor(hex1, direction)
	local dir = hex_direction(direction)
	return Hex(hex1.q + dir.q, hex1.r + dir.r)
end

function hex_round(h)
	return cube_to_hex(cube_round(hex_to_cube(h)))
end


--===CUBE===--

----cube coordinates caculation
function cube_direction(dir)
	local direction = CUBE_DIRECTIONS[dir+1]
	return Cube(direction[1], direction[2], direction[3])
end

function cube_neighbor(cube, direction)
	local dir = cube_direction(direction)
	return cube_add(cube, dir)
end


function cube_add(cube1, cube2)
	return Cube(cube1.x+cube2.x,
							cube1.y+cube2.y,
							cube1.z+cube2.z)
end

function cube_diagonal_neighbor(cube, direction)
	return cube_add(cube, CUBE_DIAGONALS[direction+1])
end

function cube_distance2(a, b)
	return (math.abs(a.x-b.x) + math.abs(a.y-b.y) + math.abs(a.z-b.z))/2
end

function cube_distance(a, b)
	return math.max(math.abs(a.x-b.x), math.abs(a.y-b.y), math.abs(a.z-b.z))
end

function cube_lerp(a, b, t)
	return Cube(a.x + (b.x - a.x) * t, a.y + (b.y - a.y) * t,
							a.z + (b.z - a.z) * t)
end

-- return a line consisted of cubes
function cube_linedraw(a, b)
	local dist = cube_distance(a, b)
	local result = {}
	for i=0,dist,1
	do
		table.insert(result, cube_round(cube_lerp(a, b, 1.0/dist * i)))
	end
	return result
end

-- return cubes in specified range
function cube_range(cube, step)
	local result = {}
	for dx=-step, step, 1
	do
		for dy=math.max(-step, -dx-step), math.min(step, -dx+step), 1
		do
			local dz = -dx-dy
			table.insert(result, cube_add(cube, Cube(dx, dy, dz)))
		end
	end
	return result
end


-- return intersecting cubes between one range and another.
function cube_intersection(cb1, range1, cb2, range2)
	local result = {}
	local x_min = math.max(cb1.x-range1, cb2.x-range2)
	local x_max = math.min(cb1.x+range1, cb2.x+range2)
	local y_min = math.max(cb1.y-range1, cb2.y-range2)
	local y_max = math.min(cb1.y+range1, cb2.y+range2)
	local z_min = math.max(cb1.z-range1, cb2.z-range2)
	local z_max = math.min(cb1.z+range1, cb2.z+range2)

	for x=x_min, x_max, 1
	do
		for y=math.max(y_min, -x-z_max), math.min(y_max, -x-z_min), 1
		do
			local z = -x-y
			table.insert(result, Cube(x, y, z))
		end
	end
	return result
end

-- return a integer coordinates
function cube_round(cb)
	local rx = round(cb.x)
	local ry = round(cb.y)
	local rz = round(cb.z)

	local x_diff = math.abs(rx - cb.x)
	local y_diff = math.abs(ry - cb.y)
	local z_diff = math.abs(rz - cb.z)

	if(x_diff > y_diff and x_diff > z_diff)	then
		rx = -ry - rz
	elseif(y_diff > z_diff) then
			ry = -rx - rz
	else
			rz = -rx - ry
	end
	return Cube(rx, ry, rz)
end









-------[[CONVERSIONS]]-------


--coordinates conversion
function cube_to_hex(cx, cy, cz)
	return cx, cz
end

function hex_to_cube(q, r)
	return q, -x-z, z
end

function cube_to_oddq(cube)
	return Hex(cube.x,  cube.z + (cube.x - cube.x%2)/2)
end

function oddq_to_cube(hex)
	x = hex.q
	z = hex.r - ( hex.q - hex.q%2)/2
	y = -x-z
	return Cube(x, y, z)
end
