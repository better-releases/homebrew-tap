class Brel < Formula
  desc "better-releases cli tool"
  homepage "https://better-releases.com"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/better-releases/brel/releases/download/0.1.1/brel-aarch64-apple-darwin.tar.xz"
      sha256 "55638cb43e311072413d6f4adb05a16d16a487f53c7529e9241784b4b9d0b02a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/better-releases/brel/releases/download/0.1.1/brel-x86_64-apple-darwin.tar.xz"
      sha256 "b11c1a139bb94d7780bc75879618b92a3bd5882c978817b31fcecdb581cd4164"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/better-releases/brel/releases/download/0.1.1/brel-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6cbce34fbf66f6bdb9d5175d3efcbea84ee8c44b5ba207cb025d0b42c6ff6ebf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/better-releases/brel/releases/download/0.1.1/brel-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e10f2b17e07ee388871ae6095ce3bce5a1657e8bc5694aa98888907d4113ad88"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "brel" if OS.mac? && Hardware::CPU.arm?
    bin.install "brel" if OS.mac? && Hardware::CPU.intel?
    bin.install "brel" if OS.linux? && Hardware::CPU.arm?
    bin.install "brel" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
