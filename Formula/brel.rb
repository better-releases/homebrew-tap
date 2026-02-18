class Brel < Formula
  desc "better-releases cli tool"
  homepage "https://better-releases.com"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/better-releases/brel/releases/download/0.5.0/brel-aarch64-apple-darwin.tar.xz"
      sha256 "044dbd83ae85e100df6fb86a6fef38f61f518a983704a789516413134cc7758d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/better-releases/brel/releases/download/0.5.0/brel-x86_64-apple-darwin.tar.xz"
      sha256 "974899978c6e2e233494b3ecb0c0e0be403bb436557111d52965b3a40816b177"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/better-releases/brel/releases/download/0.5.0/brel-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "39e2320fbbcba6aba5a84050a733534b5d7f6640a902bbf93ecb8a38dc754d73"
    end
    if Hardware::CPU.intel?
      url "https://github.com/better-releases/brel/releases/download/0.5.0/brel-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "05702d2de20c7629dc2ec7c77c2a8609c005975cf43d82bafcd0e4c329569219"
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
