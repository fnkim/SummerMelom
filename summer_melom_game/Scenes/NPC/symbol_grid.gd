extends Node2D

var symbol = preload("uid://dks7dimo4ti38")

@export var mark_pos: Array[Marker2D]

var current_markers: Array[Marker2D]
var centered: bool


@onready var top_row: Marker2D = $TopRow
@onready var bottom_row: Marker2D = $BottomRow

var center2: float = -12
var center1: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func update_grid(symbol_array: Array[ColorManager.ColorState]) -> void:
	var symbol_count: int = symbol_array.size()
	recenter_top(true) 
	recenter_bottom(true) 
	match symbol_count:
		7:
			current_markers = [mark_pos[0], mark_pos[1], mark_pos[2], mark_pos[3], mark_pos[5], mark_pos[6], mark_pos[7]]
			recenter_bottom(false)
		6:
			current_markers = [mark_pos[1], mark_pos[2], mark_pos[3], mark_pos[5], mark_pos[6], mark_pos[7]]
		5:
			current_markers = [mark_pos[1], mark_pos[2], mark_pos[3], mark_pos[5], mark_pos[6]]
			recenter_top(false) 
		4:
			current_markers = [mark_pos[0], mark_pos[1], mark_pos[2], mark_pos[3]]
			
		3:
			current_markers = [mark_pos[1], mark_pos[2], mark_pos[3]]
		2:
			current_markers = [mark_pos[1], mark_pos[2]]
			recenter_bottom(false)
		1:
			current_markers = [mark_pos[2]]
	
	instantiate_symbols(symbol_array)


func instantiate_symbols(symbol_array: Array[ColorManager.ColorState]) -> void:
	for i in current_markers.size():
		var new_symbol: Sprite2D = symbol.instantiate()
		new_symbol.frame = get_frame_index(symbol_array[i])
		new_symbol.position = current_markers[i].position
		add_child(new_symbol)
	
	var indicator: Sprite2D = symbol.instantiate()
	indicator.frame = 6
	indicator.position = current_markers.back().position
	add_child(indicator)
	

func get_frame_index(color_state: ColorManager.ColorState) -> int:
	var index: int
	match color_state:
		ColorManager.ColorState.RED:
			index = 0
		ColorManager.ColorState.ORANGE:
			index = 1
		ColorManager.ColorState.YELLOW:
			index = 2
		ColorManager.ColorState.GREEN:
			index = 3
		ColorManager.ColorState.BLUE:
			index = 4
		ColorManager.ColorState.PURPLE:
			index = 5
	return index



func recenter_top(original_pos: bool) -> void:
	top_row.position.x = 0 if original_pos else -12

func recenter_bottom(original_pos: bool) -> void:
	bottom_row.position.x = 0 if original_pos else -12
