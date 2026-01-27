extends RefCounted
class_name Data
static var items = {
	"knife": {
		"image": load("res://sell_everything/images/knife.png"),
	},
}

static func get_item(name: String):
	return items[name]
