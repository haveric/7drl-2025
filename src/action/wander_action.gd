class_name WanderAction extends _Action

func perform(map: Map) -> _Action:
	var dx := randi_range(-1, 1)
	var dy := randi_range(-1, 1)

	return MovementAction.new(entity, dx, dy).perform(map)
