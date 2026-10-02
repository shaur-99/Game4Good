extends Control
@onready var settings_menu = $CanvasLayer/SettingsMenu
@onready var title_label = $Label
@onready var dim_overlay: ColorRect = get_node_or_null("DimOverlay")

func _ready() -> void:
	title_float()

func title_float() -> void:
	var start_y = title_label.position.y
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(title_label, "position:y", start_y - 10, 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(title_label, "position:y", start_y + 10, 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func GameRedirect() -> void:
	get_tree().change_scene_to_file("res://Scenes/start.tscn")


func SettingsRedirect() -> void:
	settings_menu.visible = !settings_menu.visible
	get_tree().paused = settings_menu.visible
	
func ContinueGame() -> void:
	var success = SaveManager.load_game()
	if not success:
		push_warning(
			"Could not load the saved game."
		)
		return
	var target = SaveManager.get_pending_scene_path()
	if target.is_empty():
		target = "res://Chapter 1/Clear Stream Valley.tscn"
	get_tree().change_scene_to_file(target)

func QuitGame() -> void:
	get_tree().quit()


func _on_continue_button_pressed() -> void:
	pass # Replace with function body.
