extends CanvasLayer

signal item_selected(item_name)
@onready var list: ItemList = $DebugList


func _ready():
	hide()
	for item_name in Data.items.keys():
		list.add_item(item_name)


func _on_debug_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	var item_name = list.get_item_text(index)
	item_selected.emit(item_name)
	hide()
