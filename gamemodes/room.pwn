#include <a_samp>
#include <zcmd>
#include <sscanf2>

/*
  .oooooo.     .oooooo.   ooooo      ooo oooooooooooo ooooo   .oooooo.     .oooooo..o 
 d8P'  `Y8b   d8P'  `Y8b  `888b.     `8' `888'     `8 `888'  d8P'  `Y8b   d8P'    `Y8 
888          888      888  8 `88b.    8   888          888  888           Y88bo.      
888          888      888  8   `88b.  8   888oooo8     888  888            `"Y8888o.  
888          888      888  8     `88b.8   888    "     888  888     ooooo      `"Y88b 
`88b    ooo  `88b    d88'  8       `888   888          888  `88.    .88'  oo     .d8P 
 `Y8bood8P'   `Y8bood8P'  o8o        `8  o888o        o888o  `Y8bood8P'   8""88888P'  
*/

#define MAX_SALAS            100
#define DIALOG_SALA_CONFIG   5000
#define DIALOG_SALA_EDIT     5100
#define DIALOG_LISTA_SALAS   5200
#define DIALOG_ENTRAR_SENHA  5300
#define DIALOG_VIRTUAL_WORLD 5400

// {#} Posição pradrão ao sair da sala (substiua)
#define SPAWN_PADRAO_X   1958.3783
#define SPAWN_PADRAO_Y   1343.1572
#define SPAWN_PADRAO_Z   15.3746

enum eSala
{
    bool:usada,
    Criador[MAX_PLAYER_NAME],
    MaxPlayers,
    ArmaID,
    Senha[32],
    Float:PosX,
    Float:PosY,
    Float:PosZ,
    Float:Angulo,
    World,
    QntPlayers,
    bool:Colete // Alterado para boolean
}
new Sala[MAX_SALAS][eSala];

new SalaAtual[MAX_PLAYERS] = {-1, ...};

enum eSalaTemp
{
    bool:Configurando,
    MaxPlayers,
    ArmaID,
    Senha[32],
    Float:PosX,
    Float:PosY,
    Float:PosZ,
    Float:Angulo,
    World,
    bool:Colete // Alterado para boolean
}
new SalaConfig[MAX_PLAYERS][eSalaTemp];

main(){}

/*
  .oooooo.         .o.       ooooo        ooooo        oooooooooo.        .o.         .oooooo.   oooo    oooo  .oooooo..o 
 d8P'  `Y8b       .888.      `888'        `888'        `888'   `Y8b      .888.       d8P'  `Y8b  `888   .8P'  d8P'    `Y8 
888              .8"888.      888          888          888     888     .8"888.     888           888  d8'    Y88bo.      
888             .8' `888.     888          888          888oooo888'    .8' `888.    888           88888[       `"Y8888o.  
888            .88ooo8888.    888          888          888    `88b   .88ooo8888.   888           888`88b.         `"Y88b 
`88b    ooo   .8'     `888.   888       o  888       o  888    .88P  .8'     `888.  `88b    ooo   888  `88b.  oo     .d8P 
 `Y8bood8P'  o88o     o8888o o888ooooood8 o888ooooood8 o888bood8P'  o88o     o8888o  `Y8bood8P'  o888o  o888o 8""88888P'  
*/

