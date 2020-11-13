local discordia = require('discordia')
local client = discordia.Client()
discordia.extensions()
local arg = {}
local code = {["validates"] = {["everyone"]=0,["here"]=0}}
local version = "V2 - Dernière mise à jour : 09/11/2020"
local text = {
    pasCode = "Ca ne ressemble pas à un code Among Us",
    ouCode = "Où est le code ?",
    codeSup = "Le code a été supprimé.",
    helpArgCode = "Tu veux faire quoi exactement ?\nEcris !tree code pour avoir de l'aide.",
    codeDuMoment = "Le code en ce moment est : **%s** *(%s)*\n*Demandé par :* %s",
    nouveauCode = "Le nouveau code est **%s**",
    noCode = "Il n'y a pas de code en ce moment.",
    notMID = [[Il faut l'ID d'un message (**Clique droit et "Copier l'ID"**).]],
    codeDeletionError = "<@664426090491805709> Erreur on code deletion; l:52; prob attempt to index ? (a nil value) ; Fix ASAP",
    codeMention = "@%s, le code est **%s**",
    pasUneMention = "Cette mention n'existe pas, sois everyone sois here.",
    attends = "Il faut que tu attendes 2 secondes entre chaque déclaration de code.",
    personneNomme = "Personne ne s'appelle comme ça dans le serveur.",
    personneVocal = "Personne n'est en vocal en ce moment.",
    pasEnvoie = "Le message n'a pas été envoyé.",
    falseEquation = "`%s` n'est pas une équation valide. %s",
    sureMention = "Es-tu sûre de vouloir mentionner `%s` ? Réagis avec :white_check_mark: (`:white_check_mark:`) ou :x: (`:x:`) à ce message.",
}
local killed = {}
local tree = {
    quoi = ([[Un "tree"]].." est une manière de représentée une suite de mots, d'arguments. Elle se présente comme ceci:\n> **!laCommande**\n`[2]` `Un des deuxièmes arguments` *(Son type)* : Comment on l'utilise *(ex: et parfois des exemples)*`"
            .."\n`[3]` `Un troisième argument` *(Son type)* : Comment on l'utilise"),
    code = {
        "> **!code**",
        "\n`[2]` `code` *(Variable)* : Le code Among Us de la game.",
        "\n`[3]` `nouv`/`nouveau` ou `new` *(Optionnel)* : Pour qu'il y ait un nouveau code *(ex: !code AAQUFQ nouv)*",
        "\n`[3]` `res`/`reset` ou `no`/`non` *(Optionnel)* : Pour effacer le code actuel (les games sont terminées, *ex: !code res*)",
        "\n**Par défaut 3 : `nouv`**",
    },
}
local data = {
    ["lastCodeTime"] = 0,
    gens = {
        ["adel1e#7791"] = {["genre"] = 1,["lastCode"]=0,["Nom"]="Adélie"},--0= masculin, 1 = féminin, 2 = autre, 3 = robot
        ["adele#0057"] = {["genre"] = 1,["lastCode"]=0,["Nom"]="Adèle"},
        ["bewbew#8634"] = {["genre"] = 0,["lastCode"]=0,["Nom"]="Aymane"},
        ["couclico#7383"] = {["genre"] = 1,["Nom"]="Chloé",["hasTools"]=true,["lastCode"]=0},
        ["helllooooo#1230"] = {["genre"]=0},["Nom"]="Elias",["lastCode"]=0,
        ["Impostor#9988"] = {["genre"] = 2,["isBot"]=true},
        ["julia.l#4091"] = {["genre"]=1,["Nom"]="Julia",["lastCode"]=0},
        ["NastuBest#1066"] = {["genre"]=0,["Nom"]="Augustin",["lastCode"]=0},
        ["NDtimo#1913"] = {["genre"]=0,["Nom"]="Timothée",["lastCode"]=0},
        ["Sam.#2284"] = {["genre"]=0,["Nom"]="Samuel",["lastCode"]=0,["hasTools"]=true},
        ["swyrl_nartex#0756"] = {["genre"]=0,["Nom"]="Romain",["lastCode"]=0},
    },
}
local vocal = {}
local sandbox = {
	math = math,
	string = string,
}
local script = {}
local listenReacts

