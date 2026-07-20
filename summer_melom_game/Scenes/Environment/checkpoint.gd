extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		GameManager.last_unlocked_blue = GameManager.blue_unlocked
		GameManager.last_unlocked_red = GameManager.red_unlocked
		GameManager.last_unlocked_yellow = GameManager.yellow_unlocked
		GameManager.last_checkpoint = position
