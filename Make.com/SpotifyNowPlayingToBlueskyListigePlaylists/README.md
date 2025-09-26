# Spotify Now Playing to Bluesky for ListigePlaylists

This Make.com blueprint automatically shares your currently playing Spotify track to Bluesky, making it easy to contribute to the [@listigeplaylists.bsky.social](https://bsky.app/profile/listigeplaylists.bsky.social) curated playlist\!

Perfect for music lovers who want to share their listening habits and contribute to the community playlist without any manual effort.

## What This Does

Every time you play a new track on Spotify, this automation will:

1.  Detect your currently playing song
2.  Download the album artwork
3.  Create a beautiful Bluesky post with:
      - Song title and artist name
      - Album artwork
      - Link to the track on Spotify
      - A mention to @listigeplaylists.bsky.social

## How It Works

You can see a live example of this automation running every four hours on our showcase profile: [TinkerHack on Bluesky](https://bsky.app/profile/tinkerhack.bsky.social).

## Make.com Free Plan Information

This blueprint works with Make.com's free plan\! Here's what you need to know:

  - **Free plan gives you:** 1,000 operations per month
  - **This scenario uses:** 5 operations per run
  - **Maximum runs per month:** 200 runs (1,000 ÷ 5)

## Scheduling Options

The blueprint schedule is preset to run **every 4 hours**. With this setting, you should be able to post for the entire month using the 1000 free credits you receive. If you want to post more frequently, you can simply change the interval, but be aware that your free credits will run out before they are renewed.

### Option 1: Conservative Schedule (Recommended and Preset for Free Plan)

**Run every 4 hours**

  - **Runs per day:** 6 (24 hours ÷ 4 hours)
  - **Runs per month:** \~180 (6 × 30 days)
  - **Operations used:** \~900 (180 × 5)
  - **Remaining buffer:** 100 operations

This schedule ensures you stay well within free plan limits while still capturing your listening activity throughout the day. It's also less "spammy" on Bluesky, giving your followers a nice overview of your music taste without overwhelming them.

### Option 2: Frequent Schedule (For More Active Sharing)

**Run every 15 minutes**

  - **Runs per day:** 96 (24 hours × 60 minutes ÷ 15 minutes)
  - **Runs per month:** \~2,880 (96 × 30 days)
  - **Operations required:** \~14,400 (2,880 × 5)

⚠️ **Important:** This option would exceed the free plan limits within the first day\! To use this schedule, you would need a paid Make.com plan.

### Customizing Your Schedule

You can set any schedule that works for you\! Here's how to calculate your usage:

**Formula:**
Operations per month = (24 ÷ hours between runs) × 30 days × 5 operations.

To stay within the free plan (1,000 operations), the minimum time between runs should be 3.6 hours. Setting it to run every 4 hours or more will keep you within free limits.

## Setup Instructions

### Step 1: Import the Blueprint

1.  [Download the blueprint file](https://github.com/TinkerHack/TheToolbox/blob/main/Make.com/SpotifyNowPlayingToBlueskyListigePlaylists/Spotify%20Now%20Playing%20to%20Bluesky%20ListigePlaylists.blueprint.json)
2.  Go to [Make.com](https://make.com) and create a free account
3.  Click "Create a new scenario" → "Import blueprint" → Upload the downloaded file

### Step 2: Connect Your Accounts

1.  **Spotify Connection:**

      - Click the Spotify module
      - Click "Add" → "Connect to Spotify"
      - Log in to your Spotify account and authorize Make.com

2.  **Bluesky Connection:**

      - Click one of the Bluesky modules
      - Click "Add" → "Connect to Bluesky"

    > 💡 **Security Tip:** It's recommended to create a dedicated app password for this integration instead of using your main Bluesky password:

    > 1.  Go to [Bluesky Settings](https://bsky.app/settings)
    > 2.  Select "App Passwords" under "Advanced"
    > 3.  Create a new password (e.g., "Make.com Integration")
    > 4.  Use this generated password when connecting Make.com to Bluesky

      - Log in to your Bluesky account using the app password

### Step 3: Configure the Bluesky Post

1.  In the scenario, click on the fourth module (the one with a JSON icon, labeled "Create JSON").
2.  In the `repo` field, replace the text `[REPLACE WITH YOUR HANDLE HERE].bsky.social` with your own Bluesky handle.
3.  Example: `yourname.bsky.social`.
4.  Click "OK" to save the changes.

### Step 4: Set Your Schedule

1.  Click the clock icon on the first module (Spotify).
2.  The schedule is already set to **every 4 hours**, which is recommended for the free plan. You can adjust this if you wish, but keep your monthly operations usage in mind.
3.  Click "OK" to save.

### Step 5: Activate the Scenario

1.  Click the "On/Off" switch at the bottom left.
2.  Confirm activation.

That's it\! Your scenario will now automatically post your currently playing tracks to Bluesky according to your schedule.

## Troubleshooting

  - **Scenario not running?** Make sure you've activated it and the schedule is set correctly.
  - **Missing posts?** The scenario only captures new tracks played after activation.
  - **Credits running low?** You can check your usage in Make.com under "Operations" in the left menu.
  - **Too many posts?** Increase the time between runs in your schedule settings.

## Need Help?

If you run into any issues:

1.  Check Make.com's help documentation
2.  Reach out to [@listigeplaylists.bsky.social](https://bsky.app/profile/listigeplaylists.bsky.social) for community support

Enjoy sharing your music journey with the Bluesky community\! 🎵
