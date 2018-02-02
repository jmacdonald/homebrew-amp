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
    (testpath/"test.exp").write <<~EOS
      spawn "amp" "test_write"
      interact timeout 1 return

      # switch to insert mode and add data
      send "i"
      send "test data"

      # escape to normal mode, save the file, and quit
      send "\x1b"
      send "s"
      send "Q"
      expect eof
    EOS

    system "expect", "-f", "test.exp"
    assert_match /test data/, IO.read("./test_write")
  end
end
