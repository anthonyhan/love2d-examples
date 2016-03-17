
function Point(x,y)
	local point = { 0, 0, }
	point.x = x
	point.y = y
	return point
end

function Hex(q, r)
	local hex = { 0, 0, }
	hex.q = q
	hex.r = r
	return hex
end



HEX_DIRECTIONS = {
	Hex{1, 0}, 		Hex{1, -1}, 	Hex{0, -1},
	Hex{-1,  0}, 	Hex{-1, 1}, 	Hex{0, 1}
}


----------------------CALCULATIONS----------------------

--===HEX===--

function hex_cornor(center, size, i)
	local angle_deg = 60 * i + 30
	local angle_rad = math.pi/180 * angle_deg
	return center.x + size * math.cos(angle_rad), center.y + size * math.sin(angle_rad)
end

-- get center x,y of a hexagon. (odd-r type) horizontal
function get_hex_center(hex)
	local x = hex.q * HEX_W  + (hex.r%2)*0.5*HEX_W  + 0.5 * HEX_W
	local y = hex.r * HEX_H * 0.75 + 0.5 * HEX_H
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

function hex_distance(h1, h2)
	return  math.max( math.abs(h1.q - h2.q), math.abs(h1.q + h1.r - h2.q - h2.r), math.abs(h1.r - h2.r))        --y=-q-r
end

function oddr_to_pixel(hex)
	local x = HEX_SIZE * math.sqrt(3) * (hex.q + 0.5 * hex.r%2)
	local y = HEX_SIZE * 3/2 * hex.r
	return Point(x,y)
end

function hex_to_pixel(hex)
	local x = HEX_SIZE * math.sqrt(3) * (hex.q + hex.r/2)
	local y = HEX_SIZE * 3/2 * hex.r
	return Point(x,y)
end