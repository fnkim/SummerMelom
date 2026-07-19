extends Button

enum State{START , MIDDLE, END}
@export var current_state: State = State.START

func _on_pressed() -> void:
	match current_state:
		State.START:
			AudioManager.play_music()
			AudioManager.change_music(AudioManager.bgmTracks[0])
		State.MIDDLE:
			AudioManager.change_music(AudioManager.bgmTracks[2])
		State.END:
			AudioManager.change_music(AudioManager.bgmTracks[1])
	print("TS Pressed")

	
