class Brel < Formula
  desc "better-releases cli tool"
  homepage "https://better-releases.com"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/better-releases/brel/releases/download/0.2.0/brel-aarch64-apple-darwin.tar.xz"
      sha256 "22638a8ea529c293c25980b624cf0701ca399af0501701cf3172e75517342752"
    end
    if Hardware::CPU.intel?
      url "https://github.com/better-releases/brel/releases/download/0.2.0/brel-x86_64-apple-darwin.tar.xz"
      sha256 "baf75bb70d13737ae9ea54e9cbc851474fda90f98bbcfba4afae7d518dee7f89"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/better-releases/brel/releases/download/0.2.0/brel-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "304966ee1ca1509884031642285aeae6955682f6223bd0315ca7269b1a85d4ae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/better-releases/brel/releases/download/0.2.0/brel-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7ae01485c7fa055adb1c6aecf020b24be571bd3927bcd749c79bea28eb074c4a"
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
