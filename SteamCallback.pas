{ Copyright 2014-2015 Relfos
  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
}
Unit SteamCallback;

{$I steam.inc}

Interface

Uses SteamAPI;

{copy from Relfos.SteamApi }
type
  SteamID = UInt64;
  PSteamID = ^SteamID;
  SteamAppID = Cardinal;
  PSteamAppID = ^SteamAppID;
  SteamAccountID = Cardinal;
  PSteamAccountID = ^SteamAccountID;
  SteamDepotID = Cardinal;
  PSteamDepotID = ^SteamDepotID;
  SteamGameID = UInt64;
  PSteamGameID = ^SteamGameID;
  SteamAPICall = UInt64;
  PSteamAPICall = ^SteamAPICall;
  SteamPublishedFileId = UInt64;
  PSteamPublishedFileId = ^SteamPublishedFileId;
  SteamSNetSocket = Cardinal;
  PSteamSNetSocket = ^SteamSNetSocket;
  SteamSNetListenSocket = Cardinal;
  PSteamSNetListenSocket = ^SteamSNetListenSocket;
  SteamLeaderboard = UInt64;
  PSteamLeaderboard = ^SteamLeaderboard;
  SteamLeaderboardEntries = UInt64;
  PSteamLeaderboardEntries = ^SteamLeaderboardEntries;

  SteamPipeHandle = Integer;
  SteamUserHandle = Integer;
  SteamAuthTicketHandle = Integer;
  SteamHTTPRequestHandle = Integer;
  SteamHTMLBrowserHandle = Integer;
  SteamServerListRequestHandle = Integer;
  SteamServerQueryHandle = Integer;
  SteamUGCHandle = Integer;
  SteamUGCUpdateHandle = Integer;
  SteamUGCQueryHandle = Integer;
  SteamUGCFileWriteStreamHandle = Integer;
  SteamPublishedFileUpdateHandle = Integer;
  SteamScreenshotHandle = Integer;
  SteamClientUnifiedMessageHandle = Integer;

  SteamResult = Cardinal;


Const
  SteamStatsCallbackID = k_iSteamUserStatsCallbacks + 1;
  SteamLeaderboardCallbackID = k_iSteamUserStatsCallbacks + 5;

Type
  PSteam_UserStatsReceived = ^Steam_UserStatsReceived;
  Steam_UserStatsReceived = Packed Record
		GameID:SteamGameID;		      // Game these stats are for
		Result:SteamResult;	  // Success / error fetching the stats
		steamID:SteamID;	// The user for whom the stats are retrieved for
	End;

  PSteam_LeaderboardScoresDownloaded = ^Steam_LeaderboardScoresDownloaded;
	Steam_LeaderboardScoresDownloaded = Packed Record
		LeaderboardID:SteamLeaderboard;
		LeaderboardEntries:SteamLeaderboardEntries;	// the handle to pass into GetDownloadedLeaderboardEntries()
		EntryCount:Integer; // the number of entries downloaded
  End;

  PCCallbackBaseVTable = ^TCCallbackBaseVTable;
  TCCallbackBaseVTable = Record
    Run,
    Run_2,
    GetCallbackSizeBytes: pointer;
  End;

  SteamCallbackDispatcher = Class;

  PCCallbackInt = ^TCCallbackInt;
  TCCallbackInt = Record
    vtable:Pointer;
    _nCallbackFlags: byte;
    _iCallback: integer;
    _Dispatcher:SteamCallbackDispatcher;
  End;

  SteamCallbackDelegate = Procedure(answer:Pointer) of Object;

  SteamCallbackDispatcher = Class
    Private
      _SteamInterface: TCCallbackInt;
      _Callback: SteamCallbackDelegate;
      _PropSize: Integer;
      _CallbackID:Integer;

    Public
      Constructor Create(iCallback:integer; CallbackProc:SteamCallbackDelegate; A_propsize:integer); Reintroduce;
      Destructor Destroy; Override;
  End;


Implementation

uses CastleLog;

{ TSteamCallback }

Var
  MyCallbackVTable: TCCallbackBaseVTable;

Procedure MySteamCallback_Run(pvParam: Pointer; pSelf: PCCallbackInt); steam_call;
Begin
  WritelnLog('MySteamCallback_Run');
  pSelf^._Dispatcher._Callback(Pointer(pvParam));
End;

Procedure MySteamCallback_Run_2(myself, pvParam: PCCallbackInt); steam_call;
Begin
  WritelnLog('MySteamCallback_Run_2');
  Myself^._Dispatcher._Callback(Pointer(pvParam));
End;

Function MySteamCallback_GetCallbackSizeBytes(myself: PCCallbackInt):Integer; steam_call;
Begin
  WritelnLog('MySteamCallback_GetCallbackSizeBytes');
  Result := Myself^._Dispatcher._PropSize;
End;

Constructor SteamCallbackDispatcher.Create(iCallback:integer; callbackProc:SteamCallbackDelegate; A_propsize: integer);
Begin
  inherited Create;
  _CallbackID := iCallback;
  _Callback := callbackProc;
  _PropSize := A_propsize;

  _SteamInterface.vtable := @MyCallbackVTable;
  _SteamInterface._nCallbackFlags := 0;
  _SteamInterface._iCallback := 0;
  _SteamInterface._Dispatcher := Self;

  SteamAPI_RegisterCallback(@_SteamInterface, _CallbackID);
End;

Destructor SteamCallbackDispatcher.Destroy;
Begin
  SteamAPI_UnregisterCallback(@_SteamInterface);
  inherited;
End;

Initialization
  MyCallbackVTable.Run := @MySteamCallback_Run;
  MyCallbackVTable.Run_2 := @MySteamCallback_Run_2;
  MyCallbackVTable.GetCallbackSizeBytes := @MySteamCallback_GetCallbackSizeBytes;
End.
