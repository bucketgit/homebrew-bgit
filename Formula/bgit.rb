class Bgit < Formula
  desc "Git CLI for repositories stored directly in GCS or S3 buckets"
  homepage "https://bucketgit.com/"
  version "1.3.3"
  license "MIT"

  release_tag = version.to_s

  on_macos do
    on_arm do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-mac-arm64"
      sha256 "a76937e94bd62c6585c2e6c8d6f4e1f2f1e25babf0af4f817abce7e07b7d60b7"
    end

    on_intel do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-mac-amd64"
      sha256 "a25e3df839443b62ae85bc35a1ccfde3452f286a3744d07ab348c63d1f2fba12"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-linux-amd64"
      sha256 "765a63ca4ab62f96e7300f4f4d3b475ebaa42af1092c7a669c8f07f66c43061a"
    end

    on_arm do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-linux-arm64"
      sha256 "bd3fef934289dc5564577767d8c37d5a118982e2d7e81a9f1b610d1f2a4f31b3"
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
