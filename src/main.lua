require "hex"
require "cube"
require "conversion"
require "utils"
require "drawing"


----------------------[[CLASS TYPES]]----------------------




----------------------[[CONSTANTS]]----------------------

HEX_SIZE = 64
HEX_H = HEX_SIZE * 2
HEX_W = HEX_H * math.sqrt(3)*0.5

HEX_ZERO = Point(0,0)

local width=love.graphics.getWidth()
local height=love.graphics.getHeight()
GRID_COLS = math.floor(width/HEX_W - 0.5) -1
GRID_ROWS = math.floor(height/HEX_H / 0.75 - 1/3) -1

local radius = 2
castle_center = oddr_to_cube(Hex(8,4))
castle_walls = cube_ring(castle_center, radius)

extra_walls_hex = { Hex(12,1), Hex(12,2), Hex(12,3), Hex(12,4), Hex(12,5), Hex(12,6), Hex(11,7), Hex(12,8), Hex(13,1), Hex(14,1), Hex(13,8), Hex(14,8) }
for i=1, table.getn(extra_walls_hex), 1
do
	local cube = oddr_to_cube(extra_walls_hex[i])
	table.insert(castle_walls, cube)
end


----------------------[[LOVE2d Methods]]----------------------

function love.load()
	-- sound = love.audio.newSource("Boom_epic_win.ogg")
	-- love.audio.play(sound)	
	
	img_tower = { image=love.graphics.newImage("assets/tower_0.png"), ox=51, oy=61, sx=1.0, sy=1.0 }
	img_gate = { image=love.graphics.newImage("assets/gate.png"), ox=51, oy=100, sx=1.0, sy=1.0 }
	img_wall_3 = { image=love.graphics.newImage("assets/wall_3.png"), ox=38, oy=40, sx=1.0, sy=1.0 }
	img_wall_4 = { image=love.graphics.newImage("assets/wall_4.png"), ox=54, oy=70, sx=1.0, sy=1.0 }
	img_wall_5 = { image=love.graphics.newImage("assets/wall_5.png"), ox=54, oy=52, sx=1.0, sy=1.0 }
	img_walls = { img_wall_3, img_wall_4, img_wall_5 };
	
	offset_walls = { Point(-HEX_W*0.5, 0),  Point(-math.sqrt(3)*0.25*HEX_SIZE, 0.75*HEX_SIZE), Point(math.sqrt(3)*0.25*HEX_SIZE, 0.75*HEX_SIZE) }
	
end

function love.resize(width, height)
	GRID_COLS = math.floor(width/HEX_W - 0.5) -1
	GRID_ROWS = math.floor(height/HEX_H / 0.75 - 1/3) -1
end

function love.update()
end

function love.draw()

	love.graphics.clear()

	--draw hexagons
	for i=0,GRID_COLS,1
	do
		for j=0,GRID_ROWS,1
		do
			local hex = Hex(i,j)
			local hex_center = get_hex_center(hex)
			local color = Color(0, 63, 0)
			if(i==0 or j==0 or i==GRID_COLS or j == GRID_ROWS)
			then
				color = Color(127, 127, 127)
			end
			draw_hex(hex_center, HEX_SIZE, color)
		end
	end


	--draw center
