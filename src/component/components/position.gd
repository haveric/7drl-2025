class_name Position extends _Component

var x := -1
var y := -1

func _init(json: Dictionary = {}) -> void:
	super(json, "position")

func parse_json(json: Dictionary = {}) -> void:
	if json.has("position"):
		var position: Dictionary = json.get("position")
		if position.has("x"):
			x = position.x
		if position.has("y"):
			y = position.y

func move(x_offset: int, y_offset: int) -> void:
	x += x_offset
	y += y_offset

func distance_to(position: Position) -> int:
	var dx: int = abs(position.x - x)
	var dy: int = abs(position.y - y)

	return max(dx, dy)

func is_at(_x: int, _y: int) -> bool:
	return x == _x && y == _y
