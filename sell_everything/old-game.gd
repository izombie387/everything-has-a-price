extends MarginContainer

@onready var player: VBoxContainer = $Rows/Sections/Player
@onready var enemy: VBoxContainer = $Rows/Sections/Enemy
@onready var users = [player, enemy]
var c=0

var group_sizes = {
	"hud": 3,
	"characters": 1,
	"items": 6,
	"equipment": 3,
}


func _ready() -> void:
	print(int(KEY_A))
	player.load_data(Data.loadouts["knight"])
	enemy.load_data(Data.loadouts["knight"])


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
				enemy.add_item(
					Data.random_item_name(),
					"items",
					c)
				c = (c+1)%6
			KEY_R:
				get_tree().reload_current_scene()
