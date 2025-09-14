extends Node

const IP_ADDRESS = "localhost"
const PORT = 43852
const MAX_CLIENT = 1 # pong is 2 player game
const PEER_WAIT_TIMER = 30

var peer: ENetMultiplayerPeer

signal peer_connected
signal connected_to_server

func client_connected(peer_id: int):
	peer_connected.emit()

func create_server():
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_CLIENT)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(client_connected)
	
func teardown_server():
	multiplayer.multiplayer_peer = null
	peer.close()
	peer = null

func create_client(ip: String = IP_ADDRESS, port: int = PORT):
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer
