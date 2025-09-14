<#
.SYNOPSIS
Updates a Spotify playlist with new releases from specified artists by their Spotify IDs. The script maintains the playlist by automatically removing older tracks based on configurable settings.

.DESCRIPTION
This script monitors new releases from a curated list of artists (specified by their Spotify IDs) and adds them to a designated playlist. 
It filters releases based on various criteria such as album type, track duration, and exclusion rules.
Additionally, it maintains the playlist by removing tracks older than a specified number of days and enforcing a maximum track limit.

.PARAMETER SpotifyPlaylistName
The name of the Spotify playlist to update. This parameter is mandatory.
IMPORTANT: The playlist name must be unique in your Spotify account to ensure correct playlist identification.

.PARAMETER IncludeArtistIds
List of Spotify artist IDs to fetch new releases from.

.PARAMETER GetRelatedArtists
Get related artists for each artist in $IncludeArtistIds.

.PARAMETER DelTracksReleasedLaterThanDays
The number of days after which tracks should be removed from the playlist. 
Default: 30 days
Example: Setting this to 45 will remove tracks that were released more than 45 days ago.

.PARAMETER MaxPlaylistTracks
The maximum number of tracks to keep in the playlist. When exceeded, oldest tracks are removed first.
Default: 100 tracks

.PARAMETER MaxTracksPerRelease
The maximum number of tracks to add per release. Useful for albums with many tracks.
Default: 5 tracks per release

.PARAMETER IncludeAlbumTypes
An array of album types to include. 
Default: @("album", "single")
Available options: "album", "single", "appears_on", "compilation"

.PARAMETER ExcludeArtistNames
An array of artist names to exclude from the search. 
Default: @(
    "Various Artists",
    "Chris Brown"
)

.PARAMETER ExcludedTitleKeywords
An array of keywords to exclude from track titles. 
Default: @(
    "Live", "Intro", "Outro", "Mix", "Remix", "Version", 
    "Edit", "Acappella", "Remaster", "Instrumental"
)
Note: The search is case-insensitive and matches partial words.

.PARAMETER ExcludeTrackMinDurationMs
The minimum duration (in milliseconds) for a track to be included. 
Default: 120000 (2 minutes)

.PARAMETER SpotishellAppName
The Spotishell application name to use. 
Default: "default"

.EXAMPLE
# Example usage with specific artist IDs:
.\Get-ArtistsReleases.ps1 `
    -SpotifyPlaylistName "My Favorite Artists Releases" `
    -IncludeArtistIds @(
        "6XyY86QOPPrYVGvF9ch6wz",  # Linkin Park
        "2qk9voo8llSGYcZ6xrBzKx",  # Kings of Leon
        "6FBDaR13swtiWwGhX1WQsP",  # blink-182
        "12Chz98pHFMPJEknJQMWvI",  # Muse
        "3YQKmKGau1PzlVlkL1iodx"   # Twenty One Pilots
    ) `
    -MaxPlaylistTracks 150 `
    -DelTracksReleasedLaterThanDays 45

# How to find artist IDs:
# 1. Open Spotify web player (open.spotify.com)
# 2. Navigate to the artist's page
# 3. The ID is in the URL: https://open.spotify.com/artist/6XyY86QOPPrYVGvF9ch6wz
# In this example, "6XyY86QOPPrYVGvF9ch6wz" is the artist ID

.NOTES
This script requires the Spotishell module to be installed. It will attempt to install the module if it's not present.

Developed by Christian Jakobsson with the assistance of AI tools Claude and Codeium.

.LINK
https://www.linkedin.com/in/christian-jakobsson-69106927

.LINK
https://gist.github.com/TinkerHack/47c6e8c74917b55cd6b16a7572555922

.EXAMPLE
Getting Started:

1. Go to https://developer.spotify.com/ and register for a new Spotify application.
   Make sure to note down the Client ID and Client Secret - you'll need these later.

2. While still at https://developer.spotify.com/ 
   Add "http://localhost:8080/spotishell" (without the quotes) as a "Redirect URIs" in your app settings.

3. Open PowerShell cmd as administrator and Install the Spotishell module from PSGallery:
   Install-Module Spotishell

