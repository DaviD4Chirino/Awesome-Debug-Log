
# Awesome Debug Log

Display values with titles into a panel in-game

![Addon Logo](<assets/Awesome Debug Log 1920x1920.png>)

![GitHub License](https://img.shields.io/github/license/DaviD4Chirino/Awesome-Debug-Log) ![GitHub Release](https://img.shields.io/github/v/release/DaviD4Chirino/Awesome-Debug-Log) ![GitHub Stars](https://img.shields.io/github/stars/DaviD4Chirino/Awesome-Debug-Log)

## Features

* Console log *But in game!* No more need to minimize the game screen
* Order your logs with *Tabs*
* Easy [keyboard based navigation](#navigating-between-tabs)

## Installation

### From The AssetLib

* Open the AssetLib tab in your project and search for **Awesome Debug Log**
* Open it and select install, from there follow the instructions
* Finally, go to *Project/Project Settings/Plugins* and activate **awesome-debug-log**

### Manually

* Go to [Releases](https://github.com/DaviD4Chirino/Awesome-Debug-Log/releases/latest) and download the Source code, inside will be a folder called
  
  **awesome-debug-log** (it may be nested)
  * UPDATE THIS WHEN THE ADDON BEEN GREENLITED

> You can also get it from the [Godot Asset Library](https://godotengine.org/asset-library/asset)
>

* Go to the root of your project and open the **addons folder** (create it if there's none)
* Finally, go to *Project/Project Settings/Plugins* and activate **awesome-debug-log**

## Usage

With the addon active, an Autoload called **Debug** will be added, then call **Debug.callable** with any of the below functions, the most important is:

### `log`

Call **Debug.log()** anywhere in your scripts to start displaying your values.

| Arguments | Type   | Value | Comment                                                                                                 |
| --------- | ------ | ----- | ------------------------------------------------------------------------------------------------------- |
| title     | String |       |                                                                                                         |
| tab       | String | ""    | The tab the log belongs to, if there's no tab with that name or its empty, it will log in the first tab |
| unique    | bool   | true  | If this is set to false, it will create a new log without looking for pre-existing logs       |

Creates a new line in the selected tab, if there's already a line with the same title it will update that instead unless specified.

In this case, to display the frames per second we call the **log** function with "FPS" as the **title** and a string that divides delta by 1.0 as the **value**.
We don´t care about the other values.

``` GDScript
func _process(delta):
    Debug.log("FPS", "%.2f" % (1.0 / delta))
```

Then it will show like so:
![Debug.log demo](3HIiT7WnLr.gif)

### `add_tab`

| Arguments   | Type   | Value | Comment                                                                       |
| ----------- | ------ | ----- | ----------------------------------------------------------------------------- |
| tab_name    | String |       |                                                                               |
| at_position | int    | -1    | Where you want the tab to be, less than 0 puts it at the end                  |
| capped_at   | int    | 0     | The maximum number of logs that tab can have, **a value of 0 means uncapped** |

Adds a new tab, if there's already a tab with the same name, it will issue a warning and return

After that, you can log your values in that tab by referencing the name like so:

```GDScript
func _ready():
    Debug.add_tab("New Tab")
 Debug.log("Vector right", Vector2.RIGHT, "New Tab")
```

![Adding a new tab example](Godot_v4.2.2-stable_mono_win64_9TPoN8A2Kq.png)

### `remove_tab`

| Arguments | Type   |
| --------- | ------ |
| tab_name  | String |

You can similarly delete tabs with the same name, if there's no tabs or there's no tab with that name, it will print an error and return

### Modifying already existing tabs

This is a tandem of 3 functions and a general function for changing properties of an existing tab. All of them returns true or false if they succeeded or failed on updating their property

#### `update_tab`

With the name of the tab, you can change all its properties. Use it when you want to change 2 or more properties at once

| Arguments        | Type   | Value | Comment |
| ---------------- | ------ | ----- | ------- |
| tab_name         | String |       |         |
| new_tab_name     | String | ""    |         |
| move_to_position | int    | -1    |         |
| capped_at        | int    | -1    |         |

If you want to change only one of those properties, use the following:

#### `update_tab_name`

| Arguments    | Type   |
| ------------ | ------ |
| tab_name     | String |
| new_tab_name | String |

Changes the name of a tab with a new one

#### `update_tab_position`

| Arguments    | Type   |
| ------------ | ------ |
| tab_name     | String |
| new_position | int    |

Changes the position of a tab to the one selected, the value is clamped between 0 and the maximum number of caps (so don't worry about it)

#### `update_tab_log_cap`

| Arguments | Type   |
| --------- | ------ |
| tab_name  | String |
| new_cap   | int    |

Changes the cap of the logs from tab

### Utility functions

There are a bunch of utility functions inside **Debug.gd** and they are *(mostly)* documented or self explanatory, you can see them by using the auto docs from Godot themselves

## Navigating between tabs

Apart from clicking on them like normal, you can use the **Function Keys** to travel between the tabs and toggle the panel altogether.

### F1

**Hides/Shows** the panel

### F2

Selects the **previous** tab

### F3

Selects the **next** tab

### Changing the hotkeys

Right now it checks for the physical keycode of the input received, this is so because i cant create a input event for you to easily modify.

So if you want different hotkeys you´ll have to modify it to listen to whatever you want

Heres the whole **input function** in **Debug.gd**

```GDScript
func _input(event: InputEvent):

    ## Replace it with whatever you want

    # I used Keycode because i don´t see how to add a custom action to the input map

    # Well, more like i don´t WANT to make a way, so I used physical keycode

    if event is InputEventKey and event.is_released():

        match event.keycode:

            # Toggle the whole screen

            KEY_F1:

                visible = !visible

  

            # Switch between tabs by pressing F1 and F2

            KEY_F2:

                tabs.select_previous_available()

            KEY_F3:

                tabs.select_next_available()
```

I just called `tabs.select_previous_available/next_available`
And toggle the visibility using this line:`visible = !visible`

---
