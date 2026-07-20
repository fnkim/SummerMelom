extends Node2D

@onready var red: TileMapLayer = $"../Red"
@onready var orange: TileMapLayer = $"../Orange"
@onready var yellow: TileMapLayer = $"../Yellow"
@onready var green: TileMapLayer = $"../Green"
@onready var blue: TileMapLayer = $"../Blue"
@onready var purple: TileMapLayer = $"../Purple"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ColorManager.change_color.connect(update_state)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_state(color: ColorManager.ColorState) -> void:
	red.visible = false
	red.collision_enabled = false
	orange.visible = false
	orange.collision_enabled = false

	match color:
		ColorManager.ColorState.RED:
			red.visible = true
			red.collision_enabled = true
		ColorManager.ColorState.ORANGE:
			orange.show()
		ColorManager.ColorState.YELLOW:
			yellow.show()
		ColorManager.ColorState.GREEN:
			green.show()
		ColorManager.ColorState.BLUE:
			blue.show()
		ColorManager.ColorState.PURPLE:
			purple.show()
		_:
			pass
