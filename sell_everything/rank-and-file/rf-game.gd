extends Control

const ajacencies = {
	"range_1": {
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
	}
}
@onready var player: Control = $MarginContainer/VBoxContainer/HBoxContainer/Player
@onready var enemy: Control = $MarginContainer/VBoxContainer/HBoxContainer/Enemy
@onready var users = [player, enemy]
var c=0
var current_cell = 0


var group_sizes = {
	"back": 1,
	"middle": 2,
	"front": 3,
}
var cells = []

func _ready() -> void:
	print(int(KEY_A))
	player.load_data(Data.loadouts["knight"])
	enemy.load_data(Data.loadouts["knight"])
	cells = player.cells + enemy.cells
	poke_cells()
	
	
func poke_cells():
	for cell in cells:
		cell.get_node("AnimationPlayer").play("attack")
		await get_tree().create_timer(0.10).timeout


func process_cell(idx):
	var cell = cells[idx]
	var item_name = cell.item_name
	if item_name == null or cell.hp <= 0:
		return false
	var item = Data.get_item(item_name)
	var active = item.get("active")
	if not active:
		return false
	
	var target = null
	for ci in ajacencies["range_1"][idx]:
		var cl = cells[ci]
		if cl.item_name and cl.hp > 0:
			target = cl
			break
	if target == null:
		return false
			
	var attack_amount = active.get("attack")
	cell.attack_target(target, attack_amount)
	target.recieve_damage_from(cell, attack_amount)
	
	return true
	

func fill_random(node: Node) -> void:
	for group in group_sizes:
		var count = group_sizes[group]
		for i in count:
			node.add_item(
				Data.rand_by_group(group),
				group, i)


func process_next_cell():
	for i in cells.size():
		if process_cell(current_cell):
			break
		current_cell = (current_cell + 1) % cells.size()
	current_cell = (current_cell + 1) % cells.size()

	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_P:
				process_next_cell()
			KEY_SPACE:
				enemy.add_item(
					Data.random_item_name(),
					"items",
					c)
				c = (c+1)%6
			KEY_R:
				get_tree().reload_current_scene()
