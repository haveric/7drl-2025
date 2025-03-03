class_name Entity extends Node

var original_json: Dictionary = {}
var components: Dictionary = {}
var entity_name: String

func _init(_json:Dictionary = {}) -> void:
	original_json = _json
	
	if original_json.has("name"):
		entity_name = original_json.get("name")
	
	load_components(original_json)

func load_components(_json: Dictionary = {}) -> void:
	ComponentLoader.load_from_json(self, components, _json)

func clone(json: Dictionary) -> Entity:
	return Entity.new(json)
