param(
    [string]$Lua = $env:VANADIELHDUI_LUA
)

$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot

if ([string]::IsNullOrWhiteSpace($Lua)) {
    $candidate = Get-Command luajit -ErrorAction SilentlyContinue
    if ($null -eq $candidate) {
        $candidate = Get-Command lua -ErrorAction SilentlyContinue
    }
    if ($null -eq $candidate) {
        $scoopLuaJit = Join-Path $env:USERPROFILE 'scoop\shims\luajit.exe'
        if (Test-Path -LiteralPath $scoopLuaJit) {
            $Lua = $scoopLuaJit
        }
    }
    if ($null -eq $candidate) {
        if ([string]::IsNullOrWhiteSpace($Lua)) {
            throw 'LuaJIT/Lua was not found. Pass -Lua <path> or set VANADIELHDUI_LUA.'
        }
    }
    else {
        $Lua = $candidate.Source
    }
}

& $Lua (Join-Path $repo 'tests\run.lua')
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}
