program steam_cge;

{.$apptype GUI}

uses
  SysUtils,
  CastleWindow, CastleApplicationProperties, CastleLog, SteamApi;

var
  Window: TCastleWindowBase;
  SteamWorking: Boolean;

procedure DoInitialize;
var
  InstancePtr: Pointer;
begin
  if SteamWorking then
  begin
    WriteLnLog('Steam is working!');
    InstancePtr := nil; // TODO
    WriteLnLog('Steam App ID: %d', [SteamAPI_ISteamUtils_GetAppID(InstancePtr)]);
    if SteamAPI_ISteamUser_BLoggedOn(InstancePtr) then
      WriteLnLog('Login successful');
  end;
end;

begin
  ApplicationProperties.ApplicationName := 'cge_steam_test';
  InitializeLog;
  SteamWorking := SteamAPI_Init();
  Window := TCastleWindowBase.Create(Application);
  Application.OnInitialize := @DoInitialize;
  Window.OpenAndRun;
  SteamAPI_Shutdown();
end.
