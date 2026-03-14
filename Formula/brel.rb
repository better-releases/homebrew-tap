class Brel < Formula
  desc "better-releases cli tool"
  homepage "https://better-releases.com"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/better-releases/brel/releases/download/0.6.0/brel-aarch64-apple-darwin.tar.xz"
      sha256 "ac35b74f327d3651f46348e2eb9941e6dff4566fc3ae90919c32b1bfa8337533"
    end
    if Hardware::CPU.intel?
      url "https://github.com/better-releases/brel/releases/download/0.6.0/brel-x86_64-apple-darwin.tar.xz"
      sha256 "6e90f2ce515b0fb2e47e453f4074a75f65ac8683232bb65d874ba5e2e97fb4a8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/better-releases/brel/releases/download/0.6.0/brel-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "52b6318b3a4754cdb97033f13c20ce26c179ac7a672bb0cf61bf6c91f0ed33b8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/better-releases/brel/releases/download/0.6.0/brel-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1564ff9600ed806a9e049c66b8359aec23bad711c96dbfa33342a770b942804c"
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
