class_name InputHandler extends Node

var current_input_handler: _EventHandler

func _ready() -> void:
	current_input_handler = MainGameEventHandler.new()
	
func get_action(player: Entity, _delta: float) -> _Action:
	return current_input_handler.get_action(player, _delta)
