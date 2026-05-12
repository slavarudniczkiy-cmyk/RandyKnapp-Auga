# Auga port notes for Valheim 0.221.x

Target:
- bootstrap a current fork for Valheim 0.221.x / Unity 6000
- avoid startup crashes first
- then re-enable UI modules one by one

Current blockers found in upstream:
1. `Auga/Auga.csproj` is hard-wired to local machine paths and Valheim `0.217.30` publicized assemblies.
2. `Auga/Auga.cs` contains an old PTB version gate that can destroy the plugin on unknown versions.
3. `Auga/Auga.cs` loads translations in `Awake()`, which is risky on newer builds if localization is not ready yet.
4. `Auga/Auga.cs` loads `augaassets` from an embedded bundle; after the Unity 6000 migration this likely needs a bundle rebuild.
5. High-risk runtime files after bootstrap are:
   - `Auga/PlayerInventory_Setup.cs`
   - `Auga/Hud_Setup.cs`
   - `Auga/Minimap_Setup.cs`
   - `Auga/TextInput_Setup.cs`

What is already added in this repo:
- `patches/0001-bootstrap-valheim-0.221x.diff`
- `scripts/bootstrap-upstream.ps1`

Planned order of work:
1. Import upstream source into this repository.
2. Apply the bootstrap patch.
3. Compile against current publicized assemblies.
4. Start game with only the loader + config + translations + asset loading path changes.
5. Re-enable UI modules in this order:
   - Inventory
   - HUD
   - Minimap
   - TextInput / Store / misc dialogs
6. Rebuild the Unity bundle if prefab or atlas references break.

Definition of done for bootstrap:
- project compiles without old absolute paths
- plugin does not self-destruct on 0.221.x
- missing localization at startup no longer hard-crashes the mod
- missing asset bundle produces a readable error instead of a null ref cascade
