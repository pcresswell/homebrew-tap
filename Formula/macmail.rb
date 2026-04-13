class Macmail < Formula
  desc "CLI tool to query and read emails stored locally by Apple Mail on macOS"
  homepage "https://github.com/pcresswell/macmail"
  url "https://github.com/pcresswell/macmail/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "a53621f8402cb8a6b20b763bfa6d7758792187d224bcbd59dbf938b79b317ac3"
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
