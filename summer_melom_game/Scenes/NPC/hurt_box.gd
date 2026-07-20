extends Area2D
class_name NPCHurtBox

signal hittable
signal hurt_player(enemy: Enemy)
@export var is_player: bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("area_entered", self._on_area_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_entered(hitbox: Area2D) -> void:
	print("out")
	if hitbox == null:
		return
	if hitbox.is_in_group("other"):
		return
	var monster = hitbox.get_parent()
	if is_player and monster is Enemy:
		hurt_player.emit(monster)
	else:
		hittable.emit()
