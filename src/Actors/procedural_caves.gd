extends TileMap

@export var width   = 160
@export var height  = 90

var fnl = FastNoiseLite.new()

func _ready() -> void:
	
	randomize()
	
	fnl.seed = randi()
	fnl.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	fnl.fractal_octaves = 2
	fnl.frequency = randf_range(0.05,0.12)
	
	generateMap()
	
func generateMap() -> void:
	for x in range(width):
		for y in range(height):
			var noiseValue := fnl.get_noise_2d(x,y)
			if noiseValue < 0.04:
				set_cell(0, Vector2i(x,y), 0, Vector2i(1,1))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
