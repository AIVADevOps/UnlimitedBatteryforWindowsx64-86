================================================================
     BATTERY OPTIMIZATIONS - AMD Ryzen 7 7735HS
     Erstellt: Januar 2026
     Letztes Update: 2026-01-18
================================================================

ORDNERSTRUKTUR:
===============

BatteryOptimizations/
|
|-- 1_PowerPlan/
|   |-- BatteryPowerTweaks.ps1      (USB, WiFi, NVMe, Display Power)
|   |-- AdvancedKernelPower.ps1     (Core Parking, C-States, Idle)
|
|-- 2_Registry/
|   |-- BatteryRegistryTweaks.reg   (Background Apps, Telemetry, etc.)
|   |-- AdvancedKernelBattery.reg   (MMCSS, NTFS, Timer Coalescing)
|   |-- ChromeEfficiency.reg        (Chrome: BelowNormal Priority)
|   |-- SpotifyDiscordEfficiency.reg (Spotify/Discord: BelowNormal)
|   |-- DevToolsEfficiency.reg      (VS Code, Node.js, Electron IFEO)
|   |-- EnergySaverAlwaysOn.reg     (Energy Saver permanent an)
|   |-- DeepBatteryTweaks.reg       (RAM/CPU Deep Optimization)
|
|-- 3_Services/
|   |-- BatteryServicesAndTasks.ps1 (Disable Services & Tasks)
|   |-- BatteryTweaks2.ps1          (Defender, Startup, Network)
|
|-- 4_ProcessPriority/
|   |-- SetEfficiencyMode.ps1       (Setzt Prozess-Prioritaeten)
|
|-- Docs/
|   |-- UXTU_Snapdragon+.txt        (EMPFOHLEN - 8W Ultra Efficiency)
|   |-- UXTU_Efficiency++_Final.txt (30W Balanced Profil)
|   |-- UXTU_UltraEfficiency_30W.txt
|
|-- WiFiFix.ps1                     (WiFi Verbindungsprobleme fixen)
|-- RealtekWiFiFix.ps1              (Realtek RTL8852BE spezifische Fixes)
|-- README.txt                      (Diese Datei)
|-- RunAll.ps1                      (Master-Script: Alles ausfuehren)


ANWENDUNG:
==========

EINMALIG (nach Neuinstallation):
1. Alle .reg Dateien in 2_Registry/ ausfuehren
2. Alle .ps1 Dateien als Admin ausfuehren
3. WiFiFix.ps1 als Admin ausfuehren
4. Neustart

BEI JEDEM START (Automatisch via UXTU):
- UXTU: Snapdragon+ Profil laden
- UXTU Autostart aktivieren!


================================================================
UXTU PROFILE
================================================================

PROFIL 1: Snapdragon+ (EMPFOHLEN fuer Battery)
----------------------------------------------
Gefuehl: Extrem schnell trotz 8W!
165Hz Window-Dragging butterweich.

Power Limits:
- STAPM: 8W
- Slow: 8W
- Fast: 8W

VRM (WICHTIG - Secret Sauce!):
- CPU TDC: 20A
- CPU EDC: 50A    <-- Hoch = Smooth UI Bursts
- SoC TDC: 10A
- SoC EDC: 15A
- GFX TDC: 15A
- GFX EDC: 20A

iGPU:
- Clock: 750 MHz
- Undervolt: -50

Other:
- All Core Offset: -50
- iGPU Offset: -50
- Boost Profile: Power Saving
- Windows Power Mode: Best Power Efficiency


PROFIL 2: Efficiency++ (fuer mehr Performance)
----------------------------------------------
Fuer Situationen wo mehr Power gebraucht wird.

- STAPM: 30W
- Slow: 30W
- Fast: 50W
- iGPU: 1700MHz
- Undervolt: -50/-50


================================================================
WIFI FIX
================================================================

Problem: WiFi erkennt Netzwerke nicht nach Sleep/Idle
Ursache: Aggressives Power Saving trennt Verbindung

Loesung (bereits angewendet):
- WiFi Power Saving: Medium (statt Max)
- Leerlauf-Energiesparen: Low
- Wake on Magic Packet: Deaktiviert
- Wake on Pattern Match: Deaktiviert

Bei Problemen: WiFiFix.ps1 als Admin ausfuehren


================================================================
WINDOWS POWER PLAN: AMD Battery Max
================================================================

- Core Parking Concurrency: 90%
- Min Processor State: 5%
- Max Processor State: 99%
- Boost Mode: Disabled
- PCI Express ASPM: Max Savings
- USB Selective Suspend: Enabled
- Display Timeout: 3 min
- WiFi Power: Medium Savings


================================================================
DEAKTIVIERTE SERVICES
================================================================

- DiagTrack (Telemetry)
- WSearch (Windows Search Indexer) - auf Manual
- SysMain (Superfetch)
- MapsBroker, RetailDemo
- Xbox Services
- Spooler (Print)
- WbioSrvc (Biometrics)
- TabletInputService (Tablet Input)
- WpcMonSvc (Parental Controls)
- PhoneSvc (Phone Service)
- RemoteRegistry


================================================================
DEEP BATTERY TWEAKS (DeepBatteryTweaks.reg)
================================================================

RAM/CPU Kernel-Level Optimierungen:

- Widgets komplett deaktiviert (entfernt)
- SystemResponsiveness = 0 (100% CPU fuer Vordergrund)
- MMCSS: NoLazyMode, AlwaysOn aus
- DisablePagingExecutive (Kernel im RAM halten)
- Prefetch/Superfetch komplett aus
- NTFS: LastAccessUpdate aus, 8.3 Namen aus

IFEO Prozess-Prioritaeten:
- Teams.exe: Below Normal + Low I/O
- OneDrive.exe: Below Normal + Low I/O
- msedge.exe: Below Normal + Low I/O
- (Terminal NICHT - bleibt performant fuer AI Coding!)


================================================================
ENERGY SAVER (EnergySaverAlwaysOn.reg)
================================================================

- Energy Saver permanent aktiviert (100% Threshold)
- EcoModeState = 1 (System-wide Efficiency Mode)


================================================================
DEV TOOLS OPTIMIERUNG
================================================================

VS Code (settings.json):
- TypeScript Server Memory: 512MB max
- Telemetrie: aus
- Auto-Updates: aus
- Git Auto-Refresh/Fetch: aus
- npm Auto-Detect: aus

IFEO (DevToolsEfficiency.reg):
- Code.exe: Below Normal Priority
- node.exe: Below Normal Priority
- Electron.exe: Below Normal Priority
- Antigravity.exe: Below Normal Priority

Environment:
- NODE_OPTIONS=--max-old-space-size=256

Windows Defender Exclusions:
- C:\dev
- C:\Users\abtel\Projekte
- node_modules Ordner


================================================================
ERGEBNIS
================================================================

Vorher (Stock):
- 2-3h Battery
- 45W Verbrauch
- Heiss & laut

Nachher (Snapdragon+ Profil):
- 10-15h Battery (geschaetzt)
- 8W Verbrauch
- Kuehl & leise
- Trotzdem smooth 165Hz UI!

================================================================
