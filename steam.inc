{$macro on}
{$ifdef UNIX}
  {$define steam_call := cdecl}
{$endif}
{$ifdef MSWINDOWS}
  {$define steam_call := cdecl}
{$endif}
