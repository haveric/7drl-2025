class_name BlocksMovement extends _Component

var blocks_movement := true

func _init(json: Dictionary = {}) -> void:
	super(json, "blocks_movement")

func parse_json(json: Dictionary = {}) -> void:
	blocks_movement = json.blocks_movement
