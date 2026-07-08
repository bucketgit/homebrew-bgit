class Bgit < Formula
  desc "Git CLI for repositories stored directly in GCS or S3 buckets"
  homepage "https://bucketgit.com/"
  version "1.3.9"
  license "MIT"

  release_tag = version.to_s

  on_macos do
    on_arm do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-mac-arm64"
      sha256 "5b3b4fa776fb9c176cb7c53abea531e95b5b126150058c5f08a2d077b597017a"
    end

    on_intel do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-mac-amd64"
      sha256 "68a2ce1b3b87aa0f5d4e6ce2b3f91453c0441b694c5f807115a635c6b785cd07"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-linux-amd64"
      sha256 "e21dfba831a0d3da294d02024c5a43e880fd6636a076fd3483e7fc327cb60d7a"
    end

    on_arm do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-linux-arm64"
      sha256 "535ef0f9ea074c174172d7ec9d01bfae7ef2dfa4009e71cd2085b43616d041fd"
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
