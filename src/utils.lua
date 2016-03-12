--predefine

function Color(r, g, b, a)
	local color = {};
	color.r = r
	color.g = g
	color.b = b
	color.a = a
	return color
end


function round(x)
	return x + 0.5 - (x + 0.5)%1
end

function is_cube_in_list(cube, list)
	for i, v in pairs(list)  do
		if( v.x == cube.x and v.y == cube.y and v.z == cube.z) then
			return true
		end
	end

	return false
end 