public OnPlayerDisconnect(playerid, reason)
{
    new nome[MAX_PLAYER_NAME];
    GetPlayerName(playerid, nome, sizeof(nome));

    if (IsPlayerInAnySala(playerid))
    {
        new s = SalaAtual[playerid];
        if (Sala[s][QntPlayers] > 0) 
            Sala[s][QntPlayers]--;
        SalaAtual[playerid] = -1;
    }

    if (SalaConfig[playerid][Configurando])
        return CancelarConfiguracaoSala(playerid);

    for (new i = 0; i < MAX_SALAS; i++)
    {
        if (Sala[i][usada] && strfind(Sala[i][Criador], nome, true) != -1)
        {
            for (new p = 0; p < MAX_PLAYERS; p++)
            {
                if (SalaAtual[p] == i)
                {
                    ResetPlayerSala(p);
                    SetPlayerPos(p, SPAWN_PADRAO_X, SPAWN_PADRAO_Y, SPAWN_PADRAO_Z);
                    SendClientMessage(p, 0x00BFFFFF, "Salinha: A sala foi deletada pois o criador saiu do servidor.");
                    SalaAtual[p] = -1;
                }
            }

            Sala[i][usada] = false;
        }
    }

    return true;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if (dialogid == DIALOG_SALA_CONFIG)
    {
        if (!response)
        {
            CancelarConfiguracaoSala(playerid);
            return SendClientMessage(playerid,  0x00BFFFFF, "INFO: {CCCCCC}Criação de sala cancelada.");
        }

        switch (listitem)
        {
            case 0:
                ShowPlayerDialog(playerid, DIALOG_SALA_EDIT, DIALOG_STYLE_INPUT,
                    "{BD8CF2}#{FFFFFF} Definir Quantidade",
                    "{BD8CF2}-{CCCCCC} Digite o número máximo de jogadores (2–50):",
                    "Salvar", "Voltar");

            case 1:
                ShowPlayerDialog(playerid, DIALOG_SALA_EDIT + 1, DIALOG_STYLE_INPUT,
                    "{BD8CF2}#{FFFFFF} Definir Arma",
                    "{BD8CF2}-{CCCCCC} Digite o ID da arma (ex: 24 - 30 - 31):",
                    "Salvar", "Voltar");
            case 2:
                ShowPlayerDialog(playerid, DIALOG_SALA_EDIT + 2, DIALOG_STYLE_INPUT,
                    "{BD8CF2}#{FFFFFF} Definir Senha",
                    "{BD8CF2}-{CCCCCC} Digite a senha da sala:",
                    "Salvar", "Voltar");

            case 3:
            {
                GetPlayerPos(playerid, SalaConfig[playerid][PosX], SalaConfig[playerid][PosY], SalaConfig[playerid][PosZ]);
                GetPlayerFacingAngle(playerid, SalaConfig[playerid][Angulo]);
                SendClientMessage(playerid, 0x00FF7FFF, "SUCESSO: {CCCCCC}Posição de spawn atual definida.");
                ShowSalaConfigDialog(playerid);
            }

            case 4:
                ShowPlayerDialog(playerid, DIALOG_VIRTUAL_WORLD, DIALOG_STYLE_INPUT,
                    "{BD8CF2}#{FFFFFF} Definir Virtual World",
                    "{BD8CF2}-{CCCCCC} Digite o Virtual World (1000-50000):",
                    "Salvar", "Voltar");

            case 5:
            {
                // Alternar entre com colete e sem colete
                SalaConfig[playerid][Colete] = !SalaConfig[playerid][Colete];
                if (SalaConfig[playerid][Colete])
                    SendClientMessage(playerid, 0x00FF7FFF, "SUCESSO: {CCCCCC}Colete ativado (100.0).");
                else
                    SendClientMessage(playerid, 0x00FF7FFF, "SUCESSO: {CCCCCC}Colete desativado.");
                ShowSalaConfigDialog(playerid);
            }

            case 6:
                CriarSalaFinal(playerid);
        }
        return true;
    }
    if (dialogid == DIALOG_VIRTUAL_WORLD)
    {
        if (!response) 
        {
            ShowSalaConfigDialog(playerid);
            return true;
        }
        
        new world = strval(inputtext);
        if (world < 1000 || world > 50000) 
        {
            SendClientMessage(playerid, 0xFF4C4CFF, "ERRO: {CCCCCC}Virtual World inválido (1000-50000).");
            ShowPlayerDialog(playerid, DIALOG_VIRTUAL_WORLD, DIALOG_STYLE_INPUT, "{BD8CF2}#{FFFFFF} Definir Virtual World", "{BD8CF2}-{CCCCCC} Digite o Virtual World (1000-50000):", "Salvar", "Voltar");
            return true;
        }
        
        for(new i = 0; i < MAX_SALAS; i++)
        {
            if(Sala[i][usada] && Sala[i][World] == world)
            {
                SendClientMessage(playerid, 0xFF4C4CFF, "ERRO: {CCCCCC}Este Virtual World já está em uso.");
                ShowPlayerDialog(playerid, DIALOG_VIRTUAL_WORLD, DIALOG_STYLE_INPUT, "{BD8CF2}#{FFFFFF} Definir Virtual World", "{BD8CF2}-{CCCCCC} Digite o Virtual World (1000-50000):", "Salvar", "Voltar");
                return true;
            }
        }
        
        SalaConfig[playerid][World] = world;
        SendClientMessage(playerid, 0x00FF7FFF, "SUCESSO: {CCCCCC}Virtual World definido com sucesso.");
        ShowSalaConfigDialog(playerid);
        return true;
    }

    if (dialogid == DIALOG_SALA_EDIT)
    {
        if (!response) 
        {
            ShowSalaConfigDialog(playerid);
            return true;
        }
        
        new qnt = strval(inputtext);
        if (qnt < 2 || qnt > 50) 
        {
            SendClientMessage(playerid, 0xFF4C4CFF, "ERRO: {CCCCCC}Quantidade inválida (2–50).");
            ShowPlayerDialog(playerid, DIALOG_SALA_EDIT, DIALOG_STYLE_INPUT, "{BD8CF2}#{FFFFFF} Definir Quantidade", "{BD8CF2}-{CCCCCC} Digite o número máximo de jogadores (2–50):", "Salvar", "Voltar");
            return true;
        }
        
        SalaConfig[playerid][MaxPlayers] = qnt;
        SendClientMessage(playerid, 0x00FF7FFF, "SUCESSO: {CCCCCC}Quantidade de jogadores definida.");
        ShowSalaConfigDialog(playerid);
        return true;
    }

    if (dialogid == DIALOG_SALA_EDIT + 1)
    {
        if (!response) 
        {
            ShowSalaConfigDialog(playerid);
            return true;
        }

        new input[32];
        format(input, sizeof(input), "%s", inputtext);

        for (new i = 0; i < strlen(input); i++)
        {
            if (input[i] < '0' || input[i] > '9')
            {
                SendClientMessage(playerid, 0xFF4C4CFF, "ERRO: {CCCCCC}Digite apenas números para o ID da arma.");
                ShowPlayerDialog(playerid, DIALOG_SALA_EDIT + 1, DIALOG_STYLE_INPUT, "{BD8CF2}#{FFFFFF} Definir Arma", "{BD8CF2}-{CCCCCC} Digite o ID da arma (ex: 24 - 30 - 31):", "Salvar", "Voltar");
                return true;
            }
        }

        new arma = strval(input);
        if (!IsValidWeapon(arma)) 
        {
            SendClientMessage(playerid, 0xFF4C4CFF, "ERRO: {CCCCCC}ID de arma inválido.");
            ShowPlayerDialog(playerid, DIALOG_SALA_EDIT + 1, DIALOG_STYLE_INPUT, "{BD8CF2}#{FFFFFF} Definir Arma", "{BD8CF2}-{CCCCCC} Digite o ID da arma:", "Salvar", "Voltar");
            return true;
        }

        SalaConfig[playerid][ArmaID] = arma;
        SendClientMessage(playerid, 0x00FF7FFF, "SUCESSO: {CCCCCC}Arma definida com sucesso.");
        ShowSalaConfigDialog(playerid);
        return true;
    }

    if (dialogid == DIALOG_SALA_EDIT + 2)
    {
        if (!response) 
        {
            ShowSalaConfigDialog(playerid);
            return true;
        }
        
        if (strlen(inputtext) < 1 || strlen(inputtext) > 31)
        {
            SendClientMessage(playerid, 0xFF4C4CFF, "ERRO: {CCCCCC}Senha deve ter entre 1 e 31 caracteres.");
            ShowPlayerDialog(playerid, DIALOG_SALA_EDIT + 2, DIALOG_STYLE_INPUT, "{BD8CF2}#{FFFFFF} Definir Senha", "{BD8CF2}-{CCCCCC} Digite a senha da sala:", "Salvar", "Voltar");
            return true;
        }
            
        format(SalaConfig[playerid][Senha], 32, "%s", inputtext);
        SendClientMessage(playerid, 0x00FF7FFF, "SUCESSO: {CCCCCC}Senha definida com sucesso.");
        ShowSalaConfigDialog(playerid);
        return true;
    }

    if (dialogid == DIALOG_LISTA_SALAS)
    {
        if (!response) return true;
        if (listitem < 0 || listitem >= MAX_SALAS) return true;
        if (!Sala[listitem][usada]) return SendClientMessage(playerid, 0xFF4C4CFF, "ERRO: {CCCCCC}Sala nao existe mais.");
        
        if (IsPlayerInAnySala(playerid))
            return SendClientMessage(playerid,0xFF4C4CFF, "ERRO: {CCCCCC}Saia da sala atual antes de entrar em outra.");
            
        SetPVarInt(playerid, "SalaSelecionada", listitem);
        ShowPlayerDialog(playerid, DIALOG_ENTRAR_SENHA, DIALOG_STYLE_INPUT, "{BD8CF2}#{FFFFFF} Entrar na Sala:", "{BD8CF2}-{CCCCCC} Digite a senha da sala:", "Entrar", "Cancelar");
        return true;
    }

    if (dialogid == DIALOG_ENTRAR_SENHA)
    {
        if (!response) 
        {
            DeletePVar(playerid, "SalaSelecionada");
            return true;
        }
        
        new s = GetPVarInt(playerid, "SalaSelecionada");
        DeletePVar(playerid, "SalaSelecionada");
        
        if (!Sala[s][usada])
            return SendClientMessage(playerid, 0xFF4C4CFF, "ERRO: {CCCCCC}Sala inexistente.");

        if (strcmp(inputtext, Sala[s][Senha], false) != 0)
            return SendClientMessage(playerid, 0xFF4C4CFF, "ERRO: {CCCCCC}Senha incorreta.");

        if (Sala[s][QntPlayers] >= Sala[s][MaxPlayers])
            return SendClientMessage(playerid, 0xFF4C4CFF, "ERRO: {CCCCCC}Sala cheia.");

        Sala[s][QntPlayers]++;
        SalaAtual[playerid] = s;

        SetPlayerVirtualWorld(playerid, Sala[s][World]);
        SetPlayerInterior(playerid, 0);
        SetPlayerPos(playerid, Sala[s][PosX], Sala[s][PosY], Sala[s][PosZ]);
        SetPlayerFacingAngle(playerid, Sala[s][Angulo]);
        SetCameraBehindPlayer(playerid);
        
        ResetPlayerWeapons(playerid);
        GivePlayerWeapon(playerid, Sala[s][ArmaID], 999);
        SetPlayerHealth(playerid, 100.0);
        
        // Aplicar colete apenas se estiver ativado
        if (Sala[s][Colete])
            SetPlayerArmour(playerid, 100.0);
        else
            SetPlayerArmour(playerid, 0.0);

        new msg[128];
        format(msg, sizeof(msg), "Salinha: Você entrou na sala criada por %s. Jogadores: %d/%d", Sala[s][Criador], Sala[s][QntPlayers], Sala[s][MaxPlayers]);
        SendClientMessage(playerid, 0x00BFFFFF, msg);
        return true;
    }

    return false;
}

