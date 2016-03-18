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
	for i, v in ipairs(list)  do
		if( v.x == cube.x and v.y == cube.y and v.z == cube.z) then
			return true
		end
	end

	return false
end 

function cube_has_neighor_in_list(cube, dir, list)
	cb_neighbor = cube_neighbor(cube, dir)
	if(is_cube_in_list(cb_neighbor, list))
	then
		return true
	end
	return false
end

function cube_sort_comp(a, b)
	if a.z == b.z then
		return a.x <= b.x
	else
		return a.z < b.z
	end
end