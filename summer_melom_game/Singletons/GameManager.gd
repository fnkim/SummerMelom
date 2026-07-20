extends Node

var red_unlocked: bool
var yellow_unlocked: bool
var blue_unlocked: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.change_music(AudioManager.bgmTracks[0])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func player_death() -> void:
	pass
	
