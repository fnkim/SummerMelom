extends CharacterBody2D

@export var speed = 300.0
@export var jump_velocity = -400.0

var health: int = 6
var can_attack: bool

@export var sprite: Sprite2D
@export var hitbox: Area2D
@export var anim: AnimationPlayer

func toggle_color():
	if GameManager.red_unlocked:
		if Input.is_action_just_pressed("red"):
			ColorManager.red_toggled = !ColorManager.red_toggled
	
	if GameManager.yellow_unlocked:
		if Input.is_action_just_pressed("yellow"):
			ColorManager.yellow_toggled = !ColorManager.yellow_toggled
	
	if GameManager.blue_unlocked:
		if Input.is_action_just_pressed("blue"):
			ColorManager.blue_toggled = !ColorManager.blue_toggled
	
	ColorManager.color_change()

func _physics_process(delta: float) -> void:
	toggle_color()
	move(delta)
	
	move_and_slide()

func move(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = jump_velocity

	var direction := Input.get_axis("left", "right")
	
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	# flip functionality
	if velocity.x > 0:
		sprite.flip_h = true
		hitbox.position.x = -25
	elif velocity.x < 0:
		sprite.flip_h = false
		hitbox.position.x = 25

func attack() -> void:
	if !can_attack:
		return
	if Input.is_action_just_pressed("attack"):
		anim.play("attack")
		await anim.animation_finished
		anim.play("idle")
		can_attack = true

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.hit_check()
