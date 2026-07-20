extends CharacterBody2D
class_name Enemy

enum EnemyState{UNATTACKABLE, ATTACKABLE}
enum EnemyAction{IDLE, FOLLOW, JUMP, ATTACK, KNOCKED_BACK, STUNNED}

@onready var target_radius_collider: CollisionShape2D = %"Target Radius Collider"
@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var attack_timer: Timer = $AttackTimer
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var symbol_grid: Node2D = $SymbolGrid
@onready var swapper: PaletteSwapper = $"Palette Swapper"
@onready var footstep_emitter = $FootstepSFX

@export var color_queue: Array[ColorManager.ColorState]
@export var target_radius_size: float = 300.0
@export var speed: float = 70
@export var hurtbox: NPCHurtBox
@export var dash_multiplier: float = 200
@export var medium: bool
@export var attack_dist: float = 50
@export var blue_boss: bool
@export var final_boss: bool
#hello
var current_color: ColorManager.ColorState
var current_state: EnemyState
var current_action: EnemyAction = EnemyAction.IDLE

#navigation variables
var target: Player
var is_attacking: bool
var current_link: NavigationLink2D
var is_hurt: bool
var is_invincible: bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	current_color = color_queue.front()
	target_radius_collider.shape.radius = target_radius_size
	symbol_grid.update_grid(color_queue)
	ColorManager.change_color.connect(update_state)
	hurtbox.hittable.connect(hit_check)



func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	match current_action:
		EnemyAction.IDLE:
			velocity.x = 0
			anim.play("idle")
			move_and_slide()
		EnemyAction.KNOCKED_BACK:
			move_and_slide()
		EnemyAction.STUNNED:
			pass
			velocity.x = 0
			move_and_slide()
		EnemyAction.FOLLOW:
			update_target_position()
			follow()
		EnemyAction.JUMP:
			if is_on_floor():
				current_action = EnemyAction.FOLLOW
			move_and_slide()

func update_target_position() -> void:
	if target:
		agent.set_target_position(target.global_position)

func follow() -> void:
	if target == null:
		return
	if abs(hitbox.global_position.x - target.position.x) > attack_dist and !is_attacking:
		is_attacking = false
		var cur_loc = global_transform.origin
		var next_loc = agent.get_next_path_position()
		var new_vel = (next_loc - cur_loc).normalized() * speed
		velocity = Vector2(new_vel.x, velocity.y)
		anim.play("walk")
		if position.x - target.position.x < 0:
			sprite.scale.x = -1
			if !medium:
				hitbox.position.x = 25
		elif position.x - target.position.x > 0:
			sprite.scale.x = 1
			if !medium:
				hitbox.position.x = -25
	else:
		attack()

	

	move_and_slide()



func jump(is_top: bool) -> void:
	var height: float
	if is_top:
		height = -200
	else:
		height = -550

	velocity.y = height
	current_action = EnemyAction.JUMP
	_jump_sfx()



func attack() -> void:
	if is_attacking:
		return
	if is_invincible:
		return
	else:
		if attack_timer.time_left == 0:
			is_attacking = true
			anim.play("attack")
			var lunge_dir = global_position.direction_to(target.position).normalized() * dash_multiplier
			velocity = lunge_dir
			if medium:
				velocity.y = -300
			await anim.animation_finished
			velocity = Vector2(0,0)
			anim.play("idle")
			is_attacking = false
			attack_timer.start(1.5)
	



func update_state(equipped_color: ColorManager.ColorState) -> void:
	var same_color: bool = current_color == equipped_color
	if same_color:
		current_state = EnemyState.ATTACKABLE
		var color_string = get_color(current_color)
		swapper.swap(color_string)
	else:
		current_state = EnemyState.UNATTACKABLE
		swapper.swap("original")

func get_color(color: ColorManager.ColorState) -> String:
	match color:
		ColorManager.ColorState.RED:
			return "red"
		ColorManager.ColorState.ORANGE:
			return "orange"
		ColorManager.ColorState.YELLOW:
			return "yellow"
		ColorManager.ColorState.GREEN:
			return "green"
		ColorManager.ColorState.BLUE:
			return "blue"
		ColorManager.ColorState.PURPLE:
			return "purple"
		_:
			return "original"



func death() -> void:
	if blue_boss:
		GameManager.drop_blue()
	if final_boss:
		GameManager.drop_final()
	queue_free()

func hit_check() -> void:
	print("hitcheck")
	if current_state == EnemyState.ATTACKABLE:
		get_hit()

func get_hit() -> void:
	current_action = EnemyAction.KNOCKED_BACK
	_hurt_sfx()
	knockback()
	swapper.flash()
	color_queue.erase(color_queue.front())
	symbol_grid.update_grid(color_queue)
	await get_tree().create_timer(0.3).timeout
	if color_queue.size() == 0:
		death()
		return
	else:
		current_color = color_queue.front()
		update_state(ColorManager.equipped_color)
		current_action = EnemyAction.STUNNED
		stunned()
	

func stunned():
	anim.play("stun")
	await get_tree().create_timer(1).timeout
	current_action = EnemyAction.FOLLOW


func knockback():
	var kb_direction = global_position.direction_to(target.position).normalized() * 100
	velocity = -kb_direction
	velocity.y = -200
	

func _on_targeting_radius_body_entered(body: Node2D) -> void:
	print(body)
	if body is Player:
		print("targeting player")
		target = body
		current_action = EnemyAction.FOLLOW


func _on_targeting_radius_body_exited(body: Node2D) -> void:
	if body is Player:
		current_action = EnemyAction.IDLE
		target = null


func _on_navigation_agent_2d_link_reached(details: Dictionary) -> void:
	var current_link = details.owner
	var distance_to_top = abs(position - current_link.end_position)
	var distance_to_bottom = abs(position - current_link.start_position)
	
	var is_at_top: bool = distance_to_top < distance_to_bottom
	if is_on_floor():
		jump(is_at_top)

func _atk_sfx():
	$ChompSFX.play()
	print("CHOMP")
	
func _jump_sfx():
	$JumpSFX.play()

func _hurt_sfx():
	$HurtSFX.play()

func _play_footstep():
	if $RayCast2D.is_colliding():
			var raycast_position = $RayCast2D.get_collision_point()
			FootstepManager.play_footstep(raycast_position, footstep_emitter)
