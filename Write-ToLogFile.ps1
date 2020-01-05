<#
.SYNOPSIS
    Write messages to a log file
.DESCRIPTION
    Write messages to a log file
.PARAMETER Message
    The message you want to have written to the log file
.PARAMETER E
    Define the Message Type as a Error Message
.PARAMETER W
    Define the Message Type as a Warning Message
.PARAMETER I
    Define the Message Type as a Informational Message
    (Default) This is the Default value if you don't specify a MessageType
.PARAMETER D
    Define the Message Type as a Debug Message
.PARAMETER Component
    If you want to have a Component name in your log file, you can specify this parameter
.PARAMETER NoDate
    If NoDate is defined, no date string will be added to the log file
.PARAMETER Show
    Show the Log Entry only to console
.PARAMETER LogFile
    The FileName of your log file.
    (Default) <ScriptRoot>\Log.txt or if $PSScriptRoot is not available .\Log.txt
.PARAMETER Delimiter
    Define your Custom Delimiter of the log file
    (Default) <TAB>
.PARAMETER LogLevel
    The FileName of your log file
.PARAMETER NoLogHeader
    Specify parameter if you don't want the log file to start with a header
.PARAMETER WriteHeader
    Only Write header with info to the log file
.EXAMPLE
    Write-ToLogFile
.NOTES
    Function Name : Write-ToLogFile
    Version       : v0.1
    Author        : John Billekens
    Requires      : PowerShell v5.1 and up
.LINK
    https://blog.j81.nl
#>
#requires -version 5.1