4. Import the Spotishell module:
   Import-Module Spotishell

5. Set up your Spotify application credentials (replace with your actual Client ID and Client Secret from step 1):
   New-SpotifyApplication -ClientId "your_client_id" -ClientSecret "your_client_secret"

6. Open your Spotify application and create a new playlist with a UNIQUE name, like "Artists New Releases".
   You'll use this name when running the script in the last step.

7. Save this script in folder of your chosing (e.g. C:\FolderName\Get-ArtistsReleases.ps1).

8. You're now ready to run the script in Powershell cmd using the following command (and default values):

   & "C:\FolderName\Get-ArtistsReleases.ps1" `
    -SpotifyPlaylistName "My Favorite Artists Releases" `
    -IncludeArtistIds @(
        "6XyY86QOPPrYVGvF9ch6wz",  # Linkin Park
        "2qk9voo8llSGYcZ6xrBzKx",  # Kings of Leon
        "6FBDaR13swtiWwGhX1WQsP",  # blink-182
        "12Chz98pHFMPJEknJQMWvI",  # Muse
        "3YQKmKGau1PzlVlkL1iodx"   # Twenty One Pilots
    ) `
    -MaxPlaylistTracks 150 `
    -DelTracksReleasedLaterThanDays 45
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$SpotifyPlaylistName, # Name of your unqiue Spotify playlist to save new releases to.

    [Parameter(Mandatory=$false)]
    [string[]]$IncludeArtistIds = @(
        "6XyY86QOPPrYVGvF9ch6wz", # Linkin Park https://open.spotify.com/artist/6XyY86QOPPrYVGvF9ch6wz
        "2qk9voo8llSGYcZ6xrBzKx", # Kings of Leon https://open.spotify.com/artist/2qk9voo8llSGYcZ6xrBzKx
        "6FBDaR13swtiWwGhX1WQsP" # blink-182 https://open.spotify.com/artist/6FBDaR13swtiWwGhX1WQsP
    ), # Choose which specific artists to include. Use https://open.spotify.com via web browser to find artist IDs.

    [Parameter(Mandatory=$false)]
    [bool]$GetRelatedArtists = $false, # Get related artists for each artist in $IncludeArtistIds.

    [Parameter(Mandatory=$false)]
    [int]$DelTracksReleasedLaterThanDays = 90, # Deletes tracks released later than X days ago from $SpotifyPlaylistName.

    [Parameter(Mandatory=$false)]
    [int]$MaxPlaylistTracks = 100, # Max number of tracks in playlist $SpotifyPlaylistName.

    [Parameter(Mandatory=$false)]
    [int]$MaxTracksPerRelease = 5, # Max tracks to add from each release.

    [Parameter(Mandatory=$false)]
    [string[]]$IncludeAlbumTypes = @(
        "album", 
        #"compilation",
        #"appears_on",
        "single"
    ), # Choose which album types to include: "album", "single", "appears_on", "compilation".

    [Parameter(Mandatory=$false)]
    [string[]]$ExcludeArtistNames = @(
        "Various Artists",
        "Chris Brown"
    ), # Exclude artist names that you don't want in the playlist.

    [Parameter(Mandatory=$false)]
    [string[]]$ExcludedTitleKeywords = @(
        "Live", 
        #"Intro", 
        #"Outro", 
        #"Mix", 
        #"Remix", 
        #"Version", 
        #"Edit",
        #"Acappella", 
        #"Remaster", 
        "Instrumental"
    ), # Exclude key words from track & album names that you don't want in the playlist.

    [Parameter(Mandatory=$false)]
    [int]$ExcludeTrackMinDurationMs = 120000, # Exclude tracks shorter than 120 seconds / 2 minutes.

    [Parameter(Mandatory=$false)]
    [string]$SpotishellAppName = "default" # Spotishell application name to use.
)

# Set error action preference to stop on first error
$ErrorActionPreference = "Stop"

# Set log path file 
[string]$LastRunDateFilePath = (Join-Path $PSScriptRoot "Get-ArtistsReleases_LastRunDate.txt")

# Start Transcript
$transcriptPath = Join-Path $PSScriptRoot "Get-ArtistsReleases_Log.txt"
Start-Transcript -Path $transcriptPath -Force

