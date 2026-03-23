/// <reference types="@rbxts/types" />
import React, { useState } from "@rbxts/react";
import { Players } from "@rbxts/services";

// ============================================================================
// COULEURS RPG
// ============================================================================

const COLORS = {
    Primary: new Color3(0.8, 0.6, 0.2),
    Background: new Color3(0.05, 0.05, 0.08),
    Panel: new Color3(0.1, 0.1, 0.12),
    PanelLight: new Color3(0.15, 0.15, 0.18),
    Text: new Color3(0.9, 0.9, 0.9),
    TextSecondary: new Color3(0.6, 0.6, 0.65),
    HP: new Color3(0.9, 0.2, 0.2),
    HPBackground: new Color3(0.2, 0.1, 0.1),
    Blue: new Color3(0.2, 0.5, 0.9),
    Purple: new Color3(0.6, 0.3, 0.9),
    Green: new Color3(0.3, 0.7, 0.4),
};

// ============================================================================
// TYPES
// ============================================================================

interface PlayerData {
    Level: number;
    XP: number;
    XPToNextLevel: number;
    Coins: number;
    Gems: number;
    Strength: number;
    Speed: number;
    Stamina: number;
    Vitality: number;
    Precision: number;
    Luck: number;
    PointsToSpend: number;
    CurrentRace: string;
    CurrentClan: string;
    CurrentAttribute: string;
    CombatStyle: string;
    TransformationLevel: number;
}

interface InventoryItem {
    name: string;
    quantity: number;
    rarity: string;
}

// ============================================================================
// COMPOSANTS
// ============================================================================

function ModernButton(props: {
    name: string;
    text: string;
    size: UDim2;
    position: UDim2;
    onClick?: () => void;
    color?: Color3;
}) {
    const buttonColor = props.color || COLORS.PanelLight;

    return (
        <textbutton
            key={props.name}
            Size={props.size}
            Position={props.position}
            Text={props.text}
            TextColor3={COLORS.Text}
            TextSize={14}
            Font={Enum.Font.GothamBold}
            BackgroundColor3={buttonColor}
            BackgroundTransparency={0.3}
            BorderSizePixel={0}
            AutoButtonColor={true}
            Event={{
                MouseButton1Click: props.onClick || (() => { }),
            }}
        />
    );
}

function PopupFrame(props: {
    keyName: string;
    title: string;
    size: UDim2;
    position: UDim2;
    onClose: () => void;
    children?: React.ReactNode;
}) {
    return (
        <frame
            key={props.keyName}
            Size={props.size}
            Position={props.position}
            BackgroundColor3={COLORS.Background}
            BackgroundTransparency={0.3}
            BorderSizePixel={0}
        >
            <textlabel
                key="Title"
                Size={new UDim2(1, 0, 0, 40)}
                Text={props.title}
                TextColor3={COLORS.Primary}
                TextSize={24}
                Font={Enum.Font.GothamBold}
                BackgroundTransparency={1}
            />

            <textbutton
                key="Close"
                Size={new UDim2(0, 30, 0, 30)}
                Position={new UDim2(1, -40, 0, 5)}
                Text="✕"
                TextColor3={COLORS.Text}
                TextSize={16}
                BackgroundColor3={COLORS.HP}
                BackgroundTransparency={0.5}
                BorderSizePixel={0}
                AutoButtonColor={true}
                Event={{
                    MouseButton1Click: props.onClose,
                }}
            />

            <frame
                key="Content"
                Size={new UDim2(1, -20, 1, -50)}
                Position={new UDim2(0, 10, 0, 45)}
                BackgroundTransparency={1}
                BorderSizePixel={0}
            >
                {props.children}
            </frame>
        </frame>
    );
}

// ============================================================================
// UI PRINCIPALE
// ============================================================================

