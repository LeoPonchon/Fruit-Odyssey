# Fruit Odyssey

Jeu Roblox de type **bandit beater / action-RPG** inspiré de plusieurs univers d'animation, développé avec **roblox-ts**, **Rojo** et React-Roblox.

Le dépôt contient à la fois la base technique du jeu et la vision de gameplay : profils persistants, gacha, races/clans/attributs, progression et interface client.

> **Statut :** en développement. Les idées de contenu à long terme ne sont pas toutes implémentées ; ce README distingue volontairement les systèmes déjà présents de la roadmap.

## Systèmes présents dans le dépôt

- persistance des données joueur ;
- gestion de profils ;
- système de gacha ;
- données partagées pour races, clans et attributs ;
- logique client et serveur séparée ;
- UI React-Roblox ;
- pipeline TypeScript → Luau via roblox-ts ;
- synchronisation avec Roblox Studio via Rojo.

## Vision gameplay

L'objectif est de construire une progression par îles avec :

- combats contre mobs et boss ;
- quêtes et récompenses ;
- styles/pouvoirs inspirés de plusieurs univers ;
- progression de statistiques ;
- armes et transformations ;
- gacha pour différents éléments de progression et de personnalisation.

Ces éléments représentent la direction du projet et peuvent être à des niveaux d'avancement différents.

## Stack

- Roblox Studio
- TypeScript
- roblox-ts 3
- Rojo 7.6.x
- React / React-Roblox
- Luau généré dans `dist/`

## Installation

```bash
git clone https://github.com/LeoPonchon/Fruit-Odyssey.git
cd Fruit-Odyssey
npm install
```

Compiler le TypeScript puis démarrer Rojo :

```bash
npm start
```

Mode développement avec watchers :

```bash
npm run dev
```

Commandes disponibles :

```bash
npm run build:rbxts   # compile TypeScript -> Luau
npm run watch:rbxts   # compilation continue
npm run serve         # serveur Rojo
npm run build         # build Rojo
```

## Structure

```text
src/                 # sources roblox-ts
dist/
├── client/           # code client compilé
├── server/           # DataStore, profils, gacha...
└── shared/           # races, clans, attributs...
default.project.json  # mapping Rojo
```

## Développement

Évitez d'éditer manuellement les fichiers générés dans `dist/` si leur source TypeScript existe : modifiez la source, puis relancez la compilation.
