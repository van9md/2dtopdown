extends CharacterBody2D

enum COW_STATE {IDLE,WALK}

@export var move_speed: float = 10
@export var starting_direction:Vector2 = Vector2(0,1)
@export var idle_time: Vector2 = Vector2(3,5)
@export var walk_time:Vector2 = Vector2 (2,3)
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var timer = $Timer
# parameters/Idle/blend_position

var move_direction = Vector2.ZERO
var current_state : COW_STATE = COW_STATE.IDLE

func _ready():
	pick_new_state()
	update_animation_parameters(move_direction)
	#update_animation_parameters(starting_direction)

func _physics_process(_delta):
	
	#update direction
	#update_animation_parameters(direcion)
	
	#update velocity
	velocity = move_direction * move_speed
	
	move_and_slide()
	
	
	
	
func update_animation_parameters(direction: Vector2):
	animation_tree.set("parameters/Walk/blend_position",direction)
	animation_tree.set("parameters/Idle/blend_position",direction)

func select_new_direction():
	move_direction = Vector2(
		randi_range(-1,1),
		randi_range(-1,1)
	)

		
func pick_new_state():
	if (current_state ==COW_STATE.IDLE):
		current_state=COW_STATE.WALK 
		state_machine.travel("Walk")
		select_new_direction()
		update_animation_parameters(move_direction)
		timer.start(randi_range(walk_time[0],walk_time[1]))
	else:
		current_state= COW_STATE.IDLE
		move_direction = Vector2(0,0)
		state_machine.travel("Idle")
		update_animation_parameters(move_direction)
		timer.start(randi_range(idle_time[0],idle_time[1]))
		
	
	


func _on_timer_timeout():
	pick_new_state()
