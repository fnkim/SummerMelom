extends Node


var tilemaps:Array[TileMapLayer] = []

const footstep_sounds = {
	"Grass":[
		
	],
	"Concrete":[
		
	],
	"Rock":[
		
	]
}

func play_footstep(position: Vector2):
		var tile_data = []
		for tilemap in tilemaps:
			var tile_position = tilemap.local_to_map(position)
			var data = tilemap.get_cell_tile_data(tile_position)
			if data:
				tile_data.push_back(data)
				
		if tile_data.size() > 0:
			var tile_type = tile_data.back().get_custom_data("footstep_sound")
			print("Playing footstep")
			#if footstep_sounds.has(tile_type):
				#print(tile_type)
				