public OnPlayerSpawn(playerid)
{
    if (IsPlayerInAnySala(playerid)) {
        RespawnNaSala(playerid);
    }
    return true;
}

/*
oooooooooooo ooooo     ooo ooooo      ooo   .oooooo.     .oooooo.   oooooooooooo  .oooooo..o 
`888'     `8 `888'     `8' `888b.     `8'  d8P'  `Y8b   d8P'  `Y8b  `888'     `8 d8P'    `Y8 
 888          888       8   8 `88b.    8  888          888      888  888         Y88bo.      
 888oooo8     888       8   8   `88b.  8  888          888      888  888oooo8     `"Y8888o.  
 888    "     888       8   8     `88b.8  888          888      888  888    "         `"Y88b 
 888          `88.    .8'   8       `888  `88b    ooo  `88b    d88'  888       o oo     .d8P 
o888o           `YbodP'    o8o        `8   `Y8bood8P'   `Y8bood8P'  o888ooooood8 8""88888P'  
*/

stock IsValidWeapon(weaponid)
    return (weaponid >= 0 && weaponid <= 46 && weaponid != 19 && weaponid != 20 && weaponid != 21);

stock GetNextAvailableVirtualWorld()
{
    static currentWorld = 1000;
    return currentWorld++;
}

stock ResetPlayerSala(playerid)
{
    SalaAtual[playerid] = -1;
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerInterior(playerid, 0);
    ResetPlayerWeapons(playerid);
}

