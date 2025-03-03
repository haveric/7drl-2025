class_name MovementAction extends _ActionWithDirection

func perform(map: Map) -> _Action:
	if !entity.components.has("position"):
		return UnableToPerformAction.new(entity, "Entity doesn't have a position.")

	if dx == 0 && dy == 0: # Wait
		return self

	var position: Position = entity.components.get("position")

	var dest_x: int = position.x + dx
	var dest_y: int = position.y + dy

	if !map.is_in_bounds(dest_x, dest_y):
		return UnableToPerformAction.new(entity, "Location is outside the map!")

	var furniture_entity: Entity = map.tiles_furniture[dest_x][dest_y]
	if furniture_entity:
		if furniture_entity && furniture_entity.components.has("blocks_movement"):
			var blocks_movement_component: BlocksMovement = furniture_entity.components.get("blocks_movement")
			if blocks_movement_component.blocks_movement:
				return UnableToPerformAction.new(entity, "There's a " + furniture_entity.entity_name + " in the way!")

	var ground_entity: Entity = map.tiles_ground[dest_x][dest_y]
	if ground_entity:
		if ground_entity && ground_entity.components.has("blocks_movement"):
			var blocks_movement_component: BlocksMovement = ground_entity.components.get("blocks_movement")
			if blocks_movement_component.blocks_movement:
				return UnableToPerformAction.new(entity, "There's a " + ground_entity.entity_name + " in the way!")

	position.move(dx, dy)

	return self
