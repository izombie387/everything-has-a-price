extends Control


func _get_drag_data(at_position: Vector2) -> Variant:
	return {
		"cell": self,
		"on_dropped": on_dropped,
	}

func _drop_data(at_position: Vector2, data: Variant) -> void:
	pass
	
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true
	
func on_dropped():
	pass
