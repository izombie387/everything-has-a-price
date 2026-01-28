extends MarginContainer

@onready var player: VBoxContainer = $Rows/Sections/Player
@onready var enemy: VBoxContainer = $Rows/Sections/Enemy
@onready var shop: VBoxContainer = $Rows/Sections/Shop

func _ready() -> void:
	pass
	
var c=0
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_SPACE:
				shop.add_item(
					Data.random_item_name(),
					"items",
					c)
				c = (c+1)%6
