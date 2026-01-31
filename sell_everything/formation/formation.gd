## Formation
@tool
extends MarginContainer

@onready var ranks_container: HBoxContainer = $RanksContainer
@onready var back: VBoxContainer = $RanksContainer/Back
@onready var middle: VBoxContainer = $RanksContainer/Middle
@onready var front: VBoxContainer = $RanksContainer/Front
@export var flipped: = false:
	set(v):
		if not is_node_ready(): await ready
		flipped = v
		if flipped:
			ranks_container.move_child(back, -1)
			ranks_container.move_child(front, 0)
		else:
			ranks_container.move_child(back, 0)
			ranks_container.move_child(front, -1)

# Default placement, not strict
@onready var ranks: = {
	"characters": back,
	"equipment": middle,
	"items": front,
}
var cells = []


func _ready() -> void:
	if name == "Enemy":
		flipped = true
	var rank_nodes = ranks.values()
	if flipped: 
		rank_nodes.reverse()
	for rank in rank_nodes:
		for cell in rank.get_children():
			cells.append(cell)
	clear_cells()


func clear_cells():
	for cell in cells:
		cell.clear_item()


func load_data(data):
	for rank in data:
		var i=0
		for item in data[rank]:
			add_item(item, rank, i)
			i+=1


func add_item(
		item_name: String,
		rank: String,
		index: int,
):
	var slot = ranks[rank].get_children()[index]
	if slot.item_name:
		slot.clear_item()
	slot.set_item(item_name)
