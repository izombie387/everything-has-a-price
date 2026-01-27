extends Panel
class_name Slot

@onready var tex: TextureRect = $Tex
var user: = ""
var type: = ""
var index: = -1
var item = null


func _ready() -> void:
	var user_name = owner.name
	var parent_name = get_parent().name
	assert(user_name != "ItemCollection")
	user = user_name.to_lower()
	type = parent_name.to_lower()
	index = int(name)
	
	
func _get_drag_data(_at_position: Vector2) -> Variant:
	if item == null:
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
		"item", item,
	])
	
func on_dropped():
	clear_item()
	

func clear_item():
	item	 = null
	tex.texture = null


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
	set_item(data["slot"].item)
	data["on_dropped"].call()


func set_item(item_name: String):
	item = item_name
	var texture = Data.get_item(item_name)["image"]
	tex.texture = texture
