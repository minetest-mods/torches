
minetest.register_node(":default:torch", {
	description = "Torch",
	drawtype = "mesh",
	mesh = "torch_floor.obj",
	inventory_image = "default_torch_on_floor.png",
	wield_image = "default_torch_on_floor.png",
	tiles = {{
		    name = "default_torch_on_floor_animated.png",
		    animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 3.3}
	}},
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	liquids_pointable = false,
	light_source = 13,
	groups = {choppy=2, dig_immediate=3, flammable=1, attached_node=1, torch=1},
	drop = "default:torch",
	selection_box = {
		type = "wallmounted",
		wall_top = {-1/16, -2/16, -1/16, 1/16, 0.5, 1/16},
		wall_bottom = {-1/16, -0.5, -1/16, 1/16, 2/16, 1/16},
	},
	on_place = function(itemstack, placer, pointed_thing)
		local above = pointed_thing.above
		local under = pointed_thing.under
		local wdir = minetest.dir_to_wallmounted({x = under.x - above.x, y = under.y - above.y, z = under.z - above.z})
		local fakestack = itemstack
		local retval = false
		if wdir <= 1 then
			retval = fakestack:set_name("default:torch")
		else
			retval = fakestack:set_name("default:torch_wall")
		end
		if not retval then
			return itemstack
		end
		itemstack, retval = minetest.item_place(fakestack, placer, pointed_thing, wdir)
		itemstack:set_name("default:torch")

		return itemstack
	end
})

minetest.register_node(":default:torch_wall", {
	drawtype = "mesh",
	mesh = "torch_wall.obj",
	tiles = {{
		    name = "default_torch_on_floor_animated.png",
		    animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 3.3}
	}},
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	light_source = 13,
	groups = {choppy=2, dig_immediate=3, flammable=1, not_in_creative_inventory=1, attached_node=1, torch=1},
	drop = "default:torch",
	selection_box = {
		type = "wallmounted",
		wall_top = {-0.1, -0.1, -0.1, 0.1, 0.5, 0.1},
		wall_bottom = {-0.1, -0.5, -0.1, 0.1, 0.1, 0.1},
		wall_side = {-0.5, -0.3, -0.1, -0.2, 0.3, 0.1},
	},
})

minetest.register_lbm({
	name = "torches:convert_wallmounted",
	nodenames = "default:torch",
	action = function(pos, node)
		if node.param2 >= 2 then
			minetest.set_node(pos, {name = "default:torch_wall",
				param2 = node.param2})
		end
	end
})
