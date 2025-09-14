# Spotify Now Playing to Bluesky for ListigePlaylists

This Make.com blueprint automatically shares your currently playing Spotify track to Bluesky, making it easy to contribute to the [@listigeplaylists.bsky.social](https://bsky.app/profile/listigeplaylists.bsky.social) curated playlist!

Perfect for music lovers who want to share their listening habits and contribute to the community playlist without any manual effort.

## What This Does

Every time you play a new track on Spotify, this automation will:
1. Detect your currently playing song
2. Download the album artwork
3. Create a beautiful Bluesky post with:
   - Song title and artist name
   - Album artwork
   - Link to the track on Spotify
   - A mention to @listigeplaylists.bsky.social

## Make.com Free Plan Information

This blueprint works with Make.com's free plan! Here's what you need to know:

- **Free plan gives you:** 1,000 operations per month
- **This scenario uses:** 5 operations per run
- **Maximum runs per month:** 200 runs (1,000 ÷ 5)

## Scheduling Options

You can choose how frequently this automation runs based on your needs and Make.com plan. Here are two common configurations:

### Option 1: Conservative Schedule (Recommended for Free Plan)
**Run every 4 hours**
- **Runs per day:** 6 (24 hours ÷ 4 hours)
- **Runs per month:** ~180 (6 × 30 days)
- **Operations used:** ~900 (180 × 5)
- **Remaining buffer:** 100 operations

This schedule ensures you stay well within free plan limits while still capturing your listening activity throughout the day. It's also less "spammy" on Bluesky, giving your followers a nice overview of your music taste without overwhelming them.

### Option 2: Frequent Schedule (For More Active Sharing)
**Run every 15 minutes**
- **Runs per day:** 96 (24 hours × 60 minutes ÷ 15 minutes)
- **Runs per month:** ~2,880 (96 × 30 days)
- **Operations required:** ~14,400 (2,880 × 5)

⚠️ **Important:** This option would exceed the free plan limits within the first day! To use this schedule, you would need:
- A paid Make.com plan (starting at $9/month for 10,000 operations)
- Or to manually turn the scenario on/off when you want to share music

This schedule captures almost everything you listen to in real-time, making it ideal for heavy music listeners who want to share their activity as it happens.

### Customizing Your Schedule

You can set any schedule that works for you! Here's how to calculate your usage:

**Formula:**
Operations per month = (24 ÷ hours between runs) × 30 days × 5 operations.

**Example calculations:**
- Every 30 minutes: (24 ÷ 0.5) × 30 × 5 = 7,200 operations/month
- Every 2 hours: (24 ÷ 2) × 30 × 5 = 1,800 operations/month
- Every 6 hours: (24 ÷ 6) × 30 × 5 = 600 operations/month

To stay within the free plan (1,000 operations), the minimum time between runs should be:
Minimum hours = (24 × 30 × 5) ÷ 1,000 = 3.6 hours

So setting it to run every 4 hours or more will keep you within free limits.

## Setup Instructions

### Step 1: Import the Blueprint
1. [Download the blueprint file](https://github.com/TinkerHack/TheToolbox/blob/main/Make.com/SpotifyNowPlayingToBlueskyListigePlaylists/Spotify%20Now%20Playing%20to%20Bluesky%20ListigePlaylists.blueprint.json)
2. Go to [Make.com](https://make.com) and create a free account
3. Click "Create a new scenario" → "Import blueprint" → Upload the downloaded file

### Step 2: Connect Your Accounts
1. **Spotify Connection:**
   - Click the Spotify module
   - Click "Add" → "Connect to Spotify"
   - Log in to your Spotify account and authorize Make.com

2. **Bluesky Connection:**
   - Click the Bluesky module
   - Click "Add" → "Connect to Bluesky"
   - Log in to your Bluesky account and authorize Make.com

### Step 3: Set Your Schedule
1. Click the clock icon at the top of your scenario
2. Choose your preferred schedule:
   - **Recommended for free plan:** Every 4 hours
   - **For more active sharing:** Every 15 minutes (requires paid plan)
   - **Custom:** Select "Custom" and set your desired interval
3. Click "OK" to save

### Step 4: Activate the Scenario
1. Click the "On/Off" switch at the bottom right
2. Confirm activation when prompted

That's it! Your scenario will now automatically post your currently playing tracks to Bluesky according to your schedule.

## Troubleshooting

- **Scenario not running?** Make sure you've activated it and the schedule is set correctly.
- **Missing posts?** The scenario only captures new tracks played after activation.
- **Credits running low?** You can check your usage in Make.com under "Operations" in the left menu.
- **Too many posts?** Increase the time between runs in your schedule settings.

## Need Help?

If you run into any issues:
1. Check Make.com's help documentation
2. Reach out to [@listigeplaylists.bsky.social](https://bsky.app/profile/listigeplaylists.bsky.social) for community support

Enjoy sharing your music journey with the Bluesky community! 🎵