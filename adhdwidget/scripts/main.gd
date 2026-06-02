extends Node2D
var focus = false
var points: int = 0
var points_string = "Points = %s" % "n/a"
var hatframenumber: int = 0

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		#if the widget is clicked on when it isn't focusing
		#show shy sprite and gain a point, update hat logic, then reset
		if not focus:
			$AnimatedSprite2D.play("shy")
			await get_tree().create_timer(1.0).timeout
			points = points + 1 
			points_string = "Points = %s" % points
			print(points_string)
			hat_logic()
			start_distraction()
			$Sprite2D2.frame = 0


func _ready() -> void:
# transparency code based off of: https://github.com/spaghettiSyntax/DesktopPet
	print(points_string)
	var window = get_window()
	print("Starting...")
	
	Engine.max_fps = 24
	#limit frames to save on ram
	
	get_viewport().transparent_bg = true 
	window.transparent = true 
	
	#windows build needs this 
	#window.borderless = false 
	
	#mac build doesn't
	window.borderless = true 
	
	window.always_on_top = true 
	
	window.unresizable = false 
	
	var spritewidth = 500 
	var spriteheight = 675
	var usable_rect = DisplayServer.screen_get_usable_rect()
	
	#makes it so the window defaults to the corner of your screen above taskbar
	var width = usable_rect.end.x - spritewidth 
	var height = usable_rect.end.y - spriteheight
	
	get_window().position = Vector2(width, height)
	$Sprite2D.frame = hatframenumber
	$Sprite2D2.frame = 0
	
	start_distraction()
	


func start_distraction():
	
	focus = true
	
	$AnimatedSprite2D.play("idle")
		
	# randi - gets a random integer between b and b + a - 1.
	# in this case, between 25 seconds and 60 seconds.
	var timetowait = (randi() % 36 + 25) 
	#var timetowait = 2 # used for debug purposes
	print("Wait time = %s" % timetowait )
	await get_tree().create_timer(timetowait).timeout
	# get distracted after the timer is up
	focus = false 
	$Sprite2D.frame = 0 
	$Sprite2D2.frame = hatframenumber
	$AnimatedSprite2D.play("look")
	
	
func hat_logic():
	
	print(hatframenumber)
	# if points is a multiple of 10, advance a hat 
	if (int(points)%10) == 0:
		print("Enough Points")
		hatframenumber += 1
		if hatframenumber > 8:
			hatframenumber = 1
			
	$Sprite2D.frame = hatframenumber
	
	
	