function Get-ArtistById {
    param(
        [Parameter(Mandatory=$true)]
        [string[]]$IncludeArtistIds,

        [Parameter(Mandatory=$false)]
        [bool]$GetRelatedArtists,

        [Parameter(Mandatory=$false)]
        [string]$SpotishellAppName
    )
    try {
        # Make the array unique
        $IncludeArtistIds = $IncludeArtistIds | Sort-Object -Unique

        Write-host "Fetching artist info for: $($IncludeArtistIds.Count) artists..."

        $artistInfo = @()

        $artistInfo += Invoke-WithRetry -ScriptBlock {
            Get-Artist -Id $IncludeArtistIds -ApplicationName $SpotishellAppName
        }

        If($GetRelatedArtists -eq $true){
            Write-host "Fetching related artist info for: $($IncludeArtistIds.Count) artists..."
            $IncludeArtistIds | ForEach-Object {
                $artistId = $_
                $relatedArtists = Invoke-WithRetry -ScriptBlock {
                    Get-ArtistRelatedArtists -Id $artistId -ApplicationName $SpotishellAppName
                }
                $artistInfo += $relatedArtists
            }
        }

        # Group by ArtistId and select the first occurrence
        $artistInfo = $artistInfo | 
                Group-Object -Property Id | 
                ForEach-Object { $_.Group | Select-Object -First 1 }

        return $artistInfo
    } catch {
        $errorDetails = [string]$error[0]
        $errorLine = [string]$error[0].InvocationInfo.PositionMessage
        throw "An error occurred during Get-CustomTrackObject at line $($errorLine): $errorDetails"
    }
}

function Invoke-WithRetry {
    param(
        [Parameter(Mandatory=$true)]
        [scriptblock]$ScriptBlock,
        [int]$MaxAttempts = 5,
        [int]$WaitSeconds = 5
    )
    
    $attempt = 1
    while ($attempt -le $MaxAttempts) {
        try {
            return & $ScriptBlock
        }
        catch {
            if ($attempt -eq $MaxAttempts) {
                throw
            }
            Write-Warning "Attempt $attempt of $MaxAttempts failed. Waiting $WaitSeconds seconds before retry..."
            Start-Sleep -Seconds $WaitSeconds
            $attempt++
        }
    }
}
function Assert-PowerShellCore {
    [CmdletBinding()]
    param(
        [switch]$Exit
    )

    $isPSCore = $PSVersionTable.PSEdition -eq 'Core'
    $psVersion = $PSVersionTable.PSVersion

    if (-not $isPSCore) {
        $errorMessage = @"
This script requires PowerShell Core (version 6.0 or later).
You are currently running Windows PowerShell $psVersion.
Please run this script using PowerShell Core.

To install PowerShell Core, visit:
https://github.com/PowerShell/PowerShell#get-powershell
"@

        Write-Error $errorMessage

        if ($Exit) {
            exit 1
        } else {
            return $false
        }
    } else {
        Write-Verbose "Running on PowerShell Core $psVersion"
        return $true
    }
}

# Create custom object with relevant properties
function Get-CustomTrackObject {
    param (
        $artistId,
        $trackName,
        $trackId,
        $trackUri,
        $trackNumber,
        $albumId,
        $albumReleaseDate
    )
    try {
        $customTrack = [PSCustomObject]@{
            ArtistId = $artistId
            TrackName = $trackName
            TrackId = $trackId
            TrackUri = $trackUri
            TrackNumber = $trackNumber
            AlbumId = $albumId
            AlbumReleaseDate = $albumReleaseDate
        }
        return $customTrack
    }
    catch {
        $errorDetails = [string]$error[0]
        $errorLine = [string]$error[0].InvocationInfo.PositionMessage
        throw "An error occurred during Get-CustomTrackObject at line $($errorLine): $errorDetails"
    }
}

