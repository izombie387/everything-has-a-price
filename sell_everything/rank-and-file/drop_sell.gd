extends PanelContainer

@export var gold_label: Label
	
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data["user"] != "enemy"

# Drop data here (selling to shop)
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	Globals.play_sfx("swipe")
	data["on_dropped"].call("sell", null)
	
func _get_drag_data(_at_position: Vector2) -> Variant:
	return null
