extends Node2D
@onready var credits: TextureRect = $Control/CanvasLayer/TextureRect2
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var start_button: Button = $Control/CanvasLayer/StartButton

var credits_on: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if credits_on:
		if Input.is_action_pressed("esc"):
			credits.hide()
			start_button.disabled = false
			credits_on = false



func _on_start_button_pressed() -> void:
	animation_player.play("fade to black")
	await animation_player.animation_finished
	GameManager.game_started.emit()
	queue_free()


func _on_credits_button_pressed() -> void:
	credits.show()
	start_button.disabled = true
	credits_on = true
	
