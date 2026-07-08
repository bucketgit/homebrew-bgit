class Bgit < Formula
  desc "Git CLI for repositories stored directly in GCS or S3 buckets"
  homepage "https://bucketgit.com/"
  version "1.3.6"
  license "MIT"

  release_tag = version.to_s

  on_macos do
    on_arm do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-mac-arm64"
      sha256 "fd4d4a872ae72fca4bf162da6fd5ddd0d34d311b823caaf62fc121b2ac84df61"
    end

    on_intel do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-mac-amd64"
      sha256 "3994de689e5bb9209d83940b70f4162bbc2d8cf5c5112831eb96546974b55a20"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-linux-amd64"
      sha256 "cc4cfb2d4026ee565f8e27485c6ae999474b372ce3476973aef29197a4c3c395"
    end

    on_arm do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-linux-arm64"
      sha256 "8ca6b86dc4ce5e9e64fec7c2352329e5cfc335a25e176961a32f0469027088f1"
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
