extends Node2D

var symbol = preload("uid://cshiyoxwnqciq")
@onready var center: Marker2D = $Center

@export var marks: Array[Marker2D]

var current_markers: Array[Marker2D]
var centered: bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_symbols(symbol_array: Array[ColorManager.ColorState]) -> void:
	var symbol_count: int = symbol_array.size()
	match symbol_count:
		7:
			current_markers = [marks[0], marks[1], marks[2], marks[3], marks[4], marks[5], marks[6]]
		6:
			current_markers = [marks[0], marks[1], marks[2], marks[5], marks[6], marks[7]]
		5:
			pass
		4:
			pass
		3:
			pass
		2:
			pass
		1:
			pass
	
	centered = true
	recenter(centered)

func recenter(center_pos: bool) -> void:
	position.x = 12
