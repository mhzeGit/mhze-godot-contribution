@echo off
cd /d D:\GodotSourceCode\godot

echo Building Godot...
py -3.13 -m SCons platform=windows dev_mode=yes accesskit=no d3d12=no

if %errorlevel% neq 0 (
    echo Build failed.
    pause
    exit /b
)

echo Build finished. Launching Godot...

start "" "bin\godot.windows.editor.x86_64.exe"

exit