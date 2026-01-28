extends RefCounted
class_name Data

static var items = {
	"knife": {
		"node_type": TextureRect,
		"image": load("res://sell_everything/images/knife.png"),
		"group": "items",
	},
	"white_flag": {
		"node_type": TextureRect,
		"image": load("res://sell_everything/images/white-flag.png"),
		"group": "items",
	},
	"hp_bar": {
		"node_type": ProgressBar,
		"value": 10,
		"group": "hud",
	},
	"coin_counter": {
		"node_type": Label,
		"text": "Gold: 10",
		"group": "hud",
	},
	"attack_action": {
		"node_type": Button,
		"text": "Attack",
		"group": "actions",
	},
	"placehold_character": {
		"node_type": TextureRect,
		"image": load("res://icon.svg"),
		"group": "characters",
	},
}
static var items_by_group = {}


static func _static_init() -> void:
	var dict = {}
	for item in items:
		var group = items[item]["group"]
		if group not in dict:
			dict[group] = []
		dict[group].append(item)
	items_by_group = dict
	
	
static func rand_by_group(group: String):
	return items_by_group[group].pick_random()


static func random_item_name():
	return items.keys().pick_random()


static func get_item(name: String = ""):
	if name == "":
		name = items.keys().pick_random()
	return items[name]
