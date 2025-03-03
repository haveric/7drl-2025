class_name Faction extends _Component

var factions: Array[String] = []
var enemies: Array[String] = []

func _init(json: Dictionary = {}) -> void:
	super(json, "faction")

func parse_json(json: Dictionary = {}) -> void:
	if json.has("faction"):
		var faction: Dictionary = json.get("faction")
		if faction.has("factions"):
			factions.assign(faction.factions)
		if faction.has("enemies"):
			enemies.assign(faction.enemies)

func is_enemy_of(other_faction: Faction) -> bool:
	if !other_faction:
		return false

	for faction in factions:
		if other_faction.enemies.has(faction):
			return true

	return false
