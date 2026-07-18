extends CharacterBody2D
class_name Player


@export var speed = 240.0
@export var jump_velocity = -650.0

var health: int = 6
var can_attack: bool = true
var current_enemy: Enemy


@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var ray_cast_2d: RayCast2D = $RayCast2D




func _ready() -> void:
	pass



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
	attack()
	move_and_slide()

func move(delta: float) -> void:
	
	if not is_on_floor():
		velocity.x = clampf(velocity.x,-150, 150)
		var current_gravity
		if velocity.y <= 0:
			current_gravity = get_gravity() * 2
		else:
			current_gravity = get_gravity()
		velocity += current_gravity * delta
	

	# Handle jump.
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = jump_velocity

	if Input.is_action_just_released("space") and velocity.y < 0:
		velocity.y = 0
	

	var direction := Input.get_axis("left", "right")
	
	if direction:
		velocity.x = direction * speed
		if ray_cast_2d.is_colliding():
			var raycast_position = ray_cast_2d.get_collision_point()
			FootstepManager.play_footstep(raycast_position, $FmodEventEmitter2D)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	# flip functionality
	if velocity.x > 0:
		sprite.flip_h = true
		hitbox.position.x = 25
	elif velocity.x < 0:
		sprite.flip_h = false
		hitbox.position.x = -25

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
		print("hit check")



func damage() -> void:
	health -= 1
	if health <= 0:
		GameManager.player_death()
