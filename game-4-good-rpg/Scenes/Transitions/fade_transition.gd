extends Control

@onready var fade: ColorRect = $CanvasLayer/Fade

var is_transitioning := false

func _ready() -> void:
	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fade.color.a = 0.0


func fade_to_black(duration: float = 0.5) -> void:
	if is_transitioning:
		return

	is_transitioning = true

	var tween := create_tween()
	tween.tween_property(
		fade,
		"color:a",
		1.0,
		duration
	)

	await tween.finished


func fade_from_black(duration: float = 0.5) -> void:
	fade.color.a = 1.0

	var tween := create_tween()
	tween.tween_property(
		fade,
		"color:a",
		0.0,
		duration
	)

	await tween.finished

	is_transitioning = false

func change_scene(scene_path: String, duration: float = 0.5) -> void:
	if is_transitioning:
		return

	await fade_to_black(duration)

	get_tree().change_scene_to_file(scene_path)

	await get_tree().process_frame
	await get_tree().process_frame

	await fade_from_black(duration)
