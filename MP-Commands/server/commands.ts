const MP = global.exports["MP-Base"].GetObject();

export const commands = [
    {
        name: "ooc",
        suggestion: "talk out of game character",
        isAdmin: false,
        handler: (source: number, args: string[]) => {
            const msg = args.join(' ');
            const Player = MP.Functions.GetPlayer(source);
            const id = Player.Data.PlayerId;
            const first = Player.Data.firstname;
            const last = Player.Data.lastname;
            const full = `|${id}| ${first} ${last}`;

			if (msg.length === 0) {
				// dudes an idiot and forgot to type a msg LOL
			} else {
				emitNet('chat:addMessage', -1, `OOC: ${full}: ${msg}`);
			}


        }
    },
	{
        name: "giveMoney",
        suggestion: "Give money to player id, cash/bank, amount, add/del",
        isAdmin: true,
        handler: (source: number, args: string[]) => {
			const target = parseInt(args[0])// id
			const Player = MP.Functions.GetPlayer(target)
			const bankingType = (args[1]) // cash/bank
			const amount = parseInt(args[2])  // amount
			const changer = (args[3]) // add or del
			if (Player !== null)  {
				global.exports['MP-Base'].changeMoney(target, bankingType, amount, changer)
			} else  {
				emitNet('MP-Elements:SendNotification', source,  2, "No Player Found." )

			}
        }
    },
	{
        name: "saveCoords",
        suggestion: "save coords for admins",
        isAdmin: true,
        handler: (source: number, args: string[]) => {
			const src = source
			const Player = MP.Functions.GetPlayer(src)
			emitNet("chatMessage", -1, `CONSOLE: ${Player.Data.cid}`, 3);
			emitNet("MP-Admin:Client:SaveCoords", source)
        }
    },

	{
        name: "console",
        suggestion: "used for rcon",
        isAdmin: true,
        handler: (source: number, args: string[]) => {
			const msg = args.join(' ');
			emitNet("chatMessage", -1, `CONSOLE: ${msg}`, 3);
        }
    },
	{
        name: "setgroup",
        suggestion: "used for rcon",
        isAdmin: true,
        handler: (source: number, args: string[]) => {
			const target: number = parseInt(args[0]); // player id in game
			const group = args[1]; // group [admin, mod, dev]

			const player = MP.Functions.GetPlayer(target);

			if (target !== null) {
				if (player) {
					if (MP.UserGroups[group]) {
						MP.Functions.setGroup(player, group);
						emitNet('MP-Elements:SendNotification', target, 1, `Set Group Correctly to ${group}`);
					} else {
						emitNet('MP-Elements:SendNotification', source, 2, 'Incorrect Group');
						// Add log for people trying to edit someone's perms
					}
				} else {
					emitNet('MP-Elements:SendNotification', source, 2, 'No Player Found.');
				}
			}
		}
	},
	{
        name: "addMoney",
        suggestion: "adds money to player id, cash/bank, amount",
        isAdmin: true,
        handler: (source: number, args: string[]) => {
			const target: number = parseInt(args[0]); // player id in game
			const type = args[1]; // cash or bank
			const amount = parseInt(args[2]); // amount

			const player = MP.Functions.GetPlayer(target);

			if (target !== null) {
				if (player) {
					if (type && amount) {
						global.exports['MP-Base'].changeMoney(target, type, amount, 'add');
						emitNet('MP-Elements:SendNotification', target, 1, `Added ${amount} to ${type} for ${player.Data.firstname} ${player.Data.lastname}`);
					} else {
						emitNet('MP-Elements:SendNotification', source, 2, 'Incorrect amount or type');
						// Add log for people trying to edit someone's perms
					}
				} else {
					emitNet('MP-Elements:SendNotification', source, 2, 'No Player Found.');
				}
			}
		}
    },
    // Other commands
];
