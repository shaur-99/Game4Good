extends Node

var badges := {
	"puzzle_solver": false,
	"thoughtful_listener": false,
}


func unlock_badge(badge_id: String) -> void:
	if badges.has(badge_id):
		badges[badge_id] = true
		print(
			"Badge unlocked: ",
			badge_id
		)


func has_badge(badge_id: String) -> bool:
	return badges.get(
		badge_id,
		false
	)


func to_dict() -> Dictionary:
	return {
		"badges": badges.duplicate(true)
	}


func load_from_dict(data: Dictionary) -> void:
	var saved_badges: Variant = data.get(
		"badges",
		{}
	)

	if not saved_badges is Dictionary:
		push_warning(
			"Invalid achievement save data."
		)
		return

	for badge_id in badges:
		badges[badge_id] = saved_badges.get(
			badge_id,
			false
		)
