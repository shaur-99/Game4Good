extends Node

signal choice_recorded(
	conversation_id: String,
	choice_id: String,
	style: String
)

const VALID_STYLES := [
	"curious",
	"empathetic",
	"action",
]
const THOUGHTFUL_LISTENER_BADGE := "thoughtful_listener"
const THOUGHTFUL_LISTENER_THRESHOLD := 3

var choices: Dictionary = {}
var style_counts := {
	"curious": 0,
	"empathetic": 0,
	"action": 0,
}


func record_choice(
	conversation_id: String,
	choice_id: String,
	style: String
) -> void:
	var normalized_style := style.to_lower()
	if conversation_id.is_empty() or choice_id.is_empty():
		push_warning("Dialogue choice IDs cannot be empty.")
		return
	if normalized_style not in VALID_STYLES:
		push_warning(
			"Unknown dialogue choice style: %s"
			% style
		)
		return

	var previous: Variant = choices.get(
		conversation_id,
		{}
	)
	if previous is Dictionary:
		var previous_choice := str(
			previous.get("choice_id", "")
		)
		var previous_style := str(
			previous.get("style", "")
		)
		if (
			previous_choice == choice_id
			and previous_style == normalized_style
		):
			return
		_decrement_style(previous_style)

	choices[conversation_id] = {
		"choice_id": choice_id,
		"style": normalized_style,
	}
	style_counts[normalized_style] = (
		int(style_counts.get(normalized_style, 0))
		+ 1
	)
	_update_achievement()
	choice_recorded.emit(
		conversation_id,
		choice_id,
		normalized_style
	)


func get_choice(conversation_id: String) -> String:
	var saved_choice: Variant = choices.get(
		conversation_id,
		{}
	)
	if not saved_choice is Dictionary:
		return ""
	return str(saved_choice.get("choice_id", ""))


func get_total_choices() -> int:
	return choices.size()


func get_dominant_style() -> String:
	var highest_count := 0
	var leaders: Array[String] = []
	for style in VALID_STYLES:
		var count := int(style_counts.get(style, 0))
		if count > highest_count:
			highest_count = count
			leaders = [style]
		elif count == highest_count and count > 0:
			leaders.append(style)
	if leaders.size() != 1:
		return "balanced"
	return leaders[0]


func to_dict() -> Dictionary:
	return {
		"choices": choices.duplicate(true),
	}


func load_from_dict(data: Dictionary) -> void:
	_reset_state()
	var saved_choices: Variant = data.get(
		"choices",
		{}
	)
	if not saved_choices is Dictionary:
		push_warning("Invalid dialogue choice save data.")
		return

	for conversation_id_value in saved_choices:
		var conversation_id := str(
			conversation_id_value
		)
		var saved_choice: Variant = saved_choices[
			conversation_id_value
		]
		if not saved_choice is Dictionary:
			continue
		var choice_id := str(
			saved_choice.get("choice_id", "")
		)
		var style := str(
			saved_choice.get("style", "")
		).to_lower()
		if (
			conversation_id.is_empty()
			or choice_id.is_empty()
			or style not in VALID_STYLES
		):
			continue
		choices[conversation_id] = {
			"choice_id": choice_id,
			"style": style,
		}
		style_counts[style] = (
			int(style_counts.get(style, 0))
			+ 1
		)
	_update_achievement()


func reset_choices() -> void:
	_reset_state()


func _decrement_style(style: String) -> void:
	if style not in VALID_STYLES:
		return
	style_counts[style] = maxi(
		0,
		int(style_counts.get(style, 0)) - 1
	)


func _reset_state() -> void:
	choices.clear()
	for style in VALID_STYLES:
		style_counts[style] = 0


func _update_achievement() -> void:
	if get_total_choices() < THOUGHTFUL_LISTENER_THRESHOLD:
		return
	var achievement_manager := get_node_or_null(
		"/root/AchievementManager"
	)
	if achievement_manager != null:
		achievement_manager.unlock_badge(
			THOUGHTFUL_LISTENER_BADGE
		)
