class_name Map extends Node2D

var width: int
var height: int

var player: Entity
var camera: Camera2D

var actors: Array[Entity]
var items: Array[Entity]
var tiles_ground: Array
var tiles_furniture: Array

func init_map(_width: int, _height: int, _player: Entity, _camera: Camera2D) -> void:
	width = _width
	height = _height
	
	actors = []
	items = []
	tiles_ground = init_2d_array()
	tiles_furniture = init_2d_array()
	
	player = _player
	camera = _camera
	
	actors.append(player)
	
	for i in range(5):
		var x := randi_range(0, width - 1)
		var y := randi_range(0, height - 1)
		var enemy := EntityLoader.create("enemy", {"position": {"x": x, "y": y}})
		actors.append(enemy)

func generate() -> void:
	for i in width:
		for j in height:
			var entity := "grass"
			if i > 10 && i < width - 10 && j > 10 && j < height - 10:
				if randi_range(0, 100) < 20:
					entity = "crop_plot"
				
			tiles_ground[i][j] = EntityLoader.create(entity, {"position": {"x": i, "y": j}})
	
func init_2d_array() -> Array:
	var array := []
	array.resize(width)
	for i in range(width):
		array[i] = []
		array[i].resize(height)
		
	return array

func is_in_bounds(x: int, y: int) -> bool:
	return 0 <= x && x < width && 0 <= y && y < height

func get_blocking_entity_at_location(x: int, y: int) -> Entity:
	for entity: Entity in actors:
		if entity.components.has("position"):
			var entity_position: Position = entity.components.get("position")
			if entity_position.x == x && entity_position.y == y && entity.components.has("blocks_movement"):
				var blocks_movement_component: BlocksMovement = entity.components.get("blocks_movement")
				if blocks_movement_component.blocks_movement:
					return entity

	return null
