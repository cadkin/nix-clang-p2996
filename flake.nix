{
    description = "Test C++26 p2996 flake for development";

    inputs = {
        nixpkgs.url  = github:cadkin/nixpkgs/p2996;
        utils.url    = github:numtide/flake-utils;
    };

    outputs = attrs @ { self, ... }: attrs.utils.lib.eachDefaultSystem (system: rec {
        config = rec {
            pkgs = import attrs.nixpkgs {
                inherit system;
            };

            llvm   = pkgs.llvmPackages_p2996;
            stdenv = llvm.libcxxStdenv;

            # LLDB is currently broken on Bloomberg's fork, but we can use LLVM 19's LLDB.
            # https://github.com/bloomberg/clang-p2996/pull/24
            lldb   = pkgs.llvmPackages_19.lldb;
        };

        devShells = with config; rec {
            default = p2996Dev;

            # Main developer shell.
            p2996Dev = pkgs.mkShell.override { inherit stdenv; } rec {
                name = "p2996Dev";

                packages = [
                    llvm.clang-tools
                    lldb
                ] ++ pkgs.lib.optionals (stdenv.hostPlatform.isLinux) [
                    pkgs.cntr
                ];

                # For dev, we want to disable hardening.
                hardeningDisable = [
                    "bindnow"
                    "format"
                    "fortify"
                    "fortify3"
                    "pic"
                    "relro"
                    "stackprotector"
                    "strictoverflow"
                ];

                # Ensure the locales point at the correct archive location.
                LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
            };
        };
    });
}
