# Team Fortress 2 "tf" directory
$tfdir = "B:\Steam\steamapps\common\Team Fortress 2\tf"

Function Install-Config {
    # Check directories are there
    if ( -not (Test-Path -PathType Container "$tfdir\cfg")) {
        Write-Error "'$tfdir\cfg' not a directory!"
        Return
    }
    if ( -not (Test-Path -PathType Container ".\cfg")) {
        Write-Error "'.\cfg' not a directory!"
        Return
    }

    # Remove config
    if (Test-Path -PathType Container "$tfdir\cfg\auto") {
        Remove-Item -Verbose -Recurse -Path "$tfdir\cfg\auto"
    }
    if (Test-Path -PathType Leaf "$tfdir\cfg\autoexec.cfg") {
        Remove-Item -Verbose -Path "$tfdir\cfg\autoexec.cfg"
    }

    # Copy config over
    Copy-Item -Verbose -Recurse -Path ".\cfg\auto" -Destination "$tfdir\cfg\"
    Copy-Item -Verbose -Path ".\cfg\autoexec.cfg" -Destination "$tfdir\cfg\"

    # Install tr_walkway
    Write-Host "Installing map: tr_walkway."

    Copy-Item -Verbose -Path ".\tr_walkway_rc2\tr_walkway_rc2.bsp" -Destination "$tfdir\maps"
    if ( -not (Test-Path -PathType Container "$tfdir\cfg\tr_walkway") ) {
        New-Item  -Verbose -ItemType Directory -Path "$tfdir\cfg\tr_walkway"
    }
    Copy-Item -Verbose -Path ".\tr_walkway_rc2\botmaxconfig.cfg" -Destination "$tfdir\cfg\tr_walkawy"

    # Install Hitsounds
    Write-Host "Installing hitsounds."
    if (Test-Path -PathType Container "$tfdir\custom\hitsounds\sound") {
        Remove-Item -Verbose -Recurse -Path "$tfdir\custom\hitsounds"
    }
    New-Item  -Verbose -ItemType Directory -Path "$tfdir\custom\hitsounds\sound"
    Copy-Item -Verbose -Recurse -Path ".\hitsound\ui" -Destination "$tfdir\custom\hitsounds\sound\"
    Copy-Item -Verbose -Recurse -Path ".\hitsound\player" -Destination "$tfdir\custom\hitsounds\sound\"

    # Apply hudlayout.res changes
    $hlrFile = "$tfdir\custom\eve hud\scripts\hudlayout.res"
    if (Test-Path -PathType Leaf "$hlrFile") {
        Write-Host "Found Eve Hud, applying HudDamageIndicator changes."

        $ex = "(?ms)(HudDamageIndicator.*?{.*?})"
        $newText = Get-Content ".\hud\hudlayout.res" -Raw
        $fileContent = (Get-Content "$hlrFile" -Raw) -replace $ex,$newText
        Set-Content -Verbose -Path "$hlrFile" -Value $fileContent
    }
}

Install-Config
Read-Host -Prompt "Finished execution, press Enter"
