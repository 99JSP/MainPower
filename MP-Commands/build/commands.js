"use strict";(()=>{var i=global.exports["MP-Base"].GetObject(),c=[{name:"ooc",suggestion:"talk out of game character",isAdmin:!1,handler:(o,t)=>{let e=t.join(" "),n=i.Functions.GetPlayer(o),s=n.Data.PlayerId,a=n.Data.firstname,r=n.Data.lastname,l=`|${s}| ${a} ${r}`;e.length===0||emitNet("chat:addMessage",-1,`OOC: ${l}: ${e}`)}},{name:"giveMoney",suggestion:"Give money to player id, cash/bank, amount, add/del",isAdmin:!0,handler:(o,t)=>{let e=parseInt(t[0]),n=i.Functions.GetPlayer(e),s=t[1],a=parseInt(t[2]),r=t[3];n!==null?global.exports["MP-Base"].changeMoney(e,s,a,r):emitNet("MP-Elements:SendNotification",o,2,"No Player Found.")}},{name:"saveCoords",suggestion:"save coords for admins",isAdmin:!0,handler:(o,t)=>{let e=o,n=i.Functions.GetPlayer(e);emitNet("chatMessage",-1,`CONSOLE: ${n.Data.cid}`,3),emitNet("MP-Admin:Client:SaveCoords",o)}},{name:"console",suggestion:"used for rcon",isAdmin:!0,handler:(o,t)=>{let e=t.join(" ");emitNet("chatMessage",-1,`CONSOLE: ${e}`,3)}},{name:"setgroup",suggestion:"used for rcon",isAdmin:!0,handler:(o,t)=>{let e=parseInt(t[0]),n=t[1],s=i.Functions.GetPlayer(e);e!==null&&(s?i.UserGroups[n]?(i.Functions.setGroup(s,n),emitNet("MP-Elements:SendNotification",e,1,`Set Group Correctly to ${n}`)):emitNet("MP-Elements:SendNotification",o,2,"Incorrect Group"):emitNet("MP-Elements:SendNotification",o,2,"No Player Found."))}},{name:"addMoney",suggestion:"adds money to player id, cash/bank, amount",isAdmin:!0,handler:(o,t)=>{let e=parseInt(t[0]),n=t[1],s=parseInt(t[2]),a=i.Functions.GetPlayer(e);e!==null&&(a?n&&s?(global.exports["MP-Base"].changeMoney(e,n,s,"add"),emitNet("MP-Elements:SendNotification",e,1,`Added ${s} to ${n} for ${a.Data.firstname} ${a.Data.lastname}`)):emitNet("MP-Elements:SendNotification",o,2,"Incorrect amount or type"):emitNet("MP-Elements:SendNotification",o,2,"No Player Found."))}}];})();