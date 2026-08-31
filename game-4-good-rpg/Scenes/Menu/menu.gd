extends Control
@onready var settings_menu = $CanvasLayer/SettingsMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func GameRedirect() -> void:
	get_tree().change_scene_to_file("res://Scenes/start.tscn")


func SettingsRedirect() -> void:
	settings_menu.visible = !settings_menu.visible
	get_tree().paused = settings_menu.visible


func QuitGame() -> void:
	get_tree().quit()
