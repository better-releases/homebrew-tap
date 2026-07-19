class Brel < Formula
  desc "better-releases cli tool"
  homepage "https://better-releases.com"
  version "0.13.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/better-releases/brel/releases/download/0.13.0/brel-aarch64-apple-darwin.tar.xz"
      sha256 "d6c4662c76c3fa0d049428f19cd1a16e80ec6f6645d4f23ee8b8ce6ac1e978aa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/better-releases/brel/releases/download/0.13.0/brel-x86_64-apple-darwin.tar.xz"
      sha256 "e853aec437c14e314b4d18956f24d1187ffe4644b4c674e47c14cd4f62994d11"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/better-releases/brel/releases/download/0.13.0/brel-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "405cc6e5913208b4d9833d4714162d1dad2e2932b694f1c9f8f8b21d1650f77b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/better-releases/brel/releases/download/0.13.0/brel-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "77bc0fcf6752ae6f522663a99dcdae61d1f5894dcd50b0845606c012e9f2166c"
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
