
fx_version 'adamant'
game 'gta5'


dependency 'oxmysql'

author 'JSP'

ui_page 'html/index.html'

client_scripts{
    "shared/shared.lua",
    "events/cl_events.lua",
    "gameplay/gameplay.lua",
    "core/cl_core.lua",
	"admin/cl_admin.lua",
    "character/cl_char.lua",
}

server_script '@oxmysql/lib/MySQL.lua'

server_scripts{
    "shared/shared.lua",
    "events/sv_events.lua",
    "character/db_char.lua",
    "character/sv_char.lua",
    "core/sv_core.lua",
	"admin/sv_admin.lua",
    "player/player.lua",
}

files{
	"html/img/background.png",
	"html/img/logo.png",
	"html/main.css",
	"html/index.html",
	"html/app.js",
}
