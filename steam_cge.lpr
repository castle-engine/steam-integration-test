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

{$I steam.inc}

uses
  SysUtils, Classes,
  CastleWindow, CastleApplicationProperties, CastleLog, CastleStringUtils, CastleNotifications,
  CastleUIControls,
  SteamApi, SteamCallback;

const
  AchievementString: AnsiString = 'ACH_WIN_ONE_GAME';

type
  TSteamManager = class(TComponent)
  public
    Ready: Boolean;
    procedure OnUserStats(Answer: Pointer);
  end;

procedure TSteamManager.OnUserStats(Answer: Pointer);
begin
  Ready := true;
  WriteLnLog('TSteamManager.OnUserStats callback received!');
end;

var
  Window: TCastleWindowBase;
  Notifications: TCastleNotifications;
  SteamWorking: Boolean;
  SteamManager: TSteamManager;
  CallbackDispatcher: SteamCallbackDispatcher;
  GameOverlayActivatedDispatcher: SteamCallbackDispatcher;
  SteamClientPtr, SteamUtilsPtr, SteamUserPtr, SteamUserStatsPtr: Pointer;

procedure DoUpdate(Container: TUiContainer);
var
  AchReceived: Boolean;
  AchNamePtr: PAnsiChar;
  AchName: AnsiChar;
begin
  if SteamWorking then
  begin
    SteamAPI_RunCallbacks();
    if SteamAPI_ISteamUserStats_GetAchievement(SteamUserStatsPtr, @AchievementString, AchReceived) then
      WriteLnLog('Achievement received without callback!');
    //AchNamePtr := SteamAPI_ISteamUserStats_GetAchievementName(SteamUserStatsPtr, 0);
    {if AchNamePtr <> nil then
      WriteLnLog(AchNamePtr^);}
  end;
end;

procedure SteamWarning(nSeverity: Integer; pchDebugText: PAnsiChar); steam_call;
begin
  WritelnWarning('Steam', pchDebugText);
end;

procedure SteamInitialize;
var
  SteamUser: THSteamUser;
  SteamPipe: THSteamPipe;
  LoginSuccessfull: Boolean;
begin
  { Eugene notes: I'm not exactly sure if it is correct to init Steam API here.
    "The way this overlay works is by hooking into OpenGL functionality.
    This means that in order for the overlay rendering to work correctly,
    SteamAPI_Init must be called before any rendering initalization."
    This is a quote from "Multiplayer Game Programming: Architecting Networked Games"
    but for some reason I was sure I read something like this in the documentation
    (couldn't find the source now, so maybe I'm wrong)
    Anyway, Steam overlay works for me when initialized this way,
    so it should be fine for now

    TODO: Remove this comment in the final version, decide one way or another. }
  SteamWorking := SteamAPI_Init();

  {if SteamAPI_RestartAppIfNecessary() then
  begin
    WriteLnLog('The app was run through exe - restarting through Steam. DRM will do this automatically.');
    Halt(0);
  end else
    WriteLnLog('The Steam client is running and no restart is necessary');}

  if SteamWorking then
  begin
    WriteLnLog('Steam is working!');

    SteamClientPtr := SteamInternal_CreateInterface(STEAMCLIENT_INTERFACE_VERSION);
    if SteamClientPtr = nil then
      raise Exception.Create('Cannot get SteamClient pointer');

    SteamAPI_ISteamClient_SetWarningMessageHook(SteamClientPtr, @SteamWarning);

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

    SteamUser := SteamAPI_ISteamUser_GetHSteamUser(SteamUserPtr);
    SteamUserPtr := SteamAPI_ISteamClient_GetISteamUser(SteamClientPtr, SteamUser, SteamPipe, STEAMUSER_INTERFACE_VERSION);
    WriteLnLog('SteamAPI_ISteamUser_GetSteamID', IntToStr(SteamAPI_ISteamUser_GetSteamID(SteamUserPtr)));

    Notifications.Show(Format('Steam App ID: %d', [SteamAPI_ISteamUtils_GetAppID(SteamUtilsPtr)]));
    LoginSuccessfull := SteamAPI_ISteamUser_BLoggedOn(SteamUserPtr);
    Notifications.Show(Format('Steam login successfull: %s', [BoolToStr(LoginSuccessfull, true)]));

    SteamUserStatsPtr := SteamAPI_ISteamClient_GetISteamUserStats(SteamClientPtr, SteamUser, SteamPipe, STEAMUSER_INTERFACE_VERSION);

    SteamManager := TSteamManager.Create(Window);
    CallbackDispatcher := SteamCallbackDispatcher.Create(k_iSteamUserStatsCallbacks + 1, @SteamManager.OnUserStats, SizeOf(Steam_UserStatsReceived));

    GameOverlayActivatedDispatcher := SteamCallbackDispatcher.Create(k_iSteamFriendsCallbacks + 31, @SteamManager.OnUserStats, SizeOf(Steam_GameOverlayActivated));

    if SteamAPI_ISteamUserStats_RequestCurrentStats(SteamUserStatsPtr) then
      WriteLnLog('Requested user stats and achievements, waiting for callback...');
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

  Window.OnUpdate := @DoUpdate;
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

  FreeAndNil(CallbackDispatcher);
  if SteamWorking then
    SteamAPI_Shutdown();
end.
