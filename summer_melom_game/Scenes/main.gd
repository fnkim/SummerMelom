extends Node2D
#debug dev stuff here!

@export var toggle_colors: bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if toggle_colors:
		GameManager.blue_unlocked = true
		GameManager.red_unlocked = true
		GameManager.yellow_unlocked = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