stock IsPlayerInAnySala(playerid)
    return (SalaAtual[playerid] != -1);

stock CancelarConfiguracaoSala(playerid)
{
    SalaConfig[playerid][Configurando] = false;
    SalaConfig[playerid][MaxPlayers] = 0;
    SalaConfig[playerid][ArmaID] = 0;
    SalaConfig[playerid][Senha][0] = EOS;
    SalaConfig[playerid][PosX] = 0.0;
    SalaConfig[playerid][PosY] = 0.0;
    SalaConfig[playerid][PosZ] = 0.0;
    SalaConfig[playerid][Angulo] = 0.0;
    SalaConfig[playerid][World] = 0;
    SalaConfig[playerid][Colete] = false; // Reset para falso
    return true;
}

stock ShowSalaConfigDialog(playerid)
{
    if (!SalaConfig[playerid][Configurando]) return false;
    
    new dialog[500], nomearma[64], senha[32], spawn[64], worldtxt[32], qnttxt[32], colete_txt[32];
    
    if (SalaConfig[playerid][ArmaID] > 0 && SalaConfig[playerid][ArmaID] <= 46)
        GetWeaponName(SalaConfig[playerid][ArmaID], nomearma, sizeof(nomearma));
    else
        format(nomearma, sizeof(nomearma), "{FF4C4C}Não definida");

    if (strlen(SalaConfig[playerid][Senha]) > 0)
        format(senha, sizeof(senha), "%s", SalaConfig[playerid][Senha]);
    else
        format(senha, sizeof(senha), "{FF4C4C}Não definida");

    if (SalaConfig[playerid][PosX] == 0.0 && SalaConfig[playerid][PosY] == 0.0 && SalaConfig[playerid][PosZ] == 0.0)
        format(spawn, sizeof(spawn), "{FF4C4C}Não definido");
    else
        format(spawn, sizeof(spawn), "%.2f, %.2f, %.2f, %.2f",
            SalaConfig[playerid][PosX], SalaConfig[playerid][PosY], 
            SalaConfig[playerid][PosZ], SalaConfig[playerid][Angulo]);

    if (SalaConfig[playerid][World] == 0)
        format(worldtxt, sizeof(worldtxt), "{FF4C4C}Não definido");
    else
        format(worldtxt, sizeof(worldtxt), "%d", SalaConfig[playerid][World]);

    if (SalaConfig[playerid][MaxPlayers] < 2)
        format(qnttxt, sizeof(qnttxt), "{FF4C4C}Não definido");
    else
        format(qnttxt, sizeof(qnttxt), "%d", SalaConfig[playerid][MaxPlayers]);

    // Texto para colete (sim/não)
    if (SalaConfig[playerid][Colete])
        format(colete_txt, sizeof(colete_txt), "{28C76F}Sim (100.0)");
    else
        format(colete_txt, sizeof(colete_txt), "{FF4C4C}Não");

    format(dialog, sizeof(dialog),
        "{FFFFFF}Quantidade de Jogadores:\t{28C76F}%s\n\
        {FFFFFF}Arma:\t\t\t{28C76F}%s\n\
        {FFFFFF}Senha da Sala:\t\t{28C76F}%s\n\
        {FFFFFF}Spawn:\t\t\t{28C76F}%s\n\
        {FFFFFF}Virtual World:\t\t{28C76F}%s\n\
        {FFFFFF}Colete:\t\t\t%s\n\n\
        {28C76F}CRIAR SALA",
    qnttxt, nomearma, senha, spawn, worldtxt, colete_txt);

    ShowPlayerDialog(playerid, DIALOG_SALA_CONFIG, DIALOG_STYLE_TABLIST, "{BD8CF2}#{FFFFFF} Configuração da Sala", dialog, "Selecionar", "Cancelar");
    return true;
}

