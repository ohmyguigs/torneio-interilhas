class_name PlayerEditScreen extends Control

@export_file("*.tscn") var start_level = "res://scenes/levels/playground_01.tscn" ## The level from which the game starts when starting a new game.

var user_prefs: UserPrefs
const SELECTED_BUTTON_BG: Color = Color(0.278, 0.671, 0.663)
const SELECTED_BUTTON_BORDER: Color = Color(0.125, 0.353, 0.353)
const UNSELECTED_BUTTON_BG: Color = Color(0.788, 0.667, 0.557)
const UNSELECTED_BUTTON_BORDER: Color = Color(0.306, 0.216, 0.227)

@onready var cancel_button: Button = %Back
@onready var save_button: Button = %Save
@onready var dialog_cancel_button: Button = %Cancel
@onready var dialog_save_button: Button = %Confirm
@onready var selected_stylebox_to_override = StyleBoxFlat.new()
@onready var unselected_stylebox_to_override = StyleBoxFlat.new()
@onready var dialog_modal: Control = %ConfirmModalContainer

# guild buttons
@onready var red_guild_button: Button = %Red
@onready var black_guild_button: Button = %Black
@onready var yellow_guild_button: Button = %Yellow
@onready var blue_guild_button: Button = %Blue
@onready var purple_guild_button: Button = %Purple

# guild prop groups
@onready var red_guild_prop_group: Control = %red_group
@onready var blue_guild_prop_group: Control = %blue_group
@onready var black_guild_prop_group: Control = %black_group
@onready var yellow_guild_prop_group: Control = %yellow_group
@onready var purple_guild_prop_group: Control = %purple_group

# class buttons
@onready var warrior_class_button: Button = %Warrior
@onready var lancer_class_button: Button = %Lancer
@onready var archer_class_button: Button = %Archer
@onready var monk_class_button: Button = %Monk
@onready var pawn_class_button: Button = %Pawn

# class props
@onready var red_warrior: TileMapLayer = %red_warrior_idle
@onready var red_lancer: TileMapLayer = %red_lancer_idle
@onready var red_archer: TileMapLayer = %red_archer_idle
@onready var red_monk: TileMapLayer = %red_monk_idle
@onready var red_pawn: TileMapLayer = %red_pawn_idle
@onready var purple_warrior: TileMapLayer = %purple_warrior_idle
@onready var purple_lancer: TileMapLayer = %purple_lancer_idle
@onready var purple_archer: TileMapLayer = %purple_archer_idle
@onready var purple_monk: TileMapLayer = %purple_monk_idle
@onready var purple_pawn: TileMapLayer = %purple_pawn_idle
@onready var yellow_warrior: TileMapLayer = %yellow_warrior_idle
@onready var yellow_lancer: TileMapLayer = %yellow_lancer_idle
@onready var yellow_archer: TileMapLayer = %yellow_archer_idle
@onready var yellow_monk: TileMapLayer = %yellow_monk_idle
@onready var yellow_pawn: TileMapLayer = %yellow_pawn_idle
@onready var blue_warrior: TileMapLayer = %blue_warrior_idle
@onready var blue_lancer: TileMapLayer = %blue_lancer_idle
@onready var blue_archer: TileMapLayer = %blue_archer_idle
@onready var blue_monk: TileMapLayer = %blue_monk_idle
@onready var blue_pawn: TileMapLayer = %blue_pawn_idle
@onready var black_warrior: TileMapLayer = %black_warrior_idle
@onready var black_lancer: TileMapLayer = %black_lancer_idle
@onready var black_archer: TileMapLayer = %black_archer_idle
@onready var black_monk: TileMapLayer = %black_monk_idle
@onready var black_pawn: TileMapLayer = %black_pawn_idle

# labels
@onready var version_num: Label = %VersionNum
@onready var selected_player_name: Label = %SelectedPlayerDataLabel

