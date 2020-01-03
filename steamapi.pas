unit SteamAPI;

interface

uses
  CTypes, Classes, SysUtils;

const
  SteamLib = 'steam_api64';

{$ifdef UNIX}
  {$define extdecl := cdecl}
{$endif}

{$ifdef MSWINDOWS}
  {$define extdecl := stdcall}
{$endif}

type
  TSteamAPIWarningMessageHook = procedure (nSeverity: Integer; pchDebugText: PAnsiChar); extdecl;

function SteamAPI_Init(): CBool; extdecl; external SteamLib;
procedure SteamAPI_Shutdown(); extdecl; external SteamLib;
function SteamAPI_RestartAppIfNecessary(): CBool; extdecl; external SteamLib;

// Interface routines (translated from steamworks_sdk_146/sdk/public/steam/steam_api_flat.h)

function SteamAPI_ISteamUserStats_SetAchievement(InstancePtr: Pointer; pchName: PAnsiChar): CBool; extdecl; external SteamLib;
function SteamAPI_ISteamUtils_GetAppID(InstancePtr: Pointer): CUInt32; extdecl; external SteamLib;
function SteamAPI_ISteamUser_BLoggedOn(InstancePtr: Pointer): CBool; extdecl; external SteamLib;
procedure SteamAPI_ISteamClient_SetWarningMessageHook(InstancePtr: Pointer; pFunction: TSteamAPIWarningMessageHook); extdecl; external SteamLib;

implementation

end.
