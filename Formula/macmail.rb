class Macmail < Formula
  desc "CLI tool to query and read emails stored locally by Apple Mail on macOS"
  homepage "https://github.com/pcresswell/macmail"
  url "https://github.com/pcresswell/macmail/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "5b403b875cf809395a4686c4cee986bcce001335e1e3fa5ef74642c625a62c66"
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
