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
		$VBoxContainer/CenterContainer/ButtonContainer/Start.text = "Start"
		Multiplayer.teardown_server()

func _on_connect_accept_pressed() -> void:
	var ip = $VBoxContainer/CenterContainer/ConnectMenu/IpPortCombo/IP.text
	var port = $VBoxContainer/CenterContainer/ConnectMenu/IpPortCombo/Port.text
	
	if not ip or ip == "":
		ip = $VBoxContainer/CenterContainer/ConnectMenu/IpPortCombo/IP.placeholder_text
		
	if not port or port == "":
		port = $VBoxContainer/CenterContainer/ConnectMenu/IpPortCombo/Port.placeholder_text
		
	Multiplayer.create_client(ip, int(port))
