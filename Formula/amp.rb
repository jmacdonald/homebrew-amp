class Amp < Formula
  desc "Complete text editor for your terminal"
  homepage "https://amp.rs"
  url "https://github.com/jmacdonald/amp/archive/0.5.2.tar.gz"
  sha256 "e1f22a829205cf44f8c3fcf5660dbdb9a3c5a1f64b92c67dcdb75a30ad7e5a60"
  head "https://github.com/jmacdonald/amp.git"

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "openssl"

  def install
    # Ensure we link against openssl@1.0, not openssl@1.1.
    ENV["OPENSSL_INCLUDE_DIR"] = Formula["openssl"].opt_include
    ENV["OPENSSL_LIB_DIR"] = Formula["openssl"].opt_lib

    system "cargo", "install", "--root", prefix, "--path", "."
    bin.install "target/release/amp"
  end

  test do
    # Setup a path to which Amp will write data.
    amp_file_path = testpath/"amp_file"

    (testpath/"test.exp").write <<~EOS
      spawn "#{bin}/amp" "#{amp_file_path}"
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

    # Run Amp using expect and verify that it writes the correct data.
    system "expect", "-f", "test.exp"
    assert_match "test data\n", IO.read(amp_file_path)
  end
end
