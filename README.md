I havent managed to remove the sound from the surfboard. (Maybe someone can comment a way to do it) I have set the audiohash as null, set the fWaveAudioMult to 0 but still not removing the engine sound. I also havent remove the trunk storage. ITEMS PLACED IN THE TRUNK WILL BE DELETED ON DESPAWN OF THE SURFBOARD

**INSTALLATION**

Remove "-main" from the folder name

add the following to qb-core>shared>items.lua


["surfboard"] 		 			 = {["name"] = "surfboard",       	    	["label"] = "Surfboard",	 				["weight"] = 150, 		["type"] = "item", 		["image"] = "surfboard.png", 			["unique"] = true, 	["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Lets go surfing duuuude!"},


Add the image from the "img" folder to qb-inventory>html>images

To change location its all in the client.lua

Script made by C45PER @ Spective RP
Edit it however you want, its a free script, its yours to do with as you please. 
All i ask is that if you update it an post it online please give credit. 

**Surfboards are given for free to change this you just need to add the removemoney qbcore function to the surfboard:give event in server.lua**
