extends CharacterBody2D
class_name Player

enum PlayerState{IDLE, JUMP, FALL, WALK, ATTACK, HURT}
@export var speed = 240.0
@export var jump_velocity = -700.0
@export var swapper: PaletteSwapper



var health: int = 6
var can_attack: bool = true
var current_enemy: Enemy
var current_state: PlayerState = PlayerState.WALK
var touching_enemy: bool


@onready var collider: CollisionShape2D = $CollisionShape2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var fmod_event_emitter = $FmodEventEmitter2D
@onready var hurtbox: NPCHurtBox = $Hurtbox
@onready var invincible_timer: Timer = $"Invincible Timer"
@onready var invin_anim: AnimationPlayer = $InvinAnim



func _ready() -> void:
	ColorManager.change_color.connect(palette_change)
	hurtbox.hurt_player.connect(damage)


func toggle_color():
	if GameManager.red_unlocked:
		if Input.is_action_just_pressed("red"):
			ColorManager.red_toggled = !ColorManager.red_toggled
			AudioManager._play_color(ColorManager.red_toggled, "Red")
			ColorManager.color_change()
	if GameManager.yellow_unlocked:
		if Input.is_action_just_pressed("yellow"):
			ColorManager.yellow_toggled = !ColorManager.yellow_toggled
			AudioManager._play_color(ColorManager.yellow_toggled, "Yellow")
			ColorManager.color_change()
	if GameManager.blue_unlocked:
		if Input.is_action_just_pressed("blue"):
			ColorManager.blue_toggled = !ColorManager.blue_toggled
			AudioManager._play_color(ColorManager.blue_toggled, "Blue")
			ColorManager.color_change()
	

func _physics_process(delta: float) -> void:
	attack()
	match current_state:
		PlayerState.IDLE:
			move(delta)
			anim.play("idle")
			var direction := Input.get_axis("left", "right")
			if direction:
				current_state = PlayerState.WALK
		PlayerState.WALK:
			if Input.is_action_pressed("space") and is_on_floor():
				anim.play("jump")
				velocity.y = jump_velocity
				current_state = PlayerState.JUMP
			else:
				if velocity.x != 0:
					anim.play("walk")
				else:
					anim.play("idle")
			
			move(delta)
		PlayerState.HURT:
			attack()
		PlayerState.JUMP:
			jump(delta)
		PlayerState.ATTACK:
			pass
	toggle_color()
	move_and_slide()

func land():
	print("landing")
	anim.play("land")
	await anim.animation_finished
	current_state = PlayerState.WALK


func jump(delta: float):
	move(delta)
	if Input.is_action_just_released("space") and velocity.y < 0:
		velocity.y = velocity.y * 0.5
	
	velocity.x = clampf(velocity.x,-130, 130)
	var current_gravity
	if velocity.y <= 0:
		current_gravity = get_gravity() * 0.8
	else:
		current_gravity = get_gravity() * 1.5
	
	if is_on_floor():
		land()
		current_state = PlayerState.FALL
	velocity += current_gravity * delta
	

func move(delta: float) -> void:
	velocity += get_gravity() * delta
	# Handle jump.

	var direction := Input.get_axis("left", "right")
	
	if direction:
		velocity.x = direction * speed
		if ray_cast_2d.is_colliding():
			var raycast_position = ray_cast_2d.get_collision_point()
			FootstepManager.play_footstep(raycast_position, fmod_event_emitter)
		# flip functionality
		if velocity.x > 0:
			sprite.scale.x = 1
			hitbox.position.x = 30
		elif velocity.x < 0:
			sprite.scale.x = -1
			hitbox.position.x = -30
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	


func attack() -> void:
	if !can_attack:
		return
	if Input.is_action_just_pressed("attack"):
		current_state = PlayerState.ATTACK
		anim.play("attack")
		await anim.animation_finished
		anim.play("idle")
		can_attack = true
		current_state = PlayerState.WALK

func damage(enemy: Node2D) -> void:
	current_state = PlayerState.HURT
	invincible_timer.start(0.5)
	anim.play("hurt")
	health -= 1
	var kb_direction = position.direction_to(enemy.position).normalized() * 300
	var x = -kb_direction.x
	velocity = Vector2(x, -120)
	await anim.animation_finished
	current_state = PlayerState.IDLE
	if health <= 0:
		GameManager.player_death()
		return


func palette_change(color: ColorManager.ColorState) -> void:
	var new_color: String
	match color:
		ColorManager.ColorState.RAINBOW:
			new_color = "rainbow"
		ColorManager.ColorState.RED:
			new_color = "red"
		ColorManager.ColorState.ORANGE:
			new_color = "orange"
		ColorManager.ColorState.YELLOW:
			new_color = "yellow"
		ColorManager.ColorState.GREEN:
			new_color = "green"
		ColorManager.ColorState.BLUE:
			new_color = "blue"
		ColorManager.ColorState.PURPLE:
			new_color = "purple"
		ColorManager.ColorState.NONE:
			new_color = "original"
	swapper.swap(new_color)

func _atk_sfx():
	$AtkSFX.play()
	
func _jump_sfx():
	$JumpSFX.play()

func _hurt_sfx():
	$hurtSFX.play()

func _on_invincible_timer_timeout() -> void:
	invin_anim.play("normal")
	if touching_enemy == true:
		if current_enemy != null:
			print("ouch")
			damage(current_enemy)
