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
      url "https://github.com/EdMUK/termmd/releases/download/v0.1.2/termmd-aarch64-apple-darwin.tar.gz"
      sha256 "f4bf9ecd697ab0e89e0ecccd8d9e9ef17de933304bb6a9836a7ed694e248c30b"
    end
    on_intel do
      url "https://github.com/EdMUK/termmd/releases/download/v0.1.2/termmd-x86_64-apple-darwin.tar.gz"
      sha256 "41f514f364165c93d16ccb41ccdacf2d7027021437660ff7fe4798a2965c6c9e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/EdMUK/termmd/releases/download/v0.1.2/termmd-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9253bc848246d5f22f472142a5393316db6ecbae7a1f79aeda69f2770aca700a"
    end
    on_intel do
      url "https://github.com/EdMUK/termmd/releases/download/v0.1.2/termmd-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "737e12c41c96bbbec657e63c43c697a0283ed0d111431facbc1910a4345b010e"
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
