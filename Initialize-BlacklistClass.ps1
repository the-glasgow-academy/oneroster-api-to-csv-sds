function Initialize-BlacklistClass {
    $pConn = @{
        url   = $env:GOR_API_URL
        token = $env:GOR_API_TOKEN
    }
    $c = Get-ApiContent @pConn -Endpoint 'classes' -All

    $f = $c.Classes | Where-Object {
        ($_.title -like "*Tutorial*") -or
        ($_.title -like '*Games*') -or
        ($_.title -like '*Instrumental*') -or
        ($_.title -like '*Environmental*') -or
        ($_.title -like '*Swimming*') -or
        ($_.title -like '*Supervised*') -or
        ($_.title -like '*P1.*') -or
        ($_.title -like '*P2.*') -or
        ($_.title -like '*NP1*') -or
        ($_.title -like '*NP2*') -or
        ($_.title -like '*NP3*') -or
        ($_.title -like '*NP4*') -or
        ($_.title -like '*MP1*') -or
        ($_.title -like '*MP2*') -or
        ($_.title -like '*MP3*') -or
        ($_.title -like '*MP4*') -or
        ($_.title -like '*Kindergarten*') -or
        ($_.title -like '*MN*') -or
        ($_.title -like '*Music P4 Group*') -or
        ($_.title -like 'Support for Learning P2') -or
        ($_.title -like 'Support for learning LT') 
    }
    return $f
}
