extends Node

var red_unlocked: bool
var yellow_unlocked: bool
var blue_unlocked: bool

var last_unlocked_red: bool
var last_unlocked_yellow: bool
var last_unlocked_blue: bool

var last_checkpoint: Vector2
var player: Player
signal drop_blue_spark
signal drop_final_spark


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.change_music(AudioManager.bgmTracks[0])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func player_death() -> void:
	#red_unlocked = last_unlocked_red
	#blue_unlocked = last_unlocked_blue
	#yellow_unlocked = last_unlocked_yellow
	player.health = 6
	player.position = last_checkpoint

func drop_blue():
	drop_blue_spark.emit()

func drop_final():
	drop_final_spark.emit()

func end():
	pass
