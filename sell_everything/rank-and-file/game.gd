extends Control

# Range: {Cell: cells in range}
const adjacencies = {
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
		0: [9.10],
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
	await get_tree().process_frame
	player.load_data(Data.loadouts["knight"])
	enemy.load_data(Data.loadouts["knight"])
	cells = player.cells + enemy.cells
	poke_cells()
	var i = 0
	for cell in cells:
		cell.clicked.connect(_cell_clicked)
		cell.index = i
		i += 1
		


func _cell_clicked(index):
	var debug = $DebugLayer
	debug.show()
	var item_name = await debug.item_selected
	cells[index].set_item(item_name)
	
	
func poke_cells():
	for cell in cells:
		cell.get_node("AnimationPlayer").play("shine")
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
	var range_ = active["range"]
	for ci in adjacencies[range_][idx]:
		var cl = cells[ci]
		if cl.item_name and \
				cl.user != cell.user and \
				cl.hp > 0:
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
			KEY_F:
				var w: = get_window()
				if w.mode == w.MODE_FULLSCREEN:
					w.mode = w.MODE_WINDOWED
				else:
					w.mode = w.MODE_FULLSCREEN

#func get_adjacencies():
	#var adj = {}
	#var map_width = 5
	#
	#var x_positions = []
	#for cell in cells:
		#var x = cell.global_position.x
		#if x not in x_positions:
			#x_positions.append(x)
			#
	#for range_ in range(1, map_width+1):
		#adj[range_] = {}
		#for i in player.cells.size():
			#var player_cell = player.cells[i]
			#adj[range_][player_cell.index] = []
			#var player_rect: Rect2 = Rect2(
					#player_cell.global_position, player_cell.size)
					#
			#var player_rank = x_positions.find(player_cell.global_position.x)
			#var target_rank = player_rank + range_
			#if target_rank >= x_positions.size():
				#continue
			#var target_rank_x = x_positions[target_rank]
			#player_rect.position.x = target_rank_x
			#
			#for target_cell in cells.filter(func(tc): return tc.global_position.x == target_rank_x):
				#if player_cell == target_cell:
					#continue
				#var target_rect = Rect2(target_cell.global_position, target_cell.size)
				#if player_rect.intersects(target_rect):
					#adj[range_][player_cell.index].append(target_cell.index)
					#
	#for e_cell in enemy.cells:
		## project left...
		#pass
		#
	#return adj
