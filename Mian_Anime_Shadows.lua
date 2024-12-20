repeat task.wait() until game.Players.LocalPlayer
getgenv().Version = 1.1
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dukdik234/SaveUi/refs/heads/main/Save_Ui.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dukdik234/SaveUi/refs/heads/main/Interface.lua"))()
local Window = Fluent:CreateWindow({
    Title = "Xsalary " .. " " .. tonumber(getgenv().Version),
    SubTitle = "By Oxegen",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Amethyst",
    MinimizeKey = Enum.KeyCode.LeftControl 
})




local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "swords" }),
    Eggs = Window:AddTab({ Title = "Eggs", Icon = "egg" }),
    Games_Mode = Window:AddTab({ Title = "Games Mode", Icon = "gamepad-2" }),

    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}



if not getgenv().Setting then
    getgenv().Setting = {
        Enemy_Select = "",
        Auto_Farm = false,
        Autoclick = false,
        Tp_Mons = false,
        Tp_Char = false,
        Already_Tp = {},
        Collect_Drop = false,
        CurrentTarget = nil,
        Instance_farm = false,
        Is_instance_1 = false,
        Egg_Select = "",
        Openeggs = false,
        select_eggemtohd= "",
        Hide_opengui = false,
        Tp_Toeggs = false,
        Eggcount = 7500,
        useshinypotion = false,
        stopatpity = false,
        stop_method = "",
        Enemykill_Methods = "",
        Leave_Method = "",
        Auto_dungeon = false,
        join_dungeon = false,
        leave_dungeon = false,
        leave_value = 10,
        Enemykill_Trail = "",
        Leave_Method2 = "",
        Auto_trail = false,
        join_trails = false,
        leave_trail = false,
        leave_value2 = 10,
    }
end
local Options = Fluent.Options
local GameMode_Settings
local Eggpity_Show


local EnemiesList = {}
local Eggs_List = {}
local Plys = game:GetService("Players")
local Local_Ply = Plys.LocalPlayer
local Gui = Local_Ply:WaitForChild("PlayerGui")
local Char = Local_Ply.Character
local Work = game:GetService("Workspace")
local Rep = game:GetService("ReplicatedStorage")
local hasPerformedAction = false
local Mythical_Text = "Mythical Pity: N/A"
local LastPosition
local Last_Map
local Set_Position
local Set_Maps
local Get_AlreadyMap = function()
    local Maps = (Work.Client.Maps):GetChildren()[1]
    return Maps
end

task.spawn(function()
    for _, Map in pairs(Rep.Shared.Stars:GetChildren()) do
        if Map then
            table.insert(Eggs_List, Map.Name)
        end
    end
end)

function Noclip(character,bool)
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = bool
        end
    end
end

function createSupportPart(position, size)
    local existingPart = Work:FindFirstChild("Instance_Part")
    if existingPart then
        existingPart.CFrame = position
        return existingPart
    end
    local part = Instance.new("Part")
    part.Size = size or Vector3.new(5, 1, 5) 
    part.CFrame = position
    part.Anchored = true 
    part.CanCollide = true
    part.Name = "Instance_Part"
    part.Parent = Work
    return part
end
function Tp(Target)

    local supportPart = createSupportPart(Target * CFrame.new(0,5,0))
    Noclip(Char,true)
    local humanoidRootPart = Char:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        humanoidRootPart.CFrame = supportPart.CFrame + Vector3.new(0, 3, 0)
    end
end

function GetPosition()
    local HumanoidRootPart = Char:FindFirstChild("HumanoidRootPart")
    if not HumanoidRootPart then
        warn("HumanoidRootPart not found")
        return nil
    end
    return HumanoidRootPart.CFrame
end

function refresh_Enemylist()
    table.clear(EnemiesList)
    task.spawn(function()
        for _, Enm in pairs(Work:WaitForChild("Server"):WaitForChild("Enemies"):WaitForChild(tostring(Get_AlreadyMap())):GetChildren()) do
            if Enm:IsA("Part") and not table.find(EnemiesList, Enm.Name) then
                table.insert(EnemiesList, Enm.Name)
            end
        end
    end)
