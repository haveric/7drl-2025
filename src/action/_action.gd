class_name _Action extends Node

var entity: Entity

func _init(_entity: Entity) -> void:
	entity = _entity
	
func perform(map: Map) -> _Action:
	print("Error: Not Implemented")
	return null
