# posh-event-menu
This is simple "arrow selectable" menu writen purely in powershell.  
May be handy for simple predefined events or making "GUI script" for non IT user.

![small_menu_demo](https://user-images.githubusercontent.com/41862141/136713950-cc23a965-2d00-4560-9319-8638c9bced11.gif)

## Known limitations
1. ScriptBlock (aka. "Action") technicaly is called inside DrawMenu method, and output is force forwarded to the host window.
   so if you call by menu something like ```ping google.com -n 10``` result wont show up untill all pings are done.  
   In case calling ```ping google.com -t``` powershell window will freeze until You manually stop pinging.  
   Same goes for everything that is outputing actively to terminal. eg. ```Ookla Speedtest CLI``` 

**You can find all examples shown below in repo\examples**

### Simple example 1
```
$event1 = New-MenuPosition -PositionTitle "Test Position 1" -Action {Write-Host "This is test 1"}
$event2 = New-MenuPosition -PositionTitle "Test Position 2" -Action {Write-Host "This is test 2"}
$event3 = New-MenuPosition -PositionTitle "Test Position 3" -Action {Write-Host "This is test 3"}
$menu = New-EventMenu $event1, $event2, $event3
Show-EventMenu $menu
```
### Simple example 2
```
$positions = @(
    New-MenuPosition -PositionTitle "Open Calc" -Action {calc}
    New-MenuPosition -PositionTitle "Open Notepad" -Action {notepad}
    New-MenuPosition -PositionTitle "Open Edge" -Action {microsoftedge}
)
New-EventMenu $positions | Show-EventMenu
```
### Nested menus
```
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
```

