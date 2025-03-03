class_name MainGameEventHandler extends _EventHandler

var delta_since_last_move: float = 0
var last_movement_action: String = ""
var time_to_move: float = .1

const directions: Dictionary = {
	"move_up_left": Vector2i.UP + Vector2i.LEFT,
	"move_up_right": Vector2i.UP + Vector2i.RIGHT,
	"move_down_left": Vector2i.DOWN + Vector2i.LEFT,
	"move_down_right": Vector2i.DOWN + Vector2i.RIGHT,
	"move_up": Vector2i.UP,
	"move_down": Vector2i.DOWN,
	"move_left": Vector2i.LEFT,
	"move_right": Vector2i.RIGHT,
	"wait": Vector2i.ZERO
}

func get_action(player: Entity, _delta: float) -> _Action:
	delta_since_last_move += _delta
	var can_move: bool = delta_since_last_move > time_to_move
	if !can_move:
		if last_movement_action != "" && Input.is_action_just_released(last_movement_action):
			last_movement_action = ""
			can_move = true
			time_to_move = 0
	
	if can_move:
		for direction: String in directions:
			if Input.is_action_pressed(direction):
				var offset: Vector2i = directions[direction]
				if last_movement_action == "":
					time_to_move = .25
				else:
					time_to_move = .1
				
				delta_since_last_move = 0
				last_movement_action = direction
				
				return BumpAction.new(player, offset.x, offset.y)
	
	if Input.is_action_just_pressed("zoom_out"):
		return ZoomAction.new(player, ZoomAction.ZoomDirection.OUT)
	if Input.is_action_just_pressed("zoom_in"):
		return ZoomAction.new(player, ZoomAction.ZoomDirection.IN)
	
	return null
