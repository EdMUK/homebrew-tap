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
      url "https://github.com/EdMUK/termmd/releases/download/v0.1.4/termmd-aarch64-apple-darwin.tar.gz"
      sha256 "2b27d35e9bc1ee05c110a94a5578234f5952a8860c18344b51a237e2e19b1040"
    end
    on_intel do
      url "https://github.com/EdMUK/termmd/releases/download/v0.1.4/termmd-x86_64-apple-darwin.tar.gz"
      sha256 "2bd215a7d74f3a206375f761275607be543ae8809a5173bf54dfe5af25a17b6d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/EdMUK/termmd/releases/download/v0.1.4/termmd-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "da1c2a066722b8224086d5846f86ca1595f0f1156f54b99ae300dd60f2e005b1"
    end
    on_intel do
      url "https://github.com/EdMUK/termmd/releases/download/v0.1.4/termmd-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "852714895a4201ae9d016b7689b38bf239ad0be5419a26cb4b9eaf641d02a650"
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
