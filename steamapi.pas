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

{$macro on}

{$ifdef UNIX}
  {$define extdecl := cdecl}
{$endif}
{$ifdef MSWINDOWS}
  {$define extdecl := cdecl}
{$endif}

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

type
  TSteamAPIWarningMessageHook = procedure (nSeverity: Integer; pchDebugText: PAnsiChar); extdecl;
  THSteamPipe = CInt32;
  THSteamUser = CInt32;

function SteamAPI_Init(): CBool; extdecl; external SteamLib;
procedure SteamAPI_Shutdown(); extdecl; external SteamLib;
function SteamAPI_RestartAppIfNecessary(): CBool; extdecl; external SteamLib;

{ Needed to get InstancePtr for SteamAPI_Ixxx functions.
  As ver, pass one of xxx_INTERFACE_VERSION constants.
  Thanks to https://www.pascalgamedevelopment.com/showthread.php?32674-Steam-wrapper-exploring-options }
function SteamInternal_CreateInterface(ver: PAnsiChar): Pointer; extdecl; external SteamLib;

// Interface routines (translated from steamworks_sdk_146/sdk/public/steam/steam_api_flat.h).

function SteamAPI_ISteamClient_GetISteamUtils(InstancePtr: Pointer; hSteamPipe: THSteamPipe; pchVersion: PAnsiChar): Pointer; extdecl; external SteamLib;
function SteamAPI_ISteamClient_CreateSteamPipe(InstancePtr: Pointer): THSteamPipe; extdecl; external SteamLib;
procedure SteamAPI_ISteamClient_SetWarningMessageHook(InstancePtr: Pointer; pFunction: TSteamAPIWarningMessageHook); extdecl; external SteamLib;
function SteamAPI_ISteamClient_ConnectToGlobalUser(InstancePtr: Pointer; hSteamPipe: THSteamPipe): THSteamUser; extdecl; external SteamLib;
function SteamAPI_ISteamClient_GetISteamUser(InstancePtr: Pointer; hSteamUser: THSteamUser; hSteamPipe: THSteamPipe; pchVersion: PAnsiChar): Pointer; extdecl; external SteamLib;

function SteamAPI_ISteamUserStats_SetAchievement(InstancePtr: Pointer; pchName: PAnsiChar): CBool; extdecl; external SteamLib;
function SteamAPI_ISteamUserStats_RequestCurrentStats(InstancePtr: Pointer): CBool; extdecl; external SteamLib;

function SteamAPI_ISteamUtils_GetAppID(InstancePtr: Pointer): CUInt32; extdecl; external SteamLib;

function SteamAPI_ISteamUser_BLoggedOn(InstancePtr: Pointer): CBool; extdecl; external SteamLib;

implementation

end.
