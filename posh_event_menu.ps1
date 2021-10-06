class MenuPosition {
    [int]$Id = 0;
    [string]$Content = "";
    [scriptblock]$Action = {};

    [bool]$IsActive = $false;

    MenuPosition([string]$Content, [scriptblock]$Action){
        $this.Content = $Content;
        $this.Action = $Action;
    }
}

class MenuBuilder {
    [System.Collections.Generic.List[MenuPosition]]$MenuPositions = (New-Object System.Collections.Generic.List[MenuPosition]);
    [int]$currentID = 0;
    
    AddMenuPosition([MenuPosition]$MenuPosition){
        $MenuPosition.Id = $this.MenuPositions.Count;
        $this.MenuPositions.Add($MenuPosition);
    }

    DrawPosition([MenuPosition]$MenuPosition){
        if($MenuPosition.IsActive) {Write-Host $MenuPosition.Content -ForegroundColor Black -BackgroundColor Gray}
        else {Write-Host $MenuPosition.Content -ForegroundColor Gray -BackgroundColor Black}
    }
    
    BuildMenu(){
        for($continue = $true; $continue;){
            if([console]::KeyAvailable){
                $keyReader = [System.Console]::ReadKey() 
                switch ($keyReader.key){
                    UpArrow   { if($this.currentID -le 0){$this.currentID = $this.MenuPositions.Count - 1} else {$this.currentID--}}
                    DownArrow { if($this.currentID -ge $this.MenuPositions.Count -1){$this.currentID = 0} else {$this.currentID++}}
                    Enter     { $continue = $false;  (Invoke-Command $this.MenuPositions[$this.currentID].Action) | Out-Host;}
                    F12       { $continue = $false }
                }
            }
            else{ 
                foreach ($position in $this.MenuPositions){
                    if($position.Id -eq $this.currentID){$position.IsActive = $true}
                    else { $position.IsActive = $false }
                    $this.DrawPosition($position)
                }
                [Console]::CursorVisible = $false
                Start-Sleep -Milliseconds 100; Clear-Host
            }
        }
    }
}

$menu = [MenuBuilder]::New()
$menu.AddMenuPosition([MenuPosition]::New("ipconfig", {ipconfig}));
$menu.AddMenuPosition([MenuPosition]::New("getmac",   {getmac}))
$menu.AddMenuPosition([MenuPosition]::New("hostname", {hostname}))
$menu.AddMenuPosition([MenuPosition]::New("dir",      {Get-ChildItem}))
$menu.AddMenuPosition([MenuPosition]::New("Exit",     {exit}))
$menu.BuildMenu()