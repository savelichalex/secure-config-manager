class SecureConfigManager < Formula
  desc "Create secure config for swift project easeily"
  homepage "https://github.com/savelichalex/secure-config-manager"
  url "https://github.com/savelichalex/secure-config-manager/archive/v0.1.0.tar.gz"
  version "0.1.0"
  sha256 "49f384bb2de51663915c2b55131b7034c898aca8e7f0c5cdbf400c4a060b5ba8"

  def install
    bin.install "scm"
  end
end
