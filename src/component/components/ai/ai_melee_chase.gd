class_name AIMeleeChase extends _AI

const ENTITY_PATHFINDING_WEIGHT := 10.0

var chase_location := Vector2i.MIN

func _init(json: Dictionary = {}) -> void:
	super(json, "ai_melee_chase")

func parse_json(json: Dictionary = {}) -> void:
	pass

func perform(map: Map) -> void:
	var entity := parent_entity
	var entity_position: Position = entity.components.get("position")
	if entity_position:
		var closest_enemies := []
		var closest_distance := -1
		var entity_faction: Faction = entity.components.get("faction")
		if entity_faction:
			for actor: Entity in map.actors:
				var fighter: Fighter = actor.components.get("fighter")
				if fighter && fighter.hp > 0:
					var actor_faction: Faction = actor.components.get("faction")
					if entity_faction.is_enemy_of(actor_faction):
						var actor_position: Position = actor.components.get("position")
					
						if actor_position:
							var distance := actor_position.distance_to(entity_position)
							if closest_distance == -1 || distance < closest_distance:
								closest_enemies.clear()
								closest_enemies.push_back(actor)
								closest_distance = distance
							elif distance == closest_distance:
								closest_enemies.push_back(actor)

		var closest_enemy: Entity
		if closest_enemies.size() >= 1:
			closest_enemy = closest_enemies.pick_random()
			
		if closest_enemy:
			var closest_enemy_position: Position = closest_enemy.components.get("position")
			chase_location = Vector2i(closest_enemy_position.x, closest_enemy_position.y)

			if closest_distance <= 1:
				return MeleeAction.new(entity, closest_enemy_position.x - entity_position.x, closest_enemy_position.y - entity_position.y).perform(map)
		else:
			if chase_location != Vector2i.MIN && entity_position.is_at(chase_location.x, chase_location.y):
				chase_location = Vector2i.MIN

			if chase_location == Vector2i.MIN:
				return WanderAction.new(entity).perform(map)
			
		var pathfinder := AStarGrid2D.new()
		pathfinder.region = Rect2i(0, 0, map.width, map.height)
		pathfinder.update()
		
		for i: int in range(0, map.width):
			for j: int in range(0, map.height):
				var blocks := false
				var ground_entity: Entity = map.tiles_ground[i][j]
				if ground_entity && ground_entity.components.has("blocks_movement"):
					var blocks_movement: BlocksMovement = ground_entity.components.get("blocks_movement")
					if blocks_movement:
						blocks = true

				if !blocks:
					var furniture_entity: Entity = map.tiles_furniture[i][j]
					if furniture_entity && furniture_entity.components.has("blocks_movement"):
						var blocks_movement: BlocksMovement = furniture_entity.components.get("blocks_movement")
						if blocks_movement:
							blocks = true
							
				pathfinder.set_point_solid(Vector2i(i, j), blocks)
		
		for actor: Entity in map.actors:
			if actor.components.has("position"):
				var actor_position: Position = actor.components.get("position")
				if actor.components.has("blocks_movement"):
					var blocks_movement: BlocksMovement = actor.components.get("blocks_movement")
					if blocks_movement.blocks_movement:
						pathfinder.set_point_weight_scale(Vector2i(actor_position.x, actor_position.y), ENTITY_PATHFINDING_WEIGHT)

		var entity_location := Vector2i(entity_position.x, entity_position.y)
		var path: Array = pathfinder.get_point_path(entity_location, chase_location)

		path.pop_front()
		
		if !path.is_empty():
			var destination := Vector2i(path[0])
			path.pop_front()

			var move_offset := destination - entity_location
			return MovementAction.new(entity, move_offset.x, move_offset.y).perform(map)

		return MovementAction.new(entity, 0, 0).perform(map)