end
refresh_Enemylist()
do
    Tabs.Main:AddParagraph({
        Title = "MainFarm",
        Content = "This is a FarmTabs"
    })
    local Dropdown = Tabs.Main:AddDropdown("Enemy_Dropdown", {
        Title = "Select Enemys",
        Values = EnemiesList,
        Multi = false,
        Default = "",
    })
    Dropdown:SetValue(EnemiesList[1] or "")

    Dropdown:OnChanged(function(Value)
        getgenv().Setting.Enemy_Select = Options.Enemy_Dropdown.Value
        getgenv().Setting.CurrentTarget = nil
        table.clear(getgenv().Setting.Already_Tp)

    end)
    Tabs.Main:AddButton({
        Title = "Refesh EnemyList",
        Description = "Click to refrsh enemy list",
        Callback = function()
            refresh_Enemylist()
            Dropdown:SetValues(EnemiesList)
            Dropdown:SetValue(EnemiesList[1] or "")
            getgenv().Setting.CurrentTarget = nil
            table.clear(getgenv().Setting.Already_Tp)
        end
    })

    local Dropdown_Farm_Methods = Tabs.Main:AddDropdown("Enemy_Farm_Method", {
        Title = "Select Farm Method",
        Values = {"Walk","Teleport"},
        Multi = false,
        Default = "Walk",
    })


    Dropdown_Farm_Methods:OnChanged(function(Value)
        if Options.Enemy_Farm_Method.Value == "Teleport" then
            getgenv().Setting.Tp_Mons = true
        else
            getgenv().Setting.Tp_Mons = false
        end
    end)
    local Dropdown_Character_Methods = Tabs.Main:AddDropdown("Character_Methods", {
        Title = "Select Character Method",
        Values = {"Don't Moves","Teleport"},
        Multi = false,
        Default = "Don Moves",
    })


    Dropdown_Character_Methods:OnChanged(function(Value)
        if Options.Character_Methods.Value == "Teleport" then
            getgenv().Setting.Tp_Char = true
        else
            getgenv().Setting.Tp_Char = false
        end
    end)
    local Toggle = Tabs.Main:AddToggle("Farm", {Title = "Strat Farm", Default = false })
    local Click = false
    Toggle:OnChanged(function()
        getgenv().Setting.Auto_Farm = Options.Farm.Value
        if Options.Farm.Value and not Click then
            Click= true
        else

            local args = {"General","Pets","Retreat"}
            Rep:WaitForChild("Remotes"):WaitForChild("Bridge"):FireServer(unpack(args))
            getgenv().Setting.Is_instance_1 = false
            Noclip(Char,false)
            Click=false

        end
    end)
    Tabs.Main:AddParagraph({
        Title = "Misc Farm",
        Content = "This is a FarmSetting.\n Instance Farm Require A Enemy Metohd Teleport",
    })
    local Instance_Farm = Tabs.Main:AddToggle("Instancefarm", {Title = "Instance Farm (Game Fix!)", Default = false })
    Instance_Farm:OnChanged(function()
        getgenv().Setting.Instance_farm = Options.Instancefarm.Value
    end)
    local AutoClikc_Toggle = Tabs.Main:AddToggle("Click", {Title = "Fast AutoClick", Default = false })
    AutoClikc_Toggle:OnChanged(function()
        getgenv().Setting.Autoclick = Options.Click.Value
    end)
    local Collectdrop_Toggle = Tabs.Main:AddToggle("Collec", {Title = "CollectAllDrop", Default = false })
    Collectdrop_Toggle:OnChanged(function()
        getgenv().Setting.Collect_Drop = Options.Collec.Value
    end)

    Tabs.Eggs:AddParagraph({
        Title = "Eggs",
        Content = "This Tabs is Eggs"
    })
    local Eggpity_Show = Tabs.Eggs:AddParagraph({
        Title = "Egg Pity".." ".. tostring(Gui.UI.HUD.Gacha.Pity.Frame.Amount.Text),
        Content = ""
    })
    task.spawn(function()
        while wait() do
            if Eggpity_Show then
                Eggpity_Show:SetTitle("Egg Pity :".." ".. tostring(Gui.UI.HUD.Gacha.Pity.Frame.Amount.Text))
            end
        end
    end)
    local Dropdown_Eggs = Tabs.Eggs:AddDropdown("Egg_Select", {
        Title = "Select Eggs",
        Values = Eggs_List,
        Multi = false,
        Default = "",
    })


    Dropdown_Eggs:OnChanged(function(Value)
        getgenv().Setting.Egg_Select = Options.Egg_Select.Value
    end)
    local Eggs_method = Tabs.Eggs:AddDropdown("eggmethod", {
        Title = "Select Eggs Methods",
        Values = {"Single","Multi"},
        Multi = false,
        Default = "Single",
    })

    
    Eggs_method:OnChanged(function(Value)
        if Options.eggmethod.Value == "Single" then
            getgenv().Setting.select_eggemtohd = "Open"
        else
            getgenv().Setting.select_eggemtohd = Options.eggmethod.Value
        end
    end)
    local Open_Egg = Tabs.Eggs:AddToggle("Openegg", {Title = "Open Eggs", Default = false })
    Open_Egg:OnChanged(function()
        getgenv().Setting.Openeggs = Options.Openegg.Value
    end)
    local Hide_egganim = Tabs.Eggs:AddToggle("hideegg", {Title = "Hie Open Eggs Gui", Default = false })
    Hide_egganim:OnChanged(function()
        getgenv().Setting.Hide_opengui = Options.hideegg.Value
    end)
    local tptoegg = Tabs.Eggs:AddToggle("tpegg", {Title = "Teleport To Eggs", Default = false })
    tptoegg:OnChanged(function()
        getgenv().Setting.Tp_Toeggs = Options.tpegg.Value
    end)
    Tabs.Eggs:AddParagraph({
        Title = "Eggs Misc",
        Content = "This Tabs is Eggs Misc"

    })
    local Input = Tabs.Eggs:AddInput("Input", {
        Title = "Input Your Count",
        Default = 7500,
        Placeholder = "Input Your Count Here",
        Numeric = true, 
        Finished = false, 

    })

    Input:OnChanged(function()
        getgenv().Setting.Eggcount = Input.Value
    end)
    local useshinypo = Tabs.Eggs:AddToggle("shinyp", {Title = "Auto Use ShinyPotion", Default = false })
    useshinypo:OnChanged(function()
        getgenv().Setting.useshinypotion = Options.shinyp.Value
    end)
    local stopmethod = Tabs.Eggs:AddDropdown("stopmethod", {
        Title = "Select Stop Methods",
        Values = {"NorMally Stop","Stop then go Openticket"},
        Multi = false,
        Default = "NorMally Stop",
    })

    
    stopmethod:OnChanged(function(Value)
        getgenv().Setting.stop_method = Options.stopmethod.Value 
    end)
    local stopatpity = Tabs.Eggs:AddToggle("stoppity", {Title = "Stop At Pity", Default = false })
    stopatpity:OnChanged(function()
        getgenv().Setting.stopatpity = Options.stoppity.Value
    end)

    GameMode_Settings = Tabs.Games_Mode:AddParagraph({
        Title = "Games Modes Setting",
        Content = "Game Modes Settings.\n".."Map Is Your Set : ".." "..tostring(Set_Maps) or ""
    })
    
    local leavemethod2 = Tabs.Games_Mode:AddDropdown("leave_method2", {
        Title = "Select Leave Methods",
        Values = {"Last Postion","Set Position"},
        Multi = false,
        Default = "Last Postion",
    })

    
    leavemethod2:OnChanged(function(Value)
        getgenv().Setting.Leave_Method = Options.leave_method2.Value 
    end)
    Tabs.Games_Mode:AddButton({
        Title = "Set Position",
        Description = "Set to Your Position",
        Callback = function()
            Set_Position = GetPosition()
            Set_Maps = Get_AlreadyMap()
            GameMode_Settings:SetDesc("Game Modes Settings.\n".."Map Is Your Set : ".." "..tostring(Set_Maps) or "")
            Fluent:Notify({
                Title = "Xasalary",
                Content = "The Possition Is Sets!",
                Duration = 8
            })
            print(Set_Position,Set_Maps)
        end
    })
   
    Tabs.Games_Mode:AddParagraph({
        Title = "Dungeons",
        Content = "This Tabs is Dungeons Mode tabs"
    })
   
    
    local input_dungeon = Tabs.Games_Mode:AddInput("input_leave", {
        Title = "Input Your Leave Count",
        Default = 10,
        Placeholder = "Input Your Count Here",
        Numeric = true, 
        Finished = false, 

    })
    local dungeonmethod = Tabs.Games_Mode:AddDropdown("dungeon_method", {
        Title = "Select Enemy Dungeon Methods",
        Values = {"High to low","low to High"},
        Multi = false,
        Default = "low to High",
    })

    
    dungeonmethod:OnChanged(function(Value)
        getgenv().Setting.Enemykill_Methods = Options.dungeon_method.Value 
    end)
    input_dungeon:OnChanged(function()
        getgenv().Setting.leave_value = Options.input_leave.Value
    end)
    local autodungeon = Tabs.Games_Mode:AddToggle("autodungeons", {Title = "Auto Dungeon", Default = false })
    autodungeon:OnChanged(function()
        getgenv().Setting.Auto_dungeon = Options.autodungeons.Value
    end)
    local joindungeon = Tabs.Games_Mode:AddToggle("joindungeons", {Title = "Auto Join Dungeon", Default = false })
    joindungeon:OnChanged(function()
        getgenv().Setting.join_dungeon = Options.joindungeons.Value
    end)
    local leavedungeon = Tabs.Games_Mode:AddToggle("leavedungeons", {Title = "Auto Leave Dungeon", Default = false })
    leavedungeon:OnChanged(function()
        getgenv().Setting.leave_dungeon = Options.leavedungeons.Value
    end)

    Tabs.Games_Mode:AddParagraph({
        Title = "Trail",
        Content = "This Tabs is Trail Mode tabs"
    })
    local trailmethod = Tabs.Games_Mode:AddDropdown("trail_method", {
        Title = "Select Enemy Trail Methods",
        Values = {"High to low","low to High"},
        Multi = false,
        Default = "low to High",
    })

    
    trailmethod:OnChanged(function(Value)
        getgenv().Setting.Enemykill_Trail = Options.trail_method.Value 
    end)
   
    local input_trail = Tabs.Games_Mode:AddInput("input_leave2", {
        Title = "Input Your Leave Count",
        Default = 10,
        Placeholder = "Input Your Count Here",
        Numeric = true, 
        Finished = false, 

    })

    input_trail:OnChanged(function()
        getgenv().Setting.leave_value2 = Options.input_leave2.Value
    end)
    local autotrail = Tabs.Games_Mode:AddToggle("autodtrail", {Title = "Auto Trail", Default = false })
    autotrail:OnChanged(function()
        getgenv().Setting.Auto_trail = Options.autodtrail.Value
    end)
    local jointrail = Tabs.Games_Mode:AddToggle("jointrails", {Title = "Auto Join Trail", Default = false })
    jointrail:OnChanged(function()
        getgenv().Setting.join_trails = Options.jointrails.Value
    end)
    local leavetrail= Tabs.Games_Mode:AddToggle("leavetrails", {Title = "Auto Leave Dungeon", Default = false })
    leavetrail:OnChanged(function()
        getgenv().Setting.leave_trail = Options.leavetrails.Value
    end)
