extends RefCounted
class_name Data
static var items = {
	"knife": {
		"node_type": TextureRect,
		"image": load("res://sell_everything/images/knife.png"),
	},
	"white_flag": {
		"node_type": TextureRect,
		"image": load("res://sell_everything/images/white-flag.png"),
	},
	"hp_bar": {
		"node_type": ProgressBar,
		"value": 10,
	},
	"coin_counter": {
		"node_type": Label,
		"text": "G:",
	},
	"attack_action": {
		"node_type": Button,
		"text": "Attack",
	},
}

static func random_item_name():
	return items.keys().pick_random()

static func get_item(name: String = ""):
	if name == "":
		name = items.keys().pick_random()
	return items[name]