# Function to check and install Spotishell module
function Install-SpotishellModule {
    try {
        if (-not (Get-Module -ListAvailable -Name Spotishell)) {
            Write-Host "Spotishell module not found. Installing..."
            Install-Module Spotishell -Force -Scope CurrentUser
            Import-Module Spotishell
            Write-Host "Spotishell module installed and imported successfully."
        }
        else {
            Import-Module Spotishell
            Write-Host "Spotishell module imported successfully."
        }

        # Check if Spotify application is set up
        Get-SpotifyApplication | Out-Null
    }
    catch {
        $errorDetails = [string]$error[0]
        $errorLine = [string]$error[0].InvocationInfo.PositionMessage
        throw "An error occurred during Install-SpotishellModule at line $($errorLine): $errorDetails"
    }
}

# Function to get the last run date
function Get-LastRunDate {
    param (
        [string]$FilePath
    )
    try {
        if (Test-Path $FilePath) {
            return Get-Content -Path $FilePath
        }
    }
    catch {
        $errorDetails = [string]$error[0]
        $errorLine = [string]$error[0].InvocationInfo.PositionMessage
        throw "An error occurred during Get-LastRunDate at line $($errorLine): $errorDetails"
    }
    return $null
}

# Function to get filtered album tracks
function Get-FilteredAlbumTracks {
    param (
        [Parameter(Mandatory=$true)]
        [string]$AlbumId,

        [Parameter(Mandatory=$true)]
        [string]$AlbumReleaseDate,

        [Parameter(Mandatory=$true)]
        [string]$ArtistId,

        [Parameter(Mandatory=$true)]
        [string]$IncludeUserMarket,

        [Parameter(Mandatory=$false)]
        [string[]]$ExcludedTitleKeywords,

        [Parameter(Mandatory=$false)]
        [int]$ExcludeTrackMinDurationMs,

        [Parameter(Mandatory=$false)]
        [string[]]$ExcludeArtistNames,

        [Parameter(Mandatory=$false)]
        [int]$MaxTracksPerRelease,

        [Parameter(Mandatory=$false)]
        [string]$SpotishellAppName
    )

    try {       
        $tracks = Invoke-WithRetry -ScriptBlock {
            Get-AlbumTracks -Id $AlbumId -ApplicationName $SpotishellAppName
        }

        # Check if $ExcludeTrackMinDurationMs is defined and not empty
        If(!$ExcludeTrackMinDurationMs) {
            $ExcludeTrackMinDurationMs = 0
        }

        $filteredTracks = $tracks | Where-Object {
            $trackName = $_.name
            ($_.artists.id -contains $ArtistId) -and
            $_.available_markets -contains $IncludeUserMarket -and
            $_.duration_ms -gt $ExcludeTrackMinDurationMs -and 
            -not ($_.artists.name | Where-Object { $_ -in $ExcludeArtistNames }) -and
            -not ($ExcludedTitleKeywords | Where-Object {$trackName -imatch [regex]::Escape($_) })
        }

        if ($MaxTracksPerRelease -gt 0) {
            $filteredTracks = $filteredTracks | Select-Object -First $MaxTracksPerRelease
        }

        $filteredTracksCustomObject = @()

        $filteredTracks | ForEach-Object {
            $filteredTracksCustomObject += Get-CustomTrackObject -artistId $_.artists[0].id `
            -trackName $_.name `
            -trackId $_.id `
            -trackUri $_.uri `
            -trackNumber $_.track_number `
            -albumId $AlbumId `
            -albumReleaseDate $AlbumReleaseDate
        }
        
        return $filteredTracksCustomObject
    }
    catch {
        $errorDetails = [string]$error[0]
        $errorLine = [string]$error[0].InvocationInfo.PositionMessage
        throw "An error occurred during Get-FilteredAlbumTracks at line $($errorLine): $errorDetails"
    }
}

