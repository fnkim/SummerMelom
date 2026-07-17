extends Node2D
class_name Enemy

enum EnemyState{UNATTACKABLE, ATTACKABLE}


@export var color_queue: Array[ColorManager.ColorState]

var current_color: ColorManager.ColorState
var current_state: EnemyState

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ColorManager.change_color.connect(update_state)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_state() -> void:
	if current_color == ColorManager.equipped_color:
		current_state = EnemyState.ATTACKABLE


func death() -> void:
	queue_free()

func hit_check() -> void:
	if current_state == EnemyState.ATTACKABLE:
		get_hit()

func get_hit() -> void:
	color_queue.erase(color_queue.front())
	if color_queue ==[null]:
		death()
		return
	else:
		current_color = color_queue.front()
