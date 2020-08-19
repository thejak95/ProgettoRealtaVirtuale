extends Panel

onready var lifeLable = $StatsContainer/Life
onready var coinLable = $StatsContainer/Coin

func _on_Player_life_changed(value):
	lifeLable.text = "LIVES\n" + str(value)

func _on_Player_coin_changed(value):
	coinLable.text = "COIN\n" + str(value)
