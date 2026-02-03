extends RefCounted
class_name Data

const adjacencies: = {
	1: {
		0: [1,2],
		1: [3,4],
		2: [4,5],
		3: [6],
		4: [7],
		5: [8],
		6: [3],
		7: [4],
		8: [5],
		9: [6,7],
		10: [7,8],
		11: [9,10],
	},
	2: {
		0: [3,4,5],
		1: [6,7],
		2: [7,8],
		3: [9],
		4: [9,10],
		5: [10],
		6: [1],
		7: [1,2],
		8: [2],
		9: [3,4],
		10: [4,5],
		11: [6,7,8],
	},
	3: {
		0: [6,7,8],
		1: [9],
		2: [10],
		3: [11],
		4: [11],
		5: [11],
		6: [0],
		7: [0],
		8: [0],
		9: [1],
		10: [2],
		11: [3,4,5],
	},
	4: {
		0: [9,10],
		1: [11],
		2: [11],
		3: [],
		4: [],
		5: [],
		6: [],
		7: [],
		8: [],
		9: [0],
		10: [0],
		11: [1,2],
	},
	5: {
		0: [11],
		1: [],
		2: [],
		3: [],
		4: [],
		5: [],
		6: [],
		7: [],
		8: [],
		9: [],
		10: [],
		11: [0],
	},
}
const enemy_loadouts: = {
	0: {
		8: "white_flag",
		10: "archer",
	},
}
const loadouts: = {
	"knight": {
		1: "knight", 
		#3: "knife", 
		4: "shield",
	},
	"archer": {
		1: "archer", 
		3: "white_flag",
		#4: "white_flag"
	},
	"theif": {
		#3: "knife",
		4: "theiving_gloves",
		1: "theif",
	},
}
static var items: = {
	"knife": {
		"image": load("res://sell_everything/images/knife.png"),
		"group": "items",
		"active": {
			"attack": 1,
			"range": 1,
		},
		"hp": 2,
		"price": 1,
	},
	"sword": {
		"image": load("res://sell_everything/images/sword.png"),
		"group": "items",
		"active": {
			"attack": 1,
			"range": 2,
		},
		"hp": 3,
	},
	"shield": {
		"image": load("res://sell_everything/images/shield.png"),
		"group": "equipment",
		"hp": 8,
	},
	"theiving_gloves": {
		"image": load("res://sell_everything/images/theiving-gloves.png"),
		"group": "equipment",
		"passive": {
			"gold": 1
		},
	},
	"white_flag": {
		"image": load("res://sell_everything/images/white-flag.png"),
		"group": "items",
		"hp": 5,
	},
	"archer": {
		"image": load("res://sell_everything/images/archer.png"),
		"group": "characters",
		"active": {
			"attack": 1,
			"range": 5,
		},
		"hp": 5,
	},
	"knight": {
		"image": load("res://sell_everything/images/knight.png"),
		"group": "characters",
		"hp": 10,
		"active": {
			"attack": 2,
			"range": 4,
		},
	},
	"theif": {
		"image": load("res://sell_everything/images/theif.png"),
		"group": "characters",
		"hp": 5,
		"active": {
			"attack": 2,
			"range": 3,
		},
	},
	"generic_sellable": {
		"group": "sellables",
		"value": 1,
	},
}
static var items_by_group: = {}

static func _static_init() -> void:
	var dict = {}
	for item in items:
		var group = items[item]["group"]
		if group not in dict:
			dict[group] = []
		dict[group].append(item)
	items_by_group = dict
	

static func get_tooltip(item_name: String):
	var data = items[item_name]
	var text: = item_name.capitalize()
	if "hp" in data:
		text += "\nHp: %d" % data["hp"]
	if "active" in data:
		text += "\n" + str(data["active"])
	if "passive" in data:
		text += "\n" + str(data["passive"])
	for ch in ["{", "}", '"',]:
		text = text.replace(ch, "")
	return text
	
	


static func get_adjacencies(index, item_name):
	var data = items[item_name]
	var range_ = -1
	if "active" in data and "range" in data["active"]:
		range_ = data["active"]["range"]
	else:
		return []
		
	var adj = []
	for r in range(range_, 1-1, -1):
		adj += adjacencies[r][index]
	return adj

	
static func get_item_list():
	return items
	
	
static func rand_by_group(group: String):
	return items_by_group[group].pick_random()


static func random_item_name():
	var item = null
	while item == null or items[item]["group"] == "sellables":
		item = items.keys().pick_random()
	return item

static func get_item(name: String = ""):
	if name == "":
		name = items.keys().pick_random()
	return items[name]
