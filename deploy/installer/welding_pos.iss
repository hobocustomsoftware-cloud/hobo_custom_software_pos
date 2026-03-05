; Inno Setup - HoBo POS Installer (Windows software style)
; Run setup.exe -> Install -> Ask desktop/start menu shortcuts -> Done. Client uses shortcut.
; Compile: ISCC.exe welding_pos.iss  (or use build_setup.bat from repo root)

#define MyAppName "HoBo POS"
#define MyAppVersion "1.0"
#define MyAppPublisher "HoBo"
#define MyAppURL ""

[Setup]
AppId={{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
OutputDir=dist
OutputBaseFilename=hobo_pos_setup
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=admin
UninstallDisplayIcon={app}\logo.ico

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop shortcut"; GroupDescription: "Additional icons:"
Name: "startmenuicon"; Description: "Create Start &Menu shortcut"; GroupDescription: "Additional icons:"

[Files]
; Install everything in dist (onefile: HoBoPOS.exe + logo.ico; or onedir: full HoBoPOS_Release content)
Source: "dist\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "logo.ico"; DestDir: "{app}"; Flags: ignoreversion
Source: "HoBoPOS.ini.example"; DestDir: "{app}"; DestName: "HoBoPOS.ini"; Flags: ignoreversion

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\HoBoPOS.exe"; IconFilename: "{app}\logo.ico"; Tasks: startmenuicon; Comment: "HoBo POS"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\HoBoPOS.exe"; IconFilename: "{app}\logo.ico"; Tasks: desktopicon; Comment: "HoBo POS"

[Run]
Filename: "{app}\HoBoPOS.exe"; Description: "Launch {#MyAppName}"; Flags: nowait postinstall skipifsilent
