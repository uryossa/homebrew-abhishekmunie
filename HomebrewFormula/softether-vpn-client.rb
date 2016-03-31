# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class SoftetherVpnClient < Formula
  desc "SoftEther VPN Client"
  homepage "https://www.softether.org"
  url "http://www.softether-download.com/files/softether/v4.19-9605-beta-2016.03.06-tree/Mac_OS_X/SoftEther_VPN_Client/64bit_-_Intel_x64_or_AMD64/softether-vpnclient-v4.19-9605-beta-2016.03.06-macos-x64-64bit.tar.gz"
  version "v4.19-9605-beta"
  sha256 "b50b8b39f8569bf6688500725ab06b6bd8b38a764d846204f0e6d380cae0295e"

  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "gcc"

  def install
    system "make", "i_read_and_agree_the_license_agreement"
    system "mkdir", "#{prefix}/bin"
    system "cp", "vpnclient", "#{prefix}/bin/sevpnclient"
    system "cp", "vpncmd", "#{prefix}/bin/sevpncmd"
    system "cp", "hamcore.se2", "#{prefix}/bin"
    # system "ln", "-s", "../vpnclient", "#{prefix}/bin/sevpnclient"
    # system "ln", "-s", "../vpncmd", "#{prefix}/bin/sevpncmd"
  end

  plist_options :startup => true, :manual => "sevpnclient start"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/sevpnclient</string>
          <string>start</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
      </dict>
    </plist>
    EOS
  end

  def caveats; <<-EOS.undent
    Although vpnclient can run without root, you must be root to manage VPN NICs.

    The launchdaemon is set to start.

    EOS
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test SoftEtherVPN`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "#{bin}/sevpnclient"
  end
end
