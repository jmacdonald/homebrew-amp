class Amp < Formula
  desc "Text editor for your terminal"
  homepage "https://amp.rs"
  url "https://github.com/jmacdonald/amp/archive/0.3.0.tar.gz"
  sha256 "c864fe79c44684a37a1ddd35e66087c44a7b66b991be2feaa5e04c3b1958d316"
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
