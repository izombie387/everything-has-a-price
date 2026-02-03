extends PanelContainer
class_name Cell

@export var hp_bar: ProgressBar
@export var anim: AnimationPlayer
@export var tex: TextureRect

signal clicked(index)

var user: = ""
var type: = ""
var index: = -1
var item_name = null

var hp = -1
var hp_tween
static var phase: = ""


func _ready() -> void:
	hp_bar.hide()
	var user_name = owner.name
	assert(user_name != "ItemCollection")
	user = user_name.to_lower()
	if user == "enemy":
		tex.flip_h = true
		hp_bar.theme_type_variation = "EnemyProgressBar"

	var parent_name = get_parent().name
	type = parent_name.to_lower()
	
	
static func set_phase(p):
	phase = p


func revive():
	if item_name:
		set_item(item_name)

	
func hilight(hilight_ = true):
	if hilight_:
		modulate = Color(0.554, 0.741, 1.572, 1.0)
	else:
		modulate = Color.WHITE
	
	
func _get_drag_data(_at_position: Vector2) -> Variant:
	if not item_name or phase == "character_select":
		return null
	assert(item_name != "", "not using this syntax")
	if user == "enemy" and phase != "shop":
		return null
		
	var preview = ColorRect.new()
	preview.size = size/2.0
	preview.color = Color(0.4, 0.0, 0.0, 0.4)
	set_drag_preview(preview)
	
	return {
		"dragging_item": item_name,
		"user": user,
		"on_dropped": on_dropped,
		"node": self,
	}

	
# Dropping here
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	Globals.play_sfx("swipe")
	var drop_code = null
	if data["user"] == "player":
		drop_code = "swap"
	else:
		drop_code = "buy"
	data["on_dropped"].call(drop_code, item_name)
	#clear_item()
	var inc_item = data["dragging_item"]
	if inc_item:
		set_item(inc_item)


# Can drop here
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	# Self swapping
	if user == "player" and data["user"] == "player" and data["node"] != self:
		return true
	# Shopping
	if data["user"] == "enemy"\
			and user == "player"\
			and phase == "shop"\
			and item_name == null\
			and Globals.get_gold() >= data.get("value", 1):
		return true
	return false

# I was dropped onto other_item
func on_dropped(drop_code, other_item):
	print("drop code: ", drop_code)
	print("other item: ", other_item)
	match drop_code:
		"sell":
			Globals.add_gold(
					Data.get_item(item_name).get("value",1))
			clear_item()
		"buy":
			Globals.add_gold(
					-Data.get_item(item_name).get("value",1))
			clear_item()
		"swap":
			clear_item()
			if other_item:
				set_item(other_item)


func clear_item():
	hp_bar.hide()
	tex.texture = null
	item_name = null
	
	
func set_item(new_item_name: String):
	anim.play("RESET")
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
	hilight(false)
	if anim.is_playing():
		await anim.animation_finished
	anim.play("die")
	await anim.animation_finished
	hilight(false)
	
	
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
