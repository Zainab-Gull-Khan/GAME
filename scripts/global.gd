extends Node
enum FruitType {APPLE, BANANA, ORANGE, COCONUT,WATERMELON}
var textures = {
	FruitType.APPLE:{
		"whole": preload("res://assets/images/apple_small.png"),
		"half1": preload("res://assets/images/apple_half_1_small.png"),
		"half2": preload("res://assets/images/apple_half_2_small.png")
	},
	FruitType.BANANA: {
		"whole": preload("res://assets/images/banana_small.png"),
		"half1": preload("res://assets/images/banana_half_1_small.png"),
		"half2": preload("res://assets/images/banana_half_2_small.png")
	},
	FruitType.ORANGE: {
		"whole": preload("res://assets/images/orange_small.png"),
		"half1": preload("res://assets/images/orange_half_1_small.png"),
		"half2": preload("res://assets/images/orange_half_2_small.png")
	},
	FruitType.WATERMELON: {
		"whole": preload("res://assets/images/watermelon_small.png"),
		"half1": preload("res://assets/images/watermelon_half_1_small.png"),
		"half2": preload("res://assets/images/watermelon_half_2_small.png")
	},
	FruitType.COCONUT: {
		"whole": preload("res://assets/images/coconut_small.png"),
		"half1": preload("res://assets/images/coconut_half_1_small.png"),
		"half2": preload("res://assets/images/coconut_half_2_small.png")
	}
}

# Dictionary to store splash effect textures for each fruit type
# These are used when the fruit is sliced
# Splash textures based on fruit type
var splash_textures = {
	FruitType.APPLE: preload("res://assets/images/splash_red_small.png"),
	FruitType.BANANA: preload("res://assets/images/splash_yellow_small.png"),
	FruitType.ORANGE: preload("res://assets/images/splash_orange_small.png"),
	FruitType.WATERMELON: preload("res://assets/images/splash_red_small.png"),
	FruitType.COCONUT: preload("res://assets/images/splash_transparent_small.png")
}