client:on('ready', function()
    print('Logged in as '.. client.user.username)
end)

local function printLine(...)
    local ret = {}
    for i = 1, select('#', ...) do
        local arg = tostring(select(i, ...))
        table.insert(ret, arg)
    end
    return table.concat(ret, '\t')
end

local pp = require('pretty-print')

local function prettyLine(...)
    local ret = {}
    for i = 1, select('#', ...) do
        local arg = pp.strip(pp.dump(select(i, ...)))
        table.insert(ret, arg)
    end
    return table.concat(ret, '\t')
end

local function exec(arg, msg)
    if not arg then return end
    local lines = {}
    sandbox.message = msg
    sandbox.print = function(...)
        table.insert(lines, printLine(...))
    end
    sandbox.p = function(...)
        table.insert(lines, prettyLine(...))
    end
    local fn, syntaxError = load(arg, 'Impostor', 't', sandbox)
    if not fn then return syntaxErro end
    local success, runtimeError = pcall(fn)
    if not success then return runtimeError end
    lines = table.concat(lines, '\n')
    return lines
end 

function sayName(target,includeTag)
    local name,discriminator = target:sub(1,#target-5), target:sub(#target-4)
    if includeTag == true then
        return "**"..name.."**`"..discriminator.."`"
    elseif includeTag == false then
        return "**"..name.."**"
    else return target
    end
end

client:on('reactionAdd',function(reaction,user)
    if listenReacts == "validePing" then
        local m = code.validates
        local channel = reaction.message
        local valide
        if m.everyone ~= 0 then
            valide = m.everyone
        elseif m.here ~= 0 then
            valide = m.here
        end
        if valide then
            if reaction.message == valide then
                if reaction.emojiName == "✅" then
                    if code.lastPin then
                        code.lastPin:unpin()
                    end
                    if valide == m.everyone then
                        local codeToPin = channel:reply(string.format(text.codeMention,"everyone",code.current))
                        code.lastPin = codeToPin
                        code.lastPin:pin()
                    elseif valide == m.here then
                        local codeToPin = channel:reply(string.format(text.codeMention,"here",code.current))
                        code.lastPin = codeToPin
                        code.lastPin:pin()
                    end
                elseif reaction.emojiName == "❌" then
                    channel:reply(text.pasEnvoie)
                else channel:reply("Ce n'est pas la bonne réaction.")
                end
            else channel:reply("Tu n'as pas réagi au bon message.")
            end
        else channel:reply("Valide = nil; <@664426090491805709>\neveryone = "..tostring(m.everyone).."\n here = "..tostring(m.here))
        end
        listenReacts = false
    end
end)

client:on('voiceConnect', function(member)
    vocal[member.user.tag] = {
        object = member,
    }
end)

client:on('voiceDisconnect', function(member)
    vocal[member.user.tag] = nil
end)

function meanish(str)
    local suggestion = ""
    local else_suggestion = "Je ne comprends pas cette erreur: <@664426090491805709> Nouveau cas."
    local numberOfChars = 0
    for validChars in str:gmatch('%D') do
        numberOfChars = numberOfChars+1
    end
    for validChars in str:gmatch('[^*/+-()]') do
        numberOfChars = numberOfChars+1
    end
    if numberOfChars > 1 then
        suggestion = suggestion.."Certains charactères sont invalides.\n"
    end
    if str:match('%x') then
        suggestion = suggestion..[[Le fois s'écrit "*" et non "x"]].."\n"
    end
    if str:match('%:') or str:match('%÷') then
        suggestion = suggestion..[[Le divisé s'écrit "/" et non ":" ni "÷" .]].."\n"
    end
    if str:match('%+') then
        local numberOfPlus = 0
        for plus in str:gmatch('%+') do
            numberOfPlus = numberOfPlus+1
        end
        if numberOfPlus > 1 then
            local TMplus = str:match('[%+]+')
            suggestion = suggestion.."Tu as écris **"..numberOfPlus.."** fois le signe + (`"..TMplus.."`)\n"
        end
    end
    if str:match('%-') then
        local numberOfMinus = 0
        for minus in str:gmatch('%-') do
            numberOfMinus = numberOfMinus+1
        end
        if numberOfMinus > 1 then
            local TMminus = str:match('[%-]+')
            suggestion = suggestion.."Tu as écris **"..numberOfMinus.."** fois le signe - (`"..TMminus.."`)\n"
        end
    end
    if suggestion ~= "" then
        return suggestion
    else return else_suggestion
    end
end

client:on('messageCreate', function(message)
    local author,content = message.author.tag,message.content
    arg[author] = {}
    local cmd = arg[author]
    for words in content:gmatch('%S+') do
        cmd[#cmd+1] = string.lower(words)
    end
    --use of cmd
    if not message.author.bot then
        if cmd[1] == "!code" then
            if cmd[2] then
                if not tonumber(cmd[2]) and #cmd[2] == 6 then
                    code.current = string.upper(cmd[2])
                    if not cmd[3] then
                        local codeToPin = message:reply(string.format(text.nouveauCode,code.current))
                        if code.lastPin then
                            code.lastPin:unpin()
                        end
                        code.lastPin = codeToPin
                        code.lastPin:pin()
                    elseif cmd[3] == "everyone" then
                        local lastChance = message:reply(string.format(text.sureMention,"everyone"))
                        code.validates.everyone = lastChance
                        listenReacts = "validePing"
                    elseif cmd[3] == "here" then
                        local lastChance = message:reply(string.format(text.sureMention,"here"))
                        code.validates.here = lastChance
                        listenReacts = "validePing"
                    end
                elseif cmd[2]:sub(1,3) == "res" or cmd[2]:sub(1,2) == "no" then
                    if code.current then
                        code.current = nil
                        message:reply(text.codeSup)
                        code.lastPin:unpin()
                    else message:reply(text.noCode)
                    end
                else message:reply(text.pasCode)
                end
            elseif not cmd[2] and code.current then
                message:reply(string.format(text.codeDuMoment,code.current,code.lastPin,sayName(author,true)))
            elseif not cmd[2] and not code.current then
                message:reply(text.noCode)
            end
        elseif cmd[1] == "!pin" then
            if cmd[2] then
                local targetMessage = message.channel:getMessage(cmd[2])
		        if targetMessage then
                    targetMessage:pin()
                    if cmd[3] then
                        message:reply(author.." a épinglé un message pour cette raison : "..cmd[3])
                    end
                else message:reply(text.notMID)
                end
            else message:reply(text.notMID)
            end
        elseif cmd[1] == "!unpin" then
            if cmd[2] then
                local targetMessage = message.channel:getMessage(cmd[2])
                if targetMessage then
                    targetMessage:unpin()
                else message:reply(text.notMID)
                end
            else message:reply(text.notMID)
            end
        elseif cmd[1] == "!tree" then
            if cmd[2] == "code" or cmd[2] == "!code" then
                message:reply(table.concat(tree.code))
            else message:reply(tree.quoi)
            end
        elseif cmd[1] == "!voc" then
            local inVocal = ""
            for user in pairs(vocal) do
                if user then
                    inVocal = inVocal.."• "..sayName(user,true).." est dans le vocal **"..vocal[user].object.voiceChannel.name.."**.\n"
                end
            end
            if inVocal ~= "" then
                message:reply(inVocal)
            else message:reply(text.personneVocal)
            end
            --Miscellaneous
        elseif cmd[1] == "!say" then
            message:reply(content:sub(6))
        elseif cmd[1] == "!math" then
            local result = load('return '..content:sub(7))
            if result then
                message:reply(result())
            else message:reply(string.format(text.falseEquation,content:sub(7),meanish(content:sub(7))))
            end
        elseif cmd[1] == "!lua" then
            local lua = content:match('!lua\n```lua\n(.+)```')
            local code = content:match('!lua\n```\n(.+)```')
            local current_script = {
                embed = {
                    description = "",
                    color = 3158325,
                },
            }
            if lua or code then
                script[author] = lua or code
                local x = exec(lua or code,message)
                current_script.embed.description = x
                message:reply(current_script)
            elseif not lua and not code and script[author] then
                local lastScript = {
                embed = {
                title = "Ton dernier script :",
                description = script[author],
                color = 3158325,
                fields = {
                    [1] = {
                        name = "Raw",
                        value = script[author],
                        inline = false,
                    },
                },
            },
            }
                lastScript.embed.description = exec(lastScript.embed.description)
                message:reply(lastScript)
            else message:reply("Tu n'as pas d'ancien script.")
            end
        elseif cmd[1] == "!m" then
            local init = tonumber(cmd[2])
            if message.member.voiceChannel then
                if init == 1 then
                    for user in message.member.voiceChannel.connectedMembers:iter() do
                        if not killed[user.username] then
                            user:mute()
                        end
                    end
                elseif init == 0 then
                    for user in message.member.voiceChannel.connectedMembers:iter() do
                        if not killed[user.username] then
                            user:unmute()
                        end
                    end
                end
            end
        elseif cmd[1] == "!kill" or "!k" then
            local noConsiderDead = "Personne n'est considéré comme mort."
            --[['La liste des morts a été restorée.'
            'La liste des morts a été réinitialisée.'
            "Personne n'est considéré comme mort."
            
            sayName(t_kill.tag,true).." n'est pas en vocal."
            sayName(t_kill.tag,true).." n'a pas pu être mute/démute."
            sayName(t_kill.tag,true).." a été retiré de la liste des morts."
            sayName(t_kill.tag,true).." a été ajouté à la liste des morts."
            ]]
            local formerKilled = killed
            if cmd[2] == "reset" then
                for _,dead in pairs(killed) do
                    if dead then
                        if dead.voiceChannel then
                            dead:unmute()
                        else message:reply(sayName(dead.name,true).." n'est pas dans un vocal et fait parti des morts.")
                        end
                    else message:reply(noConsiderDead)
                    end
                end
            elseif cmd[2] == "restore" then
                killed = formerKilled
                for _,dead in pairs(killed) do
                    if dead then
                        if dead.voiceChannel then
                            dead:mute()
                        else message:reply(sayName(dead.name,true).." n'est pas dans un vocal et doit être démuté(e).")
                        end
                    else message:reply(noConsiderDead)
                    end
                end
            else
                local hasMention = true
                for id,user in pairs(message.mentionedUsers) do
                    if hasMention then
                        if user then
                            local member = message.guild:getMember(id)
                            if member.voiceChannel then
                                if killed[user.name] then
                                    killed[user.name] = nil
                                    member:unmute()
                                elseif not killed[user.name] then
                                    killed[user.name] = member
                                    member:mute()
                                end
                            end
                        else hasMention = false
                        end
                    end
                end
            end
        end
        if cmd[1] == "!set" then
            message:reply(cmd[2])
            if cmd[2]:sub(1,2) == "op" then
                for roles in message.mentionedRoles:iter() do
                    message:reply(roles.name)
                end
            end
        elseif cmd[1] == "!wap" then
            message:reply("There some walls :flag_us: in this house\n"..
            "There some wools 🐑 in this house\n"..
            "There some wolves 🐺 in this house\n"..
            "There some whales 🐳 in this house\n")
        elseif cmd[1] == "!restart" then
            for k,v in pairs(aa) do
            end
        elseif cmd[1] == "!version" then
            message:reply(version)
        end
    end
end)

client:run('Bot '..token)
