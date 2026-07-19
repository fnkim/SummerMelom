extends Node2D
class_name PaletteSwapper


@export var red: Texture2D
@export var orange: Texture2D
@export var yellow: Texture2D
@export var green: Texture2D
@export var blue: Texture2D
@export var purple: Texture2D
@export var original: Texture2D


@export var sprite: Sprite2D

@onready var timer: Timer = $Timer

var mat
var timer_going: bool
var is_rainbow: bool
func _ready() -> void:
	mat = sprite.material

func swap(color: String) -> void:
	var new_palette
	match color:
		"red":
			new_palette = red
		"orange":
			new_palette = orange
		"yellow":
			new_palette = yellow
		"green":
			new_palette = green
		"blue":
			new_palette = blue
		"purple":
			new_palette = purple
		"original":
			new_palette = original
		"rainbow":
			new_palette = red
			is_rainbow = true
			rainbow()
			return
		_:
			pass
	is_rainbow = false
	mat.set_shader_parameter("new_palette", new_palette)
	
func rainbow():
	mat.set_shader_parameter("new_palette", red)
	timer.start(0.5)
	await timer.timeout
	if is_rainbow == false:
		return
	mat.set_shader_parameter("new_palette", orange)
	timer.start(0.5)
	await timer.timeout
	if is_rainbow == false:
		return
	mat.set_shader_parameter("new_palette", yellow)
	timer.start(0.5)
	await timer.timeout
	if is_rainbow == false:
		return
	mat.set_shader_parameter("new_palette", green)
	timer.start(0.5)
	await timer.timeout
	if is_rainbow == false:
		return
	mat.set_shader_parameter("new_palette", blue)
	timer.start(0.5)
	await timer.timeout
	if is_rainbow == false:
		return
	mat.set_shader_parameter("new_palette", purple)
	timer.start(0.5)
	await timer.timeout
	if is_rainbow == false:
		return
	rainbow()
