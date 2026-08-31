extends StaticBody2D

@onready var interaction_area: Area2D = $Actionable2
@onready var talk_hint: Control = $TalkHintLayer/TalkHintPanel

func _ready() -> void:
	talk_hint.visible = false
	interaction_area.area_entered.connect(_on_interaction_area_area_entered)
	interaction_area.area_exited.connect(_on_interaction_area_area_exited)

func _on_interaction_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_interaction_area"):
		talk_hint.visible = true

func _on_interaction_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("player_interaction_area"):
		talk_hint.visible = false
