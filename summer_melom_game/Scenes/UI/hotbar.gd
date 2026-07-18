extends Control

@onready var label: Label = $CanvasLayer/Label


@onready var yellow: Label = $CanvasLayer/Yellow
@onready var blue: Label = $CanvasLayer/Blue
@onready var red: Label = $CanvasLayer/Red



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ColorManager.change_color.connect(update_color)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_color(color: ColorManager.ColorState) -> void:
	
	match color:
		ColorManager.ColorState.RAINBOW:
			label.text = "Current: Rainbow"
		ColorManager.ColorState.RED:
			label.text = "Current: Red"
		ColorManager.ColorState.ORANGE:
			label.text = "Current: Orange"
		ColorManager.ColorState.YELLOW:
			label.text = "Current: Yellow"
		ColorManager.ColorState.GREEN:
			label.text = "Current: Green"
		ColorManager.ColorState.BLUE:
			label.text = "Current: Blue"
		ColorManager.ColorState.PURPLE:
			label.text = "Current: Purple"
		ColorManager.ColorState.NONE:
			label.text = "Current: Nothing :("
	

	red.show() if ColorManager.red_toggled else red.hide()
	blue.show() if ColorManager.blue_toggled else blue.hide()
	yellow.show() if ColorManager.yellow_toggled else yellow.hide()
