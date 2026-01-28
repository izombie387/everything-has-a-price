extends PanelContainer
class_name Slot

var user: = ""
var type: = ""
var index: = -1
var item_name = null
var item_node = null


func _ready() -> void:
	is_node_ready()
	print(name)
	var user_name = owner.name
	var parent_name = get_parent().name
	assert(user_name != "ItemCollection")
	user = user_name.to_lower()
	type = parent_name.to_lower()
	index = int(name)
	
	
func _get_drag_data(_at_position: Vector2) -> Variant:
	if item_name == null:
		return
	if user == "enemy":
		return
	var preview = ColorRect.new()
	preview.size = size/2.0
	preview.color = Color(0.416, 0.0, 0.0, 1.0)
	set_drag_preview(preview)
	print(info())
	return {
		"slot": self,
		"on_dropped": on_dropped,
	}
	
	
func info():
	return "\n".join([
		"---",
		"user", user,
		"type", type,
		"index", index,
		"item_name", item_name,
		"item_node", item_node.name if item_node else "null"
	])
	
	
func on_dropped():
	clear_item()
	

func clear_item():
	item_name = null
	item_node.queue_free()


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	var slot = data["slot"]
	if slot == self:
		return false
	if slot.user == "shop":
		return user == "player"
	elif slot.user != user:
		return false
	return true
	
	
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	set_item(data["slot"].item_name)
	data["on_dropped"].call()


func set_item(new_item_name: String):
	item_name = new_item_name
	var data = Data.get_item(new_item_name)
	var node_type = data["node_type"]
	var new_node = node_type.new()
	match node_type:
		TextureRect:
			var texture = data["image"]
			new_node.texture = texture
		Label:
			new_node.text = data["text"]
		Button:
			new_node.text = data["text"]
			new_node.pressed.connect(print.bind("button pressed"))
		ProgressBar:
			var value = data["value"]
			new_node.max_value = value
			new_node.value = value
			new_node.step = 1.0
	new_node.anchors_preset = PRESET_FULL_RECT
	new_node.size_flags_horizontal = SIZE_EXPAND_FILL
	new_node.size_flags_vertical = SIZE_EXPAND_FILL
	add_child(new_node)
	item_node = new_node
			
