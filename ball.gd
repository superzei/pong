extends RigidBody3D

@export var velocity:Vector3 # How fast the ball will move.

const PositionRange: float = 10.0

var just_scored: bool = false

func change_emission_color():
	var material = $BallMesh.mesh.surface_get_material(0)
	var current_color = Color.BLUE.lerp(Color.RED, (position.x + PositionRange) / (PositionRange*2))
	material.emission = current_color

func update_score_on_gui():
	$"../HUD/SubViewport/HUDView/TextEdit".text = "%d | %d" % [$"../LeftPaddle".SCORE, $"../Right Paddle".SCORE]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_score_on_gui()
	pass # Replace with function body.

func reset_ball():
	just_scored = true
	# stop collisions for a sec
	$"../LeftCollisionBox".monitoring = false
	$"../RightCollisionBox".monitoring = false
	# update the score
	update_score_on_gui()
	# set timer
	await get_tree().create_timer(2.0).timeout
	# put the ball back on center after timer expiration
	position = Vector3(0.0, 0.0, position.z)
	# maybe change the direction too?
	velocity.x = randi_range(3, 7) * (-1 + ((randi() % 2) * 2))
	velocity.y = randi_range(3, 7) * (-1 + ((randi() % 2) * 2))
	# enable collisions back
	$"../LeftCollisionBox".monitoring = true
	$"../RightCollisionBox".monitoring = true
	just_scored = false

func _physics_process(delta: float) -> void:
	change_emission_color()
	var collision_info = move_and_collide(velocity * delta)
	if collision_info: # We only want to bounce if the ball actually collided.
		velocity = velocity.bounce(collision_info.get_normal()) 

	if not just_scored:
		$"../Camera".position.x = ((position.x) / 6.0)
		$"../Camera".position.y = ((position.y) / 8.0)
		
		$"../Camera".look_at(position.lerp(Vector3.ZERO, 0.85))


func _on_left_collision_box_body_entered(body: Node3D) -> void:
	if body == self:
		print("Score for right!")
		$"../Right Paddle".SCORE += 1
		reset_ball()


func _on_right_collision_box_body_entered(body: Node3D) -> void:
	if body == self:
		print("Score for left!")
		$"../LeftPaddle".SCORE += 1
		reset_ball()
