extends RefCounted
class_name BeachTrashAtlas

const SPRITESHEET := preload("res://Assets/Chapter2/beach_trash_spritesheet.png")
const ICON_SIZE := Vector2i(64, 64)

const ITEM_COLUMNS: Dictionary = {
	"plastic_bottle": 0,
	"plastic_bag": 1,
	"glass_bottle": 2,
	"metal_can": 3,
	"shell_food_waste": 4,
	"broken_fishing_net": 5,
}


static func get_texture(item_id: String) -> Texture2D:
	var column: int = int(ITEM_COLUMNS.get(item_id, 0))
	var atlas := AtlasTexture.new()
	atlas.atlas = SPRITESHEET
	atlas.region = Rect2(column * ICON_SIZE.x, 0, ICON_SIZE.x, ICON_SIZE.y)
	return atlas
