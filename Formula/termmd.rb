# Installs the release archive rather than building from source: termmd pulls in
# resvg and syntect, which is a long compile for a viewer someone wants to try.
class Termmd < Formula
  desc "Markdown viewer for terminals that can do more than plain text"
  homepage "https://github.com/EdMUK/termmd"
  license "MIT"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/EdMUK/termmd/releases/download/v0.1.1/termmd-aarch64-apple-darwin.tar.gz"
      sha256 "1088b51060c9f1346b76c808a688b227af9310ccee40bbf0b617627423afa516"
    end
    on_intel do
      url "https://github.com/EdMUK/termmd/releases/download/v0.1.1/termmd-x86_64-apple-darwin.tar.gz"
      sha256 "4fb6a694216d8f02dda8e0a0cdc8c422a0667cc5026614bcc4937e3a899e75d9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/EdMUK/termmd/releases/download/v0.1.1/termmd-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "755049f292e3d085dda57f68c5849ad5aed972ca04e66ed44add7fed274bb8ca"
    end
    on_intel do
      url "https://github.com/EdMUK/termmd/releases/download/v0.1.1/termmd-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5dfc59975d432552371cccaa3912b8a077faa9e411d322ff029b2aa4dac0fa3d"
    end
  end

  def install
    bin.install "termmd"
    doc.install "README.md", "CHANGELOG.md"
    pkgshare.install "config.example.toml"

    # 0.1.1 carries neither. Both arrive in the next release's archive, and are
    # installed from it without this formula needing anything but a version bump.
    man1.install "termmd.1" if File.exist?("termmd.1")
    if File.directory?("completions")
      bash_completion.install "completions/termmd.bash" => "termmd"
      zsh_completion.install "completions/_termmd"
      fish_completion.install "completions/termmd.fish"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/termmd --version")

    (testpath/"doc.md").write("# Heading\n\nSome **text**, and a | table |.\n")
    output = shell_output("#{bin}/termmd -P --width 40 #{testpath}/doc.md")
    assert_match "Heading", output

    # Piped output carries no escape sequences, which is the contract that lets
    # termmd be used in a pipeline.
    refute_match(/\e\[/, output)
  end
end
