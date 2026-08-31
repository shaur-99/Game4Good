extends RefCounted
class_name BeachCleanupConfig

const TRASH_ITEMS: Array[Dictionary] = [
	{
		"item_id": "plastic_bottle",
		"display_name": "Plastic Bottle",
		"trash_type": "plastic",
		"position": Vector2(380, -1850),
	},
	{
		"item_id": "plastic_bag",
		"display_name": "Plastic Bag",
		"trash_type": "plastic",
		"position": Vector2(650, -1700),
	},
	{
		"item_id": "glass_bottle",
		"display_name": "Glass Bottle",
		"trash_type": "recyclable",
		"position": Vector2(950, -1450),
	},
	{
		"item_id": "metal_can",
		"display_name": "Metal Can",
		"trash_type": "recyclable",
		"position": Vector2(1250, -1150),
	},
	{
		"item_id": "shell_food_waste",
		"display_name": "Shell / Food Waste",
		"trash_type": "organic",
		"position": Vector2(1450, -950),
	},
	{
		"item_id": "broken_fishing_net",
		"display_name": "Broken Fishing Net",
		"trash_type": "fishing_waste",
		"position": Vector2(1800, -850),
	},
]

const BINS: Array[Dictionary] = [
	{"bin_type": "plastic", "label": "Plastic", "color": Color(0.2, 0.55, 0.95, 0.35)},
	{"bin_type": "recyclable", "label": "Recyclable", "color": Color(0.35, 0.8, 0.45, 0.35)},
	{"bin_type": "organic", "label": "Organic", "color": Color(0.75, 0.55, 0.25, 0.35)},
	{"bin_type": "fishing_waste", "label": "Fishing Waste", "color": Color(0.5, 0.4, 0.3, 0.35)},
]

const WRONG_DROP_MESSAGE := "Try another bag. Sorting helps protect marine life!"
const SUCCESS_MESSAGE := "Nice sorting!"
const COMPLETION_DIALOGUE_TITLE := "beach_cleanup_complete"


static func get_item_by_id(item_id: String) -> Dictionary:
	for item in TRASH_ITEMS:
		if item.get("item_id", "") == item_id:
			return item
	return {}


static func get_collected_items(collected_ids: Array[String]) -> Array[Dictionary]:
	var items: Array[Dictionary] = []
	for item_id in collected_ids:
		var item := get_item_by_id(item_id)
		if not item.is_empty():
			items.append(item)
	return items