export default function App() {
    const [playerData, setPlayerData] = useState<PlayerData>({
        Level: 1,
        XP: 0,
        XPToNextLevel: 100,
        Coins: 100,
        Gems: 50,
        Strength: 0,
        Speed: 0,
        Stamina: 0,
        Vitality: 0,
        Precision: 0,
        Luck: 0,
        PointsToSpend: 5,
        CurrentRace: "Humain",
        CurrentClan: "Aucun",
        CurrentAttribute: "Aucun",
        CombatStyle: "Melee",
        TransformationLevel: 0,
    });

    const [inventory] = useState<InventoryItem[]>([
        { name: "Épée en fer", quantity: 1, rarity: "Commun" },
        { name: "Potion de soin", quantity: 5, rarity: "Commun" },
        { name: "Gemme mystique", quantity: 3, rarity: "Rare" },
    ]);

    const [showStats, setShowStats] = useState(false);
    const [showWish, setShowWish] = useState(false);
    const [showInventory, setShowInventory] = useState(false);
    const [showSettings, setShowSettings] = useState(false);
    const [strPoints, setStrPoints] = useState("1");
    const [spdPoints, setSpdPoints] = useState("1");
    const [staPoints, setStaPoints] = useState("1");
    const [vitPoints, setVitPoints] = useState("1");
    const [prePoints, setPrePoints] = useState("1");
    const [lckPoints, setLckPoints] = useState("1");
    const hp = 100;
    const maxHp = 100;
    const hpPercent = maxHp > 0 ? hp / maxHp : 0;

    // Fonctions pour ajouter des points de stats
    const addStat = (statName: string) => {
        let pointsToAdd = 1;
        if (statName === "Strength") pointsToAdd = tonumber(strPoints) || 1;
        if (statName === "Speed") pointsToAdd = tonumber(spdPoints) || 1;
        if (statName === "Stamina") pointsToAdd = tonumber(staPoints) || 1;
        if (statName === "Vitality") pointsToAdd = tonumber(vitPoints) || 1;
        if (statName === "Precision") pointsToAdd = tonumber(prePoints) || 1;
        if (statName === "Luck") pointsToAdd = tonumber(lckPoints) || 1;

        pointsToAdd = math.max(1, pointsToAdd);

        if (playerData.PointsToSpend >= pointsToAdd) {
            // Mise à jour locale
            setPlayerData((prev) => {
                const newData = { ...prev };
                if (statName === "Strength") newData.Strength += pointsToAdd;
                if (statName === "Speed") newData.Speed += pointsToAdd;
                if (statName === "Stamina") newData.Stamina += pointsToAdd;
                if (statName === "Vitality") newData.Vitality += pointsToAdd;
                if (statName === "Precision") newData.Precision += pointsToAdd;
                if (statName === "Luck") newData.Luck += pointsToAdd;
                newData.PointsToSpend -= pointsToAdd;
                return newData;
            });
            print("[UI] +" + pointsToAdd + " à " + statName);
        } else {
            print("[UI] Pas assez de points!");
        }
    };

    const handleWishRace = () => {
        const ReplicatedStorage = game.GetService("ReplicatedStorage");
        const rollEvent = ReplicatedStorage.FindFirstChild("RollRace") as RemoteFunction;

        if (rollEvent && playerData.Gems >= 10) {
            const result = rollEvent.InvokeServer();
            print("[Wish] Race result: " + tostring(result));
        } else {
            print("[Wish] Pas assez de gemmes ou pas de serveur!");
        }
    };

    const handleWishClan = () => {
        const ReplicatedStorage = game.GetService("ReplicatedStorage");
        const rollEvent = ReplicatedStorage.FindFirstChild("RollClan") as RemoteFunction;

        if (rollEvent && playerData.Gems >= 10) {
            const result = rollEvent.InvokeServer();
            print("[Wish] Clan result: " + tostring(result));
        } else {
            print("[Wish] Pas assez de gemmes ou pas de serveur!");
        }
    };

    const handleWishAttribute = () => {
        const ReplicatedStorage = game.GetService("ReplicatedStorage");
        const rollEvent = ReplicatedStorage.FindFirstChild("RollAttribute") as RemoteFunction;

        if (rollEvent && playerData.Gems >= 10) {
            const result = rollEvent.InvokeServer();
            print("[Wish] Attribute result: " + tostring(result));
        } else {
            print("[Wish] Pas assez de gemmes ou pas de serveur!");
        }
    };

    return (
        <screengui key="FruitOdysseyUI" ResetOnSpawn={false}>

            {/* ============================================================
                BARRE D'HP
            ============================================================ */}
            <frame
                key="HPBarContainer"
                Size={new UDim2(0, 300, 0, 40)}
                Position={new UDim2(0.5, -150, 1, -120)}
                BackgroundColor3={COLORS.Background}
                BackgroundTransparency={1}
                BorderSizePixel={0}
            >
                <frame
                    key="HPBackground"
                    Size={new UDim2(1, -10, 0, 20)}
                    Position={new UDim2(0, 5, 0.5, -10)}
                    BackgroundColor3={COLORS.HPBackground}
                    BorderSizePixel={0}
                >
                    <frame
                        key="HPFill"
                        Size={new UDim2(hpPercent, 0, 1, 0)}
                        BackgroundColor3={COLORS.HP}
                        BorderSizePixel={0}
                    />
                </frame>
                <textlabel
                    key="HPText"
                    Size={new UDim2(1, 0, 0, 18)}
                    Text={`${hp} / ${maxHp}`}
                    TextColor3={COLORS.Text}
                    TextSize={12}
                    Font={Enum.Font.GothamBold}
                    BackgroundTransparency={1}
                    Position={new UDim2(0, 0, 0.5, -9)}
                />
            </frame>

            {/* ============================================================
                BOUTONS
            ============================================================ */}
            <frame
                key="ButtonsContainer"
                Size={new UDim2(0, 200, 0, 180)}
                Position={new UDim2(0, 10, 1, -190)}
                BackgroundColor3={COLORS.Background}
                BackgroundTransparency={1}
                BorderSizePixel={0}
            >
                <ModernButton
                    name="Stats"
                    text="📊 Stats"
                    size={new UDim2(0.9, 0, 0, 35)}
                    position={new UDim2(0.05, 0, 0, 5)}
                    color={COLORS.Primary}
                    onClick={() => setShowStats(!showStats)}
                />
                <ModernButton
                    name="Wish"
                    text="🎰 Wish"
                    size={new UDim2(0.9, 0, 0, 35)}
                    position={new UDim2(0.05, 0, 0, 45)}
                    color={COLORS.Purple}
                    onClick={() => setShowWish(!showWish)}
                />
                <ModernButton
                    name="Inventory"
                    text="🎒 Inventaire"
                    size={new UDim2(0.9, 0, 0, 35)}
                    position={new UDim2(0.05, 0, 0, 85)}
                    color={COLORS.Blue}
                    onClick={() => setShowInventory(!showInventory)}
                />
                <ModernButton
                    name="Settings"
                    text="⚙️ Paramètres"
                    size={new UDim2(0.9, 0, 0, 35)}
                    position={new UDim2(0.05, 0, 0, 125)}
                    color={COLORS.PanelLight}
                    onClick={() => setShowSettings(!showSettings)}
                />
            </frame>

            {/* ============================================================
                POPUP STATS
            ============================================================ */}
            {showStats && (
                <PopupFrame
                    keyName="StatsPopup"
                    title="📊 STATS"
                    size={new UDim2(0, 450, 0, 520)}
                    position={new UDim2(0.5, -225, 0.5, -260)}
                    onClose={() => setShowStats(false)}
                >
                    <textlabel
                        key="PointsAvailable"
                        Size={new UDim2(1, 0, 0, 30)}
                        Text={`Points disponibles: ${playerData.PointsToSpend}`}
                        TextColor3={COLORS.Primary}
                        TextSize={18}
                        Font={Enum.Font.GothamBold}
                        BackgroundTransparency={1}
                    />
                    <textlabel
                        key="LevelInfo"
                        Size={new UDim2(1, 0, 0, 25)}
                        Position={new UDim2(0, 0, 0, 35)}
                        Text={`Niveau ${playerData.Level} | XP: ${playerData.XP}/${playerData.XPToNextLevel}`}
                        TextColor3={COLORS.TextSecondary}
                        TextSize={14}
                        Font={Enum.Font.Gotham}
                        BackgroundTransparency={1}
                    />

                    <frame key="CurrentChar" Size={new UDim2(1, 0, 0, 35)} Position={new UDim2(0, 0, 0, 65)} BackgroundTransparency={1} BorderSizePixel={0}>
                        <textlabel Size={new UDim2(1, 0, 1, 0)} Text={`Race: ${playerData.CurrentRace} | Clan: ${playerData.CurrentClan}`} TextColor3={COLORS.Purple} TextSize={12} BackgroundTransparency={1} />
                    </frame>
                    <frame key="CurrentAttr" Size={new UDim2(1, 0, 0, 30)} Position={new UDim2(0, 0, 0, 95)} BackgroundTransparency={1} BorderSizePixel={0}>
                        <textlabel Size={new UDim2(1, 0, 1, 0)} Text={`Attribut: ${playerData.CurrentAttribute}`} TextColor3={COLORS.Green} TextSize={12} BackgroundTransparency={1} />
                    </frame>

                    <frame key="STR" Size={new UDim2(1, 0, 0, 35)} Position={new UDim2(0, 0, 0, 130)} BackgroundTransparency={1} BorderSizePixel={0}>
                        <textlabel Size={new UDim2(0.4, 0, 1, 0)} Text={`Force: ${playerData.Strength}`} TextColor3={COLORS.Text} TextSize={14} BackgroundTransparency={1} />
                        <textbox Size={new UDim2(0.2, 0, 0, 25)} Position={new UDim2(0.4, 0, 0, 5)} Text={strPoints} TextColor3={COLORS.Text} TextSize={12} BackgroundColor3={COLORS.Panel} BorderSizePixel={0} />
                        <ModernButton name="STRAdd" text="+" size={new UDim2(0.15, 0, 0, 25)} position={new UDim2(0.65, 0, 0, 5)} color={COLORS.Green} onClick={() => addStat("Strength")} />
                    </frame>

                    <frame key="SPD" Size={new UDim2(1, 0, 0, 35)} Position={new UDim2(0, 0, 0, 170)} BackgroundTransparency={1} BorderSizePixel={0}>
                        <textlabel Size={new UDim2(0.4, 0, 1, 0)} Text={`Vitesse: ${playerData.Speed}`} TextColor3={COLORS.Text} TextSize={14} BackgroundTransparency={1} />
                        <textbox Size={new UDim2(0.2, 0, 0, 25)} Position={new UDim2(0.4, 0, 0, 5)} Text={spdPoints} TextColor3={COLORS.Text} TextSize={12} BackgroundColor3={COLORS.Panel} BorderSizePixel={0} />
                        <ModernButton name="SPDAdd" text="+" size={new UDim2(0.15, 0, 0, 25)} position={new UDim2(0.65, 0, 0, 5)} color={COLORS.Green} onClick={() => addStat("Speed")} />
                    </frame>

                    <frame key="STA" Size={new UDim2(1, 0, 0, 35)} Position={new UDim2(0, 0, 0, 210)} BackgroundTransparency={1} BorderSizePixel={0}>
                        <textlabel Size={new UDim2(0.4, 0, 1, 0)} Text={`Endurance: ${playerData.Stamina}`} TextColor3={COLORS.Text} TextSize={14} BackgroundTransparency={1} />
                        <textbox Size={new UDim2(0.2, 0, 0, 25)} Position={new UDim2(0.4, 0, 0, 5)} Text={staPoints} TextColor3={COLORS.Text} TextSize={12} BackgroundColor3={COLORS.Panel} BorderSizePixel={0} />
                        <ModernButton name="STAAdd" text="+" size={new UDim2(0.15, 0, 0, 25)} position={new UDim2(0.65, 0, 0, 5)} color={COLORS.Green} onClick={() => addStat("Stamina")} />
                    </frame>

                    <frame key="VIT" Size={new UDim2(1, 0, 0, 35)} Position={new UDim2(0, 0, 0, 250)} BackgroundTransparency={1} BorderSizePixel={0}>
                        <textlabel Size={new UDim2(0.4, 0, 1, 0)} Text={`Vitalité: ${playerData.Vitality}`} TextColor3={COLORS.Text} TextSize={14} BackgroundTransparency={1} />
                        <textbox Size={new UDim2(0.2, 0, 0, 25)} Position={new UDim2(0.4, 0, 0, 5)} Text={vitPoints} TextColor3={COLORS.Text} TextSize={12} BackgroundColor3={COLORS.Panel} BorderSizePixel={0} />
                        <ModernButton name="VITAdd" text="+" size={new UDim2(0.15, 0, 0, 25)} position={new UDim2(0.65, 0, 0, 5)} color={COLORS.Green} onClick={() => addStat("Vitality")} />
                    </frame>

                    <frame key="PRE" Size={new UDim2(1, 0, 0, 35)} Position={new UDim2(0, 0, 0, 290)} BackgroundTransparency={1} BorderSizePixel={0}>
                        <textlabel Size={new UDim2(0.4, 0, 1, 0)} Text={`Précision: ${playerData.Precision}`} TextColor3={COLORS.Text} TextSize={14} BackgroundTransparency={1} />
                        <textbox Size={new UDim2(0.2, 0, 0, 25)} Position={new UDim2(0.4, 0, 0, 5)} Text={prePoints} TextColor3={COLORS.Text} TextSize={12} BackgroundColor3={COLORS.Panel} BorderSizePixel={0} />
                        <ModernButton name="PREAdd" text="+" size={new UDim2(0.15, 0, 0, 25)} position={new UDim2(0.65, 0, 0, 5)} color={COLORS.Green} onClick={() => addStat("Precision")} />
                    </frame>

                    <frame key="LCK" Size={new UDim2(1, 0, 0, 35)} Position={new UDim2(0, 0, 0, 330)} BackgroundTransparency={1} BorderSizePixel={0}>
                        <textlabel Size={new UDim2(0.4, 0, 1, 0)} Text={`Chance: ${playerData.Luck}`} TextColor3={COLORS.Text} TextSize={14} BackgroundTransparency={1} />
                        <textbox Size={new UDim2(0.2, 0, 0, 25)} Position={new UDim2(0.4, 0, 0, 5)} Text={lckPoints} TextColor3={COLORS.Text} TextSize={12} BackgroundColor3={COLORS.Panel} BorderSizePixel={0} />
                        <ModernButton name="LCKAdd" text="+" size={new UDim2(0.15, 0, 0, 25)} position={new UDim2(0.65, 0, 0, 5)} color={COLORS.Green} onClick={() => addStat("Luck")} />
                    </frame>

                    <frame key="Currency" Size={new UDim2(1, 0, 0, 40)} Position={new UDim2(0, 0, 0, 380)} BackgroundTransparency={1} BorderSizePixel={0}>
                        <textlabel Size={new UDim2(0.5, 0, 0, 25)} Text={`🪙 ${playerData.Coins}`} TextColor3={COLORS.Primary} TextSize={16} Font={Enum.Font.GothamBold} BackgroundTransparency={1} />
                        <textlabel Size={new UDim2(0.5, 0, 0, 25)} Position={new UDim2(0.5, 0, 0, 0)} Text={`💎 ${playerData.Gems}`} TextColor3={COLORS.Blue} TextSize={16} Font={Enum.Font.GothamBold} BackgroundTransparency={1} />
                    </frame>
                </PopupFrame>
            )}

            {/* ============================================================
                POPUP WISH
            ============================================================ */}
            {showWish && (
                <PopupFrame
                    keyName="WishPopup"
                    title="🎰 WISH"
                    size={new UDim2(0, 350, 0, 300)}
                    position={new UDim2(0.5, -175, 0.5, -150)}
                    onClose={() => setShowWish(false)}
                >
                    <textlabel key="Desc" Size={new UDim2(1, 0, 0, 30)} Text={`Vos gemmes: ${playerData.Gems}`} TextColor3={COLORS.Blue} TextSize={14} BackgroundTransparency={1} />
                    <textlabel key="Desc2" Size={new UDim2(1, 0, 0, 30)} Position={new UDim2(0, 0, 0, 20)} Text="Choisissez votre type de wish" TextColor3={COLORS.TextSecondary} TextSize={14} BackgroundTransparency={1} />

                    <ModernButton name="WishRace" text="🏃 Race (10 💎)" size={new UDim2(0.9, 0, 0, 40)} position={new UDim2(0.05, 0, 0, 55)} color={COLORS.Blue} onClick={handleWishRace} />
                    <ModernButton name="WishClan" text="👥 Clan (10 💎)" size={new UDim2(0.9, 0, 0, 40)} position={new UDim2(0.05, 0, 0, 105)} color={COLORS.Purple} onClick={handleWishClan} />
                    <ModernButton name="WishAttribute" text="⚡ Attribut (10 💎)" size={new UDim2(0.9, 0, 0, 40)} position={new UDim2(0.05, 0, 0, 155)} color={COLORS.Green} onClick={handleWishAttribute} />
                </PopupFrame>
            )}

            {/* ============================================================
                POPUP INVENTORY
            ============================================================ */}
            {showInventory && (
                <PopupFrame
                    keyName="InventoryPopup"
                    title="🎒 INVENTAIRE"
                    size={new UDim2(0, 400, 0, 400)}
                    position={new UDim2(0.5, -200, 0.5, -200)}
                    onClose={() => setShowInventory(false)}
                >
                    {inventory.map((item, index) => (
                        <frame key={`Item${index}`} Size={new UDim2(1, 0, 0, 40)} Position={new UDim2(0, 0, 0, index * 45)} BackgroundColor3={COLORS.PanelLight} BackgroundTransparency={0.5} BorderSizePixel={0}>
                            <textlabel key="ItemName" Size={new UDim2(0.7, 0, 1, 0)} Text={item.name} TextColor3={COLORS.Text} TextSize={14} Font={Enum.Font.Gotham} BackgroundTransparency={1} />
                            <textlabel key="ItemQty" Size={new UDim2(0.3, 0, 1, 0)} Position={new UDim2(0.7, 0, 0, 0)} Text={`x${item.quantity}`} TextColor3={COLORS.TextSecondary} TextSize={14} BackgroundTransparency={1} />
                        </frame>
                    ))}
                </PopupFrame>
            )}

            {/* ============================================================
                POPUP PARAMÈTRES
            ============================================================ */}
            {showSettings && (
                <PopupFrame
                    keyName="SettingsPopup"
                    title="⚙️ PARAMÈTRES"
                    size={new UDim2(0, 350, 0, 350)}
                    position={new UDim2(0.5, -175, 0.5, -175)}
                    onClose={() => setShowSettings(false)}
                >
                    <ModernButton name="Music" text="🎵 Musique: ON" size={new UDim2(0.9, 0, 0, 40)} position={new UDim2(0.05, 0, 0, 10)} color={COLORS.Green} onClick={() => print("[Settings] Musique!")} />
                    <ModernButton name="SFX" text="🔊 Effets sonores: ON" size={new UDim2(0.9, 0, 0, 40)} position={new UDim2(0.05, 0, 0, 60)} color={COLORS.Green} onClick={() => print("[Settings] SFX!")} />
                    <ModernButton name="Fullscreen" text="🖥️ Plein écran" size={new UDim2(0.9, 0, 0, 40)} position={new UDim2(0.05, 0, 0, 110)} color={COLORS.Blue} onClick={() => print("[Settings] Fullscreen!")} />
                    <ModernButton name="Quit" text="🚪 Quitter le jeu" size={new UDim2(0.9, 0, 0, 40)} position={new UDim2(0.05, 0, 0, 160)} color={COLORS.HP} onClick={() => print("[Settings] Quit!")} />
                </PopupFrame>
            )}

        </screengui>
    );
}
