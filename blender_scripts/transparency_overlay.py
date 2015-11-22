import bpy

def sort_by_volume(objects):
	volumes = {}
	for obj in objects:
		volume = obj.dimensions[0] * obj.dimensions[1] * obj.dimensions[2]
		volumes[obj] = volume
	return sorted(volumes.items(), key=lambda x:x[1])

def modify_objects(sortedVolumeTuples, number_of_objects):
	transparency = .8
	transparency_decrease = transparency/number_of_objects
	for volumeTuple in sortedVolumeTuples:
		current_object = volumeTuple[0]
		if current_object.active_material is None:
			add_material(current_object)
		decrease_transparency(current_object, transparency);
		orient(current_object)
		transparency -= transparency_decrease

def add_material(obj):
		material = bpy.data.materials.new('material for ' + obj.name)
		obj.data.materials.append(material)

def decrease_transparency(obj, transparency):
		obj.active_material.use_transparency = True
		obj.active_material.alpha = transparency

def orient(obj):
	bpy.ops.object.origin_set(type='GEOMETRY_ORIGIN')
	obj.location[0]=0
	obj.location[1]=0
	obj.location[2]=0
	obj.rotation_euler[0]=0

def run():
	scene = bpy.context.scene 
	sortedVolumes = sort_by_volume(scene.objects)
	modify_objects(sortedVolumes, len(scene.objects))
	print("Congrats - success!")

run()