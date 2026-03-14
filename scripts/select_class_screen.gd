class_name SelectClassScreen extends Control

@export_file("*.tscn") var start_level = "res://scenes/levels/playground_01.tscn" ## The level from which the game starts when starting a new game.

var user_prefs: UserPrefs

@onready var quit_button: Button = %Back
@onready var version_num: Label = %VersionNum

func _ready() -> void:
	var version = ProjectSettings.get_setting("application/config/version")
	version_num.text = "version: %s" % version
	user_prefs = UserPrefs.load_or_create()
	if not user_prefs.language.is_empty():
		TranslationServer.set_locale(user_prefs.language)

func _on_warrior_button_up() -> void:
	DataManager.reset_file_data()
	SceneManager.swap_scenes(start_level, get_tree().root, self, Const.TRANSITION.FADE_TO_WHITE)

func _on_monk_button_up() -> void:
	#DataManager.load_file_data()
	#var level_to_load = DataManager.get_file_data().game_data.level
	#SceneManager.swap_scenes(level_to_load, get_tree().root, self, Const.TRANSITION.FADE_TO_WHITE)
	DataManager.reset_file_data()
	SceneManager.swap_scenes(start_level, get_tree().root, self, Const.TRANSITION.FADE_TO_WHITE)

func _on_archer_button_up() -> void:
	#Globals.open_settings_menu()
	DataManager.reset_file_data()
	SceneManager.swap_scenes(start_level, get_tree().root, self, Const.TRANSITION.FADE_TO_WHITE)

func _on_back_button_up() -> void:
	SceneManager.swap_scenes("res://scenes/menus/start_screen.tscn", get_tree().root, self, Const.TRANSITION.FADE_TO_WHITE)
