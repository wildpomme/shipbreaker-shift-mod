param (
    [int]$shiftMinutes,
    [bool]$restoreBackup
)

if ( -not $shiftMinutes ) {
    while ( -not $shiftMinutes ) {
        $shiftMinutes = Read-Host -Prompt "Enter in whole minutes how long you would like your shift to last"
    }
}

[single]$shiftSeconds = $shiftMinutes * 60

$shiftRelative = "\Shipbreaker_Data\sharedassets0.assets"
$game = Get-ChildItem HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall | 
ForEach-Object { Get-ItemProperty $_.PsPath } | Where-Object {$_.DisplayName -eq "Hardspace: Shipbreaker"}

$installLocation = $game.InstallLocation

if ($restoreBackup -eq $true) {
    if (Test-Path "$installLocation$shiftRelative.bak") {
        Copy-Item -Path "$installLocation$shiftRelative.bak" -Destination "$installLocation$shiftRelative"
        Remove-Item -Path "$installLocation$shiftRelative.bak"
    }
    else {
        Write-Error "A backup cannot be restored because a backup does not exist."
    }

    exit
}
else {
    if (!(Test-Path "$installLocation$shiftRelative.bak")) {
        Copy-Item -Path "$installLocation$shiftRelative" -Destination "$installLocation$shiftRelative.bak"
    }

    $signal = "43-61-72-65-65-72-4D-6F-64-65-5F-4C-65-76-65-6C-41-73-73-65-74"
    $offset1 = 0x4154570    # updated to 0.1.4.142375
    $offset2 = 0x4154584
    $bytes = [System.IO.File]::ReadAllBytes("$installLocation$shiftRelative")
    $signalTest = [System.BitConverter]::ToString($bytes[$offset1..$offset2])

    if ($signal -eq $signalTest) {
        $shiftOffset = 0x41545C0   # updated to 0.1.4.142375

        $boots = [System.BitConverter]::GetBytes([single]$shiftSeconds)

        for($i = 0; $i -lt 4; $i++) {
            $bytes[$shiftOffset+$i] = $boots[$i]
        }

        [System.IO.File]::WriteAllBytes("$installLocation$shiftRelative", $bytes)
    }
    else {
        Write-Error "The shift time could not be found. The game file must have been changed."
    }

    exit
}
