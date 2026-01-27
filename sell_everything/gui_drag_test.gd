extends MarginContainer

@onready var hero: VBoxContainer = $Rows/Sections/Hero
@onready var enemy: VBoxContainer = $Rows/Sections/Enemy
@onready var shop: VBoxContainer = $Rows/Sections/Shop

func _ready() -> void:
	shop.add_item("knife")
