-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("Include"):WaitForChild("RuntimeLib"))
local _react = TS.import(script, game:GetService("ReplicatedStorage"), "node_modules", "@rbxts", "react")
local React = _react
local StrictMode = _react.StrictMode
local _react_roblox = TS.import(script, game:GetService("ReplicatedStorage"), "node_modules", "@rbxts", "react-roblox")
local createPortal = _react_roblox.createPortal
local createRoot = _react_roblox.createRoot
local App = TS.import(script, script, "App").default
local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local root = createRoot(Instance.new("Folder"))
root:render(React.createElement(StrictMode, nil, createPortal(React.createElement(App), playerGui)))
print("[React-Roblox] UI initialisée!")
