# Write-ToLogFile
PowerShell Function to write message to a log file

```powershell
NAME
    Write-ToLogFile.ps1

SYNOPSIS
    Write messages to a log file


SYNTAX
    Write-ToLogFile.ps1 [-Message] <String[]> [-I] [-Component <String>] [-NoDate] [-DateFormat <String>] 
	[-Show] [-LogFile <String>] [-Delimiter <String>] [-LogLevel <String>] [-NoLogHeader] 
	[<CommonParameters>]

    Write-ToLogFile.ps1 [-Message] <String[]> [-D] [-Component <String>] [-NoDate] [-DateFormat <String>] 
	[-Show] [-LogFile <String>] [-Delimiter <String>] [-LogLevel <String>] [-NoLogHeader] 
	[<CommonParameters>]

    Write-ToLogFile.ps1 [-Message] <String[]> [-W] [-Component <String>] [-NoDate] [-DateFormat <String>] 
	[-Show] [-LogFile <String>] [-Delimiter <String>] [-LogLevel <String>] [-NoLogHeader] 
	[<CommonParameters>]

    Write-ToLogFile.ps1 [-Message] <String[]> [-E] [-Component <String>] [-NoDate] [-DateFormat <String>] 
	[-Show] [-LogFile <String>] [-Delimiter <String>] [-LogLevel <String>] [-NoLogHeader] 
	[<CommonParameters>]

    Write-ToLogFile.ps1 [-Block] <Object[]> [-LogFile <String>] [-NoLogHeader] [<CommonParameters>]

    Write-ToLogFile.ps1 [-LogFile <String>] [-WriteHeader] [<CommonParameters>]


DESCRIPTION
    Write messages to a log file


PARAMETERS
    -Message <String[]>
        The message you want to have written to the log file

        Required?                    true
        Position?                    1
        Default value
        Accept pipeline input?       true (ByValue)
        Accept wildcard characters?  false

    -Block <Object[]>

        Required?                    true
        Position?                    1
        Default value
        Accept pipeline input?       true (ByValue)
        Accept wildcard characters?  false

    -E [<SwitchParameter>]
        Define the Message Type as a Error Message

        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -W [<SwitchParameter>]
        Define the Message Type as a Warning Message

        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -I [<SwitchParameter>]
        Define the Message Type as a Informational Message
        (Default) This is the Default value if you don't specify a MessageType

        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -D [<SwitchParameter>]
        Define the Message Type as a Debug Message

        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -Component <String>
        If you want to have a Component name in your log file, you can specify this parameter

        Required?                    false
        Position?                    named
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -NoDate [<SwitchParameter>]
        If NoDate is defined, no date string will be added to the log file

        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -DateFormat <String>

        Required?                    false
        Position?                    named
        Default value                yyyy-MM-dd HH:mm:ss:ffff
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -Show [<SwitchParameter>]
        Show the Log Entry only to console

        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -LogFile <String>
        The FileName of your log file.
        (Default) <ScriptRoot>\Log.txt or if $PSScriptRoot is not available .\Log.txt

        Required?                    false
        Position?                    named
        Default value                "$PSScriptRoot\Log.txt"
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -Delimiter <String>
        Define your Custom Delimiter of the log file
        (Default) <TAB>

        Required?                    false
        Position?                    named
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -LogLevel <String>
        The FileName of your log file

        Required?                    false
        Position?                    named
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -NoLogHeader [<SwitchParameter>]
        Specify parameter if you don't want the log file to start with a header

        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -WriteHeader [<SwitchParameter>]
        Only Write header with info to the log file

        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false

    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

INPUTS

OUTPUTS

NOTES

        Function Name : Write-ToLogFile
        Version       : v0.1
        Author        : John Billekens
        Requires      : PowerShell v5.1 and up

    -------------------------- EXAMPLE 1 --------------------------

    PS C:\>Write-ToLogFile "Add this line to a log file"


RELATED LINKS
    https://blog.j81.nl

    requires -version 5.1

```
