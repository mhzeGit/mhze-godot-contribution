# Godot Engine 4.8-dev — Universal AI Context

## Project Overview

- Godot Engine is a **MIT-licensed, cross-platform 2D and 3D game engine** built in C++17 with a node-based scene architecture. Its core purpose is to provide a fully self-contained, free and open-source game development environment with a built-in editor, multiple scripting languages (GDScript, C#, C++ via GDExtension), and a unified rendering API (Vulkan, GLES3, D3D12, Metal).
- **Target platform:** desktop, mobile, web, and console game releases. Built with **SCons** (`>=4.4`, Python `>=3.9`). Default target is `editor`; release builds use `template_release` / `template_debug`. Output is a single platform-specific binary (e.g., `godot.windows.editor.x86_64.exe`).
- Run the editor directly from `bin/` after build. No external runtime or SDK is required beyond the build tools for your platform.

---

## File & Folder Structure

### Root-level files (what matters)

| File | Purpose |
|---|---|
| `SConstruct` | **Entry point** for SCons build. Registers helper modules, detects platforms, configures environment, sets up build targets and tools. |
| `methods.py` | Build helper functions: source file registration, glob/path utilities, cache management, SCU handling (1674 lines). |
| `platform_methods.py` | Architecture aliases, OS compatibility mapping, arch detection, MoltenVK detection, Swift builder, Apple bundle generation. |
| `version.py` | Version string: `4.8.0-dev`. |
| `gles3_builders.py` | Parses GLES3 shader headers → extracts vertex/fragment/uniforms/FBOs/UBOs. |
| `glsl_builders.py` | Parses Vulkan/RD shader headers → vertex/fragment/compute/raygen/etc. |
| `scu_builders.py` | Single Compilation Unit build support — groups includes into `.scu` files (max 1024 per unit). |

### `core/` — Foundation layer

```
core/
├── config/          Engine, ProjectSettings — singleton config objects
├── crypto/          Crypto, CryptoCore, AESContext, HashingContext
├── debugger/        EngineDebugger, RemoteDebugger, ScriptDebugger, profilers
├── error/           ErrorList, error macros
├── extension/       **GDExtension system** — C API interface, wrappers, manager, dump tools
├── input/           Input, InputMap, InputEvent types
├── io/              FileAccess, DirAccess, ResourceLoader/Saver, Image, JSON, XML,
│                    HTTP, TCP/UDP, Compression, PackedData, ResourceFormat
├── math/            Vector2/3/4, Transform2D/3D, Basis, Quaternion, AABB, Plane, Projection,
│                    Color, Geometry2D/3D, AStar, BVH, Delaunay, QuickHull, MathFuncs
├── object/          **Object** (base of everything), **RefCounted**, **ClassDB**,
│                    MethodBind, ScriptLanguage, MessageQueue, UndoRedo, WorkerThreadPool
├── os/              OS, Thread, Mutex, Semaphore, Memory, Time, MainLoop, Keyboard
├── profiling/       Profiling infrastructure
├── string/          String (core), StringName, NodePath, Translation, StringBuilder
├── templates/       Generic data structures: HashMap, HashSet, Vector, List, RBMap, RID,
│                    PagedArray, LocalVector, SortArray, Span, Pair, Tuple, etc.
├── variant/         **Variant** (universal value type), Array, Dictionary, Callable,
│                    typed containers, construct/destruct/op/utility functions
├── core_bind.cpp    Core classes exposed to scripting
├── register_core_types.h   Registration entry points
├── typedefs.h       C++17 minimum, platform config, stdint/stddef includes
└── version.h        Generated version info
```

### `scene/` — Scene tree nodes and resources

```
scene/
├── 2d/               Node2D, Sprite2D, AnimatedSprite2D, Camera2D, TileMap, Parallax,
│                     CPU/GPU particles, lighting, skeletons, navigation subdirectories
├── 3d/               Node3D, Camera3D, MeshInstance3D, Skeleton3D, IK modifiers,
│                     lights, probes, fog volumes, particles, navigation, physics,
│                     XR subdirectories ~120 files
├── animation/        AnimationPlayer, AnimationTree, blend trees, state machine, Tween
├── audio/            AudioStreamPlayer2D/3D, AudioListener2D/3D
├── debugger/         Scene debugger integration
├── gui/              Control, Container, Button, Label, LineEdit, TextEdit, Tree, Popup,
│                     GraphEdit, ColorPicker, FileDialog, etc. ~130 files
├── main/             **Node** (base scene node), **SceneTree**, **Viewport**, **Window**,
│                     CanvasItem, CanvasLayer, Timer, MultiplayerAPI
├── resources/        Resource subtypes: Material, Mesh, Texture, Shader, Font, StyleBox,
│                     Animation, Curve, Gradient, Theme, Environment, Sky, etc. ~132 files
└── theme/            ThemeDB, theme data types
```

### `servers/` — Low-level engine services

```
servers/
├── audio/            AudioServer, AudioStream, AudioEffect, resamplers
├── camera/           CameraServer
├── debugger/         Server-side debugger
├── display/          DisplayServer, AccessibilityServer
├── movie_writer/     Video recording
├── navigation_2d/    NavigationServer2D, query types
├── navigation_3d/    NavigationServer3D, query types
├── physics_2d/       PhysicsServer2D (abstract), wrap_mt, extension
├── physics_3d/       PhysicsServer3D (abstract), wrap_mt, extension
├── rendering/        **RenderingServer**, **RenderingDevice**, scene cull/render,
│                     canvas render, shader language/compiler, RD backend, dummy backend
├── text/             TextServer (abstract + extensions)
└── xr/               XRServer, XRInterface
```

### `drivers/` — Platform-specific backends

```
drivers/
├── accesskit/        Accessibility bridge
├── alsa/             Linux audio
├── coreaudio/        macOS audio
├── d3d12/            Direct3D 12 rendering driver
├── gles3/            OpenGL ES 3.0 rendering driver (rasterizer, shaders, storage)
├── metal/            Metal rendering driver
├── png/              PNG image loader
├── pulseaudio/       Linux audio
├── vulkan/           Vulkan rendering driver (RD driver, context, shader containers)
├── wasapi/           Windows audio
├── xaudio2/          Windows audio
└── windows/          Win32 low-level
```

### `platform/` — OS platform integration

```
platform/
├── android/          Android port (Java + C++), SDK integration, APK export
├── ios/              iOS port, Xcode project generation
├── linuxbsd/         Linux/BSD/Unix port
├── macos/            macOS port, bundle generation
├── visionos/         Apple Vision Pro port
├── web/              Web (Emscripten/WASM) port
└── windows/          Windows (MSVC/MinGW) port, installer creation
```

### `editor/` — Built-in editor

```
editor/
├── animation/        Animation editor tracks/channels
├── asset_library/    Asset Library integration
├── audio/            Audio editor
├── debugger/         Editor debugger panel
├── doc/              Documentation tool
├── docks/            Docks (FileSystem, Scene, Import, etc.)
├── export/           Export system: export templates, platforms, code signing, shader baking
├── file_system/      FileSystem dock server/project scan
├── gui/              Editor-specific GUI widgets
├── icons/            ~1028 SVG icons (one per engine type) + build script
├── import/           Asset import pipeline (texture, font, mesh, etc.)
├── inspector/        Property inspector, array editor
├── plugins/          Plugin system: EditorPlugin, EditorResourceConversionPlugin
├── project_manager/  Project manager (first-launch dialog)
├── project_upgrade/  Project version upgrade paths
├── run/              Run game panel
├── scene/            Scene tree editor, 2D/3D viewports, gizmos
├── script/           Script editor
├── settings/         Editor settings, project settings editor
├── shader/           Shader editor
├── templates/        Project/scene templates
├── themes/           Editor theming: modern/classic styles, icons, fonts, colors
├── translations/     Editor i18n (.po files)
├── version_control/  VCS integration (Git via GDExtension)
├── editor_node.cpp   **Editor main entry point**
└── editor_builders.py  Editor-specific SCons builders
```

### `modules/` — Optional modular features (~63 modules)

Key modules:

| Module | Purpose |
|---|---|
| `gdscript/` | **GDScript language** — parser, analyzer, compiler, bytecode VM, editor integration |
| `mono/` | **C# support** — .NET glue, source generators, managed callables, GodotSharp SDK |
| `jolt_physics/` | Jolt Physics 3D engine integration (replacement for GodotPhysics3D) |
| `godot_physics_2d/` | Built-in 2D physics engine |
| `godot_physics_3d/` | Built-in 3D physics engine |
| `navigation_2d/` | 2D navigation (mesh generation, pathfinding) |
| `navigation_3d/` | 3D navigation (mesh generation, pathfinding) |
| `gltf/` | glTF 2.0 import/export |
| `visual_shader/` | Visual shader editor |
| `openxr/` | OpenXR VR/AR support |
| `webxr/` | WebXR support |
| `text_server_adv/` | Advanced text server (ICU, HarfBuzz, Graphite) |
| `text_server_fb/` | Fallback text server |
| `webrtc/` | WebRTC networking |
| `websocket/` | WebSocket client/server (wslay + enet) |
| `enet/` | ENet reliable UDP networking |
| `upnp/` | UPNP port mapping |
| `multipath/` | Multiplayer API |
| `glslang/` | GLSL/HLSL shader compilation (to SPIR-V) |
| `lightmapper_rd/` | GPU-based lightmapping (Vulkan RD) |
| `basis_universal/` | Basis Universal texture compression |
| `freetype/` | FreeType font rendering |
| `fbx/` | FBX importer (ufbx) |
| `betsy/` | Betsy GPU particle physics |
| `csg/` | CSG (Constructive Solid Geometry) nodes |
| `regex/` | PCRE2-based regular expressions |
| `svg/` | SVG rendering (thorvg) |
| `zip/` | ZIP file support (minizip) |
| `vorbis/`, `mp3/`, `ogg/`, `theora/`, `hdr/`, `tinyexr/`, `jpg/`, `tga/`, `bmp/`, `webp/`, `dds/`, `ktx/`, `cvtt/`, `etcpak/`, `astcenc/`, `bcdec/`, `msdfgen/`, `meshoptimizer/`, `xatlas_unwrap/` | Media codecs and compression |

### `thirdparty/` — Vendored dependencies (~69 libraries)

Key ones: Embree, spirv-cross/headers/reflect, volk, Vulkan headers, D3D12MA, DirectX headers, jolt_physics, mbedtls, freetype, harfbuzz, icu4c, pcre2, zlib/zstd, brotli, recastnavigation, ufbx, thorvg, doctest, glad, SDL, clipper2, manifold, yaml-cpp, etc.

### `main/` — Engine bootstrap

```
main.cpp           Engine startup, init sequence, main loop
performance.cpp    Performance singleton
main_timer_sync    Frame timing synchronization
splash.gen.h       Built-in splash screen image
app_icon.gen.h     Built-in app icon
```

### `tests/` — Unit and integration tests

```
tests/
├── core/            Core type tests
├── scene/           Scene node tests
├── servers/         Server tests
├── data/            Test data files
├── python_build/    Build system tests
├── compatibility_test/  Compatibility check
├── test_main.cpp    Test runner entry point
└── test_macros.h    Test macro definitions
```

### `doc/` — Documentation

```
classes/         XML class reference files
tools/           make_rst.py (RST generation), doc_status.py
translations/    Class reference i18n
```

### `misc/` — Development utilities

```
scripts/         CI helpers, installers (ANGLE, D3D12, Perfetto, etc.),
                 header_guards.py, file_format.py, dotnet_format, etc.
utility/         scons_hints.py, gdb_pretty_print, color.py, clang_format configs
dist/            Distribution/packaging configs
```

### `bin/` — Build output directory

Contains compiled binary (`godot.windows.editor.x86_64.exe`), D3D12 DLLs, and intermediate `obj/` files.

### Folders/files to ignore

- `__pycache__/` — Python cache
- `.scons_env.json`, `.sconsign5.dblite` — SCons state
- `*.gen.cpp`, `*.gen.h` — Auto-generated files (regenerate on build)
- `thirdparty/` — Vendored code; do not modify unless updating a dependency
- `bin/obj/` — Build artifacts

---

## Architecture & Patterns

### Layered architecture (bottom → top)

```
[Platform] → [Drivers] → [Core] → [Servers] → [Scene] → [Editor]
                              ↕
                          [Modules]
```

- **Core** has zero dependencies on scene/servers/editor — foundation types, math, I/O, object model, templates.
- **Servers** depend on Core; they provide abstract service interfaces (RenderingServer, PhysicsServer, etc.) that Drivers implement.
- **Scene** depends on Servers and Core — defines Node/Resource trees, GUI controls, animation.
- **Editor** depends on everything — the built-in editor is part of the same binary.
- **Modules** can hook into any layer via registration callbacks.

### Key base classes and shared systems

- **`Object`** (`core/object/object.h`) — absolute root of the scripting-accessible class hierarchy. Uses `GDCLASS()` macro for registration. Supports signals, properties, methods via `ClassDB`. Has `ObjectGDExtension` struct for C API extensions.
- **`RefCounted`** (`core/object/ref_counted.h`) — `Object` subclass with atomic ref-counting. Wrapped by `Ref<T>` smart pointer. `Resource` derives from this.
- **`Resource`** (`core/io/resource.h`) — `RefCounted` subclass; loadable/saveable data. Has `RES_BASE_EXTENSION` macro for custom file extensions.
- **`Node`** (`scene/main/node.h`) — `Object` subclass; fundamental scene graph node. Supports child/parent tree, groups, multiplayer, editing.
- **`CanvasItem`** → `Node2D`, `Control` — 2D drawable nodes.
- **`Node3D`** — 3D spatial node (replaces `Spatial` from Godot 3).
- **`Variant`** (`core/variant/variant.h`) — universal value type union: NIL, BOOL, INT, FLOAT, STRING, VECTOR2/3/4, TRANSFORM2D/3D, AABB, BASIS, QUATERNION, PLANE, COLOR, RECT2, NODE_PATH, OBJECT, DICTIONARY, ARRAY, CALLABLE, SIGNAL, RID, PACKED_BYTE/INT/FLOAT/STRING/COLOR/ARRAY/VECTOR2/3/4, BIT_FIELD, TYPED_ARRAY, TYPED_DICTIONARY.
- **`ClassDB`** (`core/object/class_db.h`) — central registry for all engine classes. Used to bind methods/signals/properties, instantiate by name, check inheritance.
- **`RenderingDevice`** (`servers/rendering/rendering_device.h`) — abstract GPU API (Vulkan/D3D12/Metal). Used by all shaders and rendering pipelines.
- **`SceneTree`** (`scene/main/scene_tree.h`) — root of the active scene. Runs main iteration loop, processes nodes, handles input propagation.
- **`Engine`** (`core/config/engine.h`) — engine-level singleton registry, version info, editor/main loop switch.
- **`ProjectSettings`** (`core/config/project_settings.h`) — global project configuration key-value store.
- **`OS`** (`core/os/os.h`) — abstract OS interface: file system, timers, clipboard, dialogs, process control.
- **`DisplayServer`** (`servers/display/display_server.h`) — window management, input, screens.

### State management approach

- **No global mutable state framework** — singletons are registered manually via `Engine::get_singleton()` and `ClassDB`. Core singletons: `Engine`, `ProjectSettings`, `Input`, `InputMap`, `OS`, `TranslationServer`, `ThemeDB`, `ResourceLoader`, `ResourceSaver`, `Performance`, `AudioServer`, `RenderingServer`, `PhysicsServer2D/3D`, `NavigationServer2D/3D`, `CameraServer`, `XRServer`, `GDExtensionManager`, `WorkerThreadPool`.
- **Scene tree state** is managed by `SceneTree` which owns the root `Window` → child `Node` hierarchy. Each frame: input → physics tick → process tick → render.
- **Resource system** — singletons `ResourceLoader` and `ResourceSaver` handle loading/caching with `.uid` files and import system. `ResourceFormatLoader`/`ResourceFormatSaver` plugins for each format.
- **Thread safety** — `SafeRefCount`, `SafeNumeric`, `RWLock`, `Mutex`, `SpinLock` in `core/os/` and `core/templates/`. `SAFE_FLAG_TYPE_PUN_GUARANTEES` macro for lock-free flags.
- **No reactive/property-binding system** — property changes are manual via setter calls. `UndoRedo` for editor undo/redo.

### Naming conventions

- **C++ source files:** `snake_case.cpp` / `snake_case.h` — e.g., `audio_stream_player_2d.cpp`, `resource_loader.cpp`.
- **Classes:** `PascalCase` — e.g., `AudioStreamPlayer2D`, `ResourceLoader`, `Node3D`, `RenderingDevice`.
- **Methods/functions:** `snake_case()` — e.g., `_ready()`, `_process()`, `set_position()`, `get_class()`.
- **Variables:** `snake_case` — member `snake_case` or `snake_case_` (trailing underscore for some core classes), local `snake_case`.
- **Constants/enums:** `UPPER_SNAKE_CASE` — e.g., `PROPERTY_HINT_NONE`, `ALIGN_CENTER`, `METHOD_FLAGS_DEFAULT`.
- **Macros:** `UPPER_SNAKE_CASE` — e.g., `GDCLASS()`, `ADD_SIGNAL()`, `ADD_PROPERTY()`, `SAFE_FLAG_TYPE_PUN_GUARANTEES`.
- **Files:** match the primary class they define (e.g., `audio_stream_player_2d.{cpp,h}` defines `AudioStreamPlayer2D`).
- **Compatibility:** `.compat.inc` files provide backwards-compatible method signatures for older GDExtension APIs.
- **Build scripts:** `config.py` for each module's build options, `SCsub` for SCons build definitions.

### Registration pattern

Every subsystem follows the same pattern:
1. `register_types.cpp/h` in each module/driver defines `register_types()`, `unregister_types()`.
2. `register_*_types.h` at each layer (core, scene, servers, drivers, platform, modules) collects and calls those.
3. `main.cpp` calls them in order: early singletons → core → drivers → servers → scene → modules → editor → platform APIs → GDExtension.
4. `ClassDB` is populated during registration; `GDCLASS(T, Parent)` macro provides static `get_class_static()` / `get_parent_class_static()` and `_bind_methods()` override for property/signal/method registration.
