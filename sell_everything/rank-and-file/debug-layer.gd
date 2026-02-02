extends CanvasLayer

signal item_selected(item_name)
@onready var list: ItemList = $DebugList


func _ready():
	list.hide()
	for item_name in Data.items.keys():
		list.add_item(item_name)
	var extra_buttons = [
		"none", "cancel", "clear_all", "random_enemy"
	]
	for extra in extra_buttons:
		list.add_item(extra)
	for loadout_name in Data.loadouts.keys():
		list.add_item(str("load/", loadout_name))
	

func _on_debug_list_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	var item_name = list.get_item_text(index)
	item_selected.emit(item_name)
	list.hide()
