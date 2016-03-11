require "hex"
require "cube"
require "conversion"
require "utils"


----------------------[[CLASS TYPES]]----------------------




----------------------[[CONSTANTS]]----------------------

HEX_SIZE = 40
HEX_H = HEX_SIZE * 2
HEX_W = HEX_H * math.sqrt(3)*0.5

HEX_ZERO = Point(0,0)



GRID_COLS=10
GRID_ROWS=8



----------------------[[LOVE2d Methods]]----------------------

function love.load()
	-- sound = love.audio.newSource("Boom_epic_win.ogg")
	-- love.audio.play(sound)
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
			local color = Color(0, 127, 0)
			if(i==0 or j==0 or i==GRID_COLS or j == GRID_ROWS)
			then
				color = Color(127, 127, 127)
			end
			draw_hex(hex_center, HEX_SIZE, color)
		end
	end


	--draw center
	hx1 = Hex(4, 4)
	center_pt = get_hex_center(hx1)
	draw_hex(center_pt, HEX_SIZE, Color(127,0, 0))
	cb1 = oddr_to_cube(hx1)

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
 	local hx2 = Hex(10, 0)
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
	local range2=2
	hx1 = Hex(3,3)
	hx2 = Hex(6,4)
	draw_hex_range(hx1, range1, Color(127, 127, 0))
	draw_hex_range(hx2, range2, Color(0, 127, 127))

	draw_hex_intersection(hx1, range1, hx2, range2, Color(75, 0, 0))



	--draw coordinates
	for i=0,GRID_COLS,1
	do
		for j=0,GRID_ROWS,1
		do
			local hex_odd = Hex(i,j)
			draw_hex_coordinate(hex_odd)
		end
	end

end
