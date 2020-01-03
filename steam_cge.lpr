program steam_cge;

{.$apptype GUI}

uses
  SysUtils,
  CastleWindow, CastleApplicationProperties, CastleLog, CastleStringUtils,
  SteamApi;

var
  Window: TCastleWindowBase;
  SteamWorking: Boolean;

procedure DoInitialize;
var
  { TODO: These should probably be internal variables within SteamApi, and wrapped by accessors. }
  SteamUtilsPtr, SteamUserPtr: Pointer;
begin
  if SteamWorking then
  begin
    WriteLnLog('Steam is working!');

    SteamUtilsPtr := SteamInternal_CreateInterface(STEAMUTILS_INTERFACE_VERSION);
    WriteLnLog('SteamUtilsPtr %s', [PointerToStr(SteamUtilsPtr)]);

    SteamUserPtr := SteamInternal_CreateInterface(STEAMUSER_INTERFACE_VERSION);
    WriteLnLog('SteamUserPtr %s', [PointerToStr(SteamUserPtr)]);

    WriteLnLog('Steam App ID: %d', [SteamAPI_ISteamUtils_GetAppID(SteamUtilsPtr)]);
    if SteamAPI_ISteamUser_BLoggedOn(SteamUserPtr) then
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
