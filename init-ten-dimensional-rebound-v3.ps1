param(
    [string]$ProjectRoot = (Join-Path (Get-Location) 'Ten-dimensional-rebound'),
    [switch]$InitGit
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Ensure-Directory {
    param([Parameter(Mandatory = $true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
        Write-Host ('[DIR ] ' + $Path)
    }
}

function Write-Base64FileIfMissing {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Base64
    )

    $Parent = Split-Path -Parent $Path
    if ($Parent) {
        Ensure-Directory -Path $Parent
    }

    if (-not (Test-Path -LiteralPath $Path)) {
        $Bytes = [Convert]::FromBase64String($Base64)
        [System.IO.File]::WriteAllBytes($Path, $Bytes)
        Write-Host ('[FILE] ' + $Path)
    }
    else {
        Write-Host ('[SKIP] ' + $Path)
    }
}

function Write-EmptyFileIfMissing {
    param([Parameter(Mandatory = $true)][string]$Path)

    $Parent = Split-Path -Parent $Path
    if ($Parent) {
        Ensure-Directory -Path $Parent
    }

    if (-not (Test-Path -LiteralPath $Path)) {
        [System.IO.File]::WriteAllText($Path, '', $Utf8NoBom)
        Write-Host ('[FILE] ' + $Path)
    }
    else {
        Write-Host ('[SKIP] ' + $Path)
    }
}

Ensure-Directory -Path $ProjectRoot
$Directories = @(
    'canon',
    'outlines',
    'outlines\volume-01-the-tenth-direction\chapters',
    'outlines\volume-02-graveyard-of-dimensions\chapters',
    'outlines\volume-03-after-the-rebound\chapters',
    'manuscript\volume-01-the-tenth-direction',
    'manuscript\volume-02-graveyard-of-dimensions',
    'manuscript\volume-03-after-the-rebound',
    'research',
    'revisions',
    'drafts\discarded-scenes',
    'drafts\alternate-outlines',
    'drafts\experiments',
    'assets\cover',
    'assets\diagrams',
    'assets\timeline',
    'exports\markdown',
    'exports\epub',
    'exports\pdf'
)
foreach ($RelativePath in $Directories) {
    Ensure-Directory -Path (Join-Path $ProjectRoot $RelativePath)
}
$Files = @{
    'README.md' = 'IyBUZW4tZGltZW5zaW9uYWwtcmVib3VuZAoK44CK5Y2B57u05Zue5aOw44CL6ZW/56+H56Gs56eR5bm75bCP6K+06aG555uu44CCCgrmlYXkuovmqKrot6jkuKTkuKrlroflrpnlkajmnJ/vvJrml6flroflrpnku47lrozmlbTljYHnu7Tml7bnqbrpgJDmraXpmY3oh7PkuInnu7TvvJvph4/lrZDlj43lvLnlkI7vvIzmlrDlroflrpnph43mlrDlvIDlp4vvvIzlubblj5HnjrDml6flroflrpnnlZnkuIvnmoTorablkYrkv6Hmga/jgIIKCiMjIOS4ieWNt+inhOWIkgoKMS4g56ys5LiA5Y2344CK56ys5Y2B5Liq5pa55ZCR44CLCjIuIOesrOS6jOWNt+OAiuivuOe7tOS5i+Wik+OAiwozLiDnrKzkuInljbfjgIrph43lkK/kuYvlkI7jgIsKCiMjIOebruW9lQoKLSBgY2Fub24vYO+8muato+W8j+iuvuWumuS4juacgOmrmOe6puadnwotIGBvdXRsaW5lcy9g77ya5YWo5Lmm44CB5Y2357qn5ZKM56ug6IqC5aSn57qyCi0gYG1hbnVzY3JpcHQvYO+8muato+W8j+ato+aWhwotIGByZXNlYXJjaC9g77ya546w5a6e56eR5a2m6LWE5paZ5LiO56eR5bm75aSW5o6oCi0gYHJldmlzaW9ucy9g77ya5b6F56Gu6K6k5LqL6aG55ZKM5LiA6Ie05oCn5qOA5p+lCi0gYGRyYWZ0cy9g77ya5bqf56i/5LiO5aSH6YCJ5pa55qGICi0gYGFzc2V0cy9g77ya5bCB6Z2i44CB5Zu+6KGo5ZKM5pe26Ze057q/Ci0gYGV4cG9ydHMvYO+8muWvvOWHuuaWh+S7tgoKIyMg6K6+5a6a5LyY5YWI57qnCgpgY2Fub24vMDAtc2VyaWVzLWJpYmxlLm1kYCA+IOWFtuS7liBgY2Fub24vYCDmlofku7YgPiDlhajkuabmgLvnurIgPiDljbfnurIgPiDnq6DoioLlpKfnurIgPiDmraPmlocgPiDojYnnqL/jgIIK'
    'AGENTS.md' = 'IyBBR0VOVFMubWQKCuacrOS7k+W6k+eUqOS6juWIm+S9nOehrOenkeW5u+Wwj+ivtOOAiuWNgee7tOWbnuWjsOOAi+OAggoKIyMg5bel5L2c5YmN5b+F6K+7CgotIOaJgOacieS7u+WKoe+8mmBSRUFETUUubWRg44CBYGNhbm9uLzAwLXNlcmllcy1iaWJsZS5tZGAKLSDlhpnkurrnianvvJrlho3or7sgYGNhbm9uLzAzLWNoYXJhY3RlcnMubWRgCi0g5YaZ5oqA5pyv5oiW5a6H5a6Z6K6+5a6a77ya5YaN6K+7IGBjYW5vbi8wMS1waHlzaWNzLXJ1bGVzLm1kYOOAgWBjYW5vbi8wNS10ZWNobm9sb2d5LXN5c3RlbS5tZGAKLSDlhpnmraPmlofvvJrlho3or7vlr7nlupTljbfnurLjgIHnq6DoioLlpKfnurLlkozliY3kuIDnq6DmraPmlocKCiMjIOS8mOWFiOe6pwoKYGNhbm9uLzAwLXNlcmllcy1iaWJsZS5tZGAgPiDlhbbku5YgYGNhbm9uL2AgPiDlhajkuabmgLvnurIgPiDljbfnurIgPiDnq6DoioLlpKfnurIgPiDmraPmlocgPiBgZHJhZnRzL2AKCuWPkeeUn+WGsueqgeaXtuS/ruaUueS9juS8mOWFiOe6p+aWh+S7tuOAguacque7j+aYjuehruimgeaxgu+8jOS4jeW+l+S/ruaUuSBgY2Fub24vYOOAggoKIyMg5YaZ5L2c57qm5p2fCgotIOS9v+eUqOS4reaWh+WSjOWOn+WIm+ihqOi+vu+8jOS4jeaooeS7v+eOsOWunuS9nOiAheeahOWFt+S9k+WPpeW8j+OAggotIOS/neaMgeehrOenkeW5u+OAgeWGt+mdmeOAgeWFi+WItu+8m+enkeWtpuiuvuWumuW/hemhu+acieWOn+eQhuOAgemZkOWItuWSjOS7o+S7t+OAggotIOmrmOe7tOS4jeaYr+elnuWtpuaIlui2heiHqueEtu+8m+S4jeW+l+S9v+eUqOeBtemtguOAgei9rOS4luOAgeWuh+WumeaEj+W/l+OAgeaXoOmZkOiDvea6kOaIluaXoOS7o+S7t+i2heWFiemAn+OAggotIOmZjee7tOWPquS9nOeUqOS6juepuumXtOe7tOW6pu+8jOS4jeiDvemAhui9rOaXtumXtOaIluS4gOmUruaBouWkjeWFqOmDqOe7tOW6puOAggotIOe7tOWboOOAgeW8peWoheOAgei1q+ajruOAgeS8iuiTneeahOaguOW/g+i6q+S7veS4juS6uueJqeW8p+e6v+S4jeW+l+aTheiHquaUueWPmOOAggotIOS4jeW+l+aPkOWJjeazhOmcsuWQjue7reWNt+S/oeaBr++8jOS4jeW+l+iuqeato+aWh+S4tOaXtuaWsOWinuWFs+mUruaKgOacr+ino+WGs+WbsOWig+OAggotIOS4jeW+l+WkjeWItuWOn+S9nOato+aWh+OAgeaUueWGmeWOn+S9nOS6uueJqee7k+WxgO+8jOaIluaKiuS6uuexu+WGmeaIkOWuh+WumeWUr+S4gOS4reW/g+OAggoKIyMg5paH5Lu26KeE5YiZCgotIOavj+eroOato+aWh+W/hemhu+WFiOacieWvueW6lOeroOiKguWkp+e6suOAggotIOaWsOato+W8j+iuvuWumuWFiOWGmeWFpSBgY2Fub24vYO+8jOWGjeWQjOatpeWkp+e6suWSjOato+aWh+OAggotIOacquehruiupOeahOmXrumimOWGmeWFpSBgcmV2aXNpb25zL3BlbmRpbmctZGVjaXNpb25zLm1kYOOAggotIOW6n+eov+WPquaUvuWFpSBgZHJhZnRzL2DvvIzkuI3lvpfkvZzkuLrmraPlvI/orr7lrprlvJXnlKjjgIIK'
    '.gitignore' = 'LkRTX1N0b3JlClRodW1icy5kYgpEZXNrdG9wLmluaQoKLnZzY29kZS8KLmlkZWEvCiouY29kZS13b3Jrc3BhY2UKCioudG1wCioudGVtcAoqLmJhawoqLnN3cAoqLnN3bwp+JCoKKi5sb2cKCmV4cG9ydHMvcGRmLyoKZXhwb3J0cy9lcHViLyoKZXhwb3J0cy9tYXJrZG93bi8qCgohZXhwb3J0cy9wZGYvLmdpdGtlZXAKIWV4cG9ydHMvZXB1Yi8uZ2l0a2VlcAohZXhwb3J0cy9tYXJrZG93bi8uZ2l0a2VlcAo='
    'CHANGELOG.md' = 'IyBDaGFuZ2Vsb2cKCiMjIFVucmVsZWFzZWQKCiMjIyBBZGRlZAoKLSDliJ3lp4vljJblsI/or7Tku5PlupPnu5PmnoTjgIIKLSDliJvlu7rorr7lrprjgIHlpKfnurLjgIHmraPmlofjgIHnoJTnqbblkozkv67orqLnm67lvZXjgIIKLSDnoa7lrprkuInljbfnu5PmnoTkuI7kuLvopoHkurrnianjgIIK'
    'canon\00-series-bible.md' = 'IyDjgIrljYHnu7Tlm57lo7DjgIvmgLvnurLnuqbmnZ/mlofku7YK'
    'canon\01-physics-rules.md' = 'IyDniannkIbop4TliJkK'
    'canon\02-universe-timeline.md' = 'IyDlroflrpnml7bpl7Tnur8K'
    'canon\03-characters.md' = 'IyDkurrnianorr7lrpoK'
    'canon\04-civilizations.md' = 'IyDmlofmmI7kuI7nu4Tnu4cK'
    'canon\05-technology-system.md' = 'IyDmioDmnK/kvZPns7sK'
    'canon\06-terminology.md' = 'IyDkuJPmnInlkI3or43ooagK'
    'canon\07-original-work-boundaries.md' = 'IyDljp/kvZzov57mjqXovrnnlYwK'
    'outlines\00-master-outline.md' = 'IyDjgIrljYHnu7Tlm57lo7DjgIvlhajkuabmgLvnurIK'
    'outlines\volume-01-the-tenth-direction\00-volume-outline.md' = 'IyDnrKzkuIDljbfjgIrnrKzljYHkuKrmlrnlkJHjgIvljbfnuqflpKfnurIK'
    'outlines\volume-01-the-tenth-direction\01-chapter-map.md' = 'IyDnrKzkuIDljbfnq6DoioLlnLDlm74K'
    'outlines\volume-01-the-tenth-direction\chapters\ch-001-background-noise.md' = 'IyDnrKzkuIDnq6Ag6IOM5pmv5Zmq5aOwCg=='
    'outlines\volume-01-the-tenth-direction\chapters\ch-002-open-universe.md' = 'IyDnrKzkuoznq6Ag5byA5pS+5a6H5a6ZCg=='
    'outlines\volume-01-the-tenth-direction\chapters\ch-003-boundary-project.md' = 'IyDnrKzkuInnq6Ag6L6555WM5bel56iLCg=='
    'outlines\volume-02-graveyard-of-dimensions\00-volume-outline.md' = 'IyDnrKzkuozljbfjgIror7jnu7TkuYvlopPjgIvljbfnuqflpKfnurIK'
    'outlines\volume-02-graveyard-of-dimensions\01-chapter-map.md' = 'IyDnrKzkuozljbfnq6DoioLlnLDlm74K'
    'outlines\volume-03-after-the-rebound\00-volume-outline.md' = 'IyDnrKzkuInljbfjgIrph43lkK/kuYvlkI7jgIvljbfnuqflpKfnurIK'
    'outlines\volume-03-after-the-rebound\01-chapter-map.md' = 'IyDnrKzkuInljbfnq6DoioLlnLDlm74K'
    'manuscript\volume-01-the-tenth-direction\00-volume-notes.md' = 'IyDnrKzkuIDljbflhpnkvZzorrDlvZUK'
    'manuscript\volume-02-graveyard-of-dimensions\00-volume-notes.md' = 'IyDnrKzkuozljbflhpnkvZzorrDlvZUK'
    'manuscript\volume-03-after-the-rebound\00-volume-notes.md' = 'IyDnrKzkuInljbflhpnkvZzorrDlvZUK'
    'research\README.md' = 'IyBSZXNlYXJjaAoK6K6w5b2V546w5a6e56eR5a2m44CB5pyq6K+B5a6e55CG6K665ZKM5bCP6K+05aSW5o6o44CCCg=='
    'research\extra-dimensions.md' = 'IyDpop3lpJbnu7TluqYK'
    'research\vacuum-decay.md' = 'IyDnnJ/nqbroobDlj5gK'
    'research\dimensional-compactification.md' = 'IyDnu7TluqbntKfoh7TljJYK'
    'research\quantum-bounce.md' = 'IyDph4/lrZDlj43lvLkK'
    'research\cyclic-universe.md' = 'IyDlvqrnjq/lroflrpkK'
    'research\information-and-entropy.md' = 'IyDkv6Hmga/kuI7nhrUK'
    'research\higher-dimensional-life.md' = 'IyDpq5jnu7TnlJ/lkb0K'
    'research\source-log.md' = 'IyDnp5HnoJTotYTmlpnmnaXmupDorrDlvZUK'
    'revisions\pending-decisions.md' = 'IyDlvoXnoa7orqTkuovpobkK'
    'revisions\continuity-issues.md' = 'IyDov57nu63mgKfpl67popgK'
    'revisions\physics-review.md' = 'IyDniannkIborr7lrprmo4Dmn6UK'
    'revisions\terminology-review.md' = 'IyDkuJPmnInlkI3or43mo4Dmn6UK'
    'revisions\rewrite-log.md' = 'IyDph43lhpnorrDlvZUK'
}
foreach ($Entry in $Files.GetEnumerator()) {
    Write-Base64FileIfMissing -Path (Join-Path $ProjectRoot $Entry.Key) -Base64 $Entry.Value
}
$GitKeepFiles = @(
    'drafts\discarded-scenes\.gitkeep',
    'drafts\alternate-outlines\.gitkeep',
    'drafts\experiments\.gitkeep',
    'assets\cover\.gitkeep',
    'assets\diagrams\.gitkeep',
    'assets\timeline\.gitkeep',
    'exports\markdown\.gitkeep',
    'exports\epub\.gitkeep',
    'exports\pdf\.gitkeep'
)
foreach ($RelativePath in $GitKeepFiles) {
    Write-EmptyFileIfMissing -Path (Join-Path $ProjectRoot $RelativePath)
}

if ($InitGit) {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Warning 'Git was not found. Files were created, but Git was not initialized.'
    }
    else {
        Push-Location $ProjectRoot
        try {
            if (-not (Test-Path -LiteralPath '.git')) {
                & git init
            }

            & git add .

            $UserName = (& git config user.name)
            $UserEmail = (& git config user.email)

            if ([string]::IsNullOrWhiteSpace($UserName) -or
                [string]::IsNullOrWhiteSpace($UserEmail)) {
                Write-Warning 'Git user.name or user.email is not configured. Commit was skipped.'
                Write-Host 'Run: git commit -m "chore: initialize novel repository"'
            }
            else {
                & git commit -m 'chore: initialize novel repository'
            }
        }
        finally {
            Pop-Location
        }
    }
}

Write-Host ''
Write-Host ('Initialized: ' + $ProjectRoot)