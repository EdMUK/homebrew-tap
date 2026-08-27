# homebrew-tap

Homebrew formulae for [EdMUK](https://github.com/EdMUK)'s tools.

```sh
brew install EdMUK/tap/termmd
```

`brew tap EdMUK/tap` first is optional; installing by the full name taps it.

## termmd

[A Markdown viewer for terminals that can do more than plain
text](https://github.com/EdMUK/termmd): images through the kitty, iTerm2 and
sixel protocols, tables measured to fit, and an interactive pager.

The formula installs the prebuilt binary for your platform from the termmd
release rather than compiling: the crate reaches `resvg` and `syntect`, which is
a long build for something someone is trying out. macOS and Linux, Intel and
Arm.

## Updating a formula for a new release

The checksums are published with the release, so a version bump is the URLs, the
four `sha256` lines, and nothing else:

```sh
curl -sSL https://github.com/EdMUK/termmd/releases/download/vX.Y.Z/SHA256SUMS
brew style EdMUK/tap/termmd && brew audit --strict --online EdMUK/tap/termmd
```

From termmd 0.1.2 the release archives carry the man page and the completion
scripts, and the formula installs them without further change.
