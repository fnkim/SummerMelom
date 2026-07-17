extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var red_unlocked: bool = true
var yellow_unlocked: bool = true
var blue_unlocked: bool = true

var health: int = 6




func toggle_color():
	if red_unlocked:
		if Input.is_action_just_pressed("red"):
			ColorManager.red_toggled = !ColorManager.red_toggled
	if yellow_unlocked:
		if Input.is_action_just_pressed("yellow"):
			ColorManager.yellow_toggled = !ColorManager.yellow_toggled
	if blue_unlocked:
		if Input.is_action_just_pressed("blue"):
			ColorManager.blue_toggled = !ColorManager.blue_toggled
	ColorManager.color_change()

func _physics_process(delta: float) -> void:
	toggle_color()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.hit_check()
