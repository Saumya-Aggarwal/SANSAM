extends Control

@export var is_spin: bool = false
@export var speed: int = 10
@export var power: int = 2
@export var reward_position = 0
signal sig_reward

var vat_pham = [
	{"name": "A", "from": 0, "to": 45, "ma_vat_pham": 200, "ten_vat_pham": "Thanh Long"},
	{"name": "H", "from": 45, "to": 90, "ma_vat_pham": 0, "ten_vat_pham": "Gạch"},
	{"name": "G", "from": 90, "to": 135, "ma_vat_pham": 204, "ten_vat_pham": "Chanh"},
	{"name": "F", "from": 135, "to": 180, "ma_vat_pham": 203, "ten_vat_pham": "Dưa Hấu"},
	{"name": "E", "from": 180, "to": 225, "ma_vat_pham": 201, "ten_vat_pham": "Sầu Riêng"},
	{"name": "D", "from": 225, "to": 270, "ma_vat_pham": 0, "ten_vat_pham": "Gạch"},
	{"name": "C", "from": 270, "to": 315, "ma_vat_pham": 202, "ten_vat_pham": "Vãi"},
	{"name": "B", "from": 315, "to": 360, "ma_vat_pham": 0, "ten_vat_pham": "Gạch"}
]

var chosen_items = []  # A list to track items that have already been selected

func _on_btn_spin_pressed():
	if not is_spin:
		if chosen_items.size() == vat_pham.size():
			print("All items have been selected! Resetting the wheel...")
			chosen_items.clear()  # Reset chosen items if all have been selected

		is_spin = true
		var tween = get_tree().create_tween().set_parallel(true)
		tween.connect("finished", func():
			is_spin = false
			%Wheel.rotation_degrees = fmod(%Wheel.rotation_degrees, 360)
			check_reward_position()
		)
		reward_position = randi_range(0, 360)
		tween.tween_property(%Wheel, "rotation_degrees", reward_position + 360 * speed * power, 3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)

func check_reward_position():
	for item in vat_pham:
		if reward_position >= item.from and reward_position < item.to:
			if item.name in chosen_items:
				print("Already selected this option. Spin again!")
			else:
				print("Chosen: " + item.name)
				sig_reward.emit(item.ma_vat_pham)
				chosen_items.append(item.name)  # Mark the item as chosen
			break