# Function to update the playlist
function Update-Playlist {
    param (
        [Parameter(Mandatory=$true)]
        [string]$PlaylistId,

        [Parameter(Mandatory=$true)]
        [object[]]$NewTracks,

        [Parameter(Mandatory=$false)]
        [int]$MaxPlaylistTracks,

        [Parameter(Mandatory=$false)]
        [int]$DelTracksReleasedLaterThanDays,

        [Parameter(Mandatory=$false)]
        [string]$SpotishellAppName
    )
    try {
        # Empty variable to store current playlist items 
        $currentPlaylistItems = @()

        # Use Invoke-WithRetry with a script block that processes the playlist items
        $playlistItems = Invoke-WithRetry -ScriptBlock {
            # Get all playlist items in one call
            $items = Get-PlaylistItems -Id $PlaylistId -ApplicationName $SpotishellAppName
            
            # Process each item and create custom track objects
            $items | ForEach-Object {
                Get-CustomTrackObject -artistId $_.track.artists[0].id `
                    -trackName $_.track.name `
                    -trackId $_.track.id `
                    -trackUri $_.track.uri `
                    -trackNumber $_.track.track_number `
                    -albumId $_.track.album.id `
                    -albumReleaseDate $_.track.album.release_date
            }
        }

        # Add the results to $currentPlaylistItems
        $currentPlaylistItems += $playlistItems

        # Remove tracks already in the playlist
        $NewTracks = $NewTracks | Where-Object { $_.TrackId -notin $currentPlaylistItems.TrackId }
   
        # Filter out tracks released later than $DelTracksReleasedLaterThanDays
        If($DelTracksReleasedLaterThanDays -gt 0) {
            # Remove tracks released later than $DelTracksReleasedLaterThanDays from $NewTracks
            $NewTracks = $NewTracks | Where-Object { $_.AlbumReleaseDate -ge (Get-Date).AddDays(-$DelTracksReleasedLaterThanDays).ToString("yyyy-MM-dd") }
            
            # Identify tracks released later than $DelTracksReleasedLaterThanDays from $currentPlaylistItems
            $currentPlaylistItemsToDelete = $currentPlaylistItems | Where-Object { $_.AlbumReleaseDate -le (Get-Date).AddDays(-$DelTracksReleasedLaterThanDays).ToString("yyyy-MM-dd") }
            
            # Remove tracks released later than $DelTracksReleasedLaterThanDays from $currentPlaylistItems
            $currentPlaylistItems = $currentPlaylistItems | Where-Object { $_.TrackId -notin $currentPlaylistItemsToDelete.TrackId }
        }

        # Set default value to 0
        $totalTracksAdded = 0

        # Select only the most recent tracks up to $MaxPlaylistTracks
        if ($MaxPlaylistTracks -gt 0 -and $NewTracks.Count -gt 0) {
            # Make sure we don't add the same track twice
            $allTracks = @($currentPlaylistItems) + @($NewTracks) | 
                Group-Object -Property TrackName, ArtistId | 
                ForEach-Object { $_.Group | Select-Object -First 1 }

            # Sort the unique tracks
            $sortedTracks = $allTracks | Sort-Object @{Expression = {$_.AlbumReleaseDate}; Descending=$true}, 
                                                    @{Expression = {$_.AlbumId}; Descending=$false},
                                                    @{Expression = {$_.TrackNumber}; Descending=$false}

            # Select only the most recent tracks up to $MaxPlaylistTracks
            $tracksToSet = $sortedTracks | Select-Object -First $MaxPlaylistTracks

            # Set the playlist
            $playlistUpdateResult = Set-PlaylistItems -Id $PlaylistId -Uris $tracksToSet.TrackUri -ApplicationName $SpotishellAppName
            
            # Get the tracks that were set and new
            $tracksToSetCount = $tracksToSet | Where-Object { $_.TrackId -in $NewTracks.TrackId }
            Write-Host "Set playlist with $($tracksToSetCount.Count) new tracks, sorted by release date and album." -ForegroundColor Cyan
            
            # Update the total number of tracks added
            $totalTracksAdded = $tracksToSetCount.Count
        }
        # Else check if tracks should be added or deleted
        else {
            # Only append new tracks if they are not already in the playlist
            if ($NewTracks.Count -gt 0) {
                # Sort the new tracks
                $NewTracks = $NewTracks | Sort-Object @{Expression = {$_.AlbumReleaseDate}; Descending=$true}, 
                                                        @{Expression = {$_.AlbumId}; Descending=$false},
                                                        @{Expression = {$_.TrackNumber}; Descending=$false}

                # Add the new tracks to the playlist, sorted by release date
                $playlistUpdateResult = Add-PlaylistItem -Id $PlaylistId -Uris $NewTracks.TrackUri -ApplicationName $SpotishellAppName
                Write-Host "Added $($NewTracks.Count) new unique tracks to the playlist, sorted by release date and album." -ForegroundColor Cyan
                
                # Update the total number of tracks added
                $totalTracksAdded = $NewTracks.Count
            }
            # Else if no new tracks
            else {
                Write-Warning "No new unique tracks to add to the playlist."
            }
        }

        # Delete tracks that have been released later than $DelTracksReleasedLaterThanDays and no tracks has been set
        If($currentPlaylistItemsToDelete.TrackId -and !$tracksToSetCount) {
            Write-Host "Deleting $($currentPlaylistItemsToDelete.Count) tracks that have been released later than $DelTracksReleasedLaterThanDays days."
            $playlistUpdateResult = Remove-PlaylistItems -Id $PlaylistId -Track $currentPlaylistItemsToDelete.TrackUri -ApplicationName $SpotishellAppName
        }

        # If any tracks has been added
        If($totalTracksAdded -gt 0){
            $plDescTimestamp = Get-Date -format "yyyy-MM-dd HH:mm"
            $plDescription = "Updated playlist with $($totalTracksAdded) tracks at $plDescTimestamp."

            # Update the playlist description
            Set-Playlist -id $PlaylistId -Description $plDescription
        }

        return $totalTracksAdded
    }
    catch {
        $errorDetails = [string]$error[0]
        $errorLine = [string]$error[0].InvocationInfo.PositionMessage
        throw "An error occurred during Update-Playlist at line $($errorLine): $errorDetails"
    }
}

