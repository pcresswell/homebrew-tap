class Macmail < Formula
  desc "CLI tool to query and read emails stored locally by Apple Mail on macOS"
  homepage "https://github.com/pcresswell/macmail"
  url "https://github.com/pcresswell/macmail/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "182828669169f8efec017a4992e830f0976f9d6e23c3aabd0089e5fd98e87219"
  license "MIT"

  depends_on "go" => :build
  depends_on :macos

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/macmail"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macmail --version")
  end
end
