extends Node
var db = {}

func register_item(item: ItemsData):
	db[item.item_name] = item