stock CriarSalaFinal(playerid)
{
    if (!SalaConfig[playerid][Configurando])
    {
        SendClientMessage(playerid, 0xFF4C4CFF, "ERRO: {CCCCCC}Configuração de sala nao encontrada.");
        return false;
    }

    if (SalaConfig[playerid][MaxPlayers] < 2 ||
        !IsValidWeapon(SalaConfig[playerid][ArmaID]) ||
        strlen(SalaConfig[playerid][Senha]) < 1 ||
        (SalaConfig[playerid][PosX] == 0.0 && SalaConfig[playerid][PosY] == 0.0 && SalaConfig[playerid][PosZ] == 0.0) ||
        SalaConfig[playerid][World] == 0)
    {
        SendClientMessage(playerid, 0xFF4C4CFF, "ERRO: {CCCCCC}Preencha todos os campos da sala antes de criar.");
        ShowSalaConfigDialog(playerid);
        return false;
    }

    new i;
    for (i = 0; i < MAX_SALAS; i++)
        if (!Sala[i][usada]) break;

    if (i == MAX_SALAS)
    {
        SendClientMessage(playerid, 0xFF4C4CFF, "ERRO: {CCCCCC}Limite de salas atingido.");
        CancelarConfiguracaoSala(playerid);
        return false;
    }

    for (new j = 0; j < MAX_SALAS; j++)
    {
        if(Sala[j][usada] && Sala[j][World] == SalaConfig[playerid][World])
        {
            SendClientMessage(playerid, 0xFF4C4CFF, "ERRO: {CCCCCC}Virtual World já está em uso. Escolha outro.");
            ShowSalaConfigDialog(playerid);
            return false;
        }
    }

    new nome[MAX_PLAYER_NAME];
    GetPlayerName(playerid, nome, sizeof(nome));

    Sala[i][usada] = true;
    format(Sala[i][Criador], MAX_PLAYER_NAME, "%s[%d]", nome, playerid);
    Sala[i][MaxPlayers] = SalaConfig[playerid][MaxPlayers];
    Sala[i][ArmaID] = SalaConfig[playerid][ArmaID];
    format(Sala[i][Senha], 32, "%s", SalaConfig[playerid][Senha]);
    Sala[i][PosX] = SalaConfig[playerid][PosX];
    Sala[i][PosY] = SalaConfig[playerid][PosY];
    Sala[i][PosZ] = SalaConfig[playerid][PosZ];
    Sala[i][Angulo] = SalaConfig[playerid][Angulo];
    Sala[i][World] = SalaConfig[playerid][World];
    Sala[i][Colete] = SalaConfig[playerid][Colete]; // Boolean - com ou sem colete
    Sala[i][QntPlayers] = 1;

    SalaAtual[playerid] = i;

    SetPlayerVirtualWorld(playerid, Sala[i][World]);
    SetPlayerInterior(playerid, 0);
    SetPlayerPos(playerid, Sala[i][PosX], Sala[i][PosY], Sala[i][PosZ]);
    SetPlayerFacingAngle(playerid, Sala[i][Angulo]);
    SetCameraBehindPlayer(playerid);

    ResetPlayerWeapons(playerid);
    GivePlayerWeapon(playerid, Sala[i][ArmaID], 999);
    SetPlayerHealth(playerid, 100.0);
    
    // Aplicar colete apenas se estiver ativado
    if (Sala[i][Colete])
        SetPlayerArmour(playerid, 100.0);
    else
        SetPlayerArmour(playerid, 0.0);

    new msg[200], nomearma[32];
    GetWeaponName(Sala[i][ArmaID], nomearma, sizeof(nomearma));
    format(msg, sizeof(msg), "Salinha: Sala criada com sucesso! ID: {CCCCCC}%02d{00BFFF} | Jogadores: {CCCCCC}%02d/%02d{00BFFF} | Arma: {CCCCCC}%s{00BFFF} | Senha: {CCCCCC}%s{00BFFF} | Colete: {CCCCCC}%s", 
        i, Sala[i][QntPlayers], Sala[i][MaxPlayers], nomearma, Sala[i][Senha], (Sala[i][Colete] ? "Sim" : "Não"));
    SendClientMessage(playerid, 0x00BFFFFF, msg);

    CancelarConfiguracaoSala(playerid);
    return true;
}


