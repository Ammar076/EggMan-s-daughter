extends Camera2D


@onready var camera_2d = $"."
var boss = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if boss:
		camera_2d.limit_left = 500

func _on_area_2d_boss():
	boss = true
