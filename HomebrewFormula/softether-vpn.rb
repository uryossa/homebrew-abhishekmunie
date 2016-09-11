class SoftetherVpn < Formula
  desc "SoftEther VPN Client"
  homepage "https://www.softether.org"
  url "https://github.com/abhishekmunie/SoftEtherVPN/archive/master.tar.gz"
  # sha256 ""
  head "https://github.com/abhishekmunie/SoftEtherVPN.git"

  version "HEAD"

  depends_on "openssl"
  depends_on "readline"
  depends_on "libiconv"
  depends_on "ncurses"
  depends_on "gcc"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    # Remove unrecognized options if warned by configure
    # system "./configure", "--disable-debug",
    #                       "--disable-dependency-tracking",
    #                       "--disable-silent-rules",
    #                       "--prefix=#{prefix}"
    system "cp", "src/makefiles/macos_64bit.mak", "Makefile"
    system "make"
    system "mkdir", "#{prefix}/bin"
    system "make", "install", "INSTALL_BINDIR=#{prefix}/bin/", "INSTALL_VPNSERVER_DIR=#{prefix}/vpnserver/", "INSTALL_VPNBRIDGE_DIR=#{prefix}/vpnbridge/", "INSTALL_VPNCLIENT_DIR=#{prefix}/vpnclient/", "INSTALL_VPNCMD_DIR=#{prefix}/vpncmd/"
  end

  plist_options :startup => true, :manual => "vpnclient start"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/vpnclient</string>
          <string>execsvc</string>
        </array>
        <key>KeepAlive</key>
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
    system "#{bin}/vpnclient"
  end
end
