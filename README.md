# shipbreaker-shift-mod
This is a mod for the game Hardspace: Shipbreaker that changes the value of the shift timer.

To use the mod, you must open Windows PowerShell and run the script.

For example, to change the shift time from the default of 15 minutes to 30 minutes,
you would run the Powershell script like this:

    .\Change-Shipbreaker-ShiftTime.ps1 -ShiftMinutes 30

When the time is changed, a backup of the original game file is made.
If you would like to restore the backup, so that you are using the original game file,
you would run the PowerShell script like this:

    .\Change-Shipbreaker-ShiftTime.ps1 -RestoreBackup $true