class Bgit < Formula
  desc "Git CLI for repositories stored directly in GCS or S3 buckets"
  homepage "https://bucketgit.com/"
  version "1.3.7"
  license "MIT"

  release_tag = version.to_s

  on_macos do
    on_arm do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-mac-arm64"
      sha256 "764875645902f4011f3b2259bb9cbbf1a150ee8988c38b18ac4b3e7834294177"
    end

    on_intel do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-mac-amd64"
      sha256 "68efa84c8bb99f745601416ed8ceea779b923bdd327da714ff200a997c795c81"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-linux-amd64"
      sha256 "9e77a8f5662103e300f8157781b811cb339dd2be998b62a71b639c4e85dbb0a2"
    end

    on_arm do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-linux-arm64"
      sha256 "e2ec91a03b111105a74ecc0144bc9369ff55d85f0e7d10f59277ea03bed9112d"
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
    bin.install_symlink bin/"bgit" => "git-remote-bgit"
  end

  test do
    assert_match "usage: bgit", shell_output("#{bin}/bgit help")
    assert_path_exists bin/"git-remote-bgit"
  end
end
