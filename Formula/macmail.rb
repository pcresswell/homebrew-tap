class Macmail < Formula
  desc "CLI tool to query and read emails stored locally by Apple Mail on macOS"
  homepage "https://github.com/pcresswell/macmail"
  url "https://github.com/pcresswell/macmail/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "a406590785162b7b2c91554c7039756f726afa78bccbce1875a84d7dd93a3250"
  license "MIT"

  depends_on "go" => :build
  depends_on :macos

  def install
    system "go", "mod", "tidy"
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/macmail"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macmail --version")
  end
end
