class Amp < Formula
  desc "Text editor for your terminal"
  homepage "https://amp.rs"
  url "https://github.com/jmacdonald/amp/archive/0.3.1.tar.gz"
  sha256 "24740a78488a82c53c65c201a8da6b6380fe1a167e96052a57c7d587630771d8"
  head "https://github.com/jmacdonald/amp.git"

  depends_on "rust" => :build
  depends_on "cmake" => :build
  depends_on "openssl" => :build
  depends_on "libssh2" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/amp"
  end

  test do
    # Start and stop amp gracefully.
    pid = spawn "#{bin}/amp"
    Process.kill "INT", pid

    # Collect and return the amp process' status.
    _, status = Process.wait2 pid
    status
  end
end
