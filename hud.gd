extends CanvasLayer
@onready var wood_label = $Control/VBoxContainer/wood/text
@onready var meat_label = $Control/VBoxContainer/meat/text

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_wood(new_amount):
	wood_label.text = str(new_amount)

func update_fish(new_amount):
	meat_label.text = str(new_amount)
