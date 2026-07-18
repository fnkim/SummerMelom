extends Node


var tilemaps: Array[TileMapLayer] = []
var current_tile_type


const footstep_sounds = {
	"grass":[
		
	],
	"concrete":[
		
	],
	"rock":[
		
	]
}

func play_footstep(position: Vector2):
		var tile_data = []
		for tilemap in tilemaps:
			var tile_position = tilemap.local_to_map(position)
			var data = tilemap.get_cell_tile_data(tile_position)
			if data:
				current_tile_type = data.get_custom_data("footstep_sound")
				print(current_tile_type)
				print("Playing footstep")
				
			#if footstep_sounds.has(tile_type):
				#print(tile_type)
				
