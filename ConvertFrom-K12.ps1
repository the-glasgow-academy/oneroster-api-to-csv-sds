function ConvertFrom-K12 {
    param (
        [int]$index,
        [string]$Year,
        [string]$To,
        [switch]$All,
        [switch]$ToIndex
    )

    begin {
        $t = @(
            [pscustomobject]@{ "INDEX" = 0; "CEDS" = "IT"; "SCO" = ""; "ENG" = ""; }
            [pscustomobject]@{ "INDEX" = 1; "CEDS" = "PR"; "SCO" = "" ; "ENG" = ""; }
            [pscustomobject]@{ "INDEX" = 2; "CEDS" = "PK"; "SCO" = "N"; "ENG" = ""; }
            [pscustomobject]@{ "INDEX" = 3; "CEDS" = "TK"; "SCO" = "KN"; "ENG" = "Reception"; }
            [pscustomobject]@{ "INDEX" = 4; "CEDS" = "KG"; "SCO" = "P1"; "ENG" = "1"; }
            [pscustomobject]@{ "INDEX" = 5; "CEDS" = "01"; "SCO" = "P2"; "ENG" = "2"; }
            [pscustomobject]@{ "INDEX" = 6; "CEDS" = "02"; "SCO" = "P3"; "ENG" = "3"; }
            [pscustomobject]@{ "INDEX" = 7; "CEDS" = "03"; "SCO" = "P4"; "ENG" = "4"; }
            [pscustomobject]@{ "INDEX" = 8; "CEDS" = "04"; "SCO" = "P5"; "ENG" = "5"; }
            [pscustomobject]@{ "INDEX" = 9; "CEDS" = "05"; "SCO" = "P6"; "ENG" = "6"; }
            [pscustomobject]@{ "INDEX" = 10; "CEDS" = "06"; "SCO" = "P7"; "ENG" = "7"; }
            [pscustomobject]@{ "INDEX" = 11; "CEDS" = "07"; "SCO" = "S1"; "ENG" = "8"; }
            [pscustomobject]@{ "INDEX" = 12; "CEDS" = "08"; "SCO" = "S2"; "ENG" = "9"; }
            [pscustomobject]@{ "INDEX" = 13; "CEDS" = "09"; "SCO" = "S3"; "ENG" = "10"; }
            [pscustomobject]@{ "INDEX" = 14; "CEDS" = "10"; "SCO" = "S4"; "ENG" = "11"; }
            [pscustomobject]@{ "INDEX" = 15; "CEDS" = "11"; "SCO" = "S5"; "ENG" = "12"; }
            [pscustomobject]@{ "INDEX" = 16; "CEDS" = "12"; "SCO" = "S6"; "ENG" = "13"; }
        )
    }

    process {
        if ($index) {$t | where-object {$_.index -eq $index}}
        if ($to) {$t | where-object {$_.CEDS -eq $year} | Select-Object index,$to}
        if ($all) {$t}
        if ($toIndex) {($t | where-object {$_.CEDS -eq $year} | Select-Object index).INDEX}
    }
}
