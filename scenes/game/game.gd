class_name Game extends Node2D

@onready var map := $Map
@onready var input_handler := $InputHandler
@onready var camera := $PlayerCamera

@onready var tile_map_layer_ground := $Map/LayerGround
@onready var tile_map_layer_item := $Map/LayerItem
@onready var tile_map_layer_furniture := $Map/LayerFurniture
@onready var tile_map_layer_actor := $Map/LayerActor

var tileset_ground := TileSet.new()
var tileset_item := TileSet.new()
var tileset_furniture := TileSet.new()
var tileset_actor := TileSet.new()

var player: Entity

func _ready() -> void:
	load_resources()
	new_game()

func new_game() -> void:
	player = EntityLoader.create("player", {"position": {"x": 0, "y": 0}})

	map.init_map(30, 30, player, camera)
	map.generate()
	render()
	
	camera.make_current.call_deferred()

func _physics_process(_delta: float) -> void:
	var action: _Action = input_handler.get_action(player, _delta)
	if action:
		var performed_action := action.perform(map)

		if performed_action is NoAction:
			return

		if performed_action is UnableToPerformAction:
			print(performed_action.reason)
			
		render()
		handle_enemy_turns()
	
func handle_enemy_turns() -> void:
	for entity: Entity in map.actors:
		if entity == player:
			continue

		if entity.components.has("ai"):
			entity.components.get("ai").perform(map)

func render() -> void:
	var player_position: Position = player.components.get("position")
	camera.position = Vector2i(player_position.x * 32, player_position.y * 32)
	
	tile_map_layer_ground.clear()
	tile_map_layer_furniture.clear()
	tile_map_layer_actor.clear()
	tile_map_layer_item.clear()
	
	for i: int in map.width:
		for j: int in map.height:
			var entity_ground: Entity = map.tiles_ground[i][j]
			if entity_ground:
				tile_map_layer_ground.set_cell(Vector2i(i, j), entity_ground.original_json.sprite_index, Vector2i(0, 0))
			
			var entity_furniture: Entity = map.tiles_furniture[i][j]
			if entity_furniture:
				tile_map_layer_furniture.set_cell(Vector2i(i, j), entity_furniture.original_json.sprite_index, Vector2i(0, 0))
				
	for actor: Entity in map.actors:
		if actor.components.has("position"):
			var position: Position = actor.components.get("position")
			tile_map_layer_actor.set_cell(Vector2i(position.x, position.y), actor.original_json.sprite_index, Vector2i(0, 0))
			
	for item: Entity in map.items:
		if item.components.has("position"):
			var position: Position = item.components.get("position")
			tile_map_layer_item.set_cell(Vector2i(position.x, position.y), item.original_json.sprite_index, Vector2i(0, 0))

func load_resources() -> void:
	load_entities_resource(tile_map_layer_ground, tileset_ground, EntityLoader.images_ground)
	load_entities_resource(tile_map_layer_item, tileset_item, EntityLoader.images_item)
	load_entities_resource(tile_map_layer_furniture, tileset_furniture, EntityLoader.images_furniture)
	load_entities_resource(tile_map_layer_actor, tileset_actor, EntityLoader.images_actor)

func load_entities_resource(tile_map_layer: TileMapLayer, tileset: TileSet, resources: Dictionary) -> void:
	tileset.tile_size = Vector2i(32, 32)

	for asset: String in resources:
		var file := load(asset)
		var s := TileSetAtlasSource.new()
		s.set_texture(file)
		s.texture_region_size = Vector2i(32,32)
		s.create_tile(Vector2i.ZERO,Vector2i(1,1))
		s.resource_name = asset
		tileset.add_source(s,-1)

	tile_map_layer.tile_set = tileset
