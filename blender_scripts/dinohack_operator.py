import bpy


class DinoHackOperator(bpy.types.Operator):
    """Adds transparency and orients all objects"""
    bl_idname = "object.dinohack_operator"
    bl_label = "DinoHack Operator"

    @classmethod
    def sort_by_volume(self, objects):
        # objects = objects_dictionary.values()
        volumes = {}
        for obj in objects:
            volume = obj.dimensions[0] * obj.dimensions[1] * obj.dimensions[2]
            volumes[obj] = volume
        return sorted(volumes.items(), key=lambda x:x[1])

    def modify_objects(self, sortedVolumeTuples, number_of_objects):
        transparency = .8
        transparency_decrease = transparency/number_of_objects
        for volumeTuple in sortedVolumeTuples:
            current_object = volumeTuple[0]
            if current_object.active_material is None:
                self.add_material(current_object)
            self.decrease_transparency(current_object, transparency);
            self.orient(current_object)
            transparency -= transparency_decrease

    def add_material(self, obj):
            material = bpy.data.materials.new('material for ' + obj.name)
            obj.data.materials.append(material)

    def decrease_transparency(self, obj, transparency):
            obj.active_material.use_transparency = True
            obj.active_material.alpha = transparency

    def orient(self, obj):
        bpy.ops.object.origin_set(type='GEOMETRY_ORIGIN')
        obj.location[0]=0
        obj.location[1]=0
        obj.location[2]=0
        obj.rotation_euler[0]=0

    def execute(self, context):
        scene = bpy.context.scene 
        our_objects = scene.objects.values()
        sortedVolumes = self.sort_by_volume(our_objects)
        self.modify_objects(sortedVolumes, len(scene.objects))
        print("Congrats - success!")
        return {'FINISHED'} 

def register():
    bpy.utils.register_class(DinoHackOperator)


def unregister():
    bpy.utils.unregister_class(DinoHackOperator)


if __name__ == "__main__":
    register()



