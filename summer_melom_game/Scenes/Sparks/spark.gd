extends Sprite2D

@export var spark_type: String
@export var label: Label

var can_collect: bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_collect:
		if Input.is_action_pressed(spark_type):
			collect()



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		can_collect = true
		label.show()



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		can_collect = false
		label.hide()

func collect():
	match spark_type:
		"red":
			GameManager.red_unlocked = true
		"yellow":
			GameManager.yellow_unlocked = true
		"blue":
			GameManager.blue_unlocked = true
		_:
			pass
			
	queue_free()
