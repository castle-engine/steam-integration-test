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

{ Steamworks API, see https://partner.steamgames.com/doc/sdk/api .
  TODO: rename to CastleInternalSteam. }
unit SteamAPI;

interface

{$I steam.inc}

uses
  Classes, SysUtils, CTypes;

const
  SteamLib =
    {$if defined(MSWINDOWS) and defined(CPUX86_64)}
    'steam_api64'
    {$else}
    'steam_api'
    {$endif}
  ;

  STEAMCLIENT_INTERFACE_VERSION = 'SteamClient019';
  STEAMCONTROLLER_INTERFACE_VERSION = 'SteamController007';
  STEAMFRIENDS_INTERFACE_VERSION = 'SteamFriends017';
  STEAMGAMECOORDINATOR_INTERFACE_VERSION = 'SteamGameCoordinator001';
  STEAMGAMESERVER_INTERFACE_VERSION = 'SteamGameServer012';
  STEAMGAMESERVERSTATS_INTERFACE_VERSION = 'SteamGameServerStats001';
  STEAMHTTP_INTERFACE_VERSION = 'STEAMHTTP_INTERFACE_VERSION003';
  STEAMMATCHMAKING_INTERFACE_VERSION = 'SteamMatchMaking009';
  STEAMMATCHMAKINGSERVERS_INTERFACE_VERSION = 'SteamMatchMakingServers002';
  STEAMGAMESEARCH_INTERFACE_VERSION = 'SteamMatchGameSearch001';
  STEAMPARTIES_INTERFACE_VERSION = 'SteamParties002';
  STEAMINVENTORY_INTERFACE_VERSION = 'STEAMINVENTORY_INTERFACE_V003';
  STEAMHTMLSURFACE_INTERFACE_VERSION = 'STEAMHTMLSURFACE_INTERFACE_VERSION_005';
  STEAMINPUT_INTERFACE_VERSION = 'SteamInput001';
  STEAMMUSIC_INTERFACE_VERSION = 'STEAMMUSIC_INTERFACE_VERSION001';
  STEAMNETWORKING_INTERFACE_VERSION = 'SteamNetworking005';
  STEAMMUSICREMOTE_INTERFACE_VERSION = 'STEAMMUSICREMOTE_INTERFACE_VERSION001';
  STEAMNETWORKINGSOCKETS_INTERFACE_VERSION = 'SteamNetworkingSockets004';
  STEAMPARENTALSETTINGS_INTERFACE_VERSION = 'STEAMPARENTALSETTINGS_INTERFACE_VERSION001';
  STEAMNETWORKINGUTILS_INTERFACE_VERSION = 'SteamNetworkingUtils002';
  STEAMREMOTEPLAY_INTERFACE_VERSION = 'STEAMREMOTEPLAY_INTERFACE_VERSION001';
  STEAMSCREENSHOTS_INTERFACE_VERSION = 'STEAMSCREENSHOTS_INTERFACE_VERSION003';
  STEAMREMOTESTORAGE_INTERFACE_VERSION = 'STEAMREMOTESTORAGE_INTERFACE_VERSION014';
  STEAMUSER_INTERFACE_VERSION = 'SteamUser020';
  STEAMUGC_INTERFACE_VERSION = 'STEAMUGC_INTERFACE_VERSION013';
  STEAMUSERSTATS_INTERFACE_VERSION = 'STEAMUSERSTATS_INTERFACE_VERSION011';
  STEAMUTILS_INTERFACE_VERSION = 'SteamUtils009';
  STEAMVIDEO_INTERFACE_VERSION = 'STEAMVIDEO_INTERFACE_V002';

  k_iSteamUserCallbacks = 100;
  k_iSteamGameServerCallbacks = 200;
  k_iSteamFriendsCallbacks = 300;
  k_iSteamBillingCallbacks = 400;
  k_iSteamMatchmakingCallbacks = 500;
  k_iSteamContentServerCallbacks = 600;
  k_iSteamUtilsCallbacks = 700;
  k_iClientFriendsCallbacks = 800;
  k_iClientUserCallbacks = 900;
  k_iSteamAppsCallbacks = 1000;
  k_iSteamUserStatsCallbacks = 1100;
  k_iSteamNetworkingCallbacks = 1200;
  k_iClientRemoteStorageCallbacks = 1300;
  k_iClientDepotBuilderCallbacks = 1400;
  k_iSteamGameServerItemsCallbacks = 1500;
  k_iClientUtilsCallbacks = 1600;
  k_iSteamGameCoordinatorCallbacks = 1700;
  k_iSteamGameServerStatsCallbacks = 1800;
  k_iSteam2AsyncCallbacks = 1900;
  k_iSteamGameStatsCallbacks = 2000;
  k_iClientHTTPCallbacks = 2100;
  k_iClientScreenshotsCallbacks = 2200;
  k_iSteamScreenshotsCallbacks = 2300;
  k_iClientAudioCallbacks = 2400;
  k_iClientUnifiedMessagesCallbacks = 2500;
  k_iSteamStreamLauncherCallbacks = 2600;
  k_iClientControllerCallbacks = 2700;
  k_iSteamControllerCallbacks = 2800;
  k_iClientParentalSettingsCallbacks = 2900;
  k_iClientDeviceAuthCallbacks = 3000;
  k_iClientNetworkDeviceManagerCallbacks = 3100;
  k_iClientMusicCallbacks = 3200;
  k_iClientRemoteClientManagerCallbacks = 3300;
  k_iClientUGCCallbacks = 3400;
  k_iSteamStreamClientCallbacks = 3500;
  k_IClientProductBuilderCallbacks = 3600;
  k_iClientShortcutsCallbacks = 3700;
  k_iClientRemoteControlManagerCallbacks = 3800;
  k_iSteamAppListCallbacks = 3900;
  k_iSteamMusicCallbacks = 4000;
  k_iSteamMusicRemoteCallbacks = 4100;
  k_iClientVRCallbacks = 4200;
  k_iClientReservedCallbacks = 4300;
  k_iSteamReservedCallbacks = 4400;
  k_iSteamHTMLSurfaceCallbacks = 4500;
  k_iClientVideoCallbacks = 4600;

