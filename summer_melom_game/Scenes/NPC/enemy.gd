extends CharacterBody2D
class_name Enemy

enum EnemyState{UNATTACKABLE, ATTACKABLE}
enum EnemyAction{IDLE, FOLLOW, ATTACK}

@onready var target_radius_collider: CollisionShape2D = %"Target Radius Collider"
@onready var attack_timer: Timer = $AttackTimer
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: Area2D = $Hitbox


@export var color_queue: Array[ColorManager.ColorState]
@export var target_radius_size: float = 150.0
@export var speed: float = 200.0


var current_color: ColorManager.ColorState
var current_state: EnemyState
var current_action: EnemyAction

var target: Player
var direction: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target_radius_collider.shape.radius = target_radius_size
	ColorManager.change_color.connect(update_state)



func _physics_process(delta: float) -> void:
	match current_action:
		EnemyAction.IDLE:
			pass
		EnemyAction.FOLLOW:
			follow()
		EnemyAction.ATTACK:
			if global_position.distance_to(target.global_position) < 1:
				attack_timer.paused = true
				current_action = EnemyAction.FOLLOW
			else:
				attack()


func follow() -> void:
	if position.distance_to(target.position) > 1:
		if !is_on_floor():
			velocity.y += 100
		if velocity.y > 100:
			velocity.y = 100
		
		if target.position.x > position.x:
			direction = 1
		elif target.position.x < position.x:
			direction = -1
		velocity.x = speed * direction
		
		
		if velocity.x > 0:
			sprite.flip_h = true
			hitbox.position.x = 25
		elif velocity.x < 0:
			sprite.flip_h = false
			hitbox.position.x = -25
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
