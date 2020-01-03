{
  Copyright 2020-2020 Eugene Loza, Michalis Kamburelis.

  This file is part of "Castle Game Engine".

  "Castle Game Engine" is free software; see the file COPYING.txt,
  included in this distribution, for details about the copyright.

  "Castle Game Engine" is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

  ----------------------------------------------------------------------------
}

{ Example using Steamworks API. }
program steam_cge;

{ This adds icons and version info for Windows,
  automatically created by "castle-engine compile". }
{$ifdef CASTLE_AUTO_GENERATED_RESOURCES} {$R castle-auto-generated-resources.res} {$endif}

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
  SteamClientPtr, SteamUtilsPtr, SteamUserPtr: Pointer;
  SteamUser: THSteamUser;
  SteamPipe: THSteamPipe;
  LoginSuccessfull: Boolean;
begin
  if SteamWorking then
  begin
    WriteLnLog('Steam is working!');

    SteamClientPtr := SteamInternal_CreateInterface(STEAMCLIENT_INTERFACE_VERSION);
    if SteamClientPtr = nil then
      raise Exception.Create('Cannot get SteamClient pointer');

    SteamPipe := SteamAPI_ISteamClient_CreateSteamPipe(SteamClientPtr);

    SteamUtilsPtr := SteamAPI_ISteamClient_GetISteamUtils(SteamClientPtr, SteamPipe, STEAMUTILS_INTERFACE_VERSION);
    // This SteamInternal_CreateInterface will return nil, you need to use SteamAPI_ISteamClient_GetISteamUtils instead
    //SteamUtilsPtr := SteamInternal_CreateInterface(STEAMUTILS_INTERFACE_VERSION);

    if SteamUtilsPtr = nil then
      raise Exception.Create('Cannot get SteamUtils pointer');

    SteamUser := SteamAPI_ISteamClient_ConnectToGlobalUser(SteamClientPtr, SteamPipe);

    SteamUserPtr := SteamAPI_ISteamClient_GetISteamUser(SteamClientPtr, SteamUser, SteamPipe, STEAMUSER_INTERFACE_VERSION);

    // This SteamInternal_CreateInterface will return nil, you need to use SteamAPI_ISteamClient_GetISteamUser instead
    // SteamUserPtr := SteamInternal_CreateInterface(STEAMUSER_INTERFACE_VERSION);
    if SteamUserPtr = nil then
      raise Exception.Create('Cannot get SteamUser pointer');

    WriteLnLog('Steam App ID: %d', [SteamAPI_ISteamUtils_GetAppID(SteamUtilsPtr)]);
    LoginSuccessfull := SteamAPI_ISteamUser_BLoggedOn(SteamUserPtr);
    WriteLnLog('Steam login successfull: %s', [BoolToStr(LoginSuccessfull, true)]);
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
