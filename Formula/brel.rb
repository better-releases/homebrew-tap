class Brel < Formula
  desc "better-releases cli tool"
  homepage "https://better-releases.com"
  version "0.11.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/better-releases/brel/releases/download/0.11.0/brel-aarch64-apple-darwin.tar.xz"
      sha256 "e64761ce22d2021272ef94dab2d02a749060cc1cf4c1929fef0251cb1dd1b1a0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/better-releases/brel/releases/download/0.11.0/brel-x86_64-apple-darwin.tar.xz"
      sha256 "4b9ff832c06f0cbafd2372220f5242015a3de74e598b054cf4ef8ce84f0c99f9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/better-releases/brel/releases/download/0.11.0/brel-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "03fe494239a7057dcbe50305f38e2546cf195206587a29d3408d76ee4348d204"
    end
    if Hardware::CPU.intel?
      url "https://github.com/better-releases/brel/releases/download/0.11.0/brel-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e9aebe79b8a38a0e0dee3f51ad01e8bc5e69aa3ac9e605f08b55d9d81e5e0c79"
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
