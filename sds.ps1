#requies -modules pwsh-module-api-wrapper, ad-user-provisioning
if (!(test-path ./csv)) {
    new-item -itemtype directory -path ./csv 
}

$pConn = @{
    URL   = $env:GOR_API_URL
    Token = $env:GOR_API_TOKEN
}

$orgs = Get-ApiContent @pConn -Endpoint "orgs" -all
$orgs.orgs | select sourcedid, name, type | 
export-csv ./csv/orgs.csv

$usersTeachers = Get-ApiContent @pConn -Endpoint "users?filter=role='teacher' AND status='Y'" -all
$users += $usersTeachers.Users |
Where-Object username -ne $null | 
Select SourcedId,
@{n = 'orgSourcedIds'; e = { $_.orgs.SourcedId -join ',' } },
username,
givenName,
familyName 

$userPupil = Get-ApiContent @pConn -Endpoint "users?filter=role='student' AND status='Y'" -all
$users += $userPupil.Users |
Select *, @{ n = 'YearIndex'; e = {ConvertFrom-K12 -Year $_.grades -ToIndex}} | 
Where-Object YearIndex -ge 4 | 
Select SourcedId,
@{n= 'orgSourcedIds'; e = { $_.orgs.SourcedId -join ',' } },
username,
givenName,
familyName 

$users | export-csv ./csv/users.csv

$courses = Get-ApiContent @pConn -Endpoint "courses" -all
$courses.courses | select sourcedid, title |
export-csv ./csv/courses.csv

$classes = Get-ApiContent @pConn -Endpoint "classes" -all
$classes.classes | select sourcedId,
title,
classType,
@{n = 'schoolSourcedId'; e = { $_.school.sourcedId -join ',' } },
@{n = 'termSourcedId'; e = { $_.terms.sourcedId -join ',' } }  | 
export-csv ./csv/classes.csv

$enrollments = Get-ApiContent @pConn -Endpoint "enrollments" -all
$enrollments.Enrollments | select sourcedId,
@{n = 'classSourcedId'; e = { $_.class.sourcedId } },
@{n = 'schoolSourcedId'; e = { $_.school.sourcedId } },
@{n = 'userSourcedId'; e = { $_.user.sourcedId } },
role | 
export-csv ./csv/enrollments.csv

$AS = Get-ApiContent @pConn -Endpoint "academicSessions" -all
$as.AcademicSessions | select sourcedId,
title,
type,
startDate,
endDate | 
export-csv ./csv/academicSessions.csv
