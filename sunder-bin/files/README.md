<div align="center">

![Sunder](Media/banner.svg)


[![AUR votes](https://img.shields.io/aur/votes/sunder?logo=arch-linux&style=flat-square&color=blue)](https://aur.archlinux.org/packages/sunder)
[![GitHub stars](https://img.shields.io/github/stars/FrogSnot/Sunder?style=flat-square&color=yellow)](https://github.com/FrogSnot/Sunder)
![Tauri v2](https://img.shields.io/badge/Tauri-v2-FFC131?style=flat-square&logo=tauri&logoColor=white)
![Rust](https://img.shields.io/badge/Rust-000000?style=flat-square&logo=rust&logoColor=white)
![Svelte 5](https://img.shields.io/badge/Svelte-5-FF3E00?style=flat-square&logo=svelte&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-003B57?style=flat-square&logo=sqlite&logoColor=white)
[![License](https://img.shields.io/badge/License-AGPL--3.0-blue?style=flat-square)](LICENSE)

</div>

---

## What is Sunder?

Sunder is a lightweight, native desktop music player that streams from YouTube without the bloat. Built with Tauri v2 and Rust, it uses a fraction of the memory that Electron-based alternatives consume while delivering a buttery smooth UI with hand-crafted animations.

The name says it all: to *sunder* means to split apart. We split the music from the surveillance.

## Features

### Playback
- **Dual-source search** queries YouTube Music and regular YouTube simultaneously, ranked and deduplicated
- **Native audio** via rodio, talking directly to ALSA/PipeWire/Pulse with no Web Audio overhead
- **Playback speed control** adjustable from 0.25x to 3x via a slider in the controls popup
- **Smart error recovery** if a track fails (geo-blocked, age-gated, unavailable), a banner appears offering to find an alternative version automatically, with auto-skip fallback if ignored
- **Retry with bypass** yt-dlp failures trigger a silent retry with `--force-ipv4` and `--geo-bypass` before giving up
- **Non-blocking prefetch** audio is prepared in a background thread with early session checks to discard stale loads; upcoming tracks are pre-downloaded for seamless transitions

### Lyrics
- **Synchronized lyrics** fetched on demand via yt-dlp subtitles and displayed in a dedicated view
- **Lazy fetch** lyrics are only requested when the lyrics panel is opened, never on every track load

### Queue
- **Three-section view**: Now Playing card, Next Up (with drag-to-reorder), Previously Played
- **Fluid animations** track cards slide and flip into position when the song changes, when you drag-reorder, or when tracks enter/leave the queue
- **Context menu integration** right-click any track to play next, add/remove from queue, add to or remove from a playlist
- **Auto-advance**: queue advances automatically on track end; stops gracefully after 3 consecutive errors

### Playlists
- **Full CRUD** with inline rename, quick-play, and drag-to-reorder
- **YouTube Music playlist import** paste a YT Music playlist URL to import it by name in one step
- **JSON export/import** export any playlist to a JSON file and re-import it on another machine or as a backup
- **Remove from context menu** right-click any track to remove it from the current playlist

### System Integration
- **MPRIS support** (Linux) full media player remote interface: play/pause, next, previous, metadata, and position exposed to desktop environments and media key daemons
- **Windows media keys** HWND-based system media controller wired to the same events
- **System tray** cross-platform tray icon with play/pause, next, previous, and quit controls; left-click raises the window
- **Global keyboard shortcuts** media keys and configurable bindings for seek and volume

### Settings
- **Persistent config** volume level, EQ enabled state, and EQ band gains are saved across restarts
- **Audio equalizer** 10-band parametric EQ with per-band gain control

### App
- **Focus View** full-screen mode with blurred album art background, toggled with `V` or the focus button
- **Playback Controls popup** consolidates EQ, notifications, speed, and sleep timer into a single dropdown
- **Explore** with personalized recommendations built from your listening history
- **Warm animated UI** with spring physics, staggered entrances, glow pulses, and micro-interactions
- **~15MB binary** with release optimizations (LTO, strip, single codegen unit)
- **Zero telemetry**. Nothing leaves your machine except YouTube search queries

## Install

### Arch Linux (AUR)

```bash
# Source build
yay -S sunder

# Prebuilt binary
yay -S sunder-bin
```

### Debian/Ubuntu

Download the `.deb` from [Releases](https://github.com/FrogSnot/Sunder/releases):

```bash
sudo dpkg -i sunder_*_amd64.deb
```

### Other Linux

Download the `.AppImage` from [Releases](https://github.com/FrogSnot/Sunder/releases):

```bash
chmod +x Sunder_*.AppImage
./Sunder_*.AppImage
```

### Windows

Download the `.exe` installer from [Releases](https://github.com/FrogSnot/Sunder/releases).

### macOS

Download the `.dmg` from [Releases](https://github.com/FrogSnot/Sunder/releases).

### Runtime Dependencies

[yt-dlp](https://github.com/yt-dlp/yt-dlp) and [ffmpeg](https://ffmpeg.org/) must be installed and on PATH:

```bash
# Arch
sudo pacman -S yt-dlp ffmpeg

# Ubuntu/Debian
sudo apt install yt-dlp ffmpeg

# macOS
brew install yt-dlp ffmpeg

# Windows (scoop)
scoop install yt-dlp ffmpeg
```

## Tech Stack

| Layer | Technology | Why |
|-------|-----------|-----|
| Shell | **Tauri v2** | Native webview, no bundled browser. ~100x lighter than Electron |
| Frontend | **Svelte 5** | Runes-based reactivity, zero virtual DOM overhead |
| Audio | **rodio 0.19** | Pure Rust audio with symphonia decoders (MP3/AAC/FLAC/Vorbis/WAV) |
| Extraction | **yt-dlp** | Reliable stream URL resolution, community-maintained |
| Database | **SQLite + FTS5** | WAL-mode for concurrent reads, full-text search on cached tracks |
| Build | **Vite 6** | Sub-second HMR, optimized production builds |


### Why this beats Electron music apps

1. **Memory**: Sunder idles at ~40MB. Electron apps start at 200MB+.
2. **Startup**: Native webview launches in milliseconds. No Chromium cold-start.
3. **Audio**: rodio talks directly to your OS audio stack. No Web Audio API jank.
4. **Privacy**: yt-dlp runs locally. No Google account, no tracking cookies.
5. **Size**: The release binary is ~15MB. Electron apps ship 150MB+ of Chromium.

## Development

### Prerequisites

- **Rust** (stable, 2021 edition)
- **Node.js** >= 18
- **yt-dlp** and **ffmpeg** installed and on PATH

Linux dev dependencies:

```bash
# Arch
sudo pacman -S webkit2gtk-4.1 base-devel libappindicator-gtk3 librsvg pango atk

# Ubuntu/Debian
sudo apt install libwebkit2gtk-4.1-dev build-essential curl wget file libssl-dev libgtk-3-dev libayatana-appindicator3-dev librsvg2-dev
```

### Run

```bash
git clone https://github.com/FrogSnot/Sunder.git
cd Sunder
npm install
npm run tauri dev
```

### Build

```bash
npm run tauri build
```

The optimized binary lands in `src-tauri/target/release/sunder`.

## UI Design

Warm, golden-tinted dark palette designed for long listening sessions:

- **Base**: Deep warm blacks (`#0f0e0d`, `#181614`)
- **Accent**: Burnished gold (`#e0a820`) with ambient glow effects
- **Animations**: 11+ custom keyframe animations including spring physics, staggered cascades, equalizer loaders, and floating idle states

Every interaction has tactile feedback. Buttons snap with spring easing, tracks lift on hover, active items pulse with a warm glow. The queue uses Svelte's `flip` and `fly` transitions so card positions animate smoothly during reorder and song changes -- tracks cascade up one by one when a new song starts, and slide out cleanly when removed.

## Data

The database is stored locally in platform-specific locations:

- **Linux**: `~/.local/share/com.sunder.app/`
- **Windows**: `%APPDATA%\com.sunder.app\`
- **macOS**: `~/Library/Application Support/com.sunder.app/`

Audio is cached temporarily in `/tmp/sunder/` and automatically reused on replay.

## Roadmap

- [x] Audio equalizer
- [x] Lyrics display
- [x] Keyboard shortcuts / media key support
- [x] System tray with playback controls
- [x] MPRIS / system media controller (Linux + Windows)
- [x] Dual-source search (YouTube Music + YouTube)
- [x] YouTube Music playlist import
- [x] Playlist JSON export/import
- [x] Persistent settings (volume, EQ)
- [x] Playback speed control
- [x] Focus View mode
- [ ] Local track downloads with library management

## Contributing

Interested in contributing? Please read [CONTRIBUTING.md](CONTRIBUTING.md) first.

**TL;DR: We do not accept mega-PRs.** If your PR touches more than 10 files or exceeds 500 lines of code, it will be rejected. Split it into smaller, atomic PRs. This includes AI-generated code. You are responsible for breaking it into review-sized chunks before submitting.

Small, focused contributions get merged fast. Massive PRs get closed without review.

## License

AGPLv3
