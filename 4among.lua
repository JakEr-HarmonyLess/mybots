local discordia = require('discordia')
local client = discordia.Client()
discordia.extensions()
local arg = {}
local code = {}
local version = "V1 - Dernière mise à jour : 06/11/2020"
local text = {
    pasCode = "Ca ne ressemble pas à un code Among Us",
    ouCode = "Où est le code ?",
    codeSup = "Le code a été supprimé.",
    helpArgCode = "Tu veux faire quoi exactement ?\nEcris !tree code pour avoir de l'aide.",
    codeDuMoment = "Le code en ce moment est : **%s** *(%s)*\n*Demandé par :* %s",
    nouveauCode = "Le nouveau code est %s",
    noCode = "Il n'y a pas de code en ce moment.",
    notMID = [[Il faut l'ID d'un message (**Clique droit et "Copier l'ID"**).]],
    codeDeletionError = "<@664426090491805709> Erreur on code deletion; l:52; prob attempt to index ? (a nil value) ; Fix ASAP",
}
local tree = {
    quoi = ([[Un "tree"]].." est une manière de représentée une suite de mots, d'arguments. Elle se présente comme ceci:\n> **!laCommande**\n`[2]` `Un des deuxièmes arguments *(Son type)* : Comment on l'utilise *(ex: et parfois des exemples)*`"
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
    gens = {
        ["adel1e#7791"] = {["genre"] = 1,},--1 = féminin, 0 = masculin, 2 = autre
        ["adele#0057"] = {["genre"] = 0},
        ["bewbew#8634"] = {["genre"] = 0},
        ["couclico#7383"] = {["genre"] = 1,["hasTools"]=true},
        ["helllooooo#1230"] = {["genre"]=0},
        ["Impostor#9988"] = {["genre"] = 2,["isBot"]=true},
        ["julia.l#4091"] = {["genre"]=1},
        ["NastuBest#1066"] = {["genre"]=0},
        ["NDtimo#1913"] = {["genre"]=0},
        ["Sam.#2284"] = {["genre"]=0,["hasTools"]=true},
        ["swyrl_nartex#0756"] = {["genre"]=0},
    },
}

client:on('ready', function()
    print('Logged in as '.. client.user.username)
end)

function sayName(target,includeTag)
    local name,discriminator = target:sub(1,#target-5), target:sub(#target-4)
    if includeTag then
        return "**"..name.."**`"..discriminator.."`"
    else return "**"..name.."**"
    end
end

client:on('messageCreate', function(message)
    local author,content = message.author.tag,message.content
    arg[author] = {}
    local cmd = arg[author]
    for words in content:gmatch('%S+') do
        cmd[#cmd+1] = string.lower(words)
    end
    if cmd[1] == "!code" then
        if cmd[2] then
            if tostring(cmd[2]) and #cmd[2] == 6 then
                if not cmd[3] and cmd[2] or cmd[3]:sub(1,4) == "nouv" or cmd[3] == "new" then
                    code.current = string.upper(cmd[2])
                    if code.lastPin then
                    code.lastPin:unpin()
                    end
                    local codeToPin = message.channel:send(string.format(text.nouveauCode,code.current))
                    code.lastPin = codeToPin
                    code.lastPin:pin()
                    local admin = {["Sam.#2284"]=true}
                    if admin[author] then
                        if cmd[4] then
                            if cmd[4] == "true" then
                                message:reply("@everyone, le code est " .. code.current)
                            end
                        end
                    end
                end
            elseif cmd[2]:sub(1,3) == "res" or cmd[2]:sub(1,2) == "no" then
                code.current = nil
                message:reply(text.codeSup)
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
    elseif cmd[2] == "!unpin" then
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
    elseif cmd[1] == "!version" then
        message:reply(version)
    end
end)

client:run('Bot '..token)
