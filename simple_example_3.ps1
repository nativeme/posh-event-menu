# Assuming You run example form module location
Import-Module "$PSScriptRoot\posh_event_menu.psm1"

# Declare all positions for all menus
$menuContents = @(
    # Main menu [0]
    @(
        New-MenuPosition -PositionTitle "Utils" -Action {Show-EventMenu $menus[1]}
        New-MenuPosition -PositionTitle "Network info" -Action {Show-EventMenu $menus[2]}
        New-MenuPosition -PositionTitle "Pinging" -Action {Show-EventMenu $menus[3]}
    ),
    # Submenu 1
    @(
        New-MenuPosition -PositionTitle "Open calc" -Action {calc}
        New-MenuPosition -PositionTitle "Open notepad" -Action {notepad}
        New-MenuPosition -PositionTitle "Open edge" -Action {microsoftedge}
        New-MenuPosition -PositionTitle "Back to main menu" -Action {Show-EventMenu $menus[0]}
    ),
    # Submenu 2
    @(
        New-MenuPosition -PositionTitle "Show complete IP config" -Action {Get-NetIPConfiguration -Detailed}
        New-MenuPosition -PositionTitle "Show physical net adapters" -Action {Get-NetAdapter -Physical}
        New-MenuPosition -PositionTitle "Show DNS info" -Action {Get-DnsClientServerAddress}
        New-MenuPosition -PositionTitle "Back to main menu" -Action {Show-EventMenu $menus[0]}
    ),
    # Submenu 3
    @(
        New-MenuPosition -PositionTitle "Ping google" -Action {ping google.com -n 1}
        New-MenuPosition -PositionTitle "Large ping to google" -Action {ping google.com -l 1472 -n 1}
        New-MenuPosition -PositionTitle "Ping google DNS" -Action {ping 8.8.8.8 -n 1}
        New-MenuPosition -PositionTitle "Ping cloudflare DNS" -Action {ping 1.1.1.1 -n 1}
        New-MenuPosition -PositionTitle "Test HTTP connection to google.com" -Action {Test-NetConnection google.com HTTP}
        New-MenuPosition -PositionTitle "Back to main menu" -Action {Show-EventMenu $menus[0]}
    )

)

# Create all menus
$menus = @(
    New-EventMenu $menuContents[0]
    New-EventMenu $menuContents[1]
    New-EventMenu $menuContents[2]
    New-EventMenu $menuContents[3]
)

# Open main menu
Show-EventMenu $menus[0]