--	hx1 = Hex(4, 4)
--	center_pt = get_hex_center(hx1)
--	draw_hex(center_pt, HEX_SIZE, Color(127,0, 0))
--	cb1 = oddr_to_cube(hx1)

	
	--[[
	--draw neighbor
	for i=0,5,1
	do
		cb_neighbor = cube_neighbor(cb1,i)
		-- print("x=", cb_neighbor.x, "\ty=", cb_neighbor.y, "\tz =", cb_neighbor.z)
		-- debug.debug()
		hx_neighbor = cube_to_oddr(cb_neighbor)
		if(hx_neighbor.q>=0 and hx_neighbor.q<=GRID_COLS and hx_neighbor.r>=0 and hx_neighbor.r<=GRID_ROWS)
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
 		hx_neighbor = cube_to_oddr(cb_neighbor)
 		-- print("q=",hx_neighbor.q, "r=",hx_neighbor.r)
 		if(hx_neighbor.q>=0 and hx_neighbor.q<=GRID_COLS and hx_neighbor.r>=0 and hx_neighbor.r<=GRID_ROWS)
 		then
 			neighbor_center_pt = get_hex_center(hx_neighbor)
 			draw_hex(neighbor_center_pt, HEX_SIZE, Color(0, 0, 127))
 		end
 	end
 
 	--draw hexagon line
 	local hx2 = Hex(10, 4)
 	local cb2 = oddr_to_cube(hx2)
 	local line_table = cube_linedraw(cb1, cb2)
 	for i=1,table.getn(line_table),1
 	do
 		local hx = cube_to_oddr(line_table[i])
 		hx_center = get_hex_center(hx)
 		draw_hex(hx_center, HEX_SIZE, Color(127, 0, 127))
 	end


	--draw hexagon range
	--draw_hex_range(hx1, 2, Color(0, 127, 127))




	--draw intersection between two cube areas
	local range1=2
	local range2=3
	hx1 = Hex(6,10)
	hx2 = Hex(10,10)
	draw_hex_range(hx1, range1, Color(127, 127, 0))
	draw_hex_range(hx2, range2, Color(0, 127, 127))

	draw_hex_intersection(hx1, range1, hx2, range2, Color(75, 0, 0))

	
	
	--draw cube obstacles path
	movement = 3
	--	hex_obstacles = { Hex(3,3),  Hex(4,3), Hex(5,4), Hex(4,5), Hex(3,5), Hex(3,4), Hex(2,3) }
	hex_obstacles = { Hex(3,3),  Hex(4,3), Hex(4,5), Hex(3,5), Hex(2,3) }
	cube_obstacles = {}
	for i=1, table.getn(hex_obstacles), 1
	do
		local cube = oddr_to_cube(hex_obstacles[i])
		table.insert(cube_obstacles, cube)
	end
	
	--draw obstacles
	-for i=1, table.getn(hex_obstacles),1
	-do
	-	local hx_center = get_hex_center(hex_obstacles[i])
	-	draw_hex(hx_center, HEX_SIZE, Color(63, 0, 0))
	-end
	-
	-cube_reachable(cb1, movement, cube_obstacles)
	
	
	
	-- draw cube rotations
	local hx_rotate = Hex(17,7)
	local hx3 = Hex(15,7)
	
	draw_hex(get_hex_center(hx3), HEX_SIZE, Color(63,0,0))
	cb3 = oddr_to_cube(hx3)
	cb_rotate = oddr_to_cube(hx_rotate)
	cb_delta = Cube(cb_rotate.x-cb3.x, cb_rotate.y-cb3.y, cb_rotate.z-cb3.z)
	
	for i=0, 5,1
	do
		cube_rotated = cube_rotation(cb_delta, i)
		cube_r = cube_add(cube_rotated, cb3)
		hx_r = cube_to_oddr(cube_r)
		--print("hx_r: q=".. hx_r.q .. " r=" .. hx_r.r)
		draw_hex(get_hex_center(hx_r), HEX_SIZE, Color(127,127,0))
	end
	
	-- draw cube rings
	local radius = 3
	local cb4 = oddr_to_cube(Hex(15,7))
	ring_cubes = cube_ring(cb4, radius)
	
	for i=1, table.getn(ring_cubes), 1
	do
		local cube = ring_cubes[i]
		hex = cube_to_oddr(cube)
		draw_hex(get_hex_center(hex), HEX_SIZE, Color(0,127,127))
	end
	
	--]]
	
	
	
	--render castle walls
		for i=1, table.getn(castle_walls), 1
	do
		local cube = castle_walls[i]
		hex = cube_to_oddr(cube)
		draw_hex(get_hex_center(hex), HEX_SIZE, Color(0,127,127))
	end
	
	--render castle center
	draw_hex(get_hex_center(cube_to_oddr(castle_center)), HEX_SIZE, Color(64,0,0))
	
	for j=0,GRID_ROWS,1 	--cols
	do
		for i=0,GRID_COLS,1 	--rows
		do
			
			local cube = oddr_to_cube(Hex(i,j))
			if(is_cube_in_list(cube, castle_walls))
			then
				--render tower
				local hex_center = get_hex_center(Hex(i,j))
				--love.graphics.draw(img_tttt, hex_center.x, hex_center.y)
--				if(i==5 and j==4)
--				then
--					love.graphics.draw(img_gate.image, hex_center.x, hex_center.y, 0, img_gate.sx, img_gate.sy, img_gate.ox, img_gate.oy)
--				else
					love.graphics.draw(img_tower.image, hex_center.x, hex_center.y, 0, img_tower.sx, img_tower.sy, img_tower.ox, img_tower.oy)
--				end
				
				
				--render walls //3 directions: 3,4,5
				for dir=3, 5, 1
				do
					if(cube_has_neighor_in_list(cube, dir, castle_walls))
					then
						local img_wall = img_walls[dir-2]
						local offset_wall = offset_walls[dir-2]
						love.graphics.draw(img_wall.image, hex_center.x+offset_wall.x, hex_center.y+offset_wall.y, 0, img_wall.sx, img_wall.sy, img_wall.ox, img_wall.oy)
					end
				end
			end			
		end
	end
	
	
--[[
	--draw coordinates
	for i=0,GRID_COLS,1
	do
		for j=0,GRID_ROWS,1
		do
			local hex_odd = Hex(i,j)
			draw_hex_coordinate(hex_odd)
		end
	end
--]]
end
