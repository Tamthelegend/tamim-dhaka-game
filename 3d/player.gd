extends KinematicBody

const SAVE_DIR = "user://saves/"
var direction = Vector3.FORWARD
var velocity = Vector3.ZERO
var acceleration = 10
var speed = 5
var point = 0
var y_velocity = 0
var gravity = 20
var angular_acceleration = 7
onready var animations = $player_animations/AnimationTree.get("parameters/playback")
onready var mesh = $player_animations
var save_path = SAVE_DIR + "save.dat"
var egg = true
export(Script) var game_save_class



func _ready():
	load_world()
	
func save_world():
	var new_save = game_save_class.new()
	new_save.egg = egg
	new_save.point = point
	
	var dir = Directory.new()
	if not dir.dir_exists("res://saves/"):
		dir.make_dir_recursive("res://saves/")
	ResourceSaver.save("res://saves/save_01.tres", new_save)
	
func load_world():
	var dir = Directory.new()
	if not dir.file_exists("res://saves/save_01.tres"):
		return false
		
	var world_save = load("res://saves/save_01.tres")
		
		
	egg = world_save.egg
	return true

func _physics_process(delta):
	
	
	if egg == true:
		get_parent().get_node("CSGSphere").show()
	else:
		get_parent().get_node("CSGSphere").hide()
		
	
		

	
	
	if Input.is_action_pressed("forwards") or Input.is_action_pressed("backwards") or Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		var camera_rotation = $camera_root/camera_h.global_transform.basis.get_euler().y
		direction = Vector3(Input.get_action_strength("left") - Input.get_action_strength("right"),
					0,
					Input.get_action_strength("forwards") - Input.get_action_strength("backwards")).rotated(Vector3.UP,camera_rotation)
		direction = direction.normalized()
		animations.travel("walk")
		speed = 3
		

	else:
		speed = 0
		animations.travel("idle")
	
	if !is_on_floor():
		y_velocity += gravity * delta
	else:
		y_velocity = 0
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		save_world()
	if Input.is_action_just_pressed("kill"):
		egg = false
	mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(direction.x, direction.z), delta * angular_acceleration)
	
	velocity = lerp(velocity, speed * direction, delta * acceleration)
	move_and_slide(velocity + Vector3.DOWN * y_velocity, Vector3.UP)
	
	
		
	


func _on_Area_body_entered(body):
	point = 1
	save_world()
	print(point)
	
	


func _on_Area2_body_entered(body):
	load_world()
	print(egg)
			