end
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)


SaveManager:IgnoreThemeSettings()


SaveManager:SetIgnoreIndexes({})


InterfaceManager:SetFolder("Xasalary")
SaveManager:SetFolder("Xasalary/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Fluent:Notify({
    Title = "Xasalary",
    Content = "The script has been loaded.",
    Duration = 8
})





local Get_Closest_Enemy = function(Map, EnemyName)
    local ClosestEnemies = {}
    local ClosestDistance = math.huge
    --local Checkenm = {}
    --table.clear(Checkenm)
    if not Char or not Char:FindFirstChild("HumanoidRootPart") then
        return nil
    end

    local PlayerPosition = Char.HumanoidRootPart.Position
    local EnemiesFolder = Work:WaitForChild("Server"):WaitForChild("Enemies"):WaitForChild(tostring(Map))

    for _, Enm in pairs(EnemiesFolder:GetChildren()) do
        if Enm:IsA("Part") and (not EnemyName or Enm.Name == EnemyName) then
            local EnemyPosition = Enm.Position
            local Current_Health = Enm:GetAttribute("Health") or 0
            
            if EnemyPosition then
                local Distance = (PlayerPosition - EnemyPosition).Magnitude
                
       

                local isCloseEnough = Distance < 250

                if isCloseEnough then
                    table.insert(ClosestEnemies, {
                        Enemy = Enm,
                        Distance = Distance
                    })
                end
            end
        end
    end

    table.sort(ClosestEnemies, function(a, b) 
        return a.Distance < b.Distance 
    end)

    if #ClosestEnemies > 0 then
        for i = 1, #ClosestEnemies do
            local SelectedEnemy = ClosestEnemies[i].Enemy
            local Health = ClosestEnemies[i].Enemy:GetAttribute("Health")
            if Health > 0 then
                return SelectedEnemy
            else
                continue
            end
        end
    end

    return nil
