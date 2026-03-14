class Brel < Formula
  desc "better-releases cli tool"
  homepage "https://better-releases.com"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/better-releases/brel/releases/download/0.7.0/brel-aarch64-apple-darwin.tar.xz"
      sha256 "cb9f1184f3bffaf2b98175fbed59632e7839b08f39956f319cedf5b9ba0e01e5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/better-releases/brel/releases/download/0.7.0/brel-x86_64-apple-darwin.tar.xz"
      sha256 "41c0d0f5ea98ff2a712bea335d9d7c9a93859806bd8b43e6e0a42fd2be4a27fd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/better-releases/brel/releases/download/0.7.0/brel-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "eaa02ee0aa892137a4c89f8320771b529bc56b963456cdb10d893be429b11c76"
    end
    if Hardware::CPU.intel?
      url "https://github.com/better-releases/brel/releases/download/0.7.0/brel-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a576b57a3f0007e4bf7cbc82b982f8cf4fe71108a71780b8ee083e59d2ab948d"
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
