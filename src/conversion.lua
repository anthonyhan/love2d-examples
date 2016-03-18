------[[CONVERSIONS]]-------


--coordinates conversion


-- cube -> axial
function cube_to_hex(cx, cy, cz)
	return cx, cz
end

-- axial ->cube
function hex_to_cube(q, r)
	return q, -q-r, r
end




function cube_to_oddq(cube)
	return Hex(cube.x,  cube.z + (cube.x - cube.x%2)/2)
end

function cube_to_oddr(cube)
	return Hex(cube.x+(cube.z - cube.z%2)/2, cube.z)
end




function oddq_to_cube(hex)
	x = hex.q
	z = hex.r - ( hex.q - hex.q%2)/2
	y = -x-z
	return Cube(x, y, z)
end

function oddr_to_cube(hex)
	x = hex.q - (hex.r - hex.r%2)/2
	z = hex.r
	y = -x-z
	return Cube(x,y,z)
end

function oddr_to_pixel(hex)
	local x = HEX_SIZE * math.sqrt(3) * (hex.q + 0.5 * (hex.r%2))
	local y = HEX_SIZE * 3/2 * hex.r
	return Point(x,y)
end

function hex_to_pixel(hex)
	local x = HEX_SIZE * math.sqrt(3) * (hex.q + hex.r/2)
	local y = HEX_SIZE * 3/2 * hex.r
	return Point(x,y)
end

function cube_to_pixel(cube)
	local x = HEX_SIZE * math.sqrt(3) * (cube.q + cube.r/2)
	local y = HEX_SIZE * 3/2 * cube.r
	return Point(x, y)
end