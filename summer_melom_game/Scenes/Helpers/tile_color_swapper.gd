extends Node2D

@onready var red: TileMapLayer = $Red
@onready var orange: TileMapLayer = $Orange
@onready var yellow: TileMapLayer = $Yellow
@onready var green: TileMapLayer = $Green
@onready var blue: TileMapLayer = $Blue
@onready var purple: TileMapLayer = $Purple



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ColorManager.change_color.connect(update_state)
	update_state(ColorManager.ColorState.NONE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_state(color: ColorManager.ColorState) -> void:
	red.visible = false
	red.collision_enabled = false
	orange.visible = false
	orange.collision_enabled = false
	yellow.visible = false
	yellow.collision_enabled = false
	green.visible = false
	green.collision_enabled = false
	blue.visible = false
	blue.collision_enabled = false
	purple.visible = false
	purple.collision_enabled = false

	match color:
		ColorManager.ColorState.RED:
			red.visible = true
			red.collision_enabled = true
		ColorManager.ColorState.ORANGE:
			orange.visible = true
			orange.collision_enabled = true
		ColorManager.ColorState.YELLOW:
			yellow.visible = true
			yellow.collision_enabled = true
		ColorManager.ColorState.GREEN:
			green.visible = true
			green.collision_enabled = true
		ColorManager.ColorState.BLUE:
			blue.visible = true
			blue.collision_enabled = true
		ColorManager.ColorState.PURPLE:
			purple.visible = true
			purple.collision_enabled = true
		_:
			pass
