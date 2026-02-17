class Brel < Formula
  desc "better-releases cli tool"
  homepage "https://better-releases.com"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/better-releases/brel/releases/download/0.1.0/brel-aarch64-apple-darwin.tar.xz"
      sha256 "4aaa3544e99959e0da09c0d0a83776db5debd45beb15f4220bae470ce3839470"
    end
    if Hardware::CPU.intel?
      url "https://github.com/better-releases/brel/releases/download/0.1.0/brel-x86_64-apple-darwin.tar.xz"
      sha256 "982177f6742c0628a48abee831a3fadc2ddba3f0fc4cce58a968ec4bb5a35131"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/better-releases/brel/releases/download/0.1.0/brel-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ebc936c562520026de8c9b6d24b4cf5a3f6465710eb774f18098936c585a3eca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/better-releases/brel/releases/download/0.1.0/brel-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "47006ca190d7a18762b89810648c92a8b1aaae8fd00b297443c7a921259ac02c"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
