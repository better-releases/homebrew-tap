class Brel < Formula
  desc "better-releases cli tool"
  homepage "https://better-releases.com"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/better-releases/brel/releases/download/0.1.2/brel-aarch64-apple-darwin.tar.xz"
      sha256 "1ffbfe1fb992cf9383ff430b37982c1ee47e29e64da86fa55cad938f889984ed"
    end
    if Hardware::CPU.intel?
      url "https://github.com/better-releases/brel/releases/download/0.1.2/brel-x86_64-apple-darwin.tar.xz"
      sha256 "e765531be3393d2bd44b161b75921e8c1e963a71de3c518d14930e72ebcfdbf1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/better-releases/brel/releases/download/0.1.2/brel-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1ed3fd3026051882750ff223f23eaa28365a74427c825f5cdeef438d47c9fcbc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/better-releases/brel/releases/download/0.1.2/brel-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "49c078f507744e66bf830b39066064a8fca3ba51d3a34015b6bd5898b0151a5d"
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