function Get-UserPlaylistDetails {
    param (
        [Parameter(Mandatory=$true)]
        [string]$PlaylistName,

        [Parameter(Mandatory=$false)]
        [string]$SpotishellAppName
    )
    try {
        $userProfile = Get-CurrentUserProfile -ApplicationName $SpotishellAppName
        $userId = $userProfile.id
        $userCountry = $userProfile.country

        $playlists = Get-CurrentUserPlaylists -ApplicationName $SpotishellAppName

        $playlist = $playlists | Where-Object { $_.name -eq $PlaylistName -and $_.owner.id -eq $userId } | Select-Object -First 1

        if ($playlist) {
            return @{
                PlaylistId = $playlist.id
                UserMarket = $userCountry
            }
        } else {
            throw "Playlist '$PlaylistName' not found."
        }
    }
    catch {
        $errorDetails = [string]$error[0]
        $errorLine = [string]$error[0].InvocationInfo.PositionMessage
        throw "An error occurred during Get-UserPlaylistDetails at line $($errorLine): $errorDetails"
    }
}

# Helper function to check if a date string is valid
function Test-DateStringValidity {
    param (
        [string]$DateString,
        [datetime]$AfterDate
    )
    
    try {
        if ($DateString -match '^\d{4}$') {
            # If it's just a year, assume it's January 1st of that year
            $parsedDate = [datetime]::ParseExact($DateString, "yyyy", [System.Globalization.CultureInfo]::InvariantCulture)
        } elseif ($DateString -match '^\d{4}-\d{2}$') {
            # If it's a year and month, assume it's the first day of that month
            $parsedDate = [datetime]::ParseExact($DateString, "yyyy-MM", [System.Globalization.CultureInfo]::InvariantCulture)
        } else {
            # Otherwise, try to parse it as a full date
            $parsedDate = [datetime]::Parse($DateString)
        }
        
        return $parsedDate -ge $AfterDate
    }
    catch {
        Write-Warning "Unable to parse date: $DateString. Skipping this entry."
        return $false
    }
}

