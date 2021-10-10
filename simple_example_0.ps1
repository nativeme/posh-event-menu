# Assuming You run example form module location
Import-Module "$PSScriptRoot\posh_event_menu.psm1"

$event1 = New-MenuPosition -PositionTitle "Test Position 1" -Action {Write-Host "This is test 1"}
$event2 = New-MenuPosition -PositionTitle "Test Position 2" -Action {Write-Host "This is test 2"}
$event3 = New-MenuPosition -PositionTitle "Test Position 3" -Action {Write-Host "This is test 3"}

$menu = New-EventMenu $event1, $event2, $event3
Show-EventMenu $menu