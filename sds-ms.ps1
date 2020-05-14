#requies -psedition core
$uri = $env:OR_URL # "https://or.localhost/ims/oneroster/v1p1"
$ci = $env:OR_CI # API client id
$cs = $env:OR_CS # API client secret
$csvDir = "./csv-sds"

# check for CEDS conversion cmdlet
try { ConvertFrom-K12 }
catch {
	write-error "Missing cmdlet: ConvertFrom-K12"
	break
}

# Test/Create csv directory
if (!(test-path $csvDir)) {
	new-item -itemtype directory -path $csvDir
}

# Get API access token
if (!$env:OR_TOKEN) {
	$loginP = @{
		uri    = "$uri/login"
		method = "POST"
		body   = "clientid=$ci&clientsecret=$cs"
		# SkipCertificateCheck = $true
	}
	$env:OR_TOKEN = Invoke-RestMethod @loginP
}

$getP = @{
	method        = "GET"
	headers       = @{"Authorization" = "bearer $ENV:OR_TOKEN" }
	FollowRelLink = $true
	# SkipCertificateCheck = $true
}


# school csv
$orgsGet = Invoke-RestMethod @getP -uri "$uri/orgs"

$orgs = $orgsGet.orgs |
	Select-Object @{n = 'DfE Number'; e = { $_.sourcedid } },
	@{n = 'Name'; e = { $_.name } } 

$orgs | export-csv $csvDir/school.csv

# users
$usersGet = Invoke-RestMethod @getP -uri "$uri/users"
# blacklist
$blacklistUsers = $usersGet.Users |
	Select-Object *, @{ n = 'YearIndex'; e = { convertfrom-k12 -Year $_.grades -ToIndex } } |
	Where-Object {
		($_.role -eq 'aide') -or 
		($_.status -eq 'tobedeleted') -or
		($_.email -eq 'NULL') -or
        ($_.email -like '') -or
		($_.familyName -like '*ACCOUNT*') -or
		($_.YearIndex -ge 0 -and $_.YearIndex -le 3)
	}

# teacher csv
$usersTeachers = $usersGet.users |
	Where-Object role -eq 'teacher' |
	Where-Object status -eq 'active' |
	Where-Object SourcedId -notin $blacklistUsers.sourcedId |
	Select-Object @{n = 'ID'; e = { $_.SourcedId } },
	@{n = 'School DfE Number'; e = { $_.orgs.SourcedId -join ',' } },
	@{n = 'Username'; e = { $_.username } }

$usersTeachers | export-csv $csvDir/teacher.csv

# student csv
$usersPupil = $usersGet.users |
	Where-Object {
		($_.role -eq 'student') -and
		($_.status -eq 'active') -and
		($_.SourcedId -notin $blacklistUsers.sourcedid)
	} |
	Select-Object @{n = 'ID'; e = { $_.SourcedId } },
	@{n = 'School DfE Number'; e = { $_.orgs.SourcedId -join ',' } },
	@{n = 'Username'; e = { $_.Username } }

$usersPupil | export-csv $csvDir/student.csv

# user/parents csv
$usersParents = $usersGet.users |
    Where-Object {
        ($_.role -eq 'parent' -or $_.role -eq 'guardian' -or $_.role -eq 'relative') -and
        ($_.enabledUser -eq $true) -and
        ($_.SourcedId -notin $blacklistUsers.sourcedid)
    } 
$usersUser = $usersParents |
    Select-Object @{n = 'Email'; e = { $_.email } },
    @{n = 'First Name'; e = { $_.givenName } },
    @{n = 'Last Name'; e = { $_.familyName } },
    # bug requires optional fields
    @{n = 'Phone'; e = { $null } },
    @{n = 'SIS ID'; e = { $_.sourcedId } } 

$usersUser | export-csv $csvDir/user.csv

# guardianrelationship csv
$usersGuardianRel = foreach ($u in $usersParents) {
    foreach ($r in $u.agents) {
        $u |
        Select-Object @{ n = 'SIS ID'; e = { $r.sourcedId } },
        @{ n = 'Email'; e = { $u.email } },
        # bug requires optional field
        @{ n = 'Role'; e = { $u.role } }
    }
}

$usersGuardianRel |
    Where-Object 'SIS ID' -notin $blacklistUsers.sourcedid |
    export-csv $csvDir/guardianrelationship.csv

# section csv
$classesGet = Invoke-RestMethod @getP -uri "$uri/classes?filter=status='active'"
#blacklist
$blacklistClasses = $classesGet.classes | 
	Select-Object *, @{ n = 'YearIndex'; e = { ConvertFrom-K12 -Year $_.grades -ToIndex } } |
	Where-Object {
		($_.title -like "*Tutorial*") -or
		($_.title -like "*Games*") -or
		($_.title -like "*Instrumental*") -or
		($_.title -like "*Environmental*") -or
		($_.title -like "*Swimming*") -or
		($_.title -like "*Supervised*") -or
		($_.title -like "*P1.*") -or
		($_.title -like "*P2.*") -or
		($_.title -like "*NP1*") -or
		($_.title -like "*NP2*") -or
		($_.title -like "*NP3*") -or
		($_.title -like "*NP4*") -or
		($_.title -like "*MP1*") -or
		($_.title -like "*MP2*") -or 
		($_.title -like "*MP3*") -or
		($_.title -like "*MP4*") -or
		($_.title -like "*Kindergarten*") -or
		($_.title -like "*MN*") -or
		($_.title -like "*Music P4 Group*") -or
		($_.title -like "Support for Learning P2") -or 
		($_.title -like "Support for Learning LT") -or
		($_.YearIndex -ge 0 -and $_.YearIndex -le 3)
	} 

$classes = $classesGet.classes |
	Where-object sourcedid -notin $blacklistClasses.SourcedId | 
	Select-Object @{n = 'ID'; e = { $_.sourcedId } },
	@{n = 'School DfE Number'; e = { $_.school.sourcedId -join ',' } },
	@{n = 'Section Name'; e = { $_.title } } 

$classes | export-csv $csvDir/section.csv

# enrollements
$enrollmentsGet = Invoke-RestMethod @getP -uri "$uri/enrollments?filter=status='active'"
# Student enrollment
$enrollmentsStu = $enrollmentsGet.Enrollments |
	Where-Object { 
		($_.class.sourcedid -notin $blacklistClasses.sourcedId) -and
		($_.user.sourcedid -notin $blacklistUsers.sourcedId) -and
		($_.role -eq 'student')
	} |
	Select-Object @{n = 'Section ID'; e = { $_.class.sourcedId } },
	@{ n = 'ID'; e = { $_.user.sourcedId } } 

$enrollmentsStu | export-csv $csvDir/studentenrollment.csv

# teacher roster
$enrollmentsTea = $enrollmentsGet.enrollments |
	where-object {
		($_.class.sourcedId -notin $blacklistClasses.sourcedId) -and
		($_.user.sourcedId -notin $blacklistUsers.SourcedId) -and
		($_.role -eq "teacher")
	} |
	Select-Object @{n = 'Section ID'; e = { $_.class.sourcedId } },
	@{ n = 'ID'; e = { $_.user.sourcedId } }

$enrollmentsTea | export-csv $csvDir/teacherroster.csv
