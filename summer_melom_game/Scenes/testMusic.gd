extends Button

enum State{START , MIDDLE, END}
@export var current_state: State = State.START

func _on_pressed() -> void:
	$FmodEventEmitter2D.play_one_shot()
	match current_state:
		State.START:
			AudioManager.play_music()
			AudioManager.change_music(AudioManager.bgmTracks[1])
	print("TS Pressed")

	