# Helper function to get artist albums
function Get-ArtistAlbumsWithTypes {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ArtistId,

        [Parameter(Mandatory=$true)]
        [datetime]$AfterDate,

        [Parameter(Mandatory=$true)]
        [string]$IncludeUserMarket,

        [Parameter(Mandatory=$false)]
        [string[]]$IncludeAlbumTypes,

        [Parameter(Mandatory=$false)]
        [string[]]$ExcludedTitleKeywords,

        [Parameter(Mandatory=$false)]
        [string[]]$ExcludeArtistNames,

        [Parameter(Mandatory=$false)]
        [string]$SpotishellAppName
    )
    try {
        $currentArtistAlbums = Invoke-WithRetry -ScriptBlock {
            Get-ArtistAlbums -Id $artistId -ApplicationName $SpotishellAppName
        }

        $filteredAlbums = $currentArtistAlbums | Where-Object { 
            $albumName = $_.name
            $null -ne $_.id -and
            $_.available_markets -contains $IncludeUserMarket -and
            $_.album_type -in $IncludeAlbumTypes -and
            $_.album_group -in $IncludeAlbumTypes -and
            -not ($_.artists.name | Where-Object { $_ -in $ExcludeArtistNames }) -and
            (Test-DateStringValidity -DateString $_.release_date -AfterDate $AfterDate) -and
            -not ($ExcludedTitleKeywords | Where-Object { $albumName -imatch [regex]::Escape($_) })
        }
        
        return $filteredAlbums
    }
    catch {
        $errorDetails = [string]$error[0]
        $errorLine = [string]$error[0].InvocationInfo.PositionMessage
        throw "An error occurred during Get-ArtistAlbumsWithTypes at line $($errorLine): $errorDetails"
    }
}

