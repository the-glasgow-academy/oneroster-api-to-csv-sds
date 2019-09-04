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
            [pscustomobject]@{
                "INDEX" = 0
                "CEDS" = "IT"
                "SCO" = "IT"
                "ENG" = ""
            }
            [pscustomobject]@{
                "INDEX" = 1
                "CEDS" = "PR"
                "SCO" = "N"
                "ENG" = ""
            }
            [pscustomobject]@{
                "INDEX" = 2
                "CEDS" = "PK"
                "SCO" = "KN"
                "ENG" = ""
            }
            [pscustomobject]@{
                "INDEX" = 3
                "CEDS" = "TK"
                "SCO" = "P1"
                "ENG" = "Reception"
            }
            [pscustomobject]@{
                "INDEX" = 4
                "CEDS" = "KG"
                "SCO" = "P2"
                "ENG" = "1"
            }
            [pscustomobject]@{
                "INDEX" = 5
                "CEDS" = "1"
                "SCO" = "P3"
                "ENG" = "2"
            }
            [pscustomobject]@{
                "INDEX" = 6
                "CEDS" = "2"
                "SCO" = "P4"
                "ENG" = "3"
            }
            [pscustomobject]@{
                "INDEX" = 7
                "CEDS" = "3"
                "SCO" = "P5"
                "ENG" = "4"
            }
            [pscustomobject]@{
                "INDEX" = 8
                "CEDS" = "4"
                "SCO" = "P6"
                "ENG" = "5"
            }
            [pscustomobject]@{
                "INDEX" = 9
                "CEDS" = "5"
                "SCO" = "P7"
                "ENG" = "6"
            }
            [pscustomobject]@{
                "INDEX" = 10
                "CEDS" = "6"
                "SCO" = "S1"
                "ENG" = "7"
            }
            [pscustomobject]@{
                "INDEX" = 11
                "CEDS" = "7"
                "SCO" = "S2"
                "ENG" = "8"
            }
            [pscustomobject]@{
                "INDEX" = 12
                "CEDS" = "8"
                "SCO" = "S3"
                "ENG" = "9"
            }
            [pscustomobject]@{
                "INDEX" = 13
                "CEDS" = "9"
                "SCO" = "S4"
                "ENG" = "10"
            }
            [pscustomobject]@{
                "INDEX" = 14
                "CEDS" = "10"
                "SCO" = "S5"
                "ENG" = "11"
            }
            [pscustomobject]@{
                "INDEX" = 15
                "CEDS" = "11"
                "SCO" = "S6"
                "ENG" = "12"
            }
            [pscustomobject]@{
                "INDEX" = 16
                "CEDS" = "12"
                "SCO" = "S7"
                "ENG" = "13"
            }
        )
    }

    process {
        if ($index) {$t | where-object {$_.index -eq $index}}
        if ($to) {$t | where-object {$_.CEDS -eq $year} | Select index,$to}
        if ($all) {$t}
        if ($toIndex) {($t | where-object {$_.CEDS -eq $year} | Select index).INDEX}
    }
}
