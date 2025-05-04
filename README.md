# Composer

A lightweight scene manager library for [Godot](https://godotengine.org/), written in GDScript, featuring support for loading screens and data transfer between scenes.

## Getting Started

Download the latest release and copy the addons folder to your project. Then, enable the ComposerGodot addon in the [Project Settings](https://docs.godotengine.org/en/stable/tutorials/plugins/editor/installing_plugins.html#enabling-a-plugin).

<details>

<summary><strong>⚙️ Usage</strong></summary>

## 🔨 Scene Handling

+ To add/replace/restart a scene, simply call:
```
Composer.load_scene("path_to_scene", {"data_to_transfer": "Hello world!", "level": 1})
```
+ The first argument takes the path to the scene you'd like to create. The second argument is for passing any data with a Dictionary and is optional.

## 🏗️ Loading Screens
**Adding a custom loading screen**
+ To add a Loading Screen, call the 
```
Composer.setup_load_screen("path_to_load_screen")
```
This will add a loading screen and allows you to play any animations you'd like before actual loading (e.g. fade-in transition).
⚠️ Warning! You can only have one active Loading Screen at a time.

**Removing a loading screen**
+ To completely remove a Loading Screen, call
```
Composer.clear_load_screen()
```
</details>

<details>
  
<summary><strong>🚥 Signals</strong></summary>

**finished_initialising**
+ Emitted when Composer has been fully loaded and setup, alongside with its Timer.
```
finished_initialising()
```

**invalid_scene**
+ Emitted when provided scene is invalid (may not exist or path is invalid)
```
invalid_scene(path: String)
```

**failed_loading**
+ Emitted when scene has failed to load.
```
failed_loading(path: String)
```

**updated_loading**
+ Emitted every 0.1s during loading to provide progress for loading scenes.
```
updated_loading(path: String, progress: int)
```

**loading_activated**
+ A signal for use with Loading Screens for scene activation (i.e making scene visible or activating certain game logic), this helps with stuff like having a prompt to exit loading screen etc.
```
loading_activated()
```

</details>

<details>
  
<summary><strong>⚙️ Variables</strong></summary>

**root**
```
root: Node = get_tree().root
```
+ A node which will be the parent of the loaded Scenes. Default is `/root`.

**loading_timer_delay**
```
loading_timer_delay: float = 0.1
```
+ A delay between checking the loading process for progress. Default is 0.1s.

**is_using_subthreads**
```
is_using_subthreads: bool = false
```
+ Enables or disables the use of subthreads when loading scenes. Learn more about this [here](https://docs.godotengine.org/en/stable/classes/class_resourceloader.html#class-resourceloader-method-load-threaded-request). Default is false.

**cache_mode**
```
cache_mode: ResourceLoader.CacheMode = ResourceLoader.CACHE_MODE_REUSE
```
+ Sets the cache mode of loaded scenes. Learn more about this [here](https://docs.godotengine.org/en/stable/classes/class_resourceloader.html#enum-resourceloader-cachemode). Default is CacheMode.Reuse.
  
**unpack_data**
```
unpack_data: bool = true
```
+ Changes how data is unpacked during the transfer process. If true, each key in dictionary is added as a separate metadata. If false, the whole dictionary is added as one metadata with the name being "transferred_data".
</details>
