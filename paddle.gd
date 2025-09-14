extends CharacterBody3D

const SPEED: float = 10

@export var SCORE: int = 0

enum PaddlePosition {LEFT, RIGHT}
@export var Position: PaddlePosition = PaddlePosition.RIGHT

func set_paddle_color():
	# set the color for paddle
	var new_mesh = $PaddleMesh.mesh.duplicate()
	var material = new_mesh.surface_get_material(0).duplicate()
	if Position == PaddlePosition.RIGHT:
		material.emission = "blue"
	else:
		material.emission = "red"
	new_mesh.surface_set_material(0, material)
	$PaddleMesh.mesh = new_mesh
	
func _enter_tree() -> void:
	# multiplayer, right paddle is for client
	if not Multiplayer.is_multiplayer(): return
	
	var peer_id = multiplayer.get_unique_id()
	if Position == PaddlePosition.RIGHT:
		if Multiplayer.multiplayer.is_server():
			peer_id = Multiplayer.multiplayer.get_peers()[0]
		set_multiplayer_authority(peer_id)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_paddle_color()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_multiplayer_authority(): 
		return
	
	if (Input.is_action_pressed("UpLeft") and Position == PaddlePosition.LEFT) or (Input.is_action_pressed("UpRight") and Position == PaddlePosition.RIGHT):
		velocity.y = SPEED
	elif (Input.is_action_pressed("DownLeft") and Position == PaddlePosition.LEFT) or (Input.is_action_pressed("DownRight") and Position == PaddlePosition.RIGHT):
		velocity.y = -SPEED
	else:
		velocity = Vector3.ZERO
		
	move_and_collide(velocity * delta)
