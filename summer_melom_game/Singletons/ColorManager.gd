extends Node

signal change_color(ColorState)


enum Primaries{RED_TOGGLE, YELLOW_TOGGLE, BLUE_TOGGLE}

enum ColorState{RED, ORANGE, YELLOW, GREEN, BLUE, PURPLE, RAINBOW}
var equipped_color: ColorState

var red_toggled: bool
var yellow_toggled: bool
var blue_toggled: bool

var number_toggled: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func color_change() -> void:
	var total_toggled = int(red_toggled) + int(yellow_toggled) + int(blue_toggled)
	
	match total_toggled:
		3:
			equipped_color = ColorState.RAINBOW
		2:
			if red_toggled:
				equipped_color = ColorState.ORANGE if yellow_toggled else ColorState.PURPLE
			else:
				equipped_color = ColorState.PURPLE
		1:
			if red_toggled:
				equipped_color = ColorState.RED
			elif yellow_toggled:
				equipped_color = ColorState.YELLOW
			elif blue_toggled:
				equipped_color = ColorState.BLUE
		_:
			pass
	
	change_color.emit(equipped_color)
