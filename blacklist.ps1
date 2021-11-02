function blacklistClasses {
    
    param(
        [Parameter(Mandatory,ValueFromPipeline,Position=0)]
        [object]$i
    )

    Process {
        $i | Where-Object {
            ($_.title -like "*Tutorial*") -or
            ($_.title -like "*Instrumental*") -or
            ($_.title -like "*Topic*") -or
            ($_.title -like "*Swimming*") -or
            ($_.title -like "*Supervised*") -or
            ($_.title -like "*Kindergarten*") -or
            ($_.title -like "*MN*") -or
            ($_.title -like "*Music P4 Group*") -or
            ($_.title -like "Support for Learning P2") -or 
            ($_.title -like "Support for Learning LT") -or
            ($_.title -like "Learning Support*") -or 
            ($_.YearIndex -ge 0 -and $_.YearIndex -le 2) -or
            ($_.title -like "Dept Meeting*") -or
            ($_.title -like "BUSY:*")
        }
    }
}

function blacklistUsers {

    param(
        [Parameter(Mandatory,ValueFromPipeline,Position=0)]
        [object]$i
    )

    Process {
        $i | Where-Object {
            ($_.role -eq 'aide') -or 
            ($_.status -eq 'tobedeleted') -or
            ($_.email -eq 'NULL') -or
            ($_.email -like '') -or
            ($_.familyName -like '*ACCOUNT*') -or
            ($_.YearIndex -ge 0 -and $_.YearIndex -lt 4) -or
            ($null -eq $_.email)
        }
    }
}

