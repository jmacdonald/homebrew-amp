class Amp < Formula
  desc "Text editor for your terminal"
  homepage "https://amp.rs"
  url "https://github.com/jmacdonald/amp/archive/0.3.2.tar.gz"
  sha256 "9080c894111149d58a0b805e0c08edaf1d9e7cd56c4b955ba9111feec6b55208"
  head "https://github.com/jmacdonald/amp.git"

  depends_on "rust" => :build
  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "libssh2"

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
