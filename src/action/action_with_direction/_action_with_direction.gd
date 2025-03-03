class_name _ActionWithDirection extends _Action

var dx := 0
var dy := 0

func _init(_entity: Entity, _dx: int, _dy: int) -> void:
	super(_entity)
	dx = _dx
	dy = _dy
