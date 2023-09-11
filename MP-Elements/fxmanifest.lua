fx_version 'adamant'

game 'gta5'

ui_page 'html/index.html'

client_scripts {
	'client/cl_ui.lua',
}

server_script '@oxmysql/lib/MySQL.lua'
server_scripts {
	'server/sv_ui.lua'
}

files {
	'html/index.html',
	'html/scripts.js',
	'html/style.css',
}