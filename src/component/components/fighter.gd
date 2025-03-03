class_name Fighter extends _Component

var base_max_hp: int
var hp: int = -1
var base_defense: int
var base_power: int

func _init(json: Dictionary = {}) -> void:
	super(json, "fighter")

func setup_defaults() -> void:
	if hp < 0:
		set_hp(base_max_hp)

func parse_json(json: Dictionary = {}) -> void:
	if json.has("fighter"):
		var fighter: Dictionary = json.get("fighter")
		base_max_hp = fighter.base_max_hp
		if fighter.has("hp"):
			hp = fighter.hp
		base_defense = fighter.base_defense
		base_power = fighter.base_power

func set_hp(value: int) -> void:
	hp = clampi(value, 0, base_max_hp)

	if hp <= 0:
		die()

func take_damage(amount: int) -> void:
	set_hp(hp - amount)

func die() -> void:
	print(parent_entity.entity_name + " dies!")
