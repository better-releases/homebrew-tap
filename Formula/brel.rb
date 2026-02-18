class Brel < Formula
  desc "better-releases cli tool"
  homepage "https://better-releases.com"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/better-releases/brel/releases/download/0.3.0/brel-aarch64-apple-darwin.tar.xz"
      sha256 "0dd41894f229a80734b8830dfb4785c9fe65e258f2c57ce24c335346ad117739"
    end
    if Hardware::CPU.intel?
      url "https://github.com/better-releases/brel/releases/download/0.3.0/brel-x86_64-apple-darwin.tar.xz"
      sha256 "4dafbd9b3ff049bef7de2cdf9e38828117db3016d6e8a8bb5e14ec6a2b0fc0e5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/better-releases/brel/releases/download/0.3.0/brel-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5b2e6481cd68271d834d3f3d329b3b28d8973b97c297cdbc33b6a32f93e7c426"
    end
    if Hardware::CPU.intel?
      url "https://github.com/better-releases/brel/releases/download/0.3.0/brel-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3566f525ca777c665f0ec08a34b975765434dee3cb94d81f9c6191cdee936455"
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
