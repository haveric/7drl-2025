class_name ComponentLoader extends Node

var components_resource:ResourceGroup = preload("res://src/component/components.tres")

static var components := []
static var component_map: Dictionary

func _ready() -> void:
	for path in components_resource.paths:
		var component: _Component = load(path).new()
		components.append(component)
		component_map.get_or_add(component.type, component)

static func create(name: String, json: Dictionary = {}) -> _Component:
	var component: _Component = null
	if component_map.has(name):
		component = component_map.get(name).clone(json)
	else:
		print("ERROR: Missing Component id: ", name)

	return component

static func load_from_json(parent_entity: Entity, _components: Dictionary, json: Dictionary = {}) -> void:
	for component:_Component in components:
		if json.has(component.type):
			var json_to_add := {
				component.base_type: json.get(component.base_type)
			}
			var clone := component.duplicate()

			clone.parse_json(json_to_add)
			clone.set_parent_entity(parent_entity)
			_components.get_or_add(clone.base_type, clone)
