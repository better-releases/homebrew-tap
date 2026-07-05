class Brel < Formula
  desc "better-releases cli tool"
  homepage "https://better-releases.com"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/better-releases/brel/releases/download/0.9.0/brel-aarch64-apple-darwin.tar.xz"
      sha256 "2215f6c774ad252ea61f8291af999b0b80d76d2687cc2eaf07931479575a74df"
    end
    if Hardware::CPU.intel?
      url "https://github.com/better-releases/brel/releases/download/0.9.0/brel-x86_64-apple-darwin.tar.xz"
      sha256 "013096bcacb4c340cc260d7f2d38457457a134ddd6da3c5dc6092ecf3da1ef27"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/better-releases/brel/releases/download/0.9.0/brel-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ea1f36a0109257dd7ef3ba890eab55d1e88c88399b1b30ed429dadf5a34c95ac"
    end
    if Hardware::CPU.intel?
      url "https://github.com/better-releases/brel/releases/download/0.9.0/brel-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3d3b49ec1f01d5d7a4cf0ab1e85fb7448dede0acef43be84c9a64b52b90ab8e7"
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
