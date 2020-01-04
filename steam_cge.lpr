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
  CastleWindow, CastleApplicationProperties, CastleLog, CastleStringUtils, CastleNotifications,
  CastleUIControls,
  SteamApi;

var
  Window: TCastleWindowBase;
  Notifications: TCastleNotifications;
  SteamWorking: Boolean;

procedure SteamInitialize;
var
  SteamClientPtr, SteamUtilsPtr, SteamUserPtr: Pointer;
  SteamUser: THSteamUser;
  SteamPipe: THSteamPipe;
  LoginSuccessfull: Boolean;
begin
  { I'm not exactly sure if it is correct to init Steam API here.
    "The way this overlay works is by hooking into OpenGL functionality.
    This means that in order for the overlay rendering to work correctly,
    SteamAPI_Init must be called before any rendering initalization."
    This is a quote from "Multiplayer Game Programming: Architecting Networked Games"
    but for some reason I was sure I read something like this in the documentation
    (couldn't find the source now, so maybe I'm wrong)
    Anyway, Steam overlay works for me when initialized this way,
    so it should be fine for now }
  SteamWorking := SteamAPI_Init();

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

    Notifications.Show(Format('Steam App ID: %d', [SteamAPI_ISteamUtils_GetAppID(SteamUtilsPtr)]));
    LoginSuccessfull := SteamAPI_ISteamUser_BLoggedOn(SteamUserPtr);
    Notifications.Show(Format('Steam login successfull: %s', [BoolToStr(LoginSuccessfull, true)]));
  end;
end;

procedure ApplicationInitialize;
begin
  Notifications := TCastleNotifications.Create(Application);
  Notifications.Anchor(hpMiddle);
  Notifications.Anchor(vpMiddle);
  Notifications.TextAlignment := hpMiddle; // looks best, when anchor is also in the middle
  Notifications.MaxMessages := 20;
  Notifications.Timeout := 20000;
  Window.Controls.InsertFront(Notifications);

  SteamInitialize;
end;

begin
  ApplicationProperties.ApplicationName := 'cge_steam_test';
  InitializeLog;

  { Initializing Steam before OpenGL context is created works too.
    However, it's less user-friendly (doing it in ApplicationInitialize
    means that we show "loading" screen when doing it). }
  // SteamInitialize;

  Window := TCastleWindowBase.Create(Application);
  Application.OnInitialize := @ApplicationInitialize;
  Window.OpenAndRun;

  if SteamWorking then
    SteamAPI_Shutdown();
end.