end



          
task.spawn(function()
    while wait() do
        if  getgenv().Setting.Auto_Farm and getgenv().Setting.Instance_farm and not getgenv().Setting.Is_instance_1 then 
            getgenv().Setting.Is_instance_1 = true
            local Original_Enemy_Select = getgenv().Setting.Enemy_Select
            local Original_Current_Target = getgenv().Setting.CurrentTarget

            for i=1,2 do
                for i, Enemy in pairs(EnemiesList) do
                    getgenv().Setting.Enemy_Select = Enemy
                    getgenv().Setting.CurrentTarget = nil
                    table.clear(getgenv().Setting.Already_Tp)
                    if i == #EnemiesList then
                        break
                    end
                    task.wait(.3)
                end
            end
            
            getgenv().Setting.Enemy_Select = Original_Enemy_Select
            getgenv().Setting.CurrentTarget = Original_Current_Target
            table.clear(getgenv().Setting.Already_Tp)
        end
    end
end)
task.spawn(function()
    while wait() do
        pcall(function()
            if getgenv().Setting.Auto_Farm then
                for _,v in pairs(Gui.UI.Frames.Pets.Background.Frame.List:GetChildren()) do
                    if v:IsA("Frame") and v.Equipped.Visible == true then


                       
                        if not getgenv().Setting.CurrentTarget or getgenv().Setting.CurrentTarget.Parent == nil then
                            table.clear(getgenv().Setting.Already_Tp)
                            getgenv().Setting.CurrentTarget = Get_Closest_Enemy(Get_AlreadyMap(), getgenv().Setting.Enemy_Select)
                        end
                        
                        
                        if getgenv().Setting.CurrentTarget then
                            local Current_Health = getgenv().Setting.CurrentTarget:GetAttribute("Health") or 0
                            if Current_Health <= 0 then
                                getgenv().Setting.CurrentTarget = nil
                            end
                            task.spawn(function()
                                if getgenv().Setting.Tp_Char  then
                                
                                    Tp(getgenv().Setting.CurrentTarget.CFrame)
                                    --Char:WaitForChild("HumanoidRootPart").CFrame = getgenv().Setting.CurrentTarget.CFrame
                                
                                
                                end
                                if getgenv().Setting.Tp_Mons then
                                    for _,pet in pairs(Work.Server.Pets:GetChildren()) do
                                        if pet and pet:IsA("Model") then
                                            local nameParts = string.split(pet.Name, "---")
                                            
                                            local playerName = nameParts[1]
                                            local hero = nameParts[2]
                                            if playerName == Local_Ply.Name and not getgenv().Setting.Already_Tp[hero]  then
                                                getgenv().Setting.Already_Tp[hero] = true
                                                pet:WaitForChild("HumanoidRootPart").CFrame = getgenv().Setting.CurrentTarget.CFrame
                                            end
                                        end
                                    end
                                end
                            end)
                          
                                
                            
                           
                            local args = {
                                "General",
                                "Pets",
                                "Attack",
                                tostring(v.Name),
                                getgenv().Setting.CurrentTarget,
                            }
                            Rep:WaitForChild("Remotes"):WaitForChild("Bridge"):FireServer(unpack(args))

                        end
                    end
                end       
            end
        end)
    end
end)

