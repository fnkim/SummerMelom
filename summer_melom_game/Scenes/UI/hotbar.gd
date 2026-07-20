extends Control

@onready var label: Label = $CanvasLayer/Label

@onready var red: Sprite2D = $CanvasLayer/Red
@onready var yellow: Sprite2D = $CanvasLayer/Yellow
@onready var blue: Sprite2D = $CanvasLayer/Blue

@onready var heart1: AnimatedSprite2D = $CanvasLayer/Heart1
@onready var heart2: AnimatedSprite2D = $CanvasLayer/Heart2
@onready var heart3: AnimatedSprite2D = $CanvasLayer/Heart3

@onready var anim: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_heart()
	ColorManager.change_color.connect(update_color)
	red.hide()
	blue.hide()
	yellow.hide()
	

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
	

	if ColorManager.red_toggled:
		red.show() 
	else: 
		red.hide()
	if ColorManager.blue_toggled:
		blue.show()
	else: 
		blue.hide()
	if ColorManager.yellow_toggled:
		yellow.show()
	else: 
		yellow.hide()
	
	
func lose_heart(health: int):
	print(health)
	match health:
		5:
			heart3.play("half")
		4:
			heart3.play("empty")
		3:
			heart2.play("half")
		2:
			heart2.play("empty")
		1:
			heart1.play("half")
		0:
			heart1.play("empty")

func reset_heart():
	heart1.play("full")
	heart2.play("full")
	heart3.play("full")

func death():
	anim.play("fade_out")
	await anim.animation_finished
	reset_heart()
	GameManager.player_death()
	anim.play("fade_in")