stock RespawnNaSala(playerid)
{
    if (IsPlayerInAnySala(playerid))
    {
        new s = SalaAtual[playerid];
        if (Sala[s][usada])
        {
            SetPlayerVirtualWorld(playerid, Sala[s][World]);
            SetPlayerInterior(playerid, 0);
            SetPlayerPos(playerid, Sala[s][PosX], Sala[s][PosY], Sala[s][PosZ]);
            SetPlayerFacingAngle(playerid, Sala[s][Angulo]);
            SetCameraBehindPlayer(playerid);
            
            ResetPlayerWeapons(playerid);
            GivePlayerWeapon(playerid, Sala[s][ArmaID], 999);
            SetPlayerHealth(playerid, 100.0);
            
            // Aplicar colete apenas se estiver ativado
            if (Sala[s][Colete])
                SetPlayerArmour(playerid, 100.0);
            else
                SetPlayerArmour(playerid, 0.0);
            
            SendClientMessage(playerid, 0x00BFFFFF, "Salinha: Você respawnou na sala.");
        }
    }
    return true;
}

/*
  .oooooo.     .oooooo.   ooo        ooooo       .o.       ooooo      ooo oooooooooo.     .oooooo.    .oooooo..o 
 d8P'  `Y8b   d8P'  `Y8b  `88.       .888'      .888.      `888b.     `8' `888'   `Y8b   d8P'  `Y8b  d8P'    `Y8 
888          888      888  888b     d'888      .8"888.      8 `88b.    8   888      888 888      888 Y88bo.      
888          888      888  8 Y88. .P  888     .8' `888.     8   `88b.  8   888      888 888      888  `"Y8888o.  
888          888      888  8  `888'   888    .88ooo8888.    8     `88b.8   888      888 888      888      `"Y88b 
`88b    ooo  `88b    d88'  8    Y     888   .8'     `888.   8       `888   888     d88' `88b    d88' oo     .d8P 
 `Y8bood8P'   `Y8bood8P'  o8o        o888o o88o     o8888o o8o        `8  o888bood8P'    `Y8bood8P'  8""88888P'  
*/

