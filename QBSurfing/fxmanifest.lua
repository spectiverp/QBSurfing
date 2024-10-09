-- fxmanifest.lua
fx_version 'cerulean'
game 'gta5'

author 'C45PER'
description 'Surfering'
version '1.0.0'

client_scripts {
    'client.lua',
}

-- Server Scripts
server_scripts {
    'server.lua',
}

-- Dependencies
dependencies {
    'qb-core',
    'qb-inventory', -- Ensure you have qb-inventory or equivalent for item management
}

files {
    'stream/**.**'
	
}
 
data_file 'HANDLING_FILE' 'stream/handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'stream/vehicles.meta'
data_file 'CARCOLS_FILE' 'stream/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'stream/carvariations.meta'
data_file 'DLC_TEXT_FILE' 'stream/dlctext.meta'
client_script 'stream/vehicle_names.lua'