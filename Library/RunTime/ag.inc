//{$DEFINE DEBUG}
//{$DEFINE RX}

{$B-}  // Complete Boolean Evaluation
{$T-}  // Typed @ operator
{$X+}  // Extended syntax
{$P+}  // Open string params
{$J+}  // Writeable structured consts
{$H+}  // Use long strings by default
{$O-}  // Optimization
{$R-}  // Range-Checking
{$V-}  // Var-String Checking

{.$IFDEF DEBUG}
  {.$D+}  // Debug information
  {.$L+}  // Local symbol information
  {.$WARNINGS ON}
  {.$HINTS ON}
{.$ELSE}
  {.$D-}  // Debug information
  {.$L-}  // Local symbol information
  {.$WARNINGS OFF}
  {.$HINTS OFF}
{.$ENDIF}

{$DEFINE D5}   // Delphi 5.0 or higher


