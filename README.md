This work is licensed under a [Creative Commons Attribution-NonCommercial-ShareAlike 4.0
International License][cc-by-nc-sa].

[![CC BY-NC-SA 4.0][cc-by-nc-sa-image]][cc-by-nc-sa]

[cc-by-nc-sa]: http://creativecommons.org/licenses/by-nc-sa/4.0/
[cc-by-nc-sa-image]: https://licensebuttons.net/l/by-nc-sa/4.0/88x31.png
[cc-by-nc-sa-shield]: https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg

# tr-lumberjack
LumberJack Script for QBCore

## Whats included
- Easy to use config
- Can change if you want it to be a job or not [Config option]
- 100 x 100 Images
- Turn on and off blips

## Dependencies
- [qb-core](https://github.com/qbcore-framework/qb-core)
- [qb-target](https://github.com/BerkieBb/qb-target)
- [qb-menu](https://github.com/qbcore-framework/qb-menu)
- [PolyZone](https://github.com/mkafrin/PolyZone)

## Installation

[If you would like to use this as a job feature] Add the job to your **qb-core/shared/job.lua**  

```
	['lumberjack'] = {
		label = 'LumberJack',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Logger',
                payment = 50
            },
        },
	},
```
in **qb-cityhall/server/main.lua** add under Local AvailableJobs

```
"lumberjack",
```

If you are using Booya Nopixel styled phone to add the job feature go to **qb-phone/config.lua  (Config.JobCenter)** [nopixel-style-phone](https://github.com/vBooya/qb-phone-npstyle)

```
    [7] = {
        job = "lumberjack",
        label = "Logger",
        Coords = {1167.73, -1347.27},
    },
```


Add the item to your **qb-core/shared/item.lua**

```
	["tree_lumber"]						= {["name"] = "tree_lumber",  	  		["label"] = "Lumber",	  		["weight"] = 50, 		["type"] = "item", 		["image"] = "lumber.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = ""},
	["tree_bark"]						= {["name"] = "tree_bark",  	  		["label"] = "Tree Bark",	  	["weight"] = 50, 		["type"] = "item", 		["image"] = "treebark.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = ""},
	["wood_plank"]						= {["name"] = "wood_plank",  	  		["label"] = "Wood Plank",	  	["weight"] = 50, 		["type"] = "item", 		["image"] = "woodplank.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = ""},
```
For images move the images from the img folder to your inventory image folder **qb-inventory/html/images**

If you are using lj-fuel or a different fuel system

Change LegacyFuel to whatever fuel system in **tr-lumberjack/client/main.lua Line 263**

## Preview Pictures
- [Youtube Video](https://youtu.be/DpmRvZUhPAo)
![Preview Screenshot](https://i.imgur.com/5ZC9RNo.jpeg)
![Preview Screenshot](https://i.imgur.com/2D3lOfG.png)
![Preview Screenshot](https://i.imgur.com/mdv3wX6.png)
![Preview Screenshot](https://i.imgur.com/TghLZWz.jpeg)
![Preview Screenshot](https://i.imgur.com/vtHS9iP.jpeg)
![Preview Screenshot](https://i.imgur.com/tIWGi16.jpeg)
![Preview Screenshot](https://i.imgur.com/I3oQ5wi.jpeg)

## Discord
- [Join Discord](https://discord.gg/T2xX5WwmEX)

## Support
- [Ko-fi Link](https://ko-fi.com/trclassic)
