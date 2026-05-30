class Bgit < Formula
  desc "Git CLI for repositories stored directly in GCS or S3 buckets"
  homepage "https://bucketgit.com/"
  version "1.3.1"
  license "MIT"

  release_tag = version.to_s

  on_macos do
    on_arm do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-mac-arm64"
      sha256 "80ed758d09cb08260021e0836e0a9a3767a5ecfba43af69370f4279372e45b8b"
    end

    on_intel do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-mac-amd64"
      sha256 "a727f699c9cc5a037432d6a7562687e113799ab33ce8477cbdd2665f4685b79a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-linux-amd64"
      sha256 "84a5611a1bd5d4053a2a31ab760c4783ed741dd901ef204eecc4feafe3fda4eb"
    end

    on_arm do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-linux-arm64"
      sha256 "62eed6abf263a76ad7a8a51c8fe35830489fd7fd99616d5ef9d9f78a04967a76"
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
