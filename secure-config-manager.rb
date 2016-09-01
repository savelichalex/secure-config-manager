class SecureConfigManager < Formula
  desc "Create secure config for swift project easeily"
  homepage "https://github.com/savelichalex/secure-config-manager"
  url "https://github.com/savelichalex/secure-config-manager/archive/v0.1.1.tar.gz"
  version "0.1.0"
  sha256 "21833f8af47bb87aef94939f6c781c5c84d85093caa8f9fa22bfe3814d621cfa"

  def install
    bin.install "scm"
  end
end
