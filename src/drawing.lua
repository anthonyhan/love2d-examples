
-----------------------------------[Draw Methods]------------------------------------------


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
	local cube = oddr_to_cube(hex)
	local range_table = cube_range(cube, range)
	for i=1,table.getn(range_table),1
	do
		local hx = cube_to_oddr(range_table[i])
		if(hx.q>=0 and hx.q<=GRID_COLS and hx.r>=0 and hx.r<=GRID_ROWS)
		then
			hx_center = get_hex_center(hx)
			draw_hex(hx_center, HEX_SIZE, color)
		end
	end
end

function draw_hex_intersection(hex1, range1, hex2, range2, color)
	local cube1 = oddr_to_cube(hex1)
	local cube2 = oddr_to_cube(hex2)
	local intersection_table = cube_intersection(cube1, range1, cube2, range2)
	for i=1,table.getn(intersection_table),1
	do
		local hx = cube_to_oddr(intersection_table[i])
		if(hx.q>=0 and hx.q<=GRID_COLS and hx.r>=0 and hx.r<=GRID_ROWS)
		then
			hx_center = get_hex_center(hx)
			draw_hex(hx_center, HEX_SIZE, color)
		end
	end
end