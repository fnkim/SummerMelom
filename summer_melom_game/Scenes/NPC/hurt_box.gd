extends Area2D
class_name NPCHurtBox

signal hittable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("area_entered", self._on_area_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_entered(hitbox: Area2D) -> void:
	if hitbox == null:
		return
	hittable.emit()
