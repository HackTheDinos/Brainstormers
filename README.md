# Brainstormers
This project is divided into two parts: 
	1. Automating detection of the volume of a brain given tiff files of a skull.
	2. Scripting add-ons for Blender that allow users to compare multiple brains.

1. Automating detection of the volume of a brain given tiff files of a skull.

2. Scripting add-ons for Blender that allow users to compare multiple brains.
	Blender is an open-source tool for 3D modeling and video composition.  Dowload here: https://www.blender.org/download/

	Blender offers a Python based API, which we are using to script taking multiple stl files, layering them, and changing their colors and transparency so that they can beviewed and compared simultaneously.

	TODO:
		Convert script file to Blender add-on so that it can be accessed from the Blender option menu.
		Align and scale brains.  Currently, all brains are centered, but are not necessarily facing the same direction.