type
  TSteamAPIWarningMessageHook = procedure (nSeverity: Integer; pchDebugText: PAnsiChar); steam_call;
  THSteamPipe = CInt32;
  THSteamUser = CInt32;

function SteamAPI_Init(): CBool; steam_call; external SteamLib;
procedure SteamAPI_Shutdown(); steam_call; external SteamLib;
function SteamAPI_RestartAppIfNecessary(): CBool; steam_call; external SteamLib;

{ Needed to get InstancePtr for SteamAPI_Ixxx functions.
  As ver, pass one of xxx_INTERFACE_VERSION constants.
  Thanks to https://www.pascalgamedevelopment.com/showthread.php?32674-Steam-wrapper-exploring-options }
function SteamInternal_CreateInterface(ver: PAnsiChar): Pointer; steam_call; external SteamLib;

// Interface routines (translated from steamworks_sdk_146/sdk/public/steam/steam_api_flat.h).

function SteamAPI_ISteamClient_GetISteamUtils(InstancePtr: Pointer; hSteamPipe: THSteamPipe; pchVersion: PAnsiChar): Pointer; steam_call; external SteamLib;
function SteamAPI_ISteamClient_CreateSteamPipe(InstancePtr: Pointer): THSteamPipe; steam_call; external SteamLib;
procedure SteamAPI_ISteamClient_SetWarningMessageHook(InstancePtr: Pointer; pFunction: TSteamAPIWarningMessageHook); steam_call; external SteamLib;
function SteamAPI_ISteamClient_ConnectToGlobalUser(InstancePtr: Pointer; hSteamPipe: THSteamPipe): THSteamUser; steam_call; external SteamLib;
function SteamAPI_ISteamClient_GetISteamUser(InstancePtr: Pointer; hSteamUser: THSteamUser; hSteamPipe: THSteamPipe; pchVersion: PAnsiChar): Pointer; steam_call; external SteamLib;
function SteamAPI_ISteamClient_GetISteamUserStats(InstancePtr: Pointer; hSteamUser: THSteamUser; hSteamPipe: THSteamPipe; pchVersion: PAnsiChar): Pointer; steam_call; external SteamLib;

function SteamAPI_ISteamUtils_GetAppID(InstancePtr: Pointer): CUInt32; steam_call; external SteamLib;

function SteamAPI_ISteamUserStats_SetAchievement(InstancePtr: Pointer; pchName: PAnsiChar): CBool; steam_call; external SteamLib;
function SteamAPI_ISteamUserStats_GetAchievement(InstancePtr: Pointer; pchName: PAnsiChar; pbAchieved: CBool): CBool; steam_call; external SteamLib;
function SteamAPI_ISteamUserStats_GetAchievementName(InstancePtr: Pointer; iAchievement: CUInt32): PAnsiChar; steam_call; external SteamLib;
function SteamAPI_ISteamUserStats_ClearAchievement(InstancePtr: Pointer; pchName: PAnsiChar): CBool; steam_call; external SteamLib;
function SteamAPI_ISteamUserStats_RequestCurrentStats(InstancePtr: Pointer): CBool; steam_call; external SteamLib;

function SteamAPI_ISteamUser_GetSteamID(InstancePtr: Pointer): CUInt32; steam_call; external SteamLib;
function SteamAPI_ISteamUser_BLoggedOn(InstancePtr: Pointer): CBool; steam_call; external SteamLib;

procedure SteamAPI_RunCallbacks(); external SteamLib;
procedure SteamAPI_RegisterCallback(pCallback: Pointer; iCallback: Integer); steam_call; external SteamLib;
procedure SteamAPI_UnregisterCallback(pCallback: Pointer); steam_call; external SteamLib;

implementation

end.
