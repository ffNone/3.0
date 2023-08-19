extends Node

enum lobby_status {Private, Friends, Public, Invisible}
enum search_distance {Close, Default, Far, Worldwide}
onready var steamName = $SteamName
onready var lobbyoutput = $Chat/RichTextLabel
onready var lobbySetName = $Chat/LobbyName
onready var lobbyGetName = $Chat/Name
func _ready():
	steamName.text = Globals.STEAM_NAME
	
	Steam.connect("lobby_created",self,"_on_Lobby_Created")
	Steam.connect("lobby_match_list",self,"_on_Lobby_Match_List")
	Steam.connect("lobby_joined",self,"_on_Lobby_Joined")
	check_Command_Line()
	
func check_Command_Line():
	var ARGUMENTS = OS.get_cmdline_args()
	
	if ARGUMENTS.size() > 0 :
		for argument in ARGUMENTS :
#			if Globals.LOBBY_INVITE_ARG:
#				join_Lobby(int(argument))
			if argument == "+connect_lobby":
				Globals.LOBBY_INVITE_ARG = true

func create_Lobby():
	if Globals.LOBBY_ID == 0:
		Steam.createLobby(lobby_status.Public, 4)

func display_Message(message):
	lobbyoutput.add_text("\n"+ str(message))
func _on_Lobby_Created(connect,lobbyID):
	if connect == 1:
		Globals.LOBBY_ID = lobbyID
		display_Message("Created lobby" + lobbySetName.text)
		Steam.setLobbyData(lobbyID, "name", lobbySetName.text)
		var name = Steam.getLobbyData(lobbyID,"name")
		lobbyGetName.text = str(name)
func _on_Create_pressed():
	pass # Replace with function body.