# node save data
var node_save_data_path: String = "/root/PlayerEditScreen"
var initial_local_player_data: Dictionary[String, String] = {
	'selected_guild': 'red',
	'selected_class': 'pawn',
	'destination_name': start_level,
	'player_id': '',
}
var local_player_data: Dictionary[String, String] = initial_local_player_data

func get_data():
	return local_player_data

func receive_data(_data):
	local_player_data.set('selected_guild', _data.get('selected_guild') if _data.get('selected_guild') else 'red')
	local_player_data.set('selected_class', _data.get('selected_class') if _data.get('selected_class') else 'pawn')

func handleGuildButtonClick(_selected_guild) -> void:
	for guild in Const.GUILDS:
		var log_selected = 'selected' if _selected_guild == guild else 'unselected'
		#print('[handleGuildButtonClick] update %s button color %s' % [guild, log_selected])
		# update all guild button styles
		var guild_button_name = guild + '_guild_button'
		var guild_button = get(guild_button_name)
		var stylebox_to_override = selected_stylebox_to_override if _selected_guild == guild else unselected_stylebox_to_override
		guild_button.add_theme_stylebox_override("normal", stylebox_to_override)
		# update all guild building 
		var guild_prop_group_name = guild + '_guild_prop_group'
		var guild_prop_group = get(guild_prop_group_name)
		var building_visibility_toggle = true if _selected_guild == guild else false
		guild_prop_group.visible = building_visibility_toggle

func handleClassButtonClick(_selected_class) -> void:
	for _class in Const.CLASSES:
		var log_selected = 'selected' if _selected_class == _class else 'unselected'
		#print('[handleClassButtonClick] update %s button color %s' % [_class, log_selected])
		# update all class button styles
		var class_button_name = _class + '_class_button'
		var class_button = get(class_button_name)
		var stylebox_to_override = selected_stylebox_to_override if _selected_class == _class else unselected_stylebox_to_override
		class_button.add_theme_stylebox_override("normal", stylebox_to_override)
		# update all guilds class props
		var prop_visibility_toggle = true if _selected_class == _class else false
		for _guild in Const.GUILDS:
			var prop_name = _guild + '_' + _class
			#print('[handleClassButtonClick] update %s prop visibility to %s' % [prop_name, prop_visibility_toggle])
			var prop = get(prop_name)
			if prop:
				prop.visible = prop_visibility_toggle

func _ready() -> void:
	var version = ProjectSettings.get_setting("application/config/version")
	version_num.text = "version: %s" % version
	selected_stylebox_to_override.set_border_width_all(4)
	selected_stylebox_to_override.bg_color = SELECTED_BUTTON_BG
	selected_stylebox_to_override.border_color = SELECTED_BUTTON_BORDER
	selected_stylebox_to_override.border_blend = true
	selected_stylebox_to_override.corner_detail = 16
	unselected_stylebox_to_override.set_border_width_all(4)
	unselected_stylebox_to_override.bg_color = UNSELECTED_BUTTON_BG
	unselected_stylebox_to_override.border_color = UNSELECTED_BUTTON_BORDER
	unselected_stylebox_to_override.border_blend = true
	unselected_stylebox_to_override.corner_detail = 16
	if SaveFileManager.save_file_exists():
		var saved_game_data = DataManager.get_file_data().nodes_data[node_save_data_path]
		print('[_ready] game saved { guild: %s , class: %s }' % [saved_game_data.selected_guild, saved_game_data.selected_class])
		if saved_game_data != null:
			if saved_game_data.selected_guild != null && saved_game_data.selected_class != null:
				receive_data(saved_game_data)

	var selected_guild = local_player_data.get('selected_guild') if local_player_data.has('selected_guild') else 'red'
	handleGuildButtonClick(selected_guild)
	var selected_class = local_player_data.get('selected_class') if local_player_data.has('selected_class') else 'pawn'
	handleClassButtonClick(selected_class)
	user_prefs = UserPrefs.load_or_create()
	if not user_prefs.language.is_empty():
		TranslationServer.set_locale(user_prefs.language)

