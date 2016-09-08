class SecureConfigManager < Formula
  desc "Create secure config for swift project easeily"
  homepage "https://github.com/savelichalex/secure-config-manager"
  url "https://github.com/savelichalex/secure-config-manager/archive/v0.2.0.tar.gz"
  version "0.2.0"
  sha256 "777523ce19a76aaa004ec2958a2ad75afe28e2dd2b955552c7264cd22270bb5c"

  def install
    bin.install "scm"
  end
end
