class_name Main_Menu	

extends Control

@onready var start_button =$MarginContainer2/HBoxContainer/VBoxContainer/Start_Button as Button
@onready var exit_button  =$MarginContainer2/HBoxContainer/VBoxContainer/Exit_Button as Button
@onready var start_level  = preload("res://scenes/Game.tscn") as PackedScene
@onready var background_music = $Background_music
@onready var hover_SFX_quit = $oof_effect
@onready var hover_SFX_start = $"Ler's Go"

# Called when the node enters the scene tree for the first time.
func _ready():
	background_music.play()
	start_button.button_down.connect(on_start_pressed)
	start_button.mouse_entered.connect(on_start_hovered)
	exit_button.mouse_entered.connect(on_exit_hovered)
	exit_button.button_down.connect(on_exit_pressed)

func on_exit_hovered() -> void:
	hover_SFX_quit.play()
func on_start_hovered() -> void:
	hover_SFX_start.play()
func on_start_pressed() -> void:
	
	get_tree().change_scene_to_packed(start_level)
	
func on_exit_pressed() -> void:

	get_tree().quit()
