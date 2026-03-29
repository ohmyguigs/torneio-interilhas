extends Marker2D
## Manage player instantiation in a level.

@export var player_scene: PackedScene ## Reference to the player scene.
#@export_range(1, 4) var player_id := 1 ## The player id.
var player_id: String = "f176ab7a623960f48c37748dc66f05cf"

@onready var parent = get_parent()

# Keep a reference so the callback isn't garbage collected
var _callback_reference: JavaScriptObject
var device_fingerprint: String = str(player_id)

func _ready() -> void:
	if OS.has_feature("web"):
		# 1. Create the callback that points to our GDScript function
		#_callback_reference = JavaScriptBridge.create_callback(_on_fingerprint_received)
		# 2. Get the 'window' interface to call our JS helper
		var window = JavaScriptBridge.get_interface("window")
		# 3. Trigger the JS function we added in the Head Include
		#window.getBrowserFingerprint(_callback_reference)
		print("[player instantiator] js bridge fpid: %s" % window.fpid)
		if typeof(window.fpid) == TYPE_STRING:
			self._on_fingerprint_received([window.fpid])
	else:
		# fallback to initial fixed value
		self._on_fingerprint_received([player_id])

# The callback function MUST take exactly one Array argument
func _on_fingerprint_received(args: Array):
	var visitor_id = args[0]
	print("Device Fingerprint ID: %s" % visitor_id)
	device_fingerprint = visitor_id
	_instantiate_player.call_deferred()

func _instantiate_player():
	var player: PlayerEntity = player_scene.instantiate() as PlayerEntity
	if player:
		var player_instance_id = player_id
		if OS.has_feature("web"):
			player_instance_id = device_fingerprint
		player.player_id = player_instance_id
		player.global_position = global_position
		parent.add_child.call_deferred(player)
		Globals.player_added_to_scene.emit(player)
		## maybe not?
		DataManager.reset_file_data()
		DataManager.save_game()
	queue_free()
