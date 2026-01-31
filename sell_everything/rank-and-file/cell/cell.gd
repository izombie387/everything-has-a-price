extends PanelContainer

@onready var hp_bar: ProgressBar = $MarginContainer/ProgressBar
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var tex: TextureRect = $MarginContainer/MarginContainer/TextureRect
enum Phase {STEAL, FIGHT}

signal clicked(index)

var user: = ""
var type: = ""
var index: = -1
var item_name = null
var phase: = Phase.STEAL
var hp = -1
var hp_tween


func _ready() -> void:
	var user_name = owner.name
	assert(user_name != "ItemCollection")
	user = user_name.to_lower()
	if user == "enemy":
		tex.flip_h = true

	var parent_name = get_parent().name
	type = parent_name.to_lower()
	
	
func hilight(hilight = true):
	if hilight:
		modulate = Color(0.554, 0.741, 1.572, 1.0)
	else:
		modulate = Color.WHITE
	
	
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
	if item_name:
		clear_item()
	if swap_item:
		set_item(swap_item)


func clear_item():
	hp_bar.hide()
	tex.texture = null
	item_name = null
	
	
func set_item(new_item_name: String):
	hp_bar.show()
	item_name = new_item_name
	tooltip_text = Data.get_tooltip(item_name)
	
	var data = Data.get_item(item_name)
	var texture = data["image"]
	tex.texture = texture
	
	hp = data.get("hp", 10)
	hp_bar.max_value = hp
	hp_bar.value = hp
	
	
func attack_target(_target, _amount):
	anim.play("attack")
	

func recieve_damage_from(_cell, amount):
	anim.play("take_damage")
	hp -= amount
	if hp_tween:
		anim.play("RESET")
		hp_tween.kill()
	hp_tween = create_tween()
	hp_tween.tween_property(hp_bar, "value", hp, 0.22).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	if hp <= 0:
		await hp_tween.finished
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

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
			and event.pressed \
			and event.button_index == MOUSE_BUTTON_RIGHT:
		clicked.emit(self)
