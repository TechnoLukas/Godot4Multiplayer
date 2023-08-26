@tool
extends Node3D

@onready var mesh: PlaneMesh = $plane.mesh
@onready var material: ShaderMaterial = $plane.material
@onready var collision: CollisionShape3D = $StaticBody3D/CollisionShape3D

func _ready():
	var heightmap = material.get("shader_parameter/NoiseTex")
	var height_scale: float = 1.5
	
	var xz_scale: float = 1

	var map_data = []
	for y in range(mesh.size.y + 1):
		for x in range(mesh.size.x + 1):
			var x_scaled: float = x * xz_scale
			var y_scaled: float = y * xz_scale
			var height = height_scale * heightmap.noise.get_noise_2d(x_scaled, y_scaled) #get_noise_2d(x_scaled, y_scaled)
			map_data.push_back(height)

	var shape = HeightMapShape3D.new()
	shape.map_width = mesh.size.x + 1
	shape.map_depth = mesh.size.y + 1
	shape.map_data = map_data
	collision.shape = shape
	