[CmdletBinding(DefaultParameterSetName = "Info")]
Param
(
    [Parameter(ParameterSetName = "Error", Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
    [Parameter(ParameterSetName = "Warning", Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
    [Parameter(ParameterSetName = "Info", Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
    [Parameter(ParameterSetName = "Debug", Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [Alias("M")]
    [string[]]$Message,

    [Parameter(ParameterSetName = "Block", Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [Alias("B")]
    [object[]]$Block,

    [Parameter(ParameterSetName = "Error")]
    [switch]$E,

    [Parameter(ParameterSetName = "Warning")]
    [switch]$W,

    [Parameter(ParameterSetName = "Info")]
    [switch]$I,

    [Parameter(ParameterSetName = "Debug")]
    [switch]$D,

    [Parameter(ParameterSetName = "Error")]
    [Parameter(ParameterSetName = "Warning")]
    [Parameter(ParameterSetName = "Info")]
    [Parameter(ParameterSetName = "Debug")]
    [string]$Component = $null,

    [Parameter(ParameterSetName = "Error")]
    [Parameter(ParameterSetName = "Warning")]
    [Parameter(ParameterSetName = "Info")]
    [Parameter(ParameterSetName = "Debug")]
    [Alias("ND")]
    [switch]$NoDate,

    [Parameter(ParameterSetName = "Error")]
    [Parameter(ParameterSetName = "Warning")]
    [Parameter(ParameterSetName = "Info")]
    [Parameter(ParameterSetName = "Debug")]
    [ValidateNotNullOrEmpty()]
    [Alias("DF")]
    [string]$DateFormat = "yyyy-MM-dd HH:mm:ss:ffff",

    [Parameter(ParameterSetName = "Error")]
    [Parameter(ParameterSetName = "Warning")]
    [Parameter(ParameterSetName = "Info")]
    [Parameter(ParameterSetName = "Debug")]
    [Alias("S")]
    [switch]$Show,

    [string]$LogFile = "$PSScriptRoot\Log.txt",

    [Parameter(ParameterSetName = "Error")]
    [Parameter(ParameterSetName = "Warning")]
    [Parameter(ParameterSetName = "Info")]
    [Parameter(ParameterSetName = "Debug")]
    [string]$Delimiter = "`t",

    [Parameter(ParameterSetName = "Error")]
    [Parameter(ParameterSetName = "Warning")]
    [Parameter(ParameterSetName = "Info")]
    [Parameter(ParameterSetName = "Debug")]
    [ValidateSet("Error", "Warning", "Info", "Debug", IgnoreCase = $false)]
    [string]$LogLevel,

    [Parameter(ParameterSetName = "Error")]
    [Parameter(ParameterSetName = "Warning")]
    [Parameter(ParameterSetName = "Info")]
    [Parameter(ParameterSetName = "Debug")]
    [Parameter(ParameterSetName = "Block")]
    [switch]$NoLogHeader,
        
    [Parameter(ParameterSetName = "Head")]
    [Alias("H", "Head")]
    [switch]$WriteHeader

)
Begin {
    # Set Message Type to Informational if nothing is defined.
    if ((-Not $I) -and (-Not $W) -and (-Not $E) -and (-Not $D) -and (-Not $Block) -and (-Not $WriteHeader)) {
        $I = $true
    }
    #Check if a log file is defined in a Script. If defined, get value.
    try {
        $LogFileVar = Get-Variable -Scope Script -Name LogFile -ValueOnly -ErrorAction Stop
        if (-Not [string]::IsNullOrWhiteSpace($LogFileVar)) {
            $LogFile = $LogFileVar
        }
    } catch {
        #Continue, no script variable found for LogFile
    }
    #Check if a LogLevel is defined in a script. If defined, get value.
    try {
        if ([string]::IsNullOrEmpty($LogLevel) -and (-Not $Block) -and (-Not $WriteHeader)) {
            $LogLevelVar = Get-Variable -Scope Script -Name LogLevel -ValueOnly -ErrorAction Stop
            $LogLevel = $LogLevelVar
        }
    } catch { 
        if ([string]::IsNullOrEmpty($LogLevel) -and (-Not $Block)) {
            $LogLevel = "Info"
        }
    }
    #Check if LogFile parameter is empty
    if ([string]::IsNullOrWhiteSpace($LogFile)) {
        if (-Not $Show) {
            Write-Warning "Messages not written to log file, LogFile path is empty!"
        }
        #Only Show Entries to Console
        $Show = $true
    } else {
        #If Not Run in a Script "$PSScriptRoot" wil only contain "\" this will be changed to the current directory
        $ParentPath = Split-Path -Path $LogFile -Parent -ErrorAction SilentlyContinue
        if (([string]::IsNullOrEmpty($ParentPath)) -or ($ParentPath -eq "\")) {
            $LogFile = $(Join-Path -Path $((Get-Item -Path ".\").FullName) -ChildPath $(Split-Path -Path $LogFile -Leaf))
        }
    }
    #Define Log Header
    if (-Not $Show) {
        if ((-Not ($NoLogHeader -eq $True) -and (-Not (Test-Path -Path $LogFile -ErrorAction SilentlyContinue))) -or ($WriteHeader)) {
            $LogHeader = @"
**********************
LogFile: $LogFile
Start time: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Username: $([Security.Principal.WindowsIdentity]::GetCurrent().Name)
RunAs Admin: $((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
Machine: $($Env:COMPUTERNAME) ($([System.Environment]::OSVersion.VersionString))
PSCulture: $($PSCulture)
PSVersion: $($PSVersionTable.PSVersion)
PSEdition: $($PSVersionTable.PSEdition)
PSCompatibleVersions: $($PSVersionTable.PSCompatibleVersions -join ', ')
BuildVersion: $($PSVersionTable.BuildVersion)
PSCommandPath: $($PSCommandPath)
LanguageMode: $($ExecutionContext.SessionState.LanguageMode)
**********************
`r`n
"@
        } else {
            $LogHeader = $null
        }
    }
} Process {
    #Define date string to start log message with. If NoDate is defined no date string will be added to the log file.
    if (-Not ($NoDate) -and (-Not $Block) -and (-Not $WriteHeader)) {
        $DateString = "{0}{1}" -f $(Get-Date -Format $DateFormat), $Delimiter
    } else {
        $DateString = $null
    }
    if (-Not [string]::IsNullOrEmpty($Component) -and (-Not $Block) -and (-Not $WriteHeader)) {
        $Component = " [{0}]{1}" -f $Component, $Delimiter
    } else {
        $Component = "{0}" -f $Delimiter
    }
    #Define the log sting for the Message Type
    if ($Block -or $WriteHeader) {
        $WriteLog = $true
    } elseif ($E -and (($LogLevel -eq "Error") -or ($LogLevel -eq "Warning") -or ($LogLevel -eq "Info") -or ($LogLevel -eq "Debug"))) {
        $MessageType = "ERROR"
        $WriteLog = $true
    } elseif ($W -and (($LogLevel -eq "Warning") -or ($LogLevel -eq "Info") -or ($LogLevel -eq "Debug"))) {
        $MessageType = "WARN "
        $WriteLog = $true
    } elseif ($I -and (($LogLevel -eq "Info") -or ($LogLevel -eq "Debug"))) {
        $MessageType = "INFO "
        $WriteLog = $true
    } elseif ($D -and (($LogLevel -eq "Debug"))) {
        $MessageType = "DEBUG"
        $WriteLog = $true
    } else {
        $WriteLog = $false
    }
    #Write the line(s) of text to a file.
    if ($WriteLog) {
        if ($WriteHeader) {
            $LogString = $LogHeader
        } elseif ($Block) {
            $LogString = $($Block | Out-String)
        } else {
            $LogString = "{0}{1}{2}{3}" -f $DateString, $MessageType, $Component, $($Message | Out-String)
        }
        if ($Show) {
            "$($LogString.TrimEnd("`r`n"))"
        } else {
            if (($LogHeader) -and (-Not $WriteHeader)) {
                $LogString = "{0}{1}" -f $LogHeader, $LogString
            }
            try {
                [System.IO.File]::AppendAllText($LogFile, $LogString, [System.Text.Encoding]::Unicode)
            } catch {
                #If file cannot be written, give an error
                Write-Error -Category WriteError -Message "Could not write to file `"$LogFile`""
            }
        }
    }
} end {

}
