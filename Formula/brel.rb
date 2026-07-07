class Brel < Formula
  desc "better-releases cli tool"
  homepage "https://better-releases.com"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/better-releases/brel/releases/download/0.10.0/brel-aarch64-apple-darwin.tar.xz"
      sha256 "f1e2490eb1c13b85d7ba32e616d809a15f6406bd5167fe5b43c41a78bace005f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/better-releases/brel/releases/download/0.10.0/brel-x86_64-apple-darwin.tar.xz"
      sha256 "2a20cf2e5640fc4b31a51825bbdf2d28043cece58bfadf384e757fdae559fd36"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/better-releases/brel/releases/download/0.10.0/brel-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c993e5d3228aadbe23ed3013d2d83b2b258dbe355005848ba17d3f877ec89636"
    end
    if Hardware::CPU.intel?
      url "https://github.com/better-releases/brel/releases/download/0.10.0/brel-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "aabf3210f0177c8d2fdfc8f4f2713255d4eb0341aa0261ffaaf927cafc4cfb4d"
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
