extends CharacterBody2D
class_name Enemy

enum EnemyState{UNATTACKABLE, ATTACKABLE}
enum EnemyAction{IDLE, FOLLOW, ATTACK}

@onready var target_radius_collider: CollisionShape2D = %"Target Radius Collider"
@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var attack_timer: Timer = $AttackTimer
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var raycast: RayCast2D = $RayCast2D

@export var color_queue: Array[ColorManager.ColorState]
@export var target_radius_size: float = 150.0
@export var speed: float = 300.0


var current_color: ColorManager.ColorState
var current_state: EnemyState
var current_action: EnemyAction

var target: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target_radius_collider.shape.radius = target_radius_size
	ColorManager.change_color.connect(update_state)



func _physics_process(delta: float) -> void:
	match current_action:
		EnemyAction.IDLE:
			pass
		EnemyAction.FOLLOW:
			update_target_position()
			follow()
		EnemyAction.ATTACK:
			if global_position.distance_to(target.global_position) < 1:
				attack_timer.paused = true
				current_action = EnemyAction.FOLLOW
			else:
				attack()

func update_target_position() -> void:
	agent.set_target_position(target.global_position)

func follow() -> void:
	if abs(position.x - target.position.x) > 5:

		var cur_loc = global_transform.origin
		var next_loc = agent.get_next_path_position()
		var new_vel = (next_loc - cur_loc).normalized() * speed
		velocity = Vector2(new_vel.x, 0)
		if velocity.x > 0:
			sprite.flip_h = true
			hitbox.position.x = -25
		elif velocity.x < 0:
			sprite.flip_h = false
			hitbox.position.x = 25
	else:
		attack_timer.paused = false
		attack_timer.start(3)
		current_action = EnemyAction.ATTACK
	

	move_and_slide()


func attack() -> void:
	await attack_timer.timeout
	print("enemy is attacking")
	anim.play("attack")
	await anim.animation_finished
	anim.play("idle")
	attack_timer.start(3)
	



func update_state(equipped_color: ColorManager.ColorState) -> void:
	if current_color == equipped_color:
		make_attackable()
	else:
		pass

func make_attackable() -> void:
	#add code to change enemy color here
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


func _on_detection_box_body_entered(body: Node2D) -> void:
	if body is Player:
		body.damage()


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
