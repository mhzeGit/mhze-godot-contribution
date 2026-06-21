@echo off
cd /d D:\GodotSourceCode\godot
py -3.13 -m SCons platform=windows accesskit=no d3d12=no
pause