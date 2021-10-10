# Assuming You run example form module location
Import-Module "$PSScriptRoot\posh_event_menu.psm1"

$positions = @(
    New-MenuPosition -PositionTitle "Open Calc" -Action {calc}
    New-MenuPosition -PositionTitle "Open Notepad" -Action {notepad}
    New-MenuPosition -PositionTitle "Open Edge" -Action {microsoftedge}
)
New-EventMenu $positions | Show-EventMenu