class Bgit < Formula
  desc "Git CLI for repositories stored directly in GCS or S3 buckets"
  homepage "https://bucketgit.com/"
  version "1.4.1"
  license "MIT"

  release_tag = version.to_s

  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-mac-arm64"
      sha256 "b97f4dc3205be2fe24c6adb46e994a8de7e96dd1c1b41db83fd5641d6650ec96"
    end

    on_intel do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-mac-amd64"
      sha256 "d0819d07c62dfcbebb86fd6e74ea8d645da53c101a718acb7965d9c655b03b2f"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-linux-amd64"
      sha256 "5d41b5e8e49d3b3f602d64a0f548bef49317df59305769ef05ca94681f4ee11a"
    end

    on_arm do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-linux-arm64"
      sha256 "0434c1b2655cd52700b1481bd4a4b8a3a7ac7ea75a008e705790c4a40a1c6b18"
    end
  end

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
    bin.install_symlink bin/"bgit" => "git-remote-bgit"
  end

  test do
    assert_match "usage: bgit", shell_output("#{bin}/bgit help")
    assert_path_exists bin/"git-remote-bgit"
  end
end