COMMAND:criarsala(playerid, params[])
{
    if (SalaConfig[playerid][Configurando])
    {
        ShowSalaConfigDialog(playerid);
        SendClientMessage(playerid, 0xFF4C4CFF, "ERRO: {CCCCCC}Você já está configurando uma sala. Use 'Cancelar' para sair.");
    }

    if (IsPlayerInAnySala(playerid))
        return SendClientMessage(playerid, 0xFF4C4CFF, "ERRO: {CCCCCC}Saia da sala atual antes de criar uma nova.");

    CancelarConfiguracaoSala(playerid);

    SalaConfig[playerid][Configurando] = true;

    ShowSalaConfigDialog(playerid);
    return true;
}

COMMAND:sairsala(playerid, params[])
{
    if (!IsPlayerInAnySala(playerid)) 
        return SendClientMessage(playerid, 0xFF4C4CFF, "ERRO: {CCCCCC}Você não está em nenhuma sala.");

    new s = SalaAtual[playerid];
    new nome[MAX_PLAYER_NAME];
    GetPlayerName(playerid, nome, sizeof(nome));
    
    new bool:ehCriador = (strfind(Sala[s][Criador], nome, true) != -1);

    if (ehCriador)
        return SendClientMessage(playerid, 0xFF4C4CFF, "ERRO: {CCCCCC}Você é o criador da sala e não pode sair. Use /deletarsala para removê-la.");
    
    SalaAtual[playerid] = -1;
    if (Sala[s][QntPlayers] > 0) 
        Sala[s][QntPlayers]--;

    ResetPlayerSala(playerid);
    SetPlayerPos(playerid, SPAWN_PADRAO_X, SPAWN_PADRAO_Y, SPAWN_PADRAO_Z);
    SetCameraBehindPlayer(playerid);

    SendClientMessage(playerid, 0x00BFFFFF, "INFO: {CCCCCC}Você saiu da sala.");

    new msg[128];
    format(msg, sizeof(msg), "Salinha: %s saiu da sala. Jogadores: %02d/%02d", nome, Sala[s][QntPlayers], Sala[s][MaxPlayers]);
    
    for (new p = 0; p < MAX_PLAYERS; p++)
    {
        if (IsPlayerConnected(p) && p != playerid && SalaAtual[p] == s)
        {
            SendClientMessage(p, 0x00BFFFFF, msg);
        }
    }

    return true;
}