func _on_warrior_button_up() -> void:
	handleClassButtonClick('warrior')
	local_player_data.set('selected_class', 'warrior')
	#DataManager.reset_file_data()
	#SceneManager.swap_scenes(start_level, get_tree().root, self, Const.TRANSITION.FADE_TO_WHITE)

func _on_monk_button_up() -> void:
	handleClassButtonClick('monk')
	local_player_data.set('selected_class', 'monk')
	#DataManager.load_file_data()
	#var level_to_load = DataManager.get_file_data().game_data.level
	#SceneManager.swap_scenes(level_to_load, get_tree().root, self, Const.TRANSITION.FADE_TO_WHITE)
	#DataManager.reset_file_data()
	#SceneManager.swap_scenes(start_level, get_tree().root, self, Const.TRANSITION.FADE_TO_WHITE)

func _on_archer_button_up() -> void:
	handleClassButtonClick('archer')
	local_player_data.set('selected_class', 'archer')
	#Globals.open_settings_menu()
	#DataManager.reset_file_data()
	#SceneManager.swap_scenes(start_level, get_tree().root, self, Const.TRANSITION.FADE_TO_WHITE)

func _on_lancer_button_up() -> void:
	handleClassButtonClick('lancer')
	local_player_data.set('selected_class', 'lancer')
	#Globals.open_settings_menu()
	#DataManager.reset_file_data()
	#SceneManager.swap_scenes(start_level, get_tree().root, self, Const.TRANSITION.FADE_TO_WHITE)

func _on_red_guild_button_up() -> void:
	handleGuildButtonClick('red')
	local_player_data.set('selected_guild', 'red')
	# set display castle color
	# set display char class color
	
func _on_blue_guild_button_up() -> void:
	handleGuildButtonClick('blue')
	local_player_data.set('selected_guild', 'blue')
	# set display castle color
	# set display char class color

func _on_black_guild_button_up() -> void:
	handleGuildButtonClick('black')
	local_player_data.set('selected_guild', 'black')
	# set display castle color
	# set display char class color

func _on_yellow_guild_button_up() -> void:
	handleGuildButtonClick('yellow')
	local_player_data.set('selected_guild', 'yellow')
	# set display castle color
	# set display char class color

func _on_purple_guild_button_up() -> void:
	handleGuildButtonClick('purple')
	local_player_data.set('selected_guild', 'purple')
	# set display castle color
	# set display char class color

func _on_save_button_up() -> void:
	var _guild = local_player_data.get('selected_guild')
	var _class = local_player_data.get('selected_class')
	var _player_id = 1 # should load actualy
	selected_player_name.text = "%s %s %d" % [_guild, _class, _player_id]
	if !dialog_modal.visible:
		dialog_modal.visible = true

func _on_cancel_button_up() -> void:
	if dialog_modal.visible:
		dialog_modal.visible = false

func _on_confirm_button_up() -> void:
	#var _guild = local_player_data.get('selected_guild')
	#var _class = local_player_data.get('selected_class')
	DataManager._save_nodes_data()
	SceneManager.swap_scenes(start_level, get_tree().root, self, Const.TRANSITION.FADE_TO_WHITE)
	#var level = DataManager.load_level_data()
	#if !level:
		#DataManager.reset_file_data()
	#DataManager.save_game()
	#var saved_player_data = DataManager.get_player_data(1)
	#if saved_player_data != null:
		#DataManager.save_player_data(1, local_player_data)
		#SceneManager.swap_scenes(start_level, get_tree().root, self, Const.TRANSITION.FADE_TO_WHITE)
	#else:
		#print("no player 1 :(")

func _on_back_button_up() -> void:
	SceneManager.swap_scenes("res://scenes/menus/start_screen.tscn", get_tree().root, self, Const.TRANSITION.FADE_TO_WHITE)
