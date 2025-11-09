extends Node
const SAVE_PATH = "user://save.dat"

const player_inv: Inventory = preload("res://entity/players/playerInventory.tres")

func save_game(inv: Inventory):
	var save_data = {
		"inventory": inv.to_dict()
	}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(save_data)
	file.close()
	print("Game Saved")

func load_game(inv: Inventory, items_db: Dictionary):
	if not FileAccess.file_exists(SAVE_PATH):
		print("No Save")
		return
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data = file.get_var()
	file.close()
	
	inv.from_dict(data["inventory"], items_db)
	print("GAME LOADED")
