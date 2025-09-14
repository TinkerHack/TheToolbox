# Get-ArtistsReleases

This PowerShell script updates a Spotify playlist with new releases from specified artists by their Spotify IDs. The script maintains the playlist by automatically removing older tracks based on configurable settings.

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

6. Open your Spotify application and create a new playlist with a UNIQUE name, like "Artists New Releases".
   You'll use this name when running the script in the last step.

7. Save this script in folder of your chosing (e.g. C:\FolderName\Get-ArtistsReleases.ps1).

8. You're now ready to run the script in Powershell cmd using the following command (and default values):
   ```powershell
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
   ```

## Parameters

- `SpotifyPlaylistName`: The name of the Spotify playlist to update. This parameter is mandatory.
- `IncludeArtistIds`: List of Spotify artist IDs to fetch new releases from.
- `GetRelatedArtists`: Get related artists for each artist in `$IncludeArtistIds`.
- `DelTracksReleasedLaterThanDays`: The number of days after which tracks should be removed from the playlist. Default: 30 days.
- `MaxPlaylistTracks`: The maximum number of tracks to keep in the playlist. When exceeded, oldest tracks are removed first. Default: 100 tracks.
- `MaxTracksPerRelease`: The maximum number of tracks to add per release. Useful for albums with many tracks. Default: 5 tracks per release.
- `IncludeAlbumTypes`: An array of album types to include. Default: `("album", "single")`.
- `ExcludeArtistNames`: An array of artist names to exclude from the search.
- `ExcludedTitleKeywords`: An array of keywords to exclude from track titles.
- `ExcludeTrackMinDurationMs`: The minimum duration (in milliseconds) for a track to be included. Default: 120000 (2 minutes).
- `SpotishellAppName`: The Spotishell application name to use. Default: "default".

## Example

```powershell
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
```

### How to find artist IDs:
1. Open Spotify web player (open.spotify.com)
2. Navigate to the artist's page
3. The ID is in the URL: https://open.spotify.com/artist/6XyY86QOPPrYVGvF9ch6wz
In this example, "6XyY86QOPPrYVGvF9ch6wz" is the artist ID
