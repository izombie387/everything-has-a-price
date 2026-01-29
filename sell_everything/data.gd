extends RefCounted
class_name Data

const loadouts: = {
	"knight": {
		"items":["knife"],
		"equipment":["shield"],
		"characters":["knight"],
	},
	"archer": {},
	"theif": {},
}
static var items = {
	"knife": {
		"image": load("res://sell_everything/images/knife.png"),
		"group": "items",
		"active": {"attack": 1},
		"cooldown": 1.0,
		"hp": 2,
	},
	"shield": {
		"image": load("res://sell_everything/images/shield.png"),
		"group": "equipment",
		"hp": 8,
	},
	"theiving_gloves": {
		"image": load("res://sell_everything/images/theiving-gloves.png"),
		"group": "equipment",
		"passive": {"steals": 1},
	},
	"white_flag": {
		"image": load("res://sell_everything/images/white-flag.png"),
		"group": "items",
		"hp": 5,
	},
	"archer": {
		"image": load("res://sell_everything/images/archer.png"),
		"group": "characters",
		"active": {"attack": 2},
		"hp": 5,
	},
	"knight": {
		"image": load("res://sell_everything/images/knight.png"),
		"group": "characters",
		"hp": 10,
	},
	"theif": {
		"image": load("res://sell_everything/images/theif.png"),
		"group": "characters",
		"hp": 5,
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
