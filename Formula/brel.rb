class Brel < Formula
  desc "better-releases cli tool"
  homepage "https://better-releases.com"
  version "0.12.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/better-releases/brel/releases/download/0.12.0/brel-aarch64-apple-darwin.tar.xz"
      sha256 "28eb21cb02dadff956de74d500e627fadecf4d3c4dfd4567398edd1522415855"
    end
    if Hardware::CPU.intel?
      url "https://github.com/better-releases/brel/releases/download/0.12.0/brel-x86_64-apple-darwin.tar.xz"
      sha256 "cc202505fba3f4e0172c80e0e6eb913a043459b04028e7ac7f08f4157b464702"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/better-releases/brel/releases/download/0.12.0/brel-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e6dc1f8be3890003f2eb62d6f311ebfbd71117855458641e4096727f422db4e1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/better-releases/brel/releases/download/0.12.0/brel-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "56b23c1a9ddde317a5df0272a5cb29c2d6807d76d3547326f81f17926ee1780a"
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
