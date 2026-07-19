extends Node

#im about to hard code the events in oml

var bgmTracks: Array[FmodEvent] = []
var currentMusicEvent
var currentEventInstance
var transitionEventInstance


func _ready() -> void:
	currentMusicEvent = bgmTracks[0]

func IsPlaying() -> bool:
	return currentEventInstance.isValid() && currentEventInstance!=null

func play_music() :
	
	if(!currentEventInstance.isValid()):
		currentEventInstance = FmodServer.create_event_instance(currentMusicEvent)
	
	currentEventInstance.start()
	
func stop_music():
	var stopMode = FmodServer.FMOD_STUDIO_STOP_IMMEDIATE
	if(IsPlaying()):
		currentEventInstance.stop(stopMode)
		currentEventInstance.release()

	
func change_music(chosenBGM:FmodEvent, duration: float = 1.0):
#	
	if((currentMusicEvent == chosenBGM) && IsPlaying()):
		return
		
	if(!IsPlaying()):
		currentMusicEvent = chosenBGM
		currentEventInstance = FmodServer.create_event_instance(currentMusicEvent)
		play_music()
	else:
		doCrossFade(chosenBGM,duration)
#
	
func doCrossFade(nextTrack:FmodEvent, duration:float):
	currentEventInstance.stop(FmodServer.FMOD_STUDIO_STOP_ALLOWFADEOUT)
	currentEventInstance.release()
	transitionEventInstance = FmodServer.create_event_instance(nextTrack.guid)
	transitionEventInstance.set_volume(0.0)
	transitionEventInstance.start()
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	
#	Can't believe i have to use lambda
	tween.tween_method(
		func(val: float) :
			transitionEventInstance.set_volume(val),
			0.0,
			1.0,
			duration
	)
	
	tween.tween_method(
		func(val:float) :
			currentEventInstance.set_volume(val),
			1.0,
			0.0,
			duration
	)
	
	tween.chain().tween_callback(_on_crossfade_complete.bind(nextTrack))
	
	
func _on_crossfade_complete(nextTrack : FmodEvent):
	if(IsPlaying()):
		currentEventInstance.stop(FmodServer.FMOD_STUDIO_STOP_IMMEDIATE)
		currentEventInstance.release()
		
	currentEventInstance = transitionEventInstance
	currentMusicEvent = nextTrack
	transitionEventInstance = null
	
	
	
	
	
	
