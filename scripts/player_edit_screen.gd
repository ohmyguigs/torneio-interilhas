class_name PlayerEditScreen extends Control

@export_file("*.tscn") var start_level = "res://scenes/levels/playground_01.tscn" ## The level from which the game starts when starting a new game.

var user_prefs: UserPrefs
var local_player_data: Dictionary[int, DataPlayer] = {}

@onready var cancel_button: Button = %Back
@onready var red_guild_button: Button = %Red
@onready var black_guild_button: Button = %Black
@onready var yellow_guild_button: Button = %Yellow
@onready var blue_guild_button: Button = %Blue
@onready var purple_guild_button: Button = %Purple
@onready var version_num: Label = %VersionNum

func updateGuildButton(selected_guild) -> void:
	for guild in Const.GUILDS:
		if selected_guild == guild:
			if guild == 'red':
				#red_guild_button.add_theme_stylebox_override("pressed")
				print('update %s button color selected' % guild)
			if guild == 'yellow':
				#yellow_guild_button.add_theme_stylebox_override("pressed")
				print('update %s button color selected' % guild)
			if guild == 'black':
				#black_guild_button.add_theme_stylebox_override("pressed")
				print('update %s button color selected' % guild)
			if guild == 'blue':
				#blue_guild_button.add_theme_stylebox_override("pressed")
				print('update %s button color selected' % guild)
			if guild == 'purple':
				#purple_guild_button.add_theme_stylebox_override("pressed")
				print('update %s button color selected' % guild)

func _ready() -> void:
	var version = ProjectSettings.get_setting("application/config/version")
	version_num.text = "version: %s" % version
	#local_player_data = DataManager.get_player_data(1)
	#var selected_guild = local_player_data.get('selected_guild')
	#updateGuildButton(selected_guild)
	updateGuildButton('red')
	user_prefs = UserPrefs.load_or_create()
	if not user_prefs.language.is_empty():
		TranslationServer.set_locale(user_prefs.language)

func _on_warrior_button_up() -> void:
	DataManager.reset_file_data()
	#SceneManager.swap_scenes(start_level, get_tree().root, self, Const.TRANSITION.FADE_TO_WHITE)

func _on_monk_button_up() -> void:
	#DataManager.load_file_data()
	#var level_to_load = DataManager.get_file_data().game_data.level
	#SceneManager.swap_scenes(level_to_load, get_tree().root, self, Const.TRANSITION.FADE_TO_WHITE)
	DataManager.reset_file_data()
	#SceneManager.swap_scenes(start_level, get_tree().root, self, Const.TRANSITION.FADE_TO_WHITE)

func _on_archer_button_up() -> void:
	#Globals.open_settings_menu()
	DataManager.reset_file_data()
	#SceneManager.swap_scenes(start_level, get_tree().root, self, Const.TRANSITION.FADE_TO_WHITE)

func _on_lancer_button_up() -> void:
	#Globals.open_settings_menu()
	DataManager.reset_file_data()
	#SceneManager.swap_scenes(start_level, get_tree().root, self, Const.TRANSITION.FADE_TO_WHITE)

func _on_red_guild_button_up() -> void:
	local_player_data.set('selected_guild', 'red')
	updateGuildButton('red')
	# set castle color
	# set class color
	

func _on_back_button_up() -> void:
	SceneManager.swap_scenes("res://scenes/menus/start_screen.tscn", get_tree().root, self, Const.TRANSITION.FADE_TO_WHITE)
