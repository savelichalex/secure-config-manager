class SecureConfigManager < Formula
  desc "Create secure config for swift project easeily"
  homepage "https://github.com/savelichalex/secure-config-manager"
  url "https://github.com/savelichalex/secure-config-manager/archive/0.2.0.tar.gz"
  version "0.2.0"
  sha256 "e4c27f1b6110531dad127f28e3d9425ff531fe6702024549ce352c2e9e1812b7"

  def install
    bin.install "scm"
  end
end