COMMAND:salas(playerid, params[])
{
    new dialog[1024], linha[128], arma[32];
    format(dialog, sizeof(dialog), "{CCCCCC}ID\t{CCCCCC}Criador\t{CCCCCC}Jogadores\t{CCCCCC}Arma\t{CCCCCC}Colete\n");

    new count = 0;
    for (new i = 0; i < MAX_SALAS; i++)
    {
        if (!Sala[i][usada]) continue;
        
        GetWeaponName(Sala[i][ArmaID], arma, sizeof(arma));
        format(linha, sizeof(linha), "{FFFFFF}%d\t{BD8CF2}%s\t{FFFFFF}%02d/%02d\t{FFFFFF}%s[%d]\t{FFFFFF}%s\n", 
            i, Sala[i][Criador], Sala[i][QntPlayers], Sala[i][MaxPlayers], arma, Sala[i][ArmaID], 
            (Sala[i][Colete] ? "Sim" : "Não"));
        strcat(dialog, linha);
        count++;
    }

    if (count == 0)
        return SendClientMessage(playerid, 0xFF4C4CFF, "ERRO: {CCCCCC}Nenhuma sala disponível no momento.");

    ShowPlayerDialog(playerid, DIALOG_LISTA_SALAS, DIALOG_STYLE_TABLIST_HEADERS, "{BD8CF2}#{FFFFFF} Salas Disponiveis:", dialog, "Entrar", "Fechar");
    return true;
}

COMMAND:deletarsala(playerid, params[])
{
    new nome[MAX_PLAYER_NAME];
    GetPlayerName(playerid, nome, sizeof(nome));
    
    new s = -1;
    
    for (new i = 0; i < MAX_SALAS; i++)
    {
        if (Sala[i][usada] && strfind(Sala[i][Criador], nome, true) != -1)
        {
            s = i;
            break;
        }
    }
    
    if (s == -1) 
        return SendClientMessage(playerid, 0xFF4C4CFF, "ERRO: {CCCCCC}Você nao é criador de nenhuma sala ativa.");
    
    for (new p = 0; p < MAX_PLAYERS; p++)
    {
        if (SalaAtual[p] == s)
        {
            ResetPlayerSala(p);
            SetPlayerPos(p, SPAWN_PADRAO_X, SPAWN_PADRAO_Y, SPAWN_PADRAO_Z);
            SendClientMessage(p, 0x00BFFFFF, "INFO: {CCCCCC}A sala foi deletada pelo criador.");
            SalaAtual[p] = -1;
        }
    }

    Sala[s][usada] = false;
    SendClientMessage(playerid, 0x00FF7FFF, "SUCESSO: {CCCCCC}Sala deletada com exito.");
    return true;
}