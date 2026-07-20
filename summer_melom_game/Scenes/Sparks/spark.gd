extends Sprite2D

@export var spark_type: String
@export var label: Label
@export var hotbar: Control

var can_collect: bool
var final_unlocked: bool
var blue_unlocked: bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.drop_blue_spark.connect(show_blue)
	GameManager.drop_final_spark.connect(show_final)

func show_final():
	if spark_type == "final":
		final_unlocked = true
		show()

func show_blue():
	if spark_type == "blue":
		blue_unlocked = true
		show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_collect:
		if Input.is_action_pressed(spark_type):
			collect()



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		if spark_type == "blue" and !blue_unlocked:
			return
		if spark_type == "final" and !final_unlocked:
			return
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
		"final":
			if hotbar:
				hotbar.end()
		_:
			pass
			
	queue_free()
