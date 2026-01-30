extends PanelContainer
#class_name Slot

enum Phase {STEAL, FIGHT}
var user: = ""
var type: = ""
var index: = -1
var item_name = null
var item_node = null
var phase: = Phase.STEAL


func _ready() -> void:
	var user_name = owner.name
	var parent_name = get_parent().name
	assert(user_name != "ItemCollection")
	user = user_name.to_lower()
	type = parent_name.to_lower()
	index = int(name)
	
	
func _get_drag_data(_at_position: Vector2) -> Variant:
	if not is_instance_valid(item_node):
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

	
# Dropping here
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var incoming = data["slot"]
	var swap = null
	if is_instance_valid(item_node):
		if incoming.user == "player":
			swap = item_name
		clear_item()
	print(data["slot"].info())
	set_item(data["slot"].item_name)
	data["on_dropped"].call(swap)


# Can drop here
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	var from_slot = data["slot"]
	# Self swapping
	if user == "player" and from_slot.user == "player" and from_slot != self:
		return true
	# Stealing
	if from_slot.user == "enemy" and phase == Phase.STEAL:
		return user == "player"
	return false

# I was dropped elsewhere
func on_dropped(swap_item):
	print("setting: ", swap_item)
	if is_instance_valid(item_node):
		clear_item()
	if swap_item:
		set_item(swap_item)


func clear_item():
	print("clear item call")
	item_node.queue_free()
	item_node = null
	item_name = null
	
	
func set_item(new_item_name: String):
	item_name = new_item_name
	tooltip_text = item_name.capitalize()
	var data = Data.get_item(item_name)
	var node_type = data["node_type"]
	var n = node_type.new()
	match node_type:
		TextureRect:
			var texture = data["image"]
			n.texture = texture
			n.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		Label:
			n.text = data["text"]
			n.clip_text = true
			n.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			n.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_:
			print("class not handled")
	n.mouse_filter = MOUSE_FILTER_IGNORE
	n.anchors_preset = PRESET_FULL_RECT
	n.size_flags_horizontal = SIZE_EXPAND_FILL
	n.size_flags_vertical = SIZE_EXPAND_FILL
	add_child(n)
	item_node = n
	
	
func info():
	return str(
		"---",
		"\nuser: ", user,
		"\ntype: ", type,
		"\nindex: ", index,
		"\nitem_name: ", item_name,
		"\nitem_node: ", item_node.name if item_node else "null"
	)
