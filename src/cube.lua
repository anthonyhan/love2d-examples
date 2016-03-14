

function Cube(x, y, z)
	local cube = {}
	cube.x = x
	cube.y = y
	cube.z = z
	return cube
end


CUBE_DIRECTIONS = {
	{1, -1, 0}, 	{1, 0, -1}, 	{0, 1, -1},
	{-1, 1, 0}, 	{-1, 0, 1},  {0, -1, 1}
}

CUBE_DIAGONALS = {
   Cube(2, -1, -1), Cube(1, 1, -2), Cube(-1, 2, -1),
   Cube(-2, 1, 1), Cube(-1, -1, 2), Cube(1, -2, 1)
}


----------------------CALCULATIONS----------------------



--===CUBE===--

----cube coordinates caculation
function cube_direction(dir)
	local direction = CUBE_DIRECTIONS[dir+1]   --lua index starts from 1
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


-- cube obstacles
function cube_reachable(cb, movement, obstacles)
	visited = {}
	table.insert(visited, cb)
	fringes = {}
	table.insert(fringes, {cb})
	
	for k=1, movement, 1
	do
		table.insert(fringes, {})
		for j=1, table.getn(fringes[k]), 1	--each cube in fringes[k-1] --index of array starts from 1 in lua  
		do
			cube = fringes[k][j]
			for dir=0, 5, 1
			do
				neighbor = cube_neighbor(cube, dir)
				if(not is_cube_in_list(neighbor, visited) and not is_cube_in_list(neighbor, obstacles))
				then 
					table.insert(visited, neighbor)
					table.insert(fringes[k+1], neighbor)
				end
			end
		end
	end
	
	draw_cube_movements(fringes)
	return visited
end

--cube rotation,  turn anticlockwise 60 degrees per rotation
function cube_rotation(cb, rotation)
	local x,y,z = cb.x, cb.y, cb.z
	local rotations = { Cube(x,y,z), Cube(-y,-z,-x), Cube(z,x,y), Cube(-x,-y,-z), Cube(y,z,x), Cube(-z,-x,-y) }
	local index = rotation%6 + 1		--array index starts from 1
	return rotations[index]
end