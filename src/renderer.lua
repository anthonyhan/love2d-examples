
-- render castle walls
-- @walls cube tables
function render_walls(walls)   


	--render castle wall
	for i=1, table.getn(walls), 1
	do
		local cube = walls[i]
		local hex_wall = cube_to_oddr(cube)
		local hex_center = get_hex_center(hex_wall)
		--render tower
		love.graphics.draw(img_tower.image, hex_center.x, hex_center.y, 0, img_tower.sx, img_tower.sy, img_tower.ox, img_tower.oy)
		
		for dir=3, 5, 1
		do
			if(cube_has_neighor_in_list(cube, dir, walls))
			then
				local img_wall = img_walls[dir-2]
				local offset_wall = offset_walls[dir-2]
				love.graphics.draw(img_wall.image, hex_center.x+offset_wall.x, hex_center.y+offset_wall.y, 0, img_wall.sx, img_wall.sy, img_wall.ox, img_wall.oy)
			end
		end
		
	end
end