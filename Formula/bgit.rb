class Bgit < Formula
  desc "Git CLI for repositories stored directly in GCS or S3 buckets"
  homepage "https://bucketgit.com/"
  version "1.4.0"
  license "MIT"

  release_tag = version.to_s

  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-mac-arm64"
      sha256 "8a4dfe96c060634f6020e9d485486f71ca539611a05b3f3869884932b2ea52bf"
    end

    on_intel do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-mac-amd64"
      sha256 "c9b2dee4615d3477fab289c5531ca285d4acdbe7f9a976d1c69f1b8024f3e20b"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-linux-amd64"
      sha256 "24d121864e48b6c4fbce93dd22491357dd1230349f5e7c293a019e25d4ed9f51"
    end

    on_arm do
      url "https://github.com/bucketgit/bgit/releases/download/#{release_tag}/bgit-linux-arm64"
      sha256 "452c13ea9f437907a60dae961dda051e2fb29403f87096f75652c8c6b3701cbe"
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
