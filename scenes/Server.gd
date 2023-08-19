extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
#func _ready():
#
#	Gotm.initialize()
#	var config = GotmConfig.new()
#	config.project_key = "authenticators/X0cORsp7rSBkPTRe7Tdt"
#	Gotm.initialize(config)
#	#
#	var peer = NetworkedMultiplayerENet.new()
#	peer.create_server(8070)
#func join_global_lobby(mode):
#	var fetch = GotmLobbyFetch.new()
#	fetch.filter_properties.mode = mode
#	var lobbies = yield(fetch.first(1), "completed")
#	if not lobbies.empty():
#		var success = yield(lobbies[0].join(), "completed")
#		var x = Label.new()
#		x.text = "LOBBY CREATED FROM FIRST"
#		add_child(x)
#		var y = Label.new()
#		y.text = str(success)
#		add_child(y)
#	else:
#		Gotm.host_lobby()
#		Gotm.lobby.mode = mode
#		Gotm.lobby.hidden = false
#		Gotm.lobby.name = "My Lobby!"
#		Gotm.host_lobby(false)
#		var peer = NetworkedMultiplayerENet.new()
#		peer.create_server(8070)
#		print("success")
#		var x = Label.new()
#		x.text = "LOBBY CREATED FROM SECOND "
#		add_child(x)
