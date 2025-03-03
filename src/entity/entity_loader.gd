class_name EntityLoader extends Node

var entities_resource:ResourceGroup = preload("res://src/entity/entities.tres")
static var entity_map: Dictionary

static var images_ground: Dictionary
static var images_item: Dictionary
static var images_furniture: Dictionary
static var images_actor: Dictionary

var index_ground: int
var index_item: int
var index_furniture: int
var index_actor: int

func _ready() -> void:
	index_ground = 0
	index_item = 0
	index_furniture = 0
	index_actor = 0

	for path in entities_resource.paths:
		var json_as_text := FileAccess.get_file_as_string(path)
		var json := JSON.new()
		json.parse(json_as_text)
		var parsed_json: Variant = json.get_data()
		if parsed_json is Array:
			for entity: Dictionary in parsed_json:
				process_entity(entity)
		else:
			process_entity(parsed_json)

func process_entity(entity: Dictionary) -> void:
	if entity.has("extends"):
		entity.merge(entity_map.get(entity.extends).original_json)
		entity.erase("extends")

	if entity.has("sprite") and entity.has("sprite_layer"):
		var layer: String = entity.get("sprite_layer")

		if layer == "ground":
			if not images_ground.has("res://" + entity.sprite):
				images_ground.get_or_add("res://" + entity.sprite)
				entity.sprite_index = index_ground
				index_ground += 1
		elif layer == "item":
			if not images_item.has("res://" + entity.sprite):
				images_item.get_or_add("res://" + entity.sprite)
				entity.sprite_index = index_item
				index_item += 1
		elif layer == "furniture":
			if not images_furniture.has("res://" + entity.sprite):
				images_furniture.get_or_add("res://" + entity.sprite)
				entity.sprite_index = index_furniture
				index_furniture += 1
		elif layer == "actor":
			if not images_actor.has("res://" + entity.sprite):
				images_actor.get_or_add("res://" + entity.sprite)
				entity.sprite_index = index_actor
				index_actor += 1

	entity_map.get_or_add(entity.id, Entity.new(entity))
	
static func create(name: String, json: Dictionary = {}) -> Entity:
	var entity: Entity = null
	if entity_map.has(name):
		var cloned_json: Dictionary = entity_map.get(name).original_json.duplicate(true)
		cloned_json.merge(json)
		entity = Entity.new(cloned_json)
	else:
		print("ERROR: Missing Entity id: ", name)

	return entity
