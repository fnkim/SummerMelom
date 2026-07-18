extends CharacterBody2D
class_name Enemy

enum EnemyState{UNATTACKABLE, ATTACKABLE}
enum EnemyAction{IDLE, FOLLOW, JUMP, ATTACK}

@onready var target_radius_collider: CollisionShape2D = %"Target Radius Collider"
@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var attack_timer: Timer = $AttackTimer
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var symbol_grid: Node2D = $SymbolGrid



@export var color_queue: Array[ColorManager.ColorState]
@export var target_radius_size: float = 150.0
@export var speed: float = 100.0



#hello
var current_color: ColorManager.ColorState
var current_state: EnemyState
var current_action: EnemyAction

#navigation variables
var target: Player
var is_attacking: bool
var current_link: NavigationLink2D




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target_radius_collider.shape.radius = target_radius_size
	symbol_grid.update_grid(color_queue)
	ColorManager.change_color.connect(update_state)



func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	match current_action:
		EnemyAction.IDLE:
			pass
		EnemyAction.FOLLOW:
			update_target_position()
			follow()
		EnemyAction.JUMP:
			if is_on_floor():
				current_action = EnemyAction.FOLLOW
			move_and_slide()

func update_target_position() -> void:
	agent.set_target_position(target.global_position)

func follow() -> void:
	if abs(position.x - target.position.x) > 25:
		var cur_loc = global_transform.origin
		var next_loc = agent.get_next_path_position()
		var new_vel = (next_loc - cur_loc).normalized() * speed
		velocity = Vector2(new_vel.x, velocity.y)
		if position.x - target.position.x < 0:
			sprite.flip_h = true
			hitbox.position.x = 25
		elif position.x - target.position.x > 0:
			sprite.flip_h = false
			hitbox.position.x = -25
	else:
		
		attack()
	

	move_and_slide()



func jump(is_top: bool) -> void:
	var height: float
	if is_top:
		height = -100
	else:
		height = -550

	velocity.y = height
	current_action = EnemyAction.JUMP



func attack() -> void:
	if is_attacking:
		return
	else:
		if attack_timer.time_left == 0:
			is_attacking = true
			print("enemy is attacking")
			anim.play("attack")
			await anim.animation_finished
			anim.play("idle")
			attack_timer.start(1)
			is_attacking = false
	



func update_state(equipped_color: ColorManager.ColorState) -> void:
	if current_color == equipped_color:
		make_attackable(true)
	else:
		make_attackable(false)

func make_attackable(is_true: bool) -> void:
	#add code to change enemy color here
	current_state = EnemyState.ATTACKABLE if is_true else EnemyState.UNATTACKABLE


func death() -> void:
	queue_free()

func hit_check() -> void:
	if current_state == EnemyState.ATTACKABLE:
		get_hit()

func get_hit() -> void:
	symbol_grid.update_grid(color_queue)
	color_queue.erase(color_queue.front())
	if color_queue ==[null]:
		death()
		return
	else:
		current_color = color_queue.front()



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
