######################################################################
## (C) 2018 Michael Miklis (michaelmiklis.de)
##
##
## Filename:      Get-ProcessLaunchTime.ps1
##
## Version:       1.0
##
## Release:       Final
##
## Requirements:  -none-
##
## Description:   Measure the time until the main window is being displayed
##
## This script is provided 'AS-IS'.  The author does not provide
## any guarantee or warranty, stated or implied.  Use at your own
## risk. You are free to reproduce, copy & modify the code, but
## please give the author credit.
##
####################################################################
Set-PSDebug -Strict
Set-StrictMode -Version latest

function Get-ProcessLaunchTime
{
    <#
        .SYNOPSIS
        Measure the time until the main window is being displayed
  
        .DESCRIPTION
        The Get-ProcessLaunchTime CMDlet starts a process and waits
        until the specified main window is being displayed.
  
        .PARAMETER ProcessName
        Process commandline
  
        .PARAMETER ProcessArguments
        Commandline arguments for process
 
        .PARAMETER MainWindowName
        Name of the Main Window to wait for
  
        .EXAMPLE
        Get-ProcessLaunchTime -ProcessName "winword.exe" -MainWindowName "Word"
    #>

    param (
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()][string]$ProcessName,
        [parameter(Mandatory=$false)]
        [string]$ProcessArguments,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()][string]$MainWindowName
    )

    # Start stopwatch
    $Stopwatch = [Diagnostics.Stopwatch]::StartNew()

    # Start process to monitor
    $Process = [diagnostics.process]::start($ProcessName, $ProcessArguments)

    $Process.WaitForInputIdle();

    $count = 0
    $timeout = 100000

    do
    {
        # Get main windows title
        $WndTitle = $Process.MainWindowTitle

        # Refresh process data for next loop
        $Process.Refresh()

        # wait 100ms 
        Start-Sleep -Milliseconds 100

        $count++;
    } while (($WndTitle -ne $MainWindowName) -or ($count -gt $timeout))

    # Stop Stopwatch
    $Stopwatch.Stop()

    # Write time elapsed
    Write-Host $Stopwatch.Elapsed
}

Get-ProcessLaunchTime -ProcessName "winword.exe" -MainWindowName "Word"