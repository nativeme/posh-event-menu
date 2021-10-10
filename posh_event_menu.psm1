class MenuPosition{
    [int]$Id = 0;
    [string]$Content = "";
    [scriptblock]$Action = {};

    [bool]$IsActive = $false;

    MenuPosition([string]$Content, [scriptblock]$Action){
        $this.Content = $Content;
        $this.Action = $Action;
    }
}

class EventMenu{
    [System.Collections.Generic.List[MenuPosition]]$MenuPositions = (New-Object System.Collections.Generic.List[MenuPosition]);
    [int]$currentID = 0;
    
    AddMenuPosition([MenuPosition]$MenuPosition){
        $MenuPosition.Id = $this.MenuPositions.Count;
        $this.MenuPositions.Add($MenuPosition);
    }

    EventMenu(){}
    EventMenu([System.Collections.Generic.List[MenuPosition]]$MenuPositions){
        foreach ($position in $MenuPositions) {$this.AddMenuPosition($position)}
    }

    DrawPosition([MenuPosition]$MenuPosition){
        if($MenuPosition.IsActive) {Write-Host $MenuPosition.Content -ForegroundColor Black -BackgroundColor Gray}
        else {Write-Host $MenuPosition.Content -ForegroundColor Gray -BackgroundColor Black}
    }
    DrawPositions(){
        Clear-Host
        foreach ($position in $this.MenuPositions){
            if($position.Id -eq $this.currentID){$position.IsActive = $true}
            else { $position.IsActive = $false }
            $this.DrawPosition($position)
        }
        [Console]::CursorVisible = $false
    }
    DrawMenu(){
        $this.DrawPositions()
        for($continue = $true; $continue;){
            if([console]::KeyAvailable){
                $keyReader = [System.Console]::ReadKey() 
                switch ($keyReader.key){
                    UpArrow   { 
                        if($this.currentID -le 0){$this.currentID = $this.MenuPositions.Count - 1} else {$this.currentID--}
                        $this.DrawPositions()
                    }
                    DownArrow {
                        if($this.currentID -ge $this.MenuPositions.Count -1){$this.currentID = 0} else {$this.currentID++}
                        $this.DrawPositions()        
                    }
                    Enter     { $continue = $false; Clear-Host; (Invoke-Command $this.MenuPositions[$this.currentID].Action) | Out-Host;}
                }
            }
            else{ Start-Sleep -Milliseconds 50; }
        }
    }
}

# CmdLets
function New-MenuPosition{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$PositionTitle,
        [Parameter(Mandatory=$true)]
        [scriptblock]$Action
    )
    return [MenuPosition]::New($PositionTitle, $Action)
}
function New-EventMenu{
    [CmdletBinding()]
    param (
        [Parameter(
            Position = 0,
            Mandatory=$false,
            ValueFromPipeline=$true
        )]
        [System.Collections.Generic.List[MenuPosition]]$MenuPositions
    )

    if    ($null -ne $MenuPositions) { return [EventMenu]::New($MenuPositions) }
    return [EventMenu]::New()
}
function Show-EventMenu {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true
        )]
        [EventMenu]$EventMenu
    )
    $EventMenu.DrawMenu()
}