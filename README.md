## Session Tracker
The purpose of this script is to track how much time you spend working in specific programs.
> This is a modified version of a popular AutoHotKey script created by [Neil Cicierega](https://neilblr.com/post/58757345346).  

## Functionality 
By default only hours, minutes and seconds are shown in the main window. There's also the option to toggle the title of programs. The timer doesn't start until a whitelisted program is in focus. To whitelist a program select a program slot in the menu (ctrl+m) and click anywhere in the desired window.

![WindowPreview](https://github.com/403nul/SessionTracker/blob/main/status.png)

## Menu
The menu is shown on mouse location whenever pressing Ctrl+M, regardless of what program is in focus. The options are:
* **Resume Previous Time** - loads the saved time stored in **timer.ini**
* **Program 1/3** - three slots to specify which programs are considered work.
* **Pause Timeout** - decides if being idle stops the timer or not.
* **Color Alert** - decides if the timer window changes color based on if a work window is in focus.
* **Stay On Top** - decides if the timer window stays on top of all other programs.
* **Toggle Title** - toggles the visibility of a whitelisted programs title in the main timer window.
* **Toggle Persistent Title** - toggles if the window title automatically changes or not if "Toggle Title" is enabled.

![MenuPreview](https://github.com/403nul/SessionTracker/blob/main/menu.png)

## Config File
Upon first run a config file called **timer.ini** is automatially created wherever the exectutable is ran. It saves menu options and has extra settings such as:

* **Timeout** - how long it takes in seconds of inactivity to stop the timer.
* **OnColor** - the color of the window when working.
* **OffColor** - the color of the window when not working.
* **LastTime** - last saved time, can be manuaully overwritten in the config and restored with "Resume Previous Time."

## Download
AutoHotkey Script / Executable: [Download](https://github.com/403nul/SessionTracker/releases/tag/dl)
