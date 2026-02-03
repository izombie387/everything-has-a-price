extends Control

var sold: = false
var item_name = "generic_sellable"

# Can drag sellables
func _get_drag_data(_at_position: Vector2) -> Variant:
	if sold:
		return
	return {
		"dragging_item": item_name,
		"user": "sellable",
		"on_dropped": on_dropped,
		"node": self,
	}

# Can't drop onto sellables
func _drop_data(_at_position: Vector2, _data: Variant) -> void:
	assert(false, "Can't drop onto sellables")
	
# Can't drop onto sellables
func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return false
	
# This sellable was sold
func on_dropped(drop_code, _other_item):
	if drop_code == "sell":
		Globals.add_gold(
			Data.get_item(item_name).get("value",1))
		clear_item()
		
func clear_item():
	sold = true
	modulate = Color(1.0, 1.0, 1.0, 0.1)
	set("disabled", true)
