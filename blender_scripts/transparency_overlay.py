import bpy
scene = bpy.context.scene
initial_transparency = .8
transparency_decrease = initial_transparency/len(scene.objects)

def sort_by_volume(objects):
	volumes = {}
	for obj in objects:
		volume = obj.dimensions[0] * obj.dimensions[1] * obj.dimensions[2]
		volumes[obj] = volume
	return sorted(volumes.items(), key=lambda x:x[1])

def modify_objects(sortedVolumeTuples):
	transparency = initial_transparency
	for volumeTuple in sortedVolumeTuples:
		current_object = volumeTuple[0]
		if is_not_lamp_or_camera(current_object):
			if current_object.active_material is None:
				add_material(current_object)
			set_transparency(current_object, transparency);
			orient(current_object)
			transparency -= transparency_decrease

def is_not_lamp_or_camera(obj):
	return obj.type != 'LAMP' and obj.type != 'CAMERA'

def add_material(obj):
		material = bpy.data.materials.new('material for ' + obj.name)
		obj.data.materials.append(material)

def set_transparency(obj, transparency):
		obj.active_material.use_transparency = True
		obj.active_material.alpha = transparency

def orient(obj):
	scene.objects.active = obj
	bpy.ops.object.origin_set(type='GEOMETRY_ORIGIN')
	obj.select = True
	obj.location[0]=0
	obj.location[1]=0
	obj.location[2]=0
	obj.rotation_euler[0]=0

def run():
	sortedVolumes = sort_by_volume(scene.objects)
	modify_objects(sortedVolumes)
	print("Congrats - success!")

run()