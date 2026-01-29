extends Control
class_name Slot

enum Phase {STEAL, FIGHT}
@onready var hp_bar: ProgressBar = $MarginContainer/ProgressBar
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var tex: TextureRect = $MarginContainer/MarginContainer/TextureRect
var user: = ""
var type: = ""
var index: = -1
var item_name = null
var phase: = Phase.STEAL
var hp = -1


func _ready() -> void:
	var user_name = owner.name
	var parent_name = get_parent().name
	assert(user_name != "ItemCollection")
	user = user_name.to_lower()
	type = parent_name.to_lower()
	index = int(name)
	
	
func _get_drag_data(_at_position: Vector2) -> Variant:
	if not item_name:
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
	if item_name:
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
	if item_name:
		clear_item()
	if swap_item:
		set_item(swap_item)


func clear_item():
	tex.texture = null
	item_name = null
	
	
func set_item(new_item_name: String):
	item_name = new_item_name
	tooltip_text = item_name.capitalize()
	
	var data = Data.get_item(item_name)
	var texture = data["image"]
	tex.texture = texture
	
	hp = data["hp"]
	hp_bar.max_value = hp
	hp_bar.value = hp
	
	
func attack_target(_target, _amount):
	anim.play("attack")
	

func recieve_damage_from(_cell, amount):
	anim.play("take_damage")
	hp -= amount
	hp_bar.value = hp
	if hp <= 0:
		die()
	
	
func die():
	anim.play("die")
	
	
func info():
	return str(
		"---",
		"\nuser: ", user,
		"\ntype: ", type,
		"\nindex: ", index,
		"\nitem_name: ", item_name,
	)
