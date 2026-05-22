class Bgit < Formula
  desc "Git CLI for repositories stored directly in GCS or S3 buckets"
  homepage "https://bucketgit.com/"
  version "1.1.2"
  license "MIT"

  release_tag = version.to_s

  on_macos do
    on_arm do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-mac-arm64"
      sha256 "0e35094924fcdaf06f6d022a4bbbc5dcdd926fd38db4e02f4ffe38f3c6526ed6"
    end

    on_intel do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-mac-amd64"
      sha256 "6491d7fdaba6148e081b634e5fec7d61f68064d91cf49b6efebaf2736179acf6"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-linux-amd64"
      sha256 "b4b83e61fb1edee7a282ac67c827aef6bbe37d325126831912a7166cb8a6ab47"
    end

    on_arm do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-linux-arm64"
      sha256 "a5ab82cc81603a5576f1f4e2d0ceac4f88ccd989a700d88046716aef7ec051a0"
    end
  end

  depends_on "git"

  def install
    binary_name =
      if OS.mac?
        Hardware::CPU.arm? ? "bgit-mac-arm64" : "bgit-mac-amd64"
      elsif OS.linux?
        Hardware::CPU.arm? ? "bgit-linux-arm64" : "bgit-linux-amd64"
      else
        odie "Unsupported platform for bgit"
      end

    source_binary = buildpath/binary_name
    odie "Expected prebuilt binary missing: #{source_binary}" unless source_binary.exist?

    bin.install source_binary => "bgit"
    chmod 0755, bin/"bgit"
  end

  test do
    assert_match "usage: bgit", shell_output("#{bin}/bgit help")
  end
end
