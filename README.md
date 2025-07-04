# REVIVAL
GSC mod menu for COD Ghosts Extinction

## Requirement
- Alterware Launcher for Call of Duty Ghosts

## Installation
- Download and place the revival.gsc file in the data/scripts/mp folder

## Configuration
- There is an issue with the resolution currently. The menu will appear offscreen on high resolutions. To fix this open the file in any text editor and on line 171 add a multiplier to move the menu back on screen.
- Example: scaleX = (res_width / ref_width) * 0.5;
- This is trial and error depending on your resolution. If you need the menu moved left then decrease the multiplier and vice versa.

## Controls
- Aim + Melee to open the menu, Aim/Shoot to scroll, Interact button to select, Melee to go back/close
