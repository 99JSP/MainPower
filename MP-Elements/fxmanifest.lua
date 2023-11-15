fx_version 'adamant'

game 'gta5'

ui_page 'html/index.html'

author 'JSP'

client_scripts {
	'client/cl_ui.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/sv_ui.lua'
}

files {
	'html/index.html',
	'html/scripts.js',
	'html/style.css',
}