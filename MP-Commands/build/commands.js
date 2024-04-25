"use strict";(()=>{var i=global.exports["MP-Base"].GetObject(),m=n=>new Promise(e=>setTimeout(e,n)),c=[{name:"ooc",suggestion:"talk out of game character",isAdmin:!1,handler:(n,e)=>{let t=e.join(" "),o=i.Functions.GetPlayer(n),s=o.Data.PlayerId,a=o.Data.firstname,r=o.Data.lastname,l=`|${s}| ${a} ${r}`;t.length===0||emitNet("chat:addMessage",-1,`OOC: ${l}: ${t}`)}},{name:"giveMoney",suggestion:"Give money to player id, cash/bank, amount, add/del",isAdmin:!0,handler:(n,e)=>{let t=parseInt(e[0]),o=i.Functions.GetPlayer(t),s=e[1],a=parseInt(e[2]),r=e[3];o!==null?global.exports["MP-Base"].changeMoney(t,s,a,r):emitNet("MP-Elements:SendNotification",n,2,"No Player Found.")}},{name:"saveCoords",suggestion:"save coords for admins",isAdmin:!0,handler:(n,e)=>{let t=n,o=i.Functions.GetPlayer(t);emitNet("chatMessage",-1,`CONSOLE: ${o.Data.cid}`,3),emitNet("MP-Admin:Client:SaveCoords",n)}},{name:"console",suggestion:"used for rcon",isAdmin:!0,handler:(n,e)=>{let t=e.join(" ");emitNet("chatMessage",-1,`CONSOLE: ${t}`,3)}},{name:"setgroup",suggestion:"used for rcon",isAdmin:!0,handler:(n,e)=>{let t=parseInt(e[0]),o=e[1],s=i.Functions.GetPlayer(t);t!==null&&(s?i.UserGroups[o]?(i.Functions.setGroup(s,o),emitNet("MP-Elements:SendNotification",t,1,`Set Group Correctly to ${o}`)):emitNet("MP-Elements:SendNotification",n,2,"Incorrect Group"):emitNet("MP-Elements:SendNotification",n,2,"No Player Found."))}},{name:"addMoney",suggestion:"adds money to player id, cash/bank, amount",isAdmin:!0,handler:(n,e)=>{let t=parseInt(e[0]),o=e[1],s=parseInt(e[2]),a=i.Functions.GetPlayer(t);t!==null&&(a?o&&s?(global.exports["MP-Base"].changeMoney(t,o,s,"add"),emitNet("MP-Elements:SendNotification",t,1,`Added ${s} to ${o} for ${a.Data.firstname} ${a.Data.lastname}`)):emitNet("MP-Elements:SendNotification",n,2,"Incorrect amount or type"):emitNet("MP-Elements:SendNotification",n,2,"No Player Found."))}},{name:"setjob",suggestion:"setjob player id, job id, job grade",isAdmin:!0,handler:async(n,e)=>{let t=parseInt(e[0]),o=i.Functions.GetPlayer(t),s=global.exports["MP-Base"].GetPlayerData(n,"job"),a=e[1],r=parseInt(e[2]);o!==null?(emitNet(s+":client:unloadJob",t),console.log(o.Data.job+":client:unloadJob",t),emit(a+":server:changeJob",t,a,r),await m(500),emitNet(a+":client:loadJob",t)):emitNet("MP-Elements:SendNotification",n,2,"No Player Found.")}},{name:"job",suggestion:"View your current occupation",isAdmin:!1,handler:(n,e)=>{i.Functions.GetPlayer(n)!==null?emit("server:getJob",n):emitNet("MP-Elements:SendNotification",n,2,"Something is wrong, contact administrator.")}},{name:"adminmenu",suggestion:"(admin only) opens admin menu",isAdmin:!0,handler:(n,e)=>{let t=parseInt(e[0]),o=i.Functions.GetPlayer(t),s=e[1],a=parseInt(e[2]);n!==null?emitNet("admin:client:openAdminMenu",n):emitNet("MP-Elements:SendNotification",n,2,"Something is wrong here...")}}];})();
