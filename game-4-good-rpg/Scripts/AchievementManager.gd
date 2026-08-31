
extends Node

var badges := {
	"puzzle_solver": false
}

func unlock_badge(badge_id: String) -> void:
	if badges.has(badge_id):
		badges[badge_id] = true
		print("Badge unlocked: ", badge_id)

func has_badge(badge_id: String) -> bool:
	return badges.get(badge_id, false)
