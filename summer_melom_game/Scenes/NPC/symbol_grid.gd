extends Node2D

var symbol = preload("uid://dks7dimo4ti38")

@export var all_symbols: Array[Sprite2D]

var current_symbols: Array[Sprite2D]
var centered: bool


@onready var top_row: Marker2D = $TopRow
@onready var bottom_row: Marker2D = $BottomRow
@onready var indicator: Sprite2D = $Indicator


var center2: float = -12
var center1: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_grid(symbol_array: Array[ColorManager.ColorState]) -> void:
	if symbol_array.size() == 0:
		hide()
		return
	var symbol_count: int = symbol_array.size()
	recenter_top(true) 
	recenter_bottom(true) 
	match symbol_count:
		7:
			current_symbols = [all_symbols[7], all_symbols[6], all_symbols[5], all_symbols[3], all_symbols[2], all_symbols[1], all_symbols[0]]
			recenter_bottom(false)
		6:
			current_symbols = [all_symbols[7], all_symbols[6], all_symbols[5], all_symbols[3], all_symbols[2], all_symbols[1]]
			
		5:
			current_symbols = [all_symbols[6], all_symbols[5], all_symbols[3], all_symbols[2], all_symbols[1]]
			recenter_top(false) 
		4:
			current_symbols = [all_symbols[3], all_symbols[2], all_symbols[1], all_symbols[0]]
			
		3:
			current_symbols = [all_symbols[3], all_symbols[2], all_symbols[1]]
		2:
			current_symbols = [all_symbols[2], all_symbols[1]]
			recenter_bottom(false)
		1:
			current_symbols = [all_symbols[2]]
			
	indicator.position = current_symbols.front().position
	
	for i in current_symbols.size():
		current_symbols[i].frame = get_frame_index(symbol_array[i])
		
	for a in all_symbols:
		a.hide()
	for s in current_symbols:
		s.show()
	




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
		_:
			index = 7
	return index



func recenter_top(original_pos: bool) -> void:
	top_row.position.x = 0 if original_pos else -12

func recenter_bottom(original_pos: bool) -> void:
	bottom_row.position.x = 0 if original_pos else -12
