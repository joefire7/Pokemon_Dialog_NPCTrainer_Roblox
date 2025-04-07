# Pokemon_Dialog_NPCTrainer_Roblox

# Youtube Video  [![Watch the video](https://img.youtube.com/vi/FVYY6YW8w_8/hqdefault.jpg)](https://www.youtube.com/watch?v=FVYY6YW8w_8)

# Images
![Screenshot 2025-04-07 at 1 13 01 AM](https://github.com/user-attachments/assets/3af33234-4c23-430a-9f46-37328df76ca6)
![Screenshot 2025-04-07 at 12 44 05 AM](https://github.com/user-attachments/assets/36f6351c-f85d-4d81-aa91-9030d8165da0)
![Screenshot 2025-04-07 at 1 10 00 AM](https://github.com/user-attachments/assets/20c18432-9472-47e6-8bc8-c86b571946bc)
![Screenshot 2025-04-07 at 1 10 44 AM](https://github.com/user-attachments/assets/fd7784ef-b8b7-49d0-bec7-4fac22d53ffa)
![Screenshot 2025-04-07 at 1 09 41 AM](https://github.com/user-attachments/assets/f42cb00a-3b79-40b0-8b70-6d79c8138e59)
![Screenshot 2025-04-07 at 1 09 15 AM](https://github.com/user-attachments/assets/745c8b4d-444a-4360-abaa-61b06087b720)
![Screenshot 2025-04-07 at 1 06 14 AM](https://github.com/user-attachments/assets/9cbc23b4-2614-4353-a690-652e2d06fb95)
![Screenshot 2025-04-07 at 12 56 03 AM](https://github.com/user-attachments/assets/e6125723-cc30-4d54-bd06-12a95680379e)
![Screenshot 2025-04-07 at 1 12 27 AM](https://github.com/user-attachments/assets/0f06edcd-460f-4bce-955f-53030fb34790)
![Screenshot 2025-04-07 at 1 15 16 AM](https://github.com/user-attachments/assets/5e35da59-9a61-4c60-9dea-a56d9ddc839e)
![Screenshot 2025-04-07 at 1 17 05 AM](https://github.com/user-attachments/assets/3b37bccb-8373-475f-b390-fd5a16ca9869)
![Screenshot 2025-04-07 at 1 17 42 AM](https://github.com/user-attachments/assets/8f123793-baed-44ea-b8a6-40851514cb53)


# Roblox Dialog & Interaction System - Technical Document

## Overview
This document describes the Lua systems implemented in Roblox Studio to support NPC dialog interactions, player proximity detection, cinematic camera control, and reusable modular scripting. The following systems are fully integrated:

- **Dialog UI System**
- **Interaction/Proximity System**
- **Cinematic Camera Controller**
- **Modular Architecture with ModuleScripts**

---

## 1. Dialog UI System

### Purpose:
To display dynamic NPC dialog through a modern, animated UI with speaker name, typing effect, and navigation.

### Features:
- Animated prompt UI (fade-in/out and scale)
- Typing effect that reveals text character by character
- Navigation with `Next` button and mouse click
- Responsive `TextButton` animation (pulse + dot cycle)

### Key Scripts:
**LocalScript (DialogUIController)** in `PlayerScripts`:
- Listens to RemoteEvents from server (`StartDialog`)
- Shows/hides dialog UI with smooth transitions
- Accepts keyboard input (E) to start dialog
- Manages dialog flow with `currentDialog`, `currentIndex`, `isTyping`
- Integrates with CameraController to switch perspectives

### UI Elements:
- `PromptFrame`: Contains dialog box
- `DialogText`, `SpeakerName`: Dynamic labels
- `NextButton`: Button to advance lines
- `UIScale`: Used for tweened animation effects

---

## 2. Interaction System

### Purpose:
Allow NPCs to trigger UI prompts when players enter a trigger zone and interact using proximity.

### Features:
- Trigger zone (`Touched`, `TouchEnded`) with debounce
- Checks valid players by `HumanoidRootPart`
- Smooth rotation of NPC toward player
- NPC plays idle/point animation
- Detects distance every frame to auto-exit interaction

### Key Script:
**Script (TriggerInteraction)** inside each NPC's `TriggerBox`
- Manages touch zone
- Fires `StartDialog:FireClient()` with NPC name
- Starts/stops animation tracks
- Calls `smoothRotateTo()` for NPC rotation
- Starts `monitorProximity()` to detect distance

### Helper Functions:
- `getValidPlayer(hit)`
- `isStillTouching(player)`
- `exitInteraction(player)`
- `monitorProximity(player)`
- `smoothRotateTo(targetPos, duration)`

---

## 3. Camera Controller

### Purpose:
Control cinematic camera movement when dialog starts and returns to the player when it ends.

### Structure:
**ModuleScript: `CameraController`** in `PlayerScripts`

### Functions:
#### `FocusOnNPC(npc)`
- Moves camera in front of NPC’s head
- Aims camera at NPC’s face
- Uses `CFrame.lookAt` with head `LookVector` and `UpVector`
- Tweens smoothly into place

#### `ReturnToPlayer()`
- Resets camera to behind the player
- Re-enables default `CameraType.Custom`
- Uses fallback positioning from `HumanoidRootPart`

### Tweening:
- TweenService animates `camera.CFrame`

---

## 4. Dialog Data

### Location:
Server-side ModuleScript or Script holding dialog:
```lua
local dialogData = {
	Riku_Trainer = {
		{speaker = "Riku", text = "Hmph. Another wannabe Trainer..."},
		...
	},
	Kaida_Trainer = { ... },
	Milo_Trainer = { ... },
	Tara_Trainer = { ... },
	Juno_Trainer = { ... }
}
```

Used by `StartDialog.OnServerEvent` to send NPC-specific dialog to clients.

---

## 5. Best Practices Used
- Modular `require()` usage for CameraController
- Typing effects with `wait(typingSpeed)`
- UI animations using TweenService
- Decoupling UI logic and 3D world logic (via RemoteEvents)
- Dynamic speaker/npc name resolution
- Clean proximity checks with `.Magnitude` and `RunService.Heartbeat`

---

## 6. Future Improvements (Optional)
- Branching dialogs based on player choices
- Save player dialog state
- Support for voice-over + subtitles
- Reactions from NPC (emotes, responses)
- UI dialog history panel

---

## 7. Folder Structure Example
```
StarterPlayer
└── StarterPlayerScripts
    ├── DialogUIController (LocalScript)
    ├── CameraController (ModuleScript)

ReplicatedStorage
└── StartDialog (RemoteEvent)

Workspace
└── NPC_Trainer
    ├── Humanoid
    ├── Head
    └── TriggerBox
        └── TriggerInteraction (Script)
```

