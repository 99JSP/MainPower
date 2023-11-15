import { commands } from './commands'; // Adjust the path to the actual location of the commands.ts file
// const Delay = (time: number) => new Promise(resolve => setTimeout(resolve, time));
const MP = global.exports["MP-Base"].GetObject();

function registerCommands() {
    for (const command of commands) {
        RegisterCommand(
            command.name,
            (source: number, args: string[]) => {
				// change to ace perms
                if (command.isAdmin && IsPlayerAceAllowed(source.toString(), "group.admin")) {
                    // Handle unauthorized access to admin command here
                    emitNet('chat:addMessage', source, { args: ['^1Error', 'You do not have permission to use this command.'] });
                } else {
                    command.handler(source, args);
                }
            },
            false
        );
    }
}


registerCommands();

on('playerConnecting', () => {
    // This code will run when a player connects
    registerCommands(); // Call the function to register commands
});