task.spawn(function()
    while task.wait() do
        pcall(function()
            if getgenv().Setting.Autoclick then
                local args = {"Enemies","World","Click"}
                Rep:WaitForChild("Remotes"):WaitForChild("Bridge"):FireServer(unpack(args))            
            end
        end)    
    end
end)
task.spawn(function()
    while task.wait() do
        pcall(function()
            if getgenv().Setting.Collect_Drop then
                for _,v in pairs(Work.Client.Drops:GetChildren()) do
                    if v and v:IsA("Part") then
                        v.CFrame = Local_Ply.Character:FindFirstChild("HumanoidRootPart").CFrame
                    end
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait() do
        pcall(function()
            if getgenv().Setting.Openeggs then
                local Egg_Distance = (Char:FindFirstChild("HumanoidRootPart").Position - Work.Server.Stars[getgenv().Setting.Egg_Select].Coins.Star.Position).Magnitude
               
                if Egg_Distance < 10 then
                    
                    local args = {
                        [1] = "General",
                        [2] = "Stars",
                        [3] = getgenv().Setting.select_eggemtohd,
                        [4] = getgenv().Setting.Egg_Select,
                        [5] = "Coins"
                    }
                    Rep:WaitForChild("Remotes"):WaitForChild("Bridge"):FireServer(unpack(args))
                else
                    return
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait() do
        pcall(function()
            if getgenv().Setting.Hide_opengui then
                local main = Gui:FindFirstChild("UI")
                local Eggframe = Gui:FindFirstChild("Star")
                if not Eggframe then return end
                if Eggframe.Frame.Visible then Eggframe.Frame.Visible = false end 
                if main and main.Enabled == false then
                    main.Enabled = true
                else 
                    return
                end
            end
        end)
    end
end)
task.spawn(function()
    while task.wait() do
        pcall(function()
            if getgenv().Setting.Tp_Toeggs then
                Char:FindFirstChild("HumanoidRootPart").CFrame = Work.Server.Stars[getgenv().Setting.Egg_Select].Coins.Star.CFrame
            end
        end)
    end
end)
task.spawn(function()
    while task.wait() do
        pcall(function()
            
            local pity = string.split(Gui.UI.HUD.Gacha.Pity.Frame.Amount.Text, "/")
            local Ispity = tonumber(pity[1])
            local Is_Ticket = tonumber(Gui.UI.Frames.Shop.Background.Frame.Cut.Top.Tickets.Container.Amount.Text)
           
            if not Ispity then return end
            
            if getgenv().Setting.useshinypotion then
                local Oldmethod = getgenv().Setting.select_eggemtohd

                if Ispity >= 100 and Ispity <= 110 then
                    getgenv().Setting.select_eggemtohd = "Open"
                    
                    if Ispity == 110 and Oldmethod == "Single" then
                        getgenv().Setting.select_eggemtohd = "Open"
                    end
                end
            end
            
            if getgenv().Setting.stopatpity then
                if Ispity == tonumber(getgenv().Setting.Eggcount) and not hasPerformedAction then
                    local Old_tp = getgenv().Setting.Tp_Toeggs
                    if getgenv().Setting.stop_method == "NorMally Stop" then
                        getgenv().Setting.Openeggs = false
                        hasPerformedAction = true
                    elseif getgenv().Setting.stop_method == "Stop then go Openticket" then
                        local Egg_Distance = (Char:FindFirstChild("HumanoidRootPart").Position - Work.Server.Stars[getgenv().Setting.Egg_Select].Tickets.Star.Position).Magnitude
                        if Is_Ticket >= 199 then
                            if Egg_Distance < 10 then
                                task.wait(3)
                                
                                local args = {
                                    [1] = "General",
                                    [2] = "Stars",
                                    [3] = "Open",
                                    [4] = getgenv().Setting.Egg_Select,
                                    [5] = "Tickets"
                                }
                                
                                Rep:WaitForChild("Remotes"):WaitForChild("Bridge"):FireServer(unpack(args))
                            
                                getgenv().Setting.Openeggs = true
                                if Old_tp then
                                    getgenv().Setting.Tp_Toeggs = true
                                else
                                    Char:FindFirstChild("HumanoidRootPart").CFrame = Work.Server.Stars[getgenv().Setting.Egg_Select].Coins.Star.CFrame
                                end
                                hasPerformedAction = true
                                 
                            else
                                getgenv().Setting.Tp_Toeggs = false
                        
                                Char:FindFirstChild("HumanoidRootPart").CFrame = Work.Server.Stars[getgenv().Setting.Egg_Select].Tickets.Star.CFrame
                            
                            end
                        else
                            return
                        end
                    end
                end
                if Ispity ~= tonumber(getgenv().Setting.Eggcount) then
                    hasPerformedAction = false
                end
            end
        end)
    end
end)
task.spawn(function()
    local Dungeon_Target = nil
    local Mons = {}
    local Tp_Mons = {}
    local is_Instance2 = false
    local Join_Dungeon = false
    local Old_Farm_Value
    local OldTp_Tpeggvalue 
    local IS_Dungeon = Local_Ply:GetAttribute("Mode")
    Last_Map = Get_AlreadyMap() or "Leaf Village"
    --{"Last Postion","Set Position"}
    while task.wait() do
        pcall(function()
            if getgenv().Setting.join_dungeon then
                local Dungeon_value = Work.Server.Trial.Lobby.Dungeon_Door:GetAttribute("Opened")
                
                local Tp_Pos = Work.Server.Trial.Rooms.Dungeon.Lobby.Player_Teleport.CFrame
                if getgenv().Setting.Leave_Method == "Last Postion" then
                    Last_Map = Get_AlreadyMap() or "Leaf Village"
                    LastPosition = GetPosition()
                end
                Old_Farm_Value = getgenv().Setting.Auto_Farm
                OldTp_Tpeggvalue = getgenv().Setting.Tp_Toeggs
                if IS_Dungeon or Dungeon_value or Dungeon_value == true and not Join_Dungeon then
                    Join_Dungeon = true
                   
                    if Old_Farm_Value then 
                        getgenv().Setting.Auto_Farm = false 
                    end
                    if OldTp_Tpeggvalue  then 
                        getgenv().Setting.Tp_Toeggs = false 
                    end
      
                    local args = { 
                        [1] = "Enemies",
                        [2] = "Trial_Dungeon",
                        [3] = "Join"
                    }
                    Rep:WaitForChild("Remotes"):WaitForChild("Bridge"):FireServer(unpack(args))
                    Char:FindFirstChild("HumanoidRootPart").CFrame = Tp_Pos
                end
            end
            if getgenv().Setting.Auto_dungeon and IS_Dungeon or Join_Dungeon then
                local function GetEnemy()
                    table.clear(Mons)
                    local Mon = Work.Server.Trial.Enemies.Dungeon
                    for _,mons in pairs(Mon:GetChildren()) do
                        
                        if mons then
                            table.insert(Mons,{
                                Enm = mons,
                                Health = mons:GetAttribute("Health")
                            })
                        end
                    end
                    if getgenv().Setting.Enemykill_Methods == "low to High" then
                        table.sort(Mons, function(a, b) 
                            return a.Health < b.Health 
                        end)
                    
                        if #Mons > 0 then
                            for i = 1, #Mons do
                                local SelectedEnemy = Mons[i].Enm
                                local Health = Mons[i].Enm:GetAttribute("Health")
                                if Health > 0 then
                                    return SelectedEnemy
                                else
                                    continue
                                end
                            end
                        end
                        return nil
                    else
                        table.sort(Mons, function(a, b) 
                            return a.Health > b.Health 
                        end)
                    
                        if #Mons > 0 then
                            for i = 1, #Mons do
                                local SelectedEnemy = Mons[i].Enm
                                local Health = Mons[i].Enm:GetAttribute("Health")
                                if Health > 0 then
                                    return SelectedEnemy
                                else
                                    continue
                                end
                            end
                        end
                        return nil
                    end
                end
                for _,v in pairs(Gui.UI.Frames.Pets.Background.Frame.List:GetChildren()) do
                    if v:IsA("Frame") and v.Equipped.Visible == true then
                        if not Dungeon_Target or Dungeon_Target == nil or Dungeon_Target.Parent == nil then
                            table.clear(Tp_Mons)
                            Dungeon_Target = GetEnemy()
                        end

                        if Dungeon_Target then
                            local Current_Health = Dungeon_Target:GetAttribute("Health") or 0
                            if Current_Health <= 0 then
                                Dungeon_Target = nil
                            end
                            task.spawn(function()
                                Tp(Dungeon_Target.CFrame)
                                for _,pet in pairs(Work.Server.Pets:GetChildren()) do
                                    if pet and pet:IsA("Model") then
                                        local nameParts = string.split(pet.Name, "---")
                                        local playerName = nameParts[1]
                                        local hero = nameParts[2]
                                        if playerName == Local_Ply.Name and not Tp_Mons[hero]  then
                                            Tp_Mons[hero] = true
                                            pet:WaitForChild("HumanoidRootPart").CFrame = Dungeon_Target.CFrame
                                        end
                                    end
                                end
                            end)
                            local args = {
                                "General",
                                "Pets",
                                "Attack",
                                tostring(v.Name),
                                Dungeon_Target,
                            }
                            Rep:WaitForChild("Remotes"):WaitForChild("Bridge"):FireServer(unpack(args))

                        end
                    end
                end
                
            end
            if getgenv().Setting.leave_dungeon then
                local Rooms_Value = tonumber(Gui.UI.HUD.Trial.Frame.Room.Value.Text)
                if IS_Dungeon or Join_Dungeon then   
                    if Rooms_Value >= tonumber(getgenv().Setting.leave_value) or Rooms_Value == tonumber(getgenv().Setting.leave_value) then
                        Join_Dungeon = false
                        local args = {
                            [1] = "General",
                            [2] = "Teleport",
                            [3] = "Teleport",
                            [4] = tostring(Last_Map)
                        }
                        Rep:WaitForChild("Remotes"):WaitForChild("Bridge"):FireServer(unpack(args))
                        task.delay(0.5, function()
                            task.spawn(function()
                                if getgenv().Setting.Leave_Method == "Set Position" then
                                    Char:FindFirstChild("HumanoidRootPart").CFrame = Set_Position
                                else
                                    Char:FindFirstChild("HumanoidRootPart").CFrame = LastPosition
                                end
                                if Old_Farm_Value  then 
                                    
                                    getgenv().Setting.Auto_Farm = true 
                                end
                                if OldTp_Tpeggvalue   then 
                                    getgenv().Setting.Tp_Toeggs = true 
                                end
                            end)
                        end)
                    end
                else
                    return
                end
            end
        end)
    end
end)

task.spawn(function()
    local Trail_Target = nil
    local Mons2 = {}
    local Tp_Mons2 = {}
    local Join_Trail = false
    local Old_Farm_Value
    local OldTp_Tpeggvalue 
    local IS_Trial = Local_Ply:GetAttribute("Mode")
    Last_Map = Get_AlreadyMap() or "Leaf Village"
    while task.wait() do
        pcall(function()
            if getgenv().Setting.join_trails then
                local Trail_value = Work.Server.Trial.Lobby.Easy_Door:GetAttribute("Opened")
                
                local Tp_Pos = Work.Server.Trial.Rooms.Easy.Lobby.Player_Teleport.CFrame
                Old_Farm_Value = getgenv().Setting.Auto_Farm
                OldTp_Tpeggvalue = getgenv().Setting.Tp_Toeggs
                if getgenv().Setting.Leave_Method == "Last Postion" then
                    Last_Map = Get_AlreadyMap() or "Leaf Village"
                    LastPosition = GetPosition()
                end
                if IS_Trial or Trail_value or Trail_value == true and not Join_Trail then
                    Join_Trail = true
                    
                    if Old_Farm_Value  then 
                        getgenv().Setting.Auto_Farm = false 
                    end
                    if OldTp_Tpeggvalue  then 
                        getgenv().Setting.Tp_Toeggs = false 
                    end
                    
                    local args = {
                        [1] = "Enemies",
                        [2] = "Trial_Easy",
                        [3] = "Join"
                    }
                    Rep:WaitForChild("Remotes"):WaitForChild("Bridge"):FireServer(unpack(args))
                    
                    Char:FindFirstChild("HumanoidRootPart").CFrame = Tp_Pos
                end
            end
            if getgenv().Setting.Auto_trail and IS_Trial or Join_Trail then
                local function GetEnemy()
                    table.clear(Mons2)
                    local Mon = Work.Server.Trial.Enemies.Easy
                    for _,mons in pairs(Mon:GetChildren()) do
                        
                        if mons then
                            table.insert(Mons2,{
                                Enm = mons,
                                Health = mons:GetAttribute("Health")
                            })
                        end
                    end
                    if getgenv().Setting.Enemykill_Trail == "low to High" then
                        table.sort(Mons2, function(a, b) 
                            return a.Health < b.Health 
                        end)
                    
                        if #Mons2 > 0 then
                            for i = 1, #Mons2 do
                                local SelectedEnemy = Mons2[i].Enm
                                local Health = Mons2[i].Enm:GetAttribute("Health")
                                if Health > 0 then
                                    return SelectedEnemy
                                else
                                    continue
                                end
                            end
                        end
                        return nil
                    else
                        table.sort(Mons2, function(a, b) 
                            return a.Health > b.Health 
                        end)
                    
                        if #Mons2 > 0 then
                            for i = 1, #Mons2 do
                                local SelectedEnemy = Mons2[i].Enm
                                local Health = Mons2[i].Enm:GetAttribute("Health")
                                if Health > 0 then
                                    return SelectedEnemy
                                else
                                    continue
                                end
                            end
                        end
                        return nil
                    end
                end
                for _,v in pairs(Gui.UI.Frames.Pets.Background.Frame.List:GetChildren()) do
                    if v:IsA("Frame") and v.Equipped.Visible == true then
                        if not Trail_Target or Trail_Target == nil or Trail_Target.Parent == nil then
                            table.clear(Tp_Mons2)
                            Trail_Target = GetEnemy()
                        end

                        if Trail_Target then
                            local Current_Health = Trail_Target:GetAttribute("Health") or 0
                            if Current_Health <= 0 then
                                Trail_Target = nil
                            end
                            task.spawn(function()
                                Tp(Trail_Target.CFrame)
                                for _,pet in pairs(Work.Server.Pets:GetChildren()) do
                                    if pet and pet:IsA("Model") then
                                        local nameParts = string.split(pet.Name, "---")
                                        local playerName = nameParts[1]
                                        local hero = nameParts[2]
                                        if playerName == Local_Ply.Name and not Tp_Mons2[hero]  then
                                            Tp_Mons2[hero] = true
                                            pet:WaitForChild("HumanoidRootPart").CFrame = Trail_Target.CFrame
                                        end
                                    end
                                end
                            end)
                            local args = {
                                "General",
                                "Pets",
                                "Attack",
                                tostring(v.Name),
                                Trail_Target,
                            }
                            Rep:WaitForChild("Remotes"):WaitForChild("Bridge"):FireServer(unpack(args))

                        end
                    end
                end
                
            end
            if getgenv().Setting.leave_trail then
                local Rooms_Value = tonumber(Gui.UI.HUD.Trial.Frame.Room.Value.Text)
                if IS_Trial or Join_Trail then   
                   
                    if Rooms_Value >= tonumber(getgenv().Setting.leave_value2) or Rooms_Value == tonumber(getgenv().Setting.leave_value2) then
                        Join_Trail = false
                        local args = {
                            [1] = "General",
                            [2] = "Teleport",
                            [3] = "Teleport",
                            [4] = tostring(Last_Map)
                        }
                        Rep:WaitForChild("Remotes"):WaitForChild("Bridge"):FireServer(unpack(args))
                        task.delay(0.5, function()
                            task.spawn(function()
                                if getgenv().Setting.Leave_Method == "Set Position" then
                                    Char:FindFirstChild("HumanoidRootPart").CFrame = Set_Position
                                else
                                    Char:FindFirstChild("HumanoidRootPart").CFrame = LastPosition
                                end
                                if Old_Farm_Value then 
                                    --print(1123)
                                    getgenv().Setting.Auto_Farm = true 
                                end
                                if OldTp_Tpeggvalue then 
                                    getgenv().Setting.Tp_Toeggs = true 
                                end
                            end)
                        end)
                        
                    end
                end
            end
        end)
    end
end)


[[--
local args = {
    [1] = "General",
    [2] = "Teleport",
    [3] = "Teleport",
    [4] = "Leaf Village"
}

game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Bridge"):FireServer(unpack(args))


local args = {
    [1] = "Enemies",
    [2] = "Trial_Easy",
    [3] = "Join"
}

game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Bridge"):FireServer(unpack(args))

--]]
[[--
Atk Mons
local args = {
    [1] = "General",
    [2] = "Pets",
    [3] = "Attack",
    [4] = "4102c165-8516-4deb-917d-c5e5f31ab361",
    [5] = workspace:WaitForChild("Server"):WaitForChild("Enemies"):WaitForChild("Leaf Village"):WaitForChild("Modare")
}

game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Bridge"):FireServer(unpack(args))

--]]
[[--
Out Mons
local args = {
   local args = {
    [1] = "General",
    [2] = "Pets",
    [3] = "Retreat"
}

game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Bridge"):FireServer(unpack(args))

--]]

[[--
Open Egg
local args = {
    [1] = "General",
    [2] = "Stars",
    [3] = "Open",
    [4] = "Leaf Village",
    [5] = "Coins"
}

game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Bridge"):FireServer(unpack(args))

--]]
[[--
Open Multi Egg
local args = {
    [1] = "General",
    [2] = "Stars",
    [3] = "Multi",
    [4] = "Leaf Village",
    [5] = "Coins"
}

game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Bridge"):FireServer(unpack(args))

--]]
[[--
Open Ticket Egg
local args = {
    [1] = "General",
    [2] = "Stars",
    [3] = "Open",
    [4] = "Leaf Village",
    [5] = "Tickets"
}

game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Bridge"):FireServer(unpack(args))

--]]
[[--
Ticket Quest
local args = {
    [1] = "General",
    [2] = "Quests",
    [3] = "Tickets"
}

game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Bridge"):FireServer(unpack(args))
Vip
local args = {
    [1] = "General",
    [2] = "Quests",
    [3] = "TicketsVIP"
}

game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Bridge"):FireServer(unpack(args))

--]]
[[--
Main Quest
local args = {
    [1] = "General",
    [2] = "Quests",
    [3] = "Accept",
    [4] = "Leaf Village",
    [5] = "EximiusX Hunt"
}

game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Bridge"):FireServer(unpack(args))

--]]
