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
      url "https://github.com/EdMUK/termmd/releases/download/v0.1.3/termmd-aarch64-apple-darwin.tar.gz"
      sha256 "8ec3c7ab763573843af65df31ef4b7e2aaf50a404460e4d7bb89acdd97860090"
    end
    on_intel do
      url "https://github.com/EdMUK/termmd/releases/download/v0.1.3/termmd-x86_64-apple-darwin.tar.gz"
      sha256 "3a5872154e14e842ae7d68b50299284718a439a3b1368bde24e0f3156f983310"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/EdMUK/termmd/releases/download/v0.1.3/termmd-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "51aea7147d20195706372fabf5009d3a33c35f052c09c74730777bbdc4863e5f"
    end
    on_intel do
      url "https://github.com/EdMUK/termmd/releases/download/v0.1.3/termmd-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "855a373dec249b675fc39e0cc2a92c95a0cdda60402ce14f4f6c3bb027d3434b"
    end
  end

  def install
    bin.install "termmd"
    doc.install "README.md", "CHANGELOG.md"
    pkgshare.install "config.example.toml"

    man1.install "termmd.1"
    bash_completion.install "completions/termmd.bash" => "termmd"
    zsh_completion.install "completions/_termmd"
    fish_completion.install "completions/termmd.fish"
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
