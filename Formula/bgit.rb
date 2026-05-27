class Bgit < Formula
  desc "Git CLI for repositories stored directly in GCS or S3 buckets"
  homepage "https://bucketgit.com/"
  version "1.2.0"
  license "MIT"

  release_tag = version.to_s

  on_macos do
    on_arm do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-mac-arm64"
      sha256 "5b41ac96ff22ac5556eeae8555fb800fac635cc21669707b8961b909e63c7e9c"
    end

    on_intel do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-mac-amd64"
      sha256 "ca27331b63f466b0f9cffcd88b406bea9ab614138bcf39e1b74b6e07244cc5be"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-linux-amd64"
      sha256 "85e98f09de7279c979957a2f0a1a74584c012d73ca6aed2dd06fe2fdcc925ba9"
    end

    on_arm do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-linux-arm64"
      sha256 "64269a1d2a680981482cb61249aac25a4d31d5428e4e112fe859169b1b3e79ee"
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
