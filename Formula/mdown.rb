class Mdown < Formula
  desc "Fast, native macOS Markdown reader built with SwiftUI and cmark-gfm"
  homepage "https://github.com/pcresswell/mdown"
  url "https://github.com/pcresswell/mdown/archive/refs/tags/v1.10.tar.gz"
  sha256 "5cec37d781ac61b610dc5b515d95a2ec138c021c0e2efbe1968b4e19e386a9f0"
  license "MIT"

  depends_on xcode: ["15.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"

    # Swift puts the binary under an arch-specific path
    bin_path = Dir[".build/*-apple-macosx/release/MDown"].first
    raise "MDown binary not found after build" unless bin_path

    bin.install bin_path => "mdown"

    # SwiftPM resource bundle (mermaid.min.js, loaded via Bundle.module).
    resource_bundle = Dir[".build/*-apple-macosx/release/MDown_MDown.bundle"].first

    # Place it next to the CLI binary so `mdown file.md` finds it too.
    cp_r resource_bundle, bin if resource_bundle

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

    # Bundle.module resolves via Bundle.main.resourceURL when launched as an
    # .app, so the resource bundle must live in Contents/Resources for Mermaid
    # diagrams to render.
    cp_r resource_bundle, resources if resource_bundle
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
