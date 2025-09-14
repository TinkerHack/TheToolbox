# Get-FollowedArtistsReleases

This PowerShell script updates a Spotify playlist with new releases from your followed artists. The script maintains the playlist by automatically removing older tracks based on configurable settings.

## Getting Started

1. Go to https://developer.spotify.com/ and register for a new Spotify application.
   Make sure to note down the Client ID and Client Secret - you'll need these later.

2. While still at https://developer.spotify.com/ 
   Add `http://localhost:8080/spotishell` (without the quotes) as a "Redirect URIs" in your app settings.

3. Open PowerShell cmd as administrator and Install the Spotishell module from PSGallery:
   ```powershell
   Install-Module Spotishell
   ```

4. Import the Spotishell module:
   ```powershell
   Import-Module Spotishell
   ```

5. Set up your Spotify application credentials (replace with your actual Client ID and Client Secret from step 1):
   ```powershell
   New-SpotifyApplication -ClientId "your_client_id" -ClientSecret "your_client_secret"
   ```

6. Open your Spotify application and create a new playlist with a UNIQUE name, like "My New Releases".
   You'll use this name when running the script in the last step.

7. Save this script in folder of your chosing (e.g. C:\FolderName\Get-FollowedArtistsReleases.ps1).

8. You're now ready to run the script in Powershell cmd using the following command (and default values):
   ```powershell
   & "C:\FolderName\Get-FollowedArtistsReleases.ps1" -SpotifyPlaylistName "My New Releases"
   ```

## Parameters

- `SpotifyPlaylistName`: The name of the Spotify playlist to update. This parameter is mandatory.
- `DelTracksReleasedLaterThanDays`: The number of days after which tracks should be removed from the playlist. Default: 90 days.
- `MaxPlaylistTracks`: The maximum number of tracks to keep in the playlist. When exceeded, oldest tracks are removed first. Default: 100 tracks.
- `MaxTracksPerRelease`: The maximum number of tracks to add per release. Useful for albums with many tracks. Default: 5 tracks per release.
- `IncludeAlbumTypes`: An array of album types to include. Default: `("album", "single")`.
- `ExcludeArtistNames`: An array of artist names to exclude from the search.
- `ExcludedTitleKeywords`: An array of keywords to exclude from track titles.
- `ExcludeTrackMinDurationMs`: The minimum duration (in milliseconds) for a track to be included. Default: 120000 (2 minutes).
- `SpotishellAppName`: The Spotishell application name to use. Default: "default".

## Examples

### Basic usage with default settings
```powershell
.\Get-FollowedArtistsReleases.ps1 -SpotifyPlaylistName "My New Releases"
```

### Extended retention period and larger playlist
```powershell
.\Get-FollowedArtistsReleases.ps1 -SpotifyPlaylistName "My New Releases" -MaxPlaylistTracks 150 -MaxTracksPerRelease 3 -DelTracksReleasedLaterThanDays 45
```

### Using custom exclusion rules
```powershell
.\Get-FollowedArtistsReleases.ps1 -SpotifyPlaylistName "My New Releases" `
    -ExcludedTitleKeywords @("Live", "Demo", "Radio Edit") `
    -ExcludeArtistNames @("Various Artists", "My Excluded Artist")
```