# Helper function to update artists releases
function Update-ArtistsReleases {
    param (
        [Parameter(Mandatory=$true)]
        [string]$SpotifyPlaylistName,
        
        [Parameter(Mandatory=$false)]
        [string[]]$IncludeArtistIds,

        [Parameter(Mandatory=$false)]
        [bool]$GetRelatedArtists,

        [Parameter(Mandatory=$false)]
        [int]$MaxPlaylistTracks,

        [Parameter(Mandatory=$false)]
        [string[]]$ExcludeArtistNames,

        [Parameter(Mandatory=$false)]
        [int]$MaxTracksPerRelease,

        [Parameter(Mandatory=$false)]
        [string[]]$IncludeAlbumTypes,

        [Parameter(Mandatory=$false)]
        [string[]]$ExcludedTitleKeywords,

        [Parameter(Mandatory=$false)]
        [int]$ExcludeTrackMinDurationMs,

        [Parameter(Mandatory=$true)]
        [string]$LastRunDateFilePath,

        [Parameter(Mandatory=$false)]
        [string]$SpotishellAppName
    )

    try {        
        Write-Host "Looking for playlist '$SpotifyPlaylistName'..."
        # Get the playlist ID and country for current user
        $userDetails = Get-UserPlaylistDetails -PlaylistName $SpotifyPlaylistName -SpotishellAppName $SpotishellAppName
        $userMarket = $userDetails.UserMarket
        $spotifyPlaylistId = $userDetails.PlaylistId
        Write-Host "Found playlist '$SpotifyPlaylistName' with ID: $spotifyPlaylistId. User market set to: $userMarket."

        # Get the date after which to get albums
        $getAlbumsAfterDayDate = Get-LastRunDate -FilePath $LastRunDateFilePath

        # If no last run date found, use a fallback date
        if (-not $getAlbumsAfterDayDate) {
            $fallbackDate = (Get-Date).AddDays(-180)
            $getAlbumsAfterDayDate = $fallbackDate.ToString("yyyy-MM-dd")
            Write-Host "No last run date found. Using fallback date: $getAlbumsAfterDayDate"
        # Else check if today's date is the same as the last run date
        } else {
            $todayDate = Get-Date -Format "yyyy-MM-dd"

            # If today's date is the same as the last run date, skip this run
            If($todayDate -eq $getAlbumsAfterDayDate){
                Write-warning "Script already ran once today and therefore skipping this run, to prevent API throttle issues."
                Write-warning "Lower the date value in this file (or delete file) to re-run the script today: $LastRunDateFilePath"
                exit
            }
        }

        # Get the date after which to get albums
        $afterDate = [datetime]::ParseExact($getAlbumsAfterDayDate, "yyyy-MM-dd", $null)

        # Get artists by ID
        $artists = Get-ArtistById -IncludeArtistIds $IncludeArtistIds -SpotishellAppName $SpotishellAppName

        # If no artists found, throw an error
        if (-not $artists) {
            throw "No artists found or error occurred while fetching artists. Make sure all artist IDs are valid."
        }
    
        # Array to store tracks from albums
        $albumTracks = @()

        # Variable to keep track of the artist iterator
        $artistIterator = 0

        # Loop through each artist
        foreach ($artist in $artists) {
            $artistIterator++

            $progressParams = @{
                Activity = "Processing Artists"
                Status = "Processing $($artist.name)"
                PercentComplete = ($artistIterator / $artists.Count * 100)
            }
            Write-Progress @progressParams

            $artistId = $artist.id
            $artistName = $artist.name

            Write-Host "Artist '${artistName}' (artist $($artistIterator) of $($artists.count)), being filtered for release types '$($IncludeAlbumTypes -join ', '), that's released since $($getAlbumsAfterDayDate)."
            
            # Get all filtered albums for the artist
            $artistAlbums = Get-ArtistAlbumsWithTypes -ArtistId $artistId `
                -IncludeUserMarket $userMarket `
                -IncludeAlbumTypes $IncludeAlbumTypes `
                -AfterDate $afterDate `
                -ExcludedTitleKeywords $ExcludedTitleKeywords `
                -ExcludeArtistNames $ExcludeArtistNames `
                -SpotishellAppName $SpotishellAppName

            # Loop through each filtered album by artist
            foreach ($album in $artistAlbums) {
                Write-Host "   - $($album.album_type) '$($album.name)' released by '${artistName}' on '$($album.release_date)'." -ForegroundColor Green
                
                # Add filtered tracks from the album to the array
                $albumTracks += Get-FilteredAlbumTracks -AlbumId $album.id `
                    -AlbumReleaseDate $album.release_date `
                    -ArtistId $artistId `
                    -IncludeUserMarket $userMarket `
                    -ExcludedTitleKeywords $ExcludedTitleKeywords `
                    -ExcludeTrackMinDurationMs $ExcludeTrackMinDurationMs `
                    -ExcludeArtistNames $ExcludeArtistNames `
                    -MaxTracksPerRelease $MaxTracksPerRelease `
                    -SpotishellAppName $SpotishellAppName
            }
        }

        # If there are new tracks, add them to the playlist
        if ($albumTracks) {
            # Update the playlist
            $tracksAdded = Update-Playlist -PlaylistId $spotifyPlaylistId `
            -NewTracks $albumTracks `
            -MaxPlaylistTracks $MaxPlaylistTracks `
            -DelTracksReleasedLaterThanDays $DelTracksReleasedLaterThanDays `
            -SpotishellAppName $SpotishellAppName

            # Update the last run date
            $todaysDate = (Get-Date).ToString("yyyy-MM-dd")
            $todaysDate | Out-File -FilePath $LastRunDateFilePath
            Write-Host "Updated last run date to '${todaysDate}' in file: $LastRunDateFilePath"      
        }
        else {
            Write-Host "No new tracks found to add to the playlist."
        }
    }
    catch {
        $errorDetails = [string]$error[0]
        $errorLine = [string]$error[0].InvocationInfo.PositionMessage
        throw "An error occurred during Update-ArtistsReleases at line $($errorLine): $errorDetails"
    }
}

# Main script execution
try {
    # Assert PowerShell Core is used
    Assert-PowerShellCore -Exit

    # Ensure Spotishell module is installed and set up
    Install-SpotishellModule
    
    # Trigger main function
    Update-ArtistsReleases `
        -SpotifyPlaylistName $SpotifyPlaylistName `
        -IncludeArtistIds $IncludeArtistIds `
        -GetRelatedArtists $GetRelatedArtists `
        -MaxPlaylistTracks $MaxPlaylistTracks `
        -ExcludeArtistNames $ExcludeArtistNames `
        -MaxTracksPerRelease $MaxTracksPerRelease `
        -IncludeAlbumTypes $IncludeAlbumTypes `
        -ExcludedTitleKeywords $ExcludedTitleKeywords `
        -ExcludeTrackMinDurationMs $ExcludeTrackMinDurationMs `
        -LastRunDateFilePath $LastRunDateFilePath `
        -SpotishellAppName $SpotishellAppName
}
catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
finally {
    # Stop Transcript
    Stop-Transcript
}