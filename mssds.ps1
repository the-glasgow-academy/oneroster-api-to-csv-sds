#requies -modules pwsh-module-api-wrapper, ad-user-provisioning
if (!(test-path ./mscsv)) {
    new-item -itemtype directory -path ./mscsv 
}

$pConn = @{
    URL   = $env:GOR_API_URL
    Token = $env:GOR_API_TOKEN
}

# school csv
$orgs = Get-ApiContent @pConn -Endpoint "orgs" -all
$orgs.orgs |
select @{n = 'DfE Number'; e = { $_.sourcedid } },
Name | 
export-csv ./mscsv/schools.csv

# teacher csv
$usersTeachers = Get-ApiContent @pConn -Endpoint "users?filter=role='teacher' AND status='Y'" -all
$usersTeachers.Users |
Where-Object username -ne $null | 
Select @{n = 'ID'; e = { $_.SourcedId } },
@{n = 'School DfE Number'; e = { $_.orgs.SourcedId -join ',' } },
username | 
export-csv ./mscsv/teacher.csv

# student csv
$userPupil = Get-ApiContent @pConn -Endpoint "users?filter=role='student' AND status='Y'" -all
$userPupil.Users |
Select *, @{ n = 'YearIndex'; e = { ConvertFrom-K12 -Year $_.grades -ToIndex } } | 
Where-Object YearIndex -ge 4 | 
Select @{n = 'ID'; e = { $_.SourcedId } },
@{n = 'School DfE Number'; e = { $_.orgs.SourcedId -join ',' } },
Username,
export-csv ./mscsv/student.csv

# section csv
$AS = Get-ApiContent @pConn -Endpoint "academicSessions" -all

$classes = Get-ApiContent @pConn -Endpoint "classes" -all
$classes.classes | select @{n = 'ID'; e = { $_.sourcedId } },
@{n = 'School DfE Number'; e = { $_.school.sourcedId -join ',' } },
@{n = 'Section Name'; e = { $_.title } } |
export-csv ./mscsv/sections.csv

# Student enrollment
$senrollments = Get-ApiContent @pConn -Endpoint "enrollments?filter=role='student'" -all
$senrollments.Enrollments |
select @{n = 'Section ID'; e = { $_.class.sourcedId } },
@{n = 'ID'; e = { 
    $id = $_.user.sourcedId
    if ($id.count -gt 1) {$id[0]}
    else {$id}
  } } |
export-csv ./mscsv/studentenrollment.csv

# teacher roster
$tenrollments = Get-ApiContent @pConn -Endpoint "enrollments?filter=role='teacher'" -all
$tenrollments.Enrollments |
select @{n = 'Section ID'; e = { $_.class.sourcedId } },
@{n = 'ID'; e = { 
    $_.user.sourcedId
 } } |
? ID -ne $null |
export-csv ./mscsv/teacherroster.csv

