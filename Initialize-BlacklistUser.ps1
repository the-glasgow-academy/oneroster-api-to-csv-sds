function Initialize-BlacklistUser {
    $pConn = @{
        url   = $env:GOR_API_URL
        token = $env:GOR_API_TOKEN
    }
    $c = Get-ApiContent @pConn -Endpoint 'users' -All
    
    $f = $c.Users | Where-Object {
        ($_.familyName -like '*ACCOUNT*')
    }
    return $f
}
