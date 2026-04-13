class Mdown < Formula
  desc "Fast, native macOS Markdown reader built with SwiftUI and cmark-gfm"
  homepage "https://github.com/pcresswell/mdown"
  url "https://github.com/pcresswell/mdown/archive/refs/tags/v1.5.tar.gz"
  sha256 "897f5705884937987ee7af09612be192f6b4396bc4c7db2ff2eec8b7f5cca026"
  license "MIT"

  depends_on xcode: ["15.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/MDown" => "mdown"

    # Build the .app bundle
    app_bundle = prefix/"MDown.app"
    contents = app_bundle/"Contents"
    macos_dir = contents/"MacOS"
    resources = contents/"Resources"

    macos_dir.mkpath
    resources.mkpath

    cp ".build/release/MDown", macos_dir/"MDown"
    cp "Resources/Info.plist", contents/"Info.plist"
    cp "Resources/MDown.icns", resources/"MDown.icns" if File.exist?("Resources/MDown.icns")

    # Link the .app bundle into the global Applications directory
    (HOMEBREW_PREFIX/"bin").install_symlink bin/"mdown"
  end

  def caveats
    <<~EOS
      MDown.app has been built at:
        #{prefix}/MDown.app

      To install it in /Applications, run:
        ln -sf #{prefix}/MDown.app /Applications/MDown.app
    EOS
  end

  test do
    assert_predicate bin/"mdown", :exist?
  end
end
