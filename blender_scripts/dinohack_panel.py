import bpy


class DinoHackPanel(bpy.types.Panel):
    """Creates a Panel in the Object properties window"""
    bl_label = "DinoHack Panel"
    bl_idname = "OBJECT_PT_DinoHack"
    bl_space_type = 'PROPERTIES'
    bl_region_type = 'WINDOW'
    bl_context = "object"

    def draw(self, context):
        layout = self.layout

        obj = context.object

        row = layout.row()
        row.label(text="DinoHack Tools")

        row = layout.row()
        row.operator("object.dinohack_operator")


def register():
    bpy.utils.register_class(DinoHackPanel)


def unregister():
    bpy.utils.unregister_class(DinoHackPanel)


if __name__ == "__main__":
    register()