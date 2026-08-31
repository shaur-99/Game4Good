extends RefCounted
class_name SprinklerIconsAtlas

const SPRITESHEET := preload("res://Assets/Chapter1/sprinkler_minigame_icons.png")
const ICON_SIZE := Vector2i(72, 72)

enum Icon {
	GROUND,
	DRY_CROP,
	HEALTHY_CROP,
	SPOT_MARKER,
	SPRINKLER,
	WATER_SPARKLE,
}


static func get_texture(icon: Icon) -> Texture2D:
	var atlas := AtlasTexture.new()
	atlas.atlas = SPRITESHEET
	atlas.region = Rect2(int(icon) * ICON_SIZE.x, 0, ICON_SIZE.x, ICON_SIZE.y)
	return atlas
