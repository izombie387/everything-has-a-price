extends MarginContainer

@onready var player: VBoxContainer = $Rows/Sections/Player
@onready var enemy: VBoxContainer = $Rows/Sections/Enemy
@onready var shop: VBoxContainer = $Rows/Sections/Shop
@onready var users = [player, enemy, shop]
var c=0
var group_sizes = {
	"hud": 3,
	"characters": 1,
	"items": 6,
	"actions": 3,
}

func _ready() -> void:
	for user in users:
		fill_random(user)

func fill_random(node: Node) -> void:
	for group in group_sizes:
		var count = group_sizes[group]
		for i in count:
			node.add_item(
				Data.rand_by_group(group),
				group, i)
	
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_SPACE:
				shop.add_item(
					Data.random_item_name(),
					"items",
					c)
				c = (c+1)%6
