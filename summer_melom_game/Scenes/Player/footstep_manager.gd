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

func play_footstep(position: Vector2, emitter:FmodEventEmitter2D):
		var tile_data = [] 
		for tilemap in tilemaps:
			var tile_position = tilemap.local_to_map(position)
			var data = tilemap.get_cell_tile_data(tile_position)
			if data:
				current_tile_type = data.get_custom_data("footstep_sound")
				
				
			if footstep_sounds.has(current_tile_type):
				match current_tile_type:
					"grass":
							emitter.set_parameter("Surface Material", "Grass")
							
							print("grass")
					"concrete":
							emitter.set_parameter("Surface Material", "Concrete")
							print("concrete")
					"rock":
							emitter.set_parameter("Surface Material", "Rock")
							print("rock")
				emitter.play()
				
