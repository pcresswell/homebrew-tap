class Mdown < Formula
  desc "Fast, native macOS Markdown reader built with SwiftUI and cmark-gfm"
  homepage "https://github.com/pcresswell/mdown"
  url "https://github.com/pcresswell/mdown/archive/refs/tags/v1.6.tar.gz"
  sha256 "8510e39e3ccb1bc6996fc3bca4df449ca2d2913eb3c02883ce76a5c392e8bd1e"
  license "MIT"

  depends_on xcode: ["15.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"

    # Swift puts the binary under an arch-specific path
    bin_path = Dir[".build/*-apple-macosx/release/MDown"].first
    raise "MDown binary not found after build" unless bin_path

    bin.install bin_path => "mdown"

    # Build the .app bundle
    app_bundle = prefix/"MDown.app"
    contents = app_bundle/"Contents"
    macos_dir = contents/"MacOS"
    resources = contents/"Resources"

    macos_dir.mkpath
    resources.mkpath

    cp bin/"mdown", macos_dir/"MDown"
    cp "Resources/Info.plist", contents/"Info.plist"
    cp "Resources/MDown.icns", resources/"MDown.icns" if File.exist?("Resources/MDown.icns")
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
