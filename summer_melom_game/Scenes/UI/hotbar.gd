extends Control

@onready var label: Label = $CanvasLayer/Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ColorManager.change_color.connect(update_color)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_color(color: ColorManager.ColorState) -> void:
	
	match color:
		ColorManager.ColorState.RED:
			label.text = "Red"
		ColorManager.ColorState.ORANGE:
			label.text = "Orange"
		ColorManager.ColorState.YELLOW:
			label.text = "Yellow"
		ColorManager.ColorState.GREEN:
			label.text = "Green"
		ColorManager.ColorState.BLUE:
			label.text = "Blue"
		ColorManager.ColorState.PURPLE:
			label.text = "Purple"
