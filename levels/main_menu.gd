extends Control

func _ready() -> void:
	swap_connect_menu(false)
	Multiplayer.peer_connected.connect(peer_connected)
	Multiplayer.multiplayer.connected_to_server.connect(peer_connected)

func swap_connect_menu(connect_visible: bool = false):
	$VBoxContainer/CenterContainer/ButtonContainer.visible = not connect_visible
	$VBoxContainer/CenterContainer/ConnectMenu.visible = connect_visible
	
func _on_connect_pressed() -> void:
	swap_connect_menu(true)

func _on_return_pressed() -> void:
	swap_connect_menu(false)
	
func start_game():
	get_tree().change_scene_to_file("res://level.tscn")

func peer_connected():
	start_game()

func _on_start_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$VBoxContainer/CenterContainer/ButtonContainer/Start.text = "Waiting for peer..."
		Multiplayer.create_server()
	else:
		$VBoxContainer/CenterContainer/ButtonContainer/Start.text = "Start Server"
		Multiplayer.teardown()

func connect_to_server() -> void:
	var ip = $VBoxContainer/CenterContainer/ConnectMenu/IpPortCombo/IP.text
	var port = $VBoxContainer/CenterContainer/ConnectMenu/IpPortCombo/Port.text
	
	if not ip or ip == "":
		ip = $VBoxContainer/CenterContainer/ConnectMenu/IpPortCombo/IP.placeholder_text
		
	if not port or port == "":
		port = $VBoxContainer/CenterContainer/ConnectMenu/IpPortCombo/Port.placeholder_text
		
	Multiplayer.create_client(ip, int(port))

func set_inputs(enabled: bool):
	$VBoxContainer/CenterContainer/ConnectMenu/IpPortCombo/IP.editable = enabled
	$VBoxContainer/CenterContainer/ConnectMenu/IpPortCombo/Port.editable = enabled
	
func _on_connect_accept_toggled(toggled_on: bool) -> void:
	set_inputs(not toggled_on)
	if toggled_on:
		$VBoxContainer/CenterContainer/ConnectMenu/ConnectAccept.text = "Connecting..."
		connect_to_server()
	else:
		$VBoxContainer/CenterContainer/ConnectMenu/ConnectAccept.text = "Connect"
		Multiplayer.teardown()

func _on_start_split_pressed() -> void:
	start_game()
