<#
  new-paper.ps1 -- create the standard folder set + note templates for one paper.

  Usage:
    .\new-paper.ps1 -Slug "mikolov2013 - Word Representations" -Title "Efficient Estimation of Word Representations in Vector Space" -Year 2013 -Files ".\in\w2v.pdf",".\in\w2v.md"
    .\new-paper.ps1 -Slug "he2016 - ResNet" -Title "Deep Residual Learning for Image Recognition" -Repro -Code ".\in\official-code"
    .\new-paper.ps1 -Slug "Smith2024 - Example Paper" -Title "An Example Paper Title" -Year 2024

  Params:
    -Slug    your name for the paper (required), e.g. "Smith2024 - Example Paper"
             (also used as the card file name: notes/<slug>/<slug>.md)
    -Title   paper title (required)
    -Year    year (optional)
    -Files   pdf / md / image paths to copy into papers/<slug>/ (optional)
    -Repro   also create code/<slug>/REPRO.md (use ONLY for papers you reproduce)
    -Code    official code folder to copy into code/<slug>/ (implies folder creation)
    -Root    vault root, default: current directory

  Behavior:
    * Creates papers/<slug>/ and notes/<slug>/ and profile/ always.
      Creates code/<slug>/ only with -Repro or -Code.
    * Fills: notes/<slug>/<slug>.md (card), notation.md
             (+ code/<slug>/REPRO.md if -Repro).
    * Creates AGENTS.md at the vault root once.
    * Existing files are NEVER overwritten. Safe to re-run / use on existing papers.
    * This script is ASCII-only on purpose; templates are read from
      .\templates\*.md as UTF-8, so PowerShell 5.1 never mis-decodes them.
#>
param(
  [Parameter(Mandatory=$true)][string]$Slug,
  [Parameter(Mandatory=$true)][string]$Title,
  [string]$Year = "",
  [string[]]$Files = @(),
  [switch]$Repro,
  [string]$Code = "",
  [string]$Root = "."
)

$ErrorActionPreference = "Stop"
$tplDir = Join-Path $PSScriptRoot "templates"
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Ensure-Dir($p){
  if(-not (Test-Path $p)){ New-Item -ItemType Directory -Force -Path $p | Out-Null }
}
function Write-IfAbsent($path, $content){
  if(-not (Test-Path $path)){
    [System.IO.File]::WriteAllText($path, $content, $utf8NoBom)
    Write-Host ("  + " + $path)
  } else {
    Write-Host ("  = skip (exists): " + $path)
  }
}
function Fill($tpl){
  return $tpl.Replace('__TITLE__', $Title).Replace('__YEAR__', $Year).Replace('__SLUG__', $Slug)
}
function Read-Tpl($name){
  $p = Join-Path $tplDir $name
  if(-not (Test-Path $p)){ throw ("template not found: " + $p) }
  return (Get-Content -Raw -Encoding UTF8 $p)
}

$dirPaper = Join-Path $Root ("papers/" + $Slug)
$dirNotes = Join-Path $Root ("notes/"  + $Slug)
$dirCode  = Join-Path $Root ("code/"   + $Slug)
$dirProf  = Join-Path $Root "profile"

foreach($d in @($dirPaper, $dirNotes, $dirProf)){ Ensure-Dir $d }
if($Repro -or $Code){ Ensure-Dir $dirCode }

# copy user-provided source / structured files
foreach($f in $Files){
  if(Test-Path $f){ Copy-Item -Recurse -Force $f -Destination $dirPaper; Write-Host ("  -> copy " + $f) }
  else { Write-Warning ("not found: " + $f) }
}
# copy official code
if($Code -and (Test-Path $Code)){
  Copy-Item -Recurse -Force $Code -Destination $dirCode
  Write-Host ("  -> copy code " + $Code)
}

# card file name == slug (so [[slug]] resolves to it; identifiable in explorer/index)
Write-IfAbsent (Join-Path $dirNotes ($Slug + ".md"))  (Fill (Read-Tpl "paper-card.md"))
Write-IfAbsent (Join-Path $dirNotes "notation.md")    (Fill (Read-Tpl "notation.md"))
if($Repro){
  Write-IfAbsent (Join-Path $dirCode "REPRO.md")      (Fill (Read-Tpl "REPRO.md"))
}

# global agent conventions at vault root (created once, never overwritten)
Write-IfAbsent (Join-Path $Root "AGENTS.md") (Read-Tpl "AGENTS.md")

Write-Host ""
Write-Host ("done: " + $Slug)
Write-Host ("  papers/" + $Slug + "/  notes/" + $Slug + "/" + $Slug + ".md")
if($Repro){ Write-Host ("  code/" + $Slug + "/") }
