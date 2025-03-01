{ pkgs, ... }:

{
    programs.nnn = {
        enable = true;
        plugins = {
            src =
                (pkgs.fetchFromGitHub {
                    owner = "jarun";
                    repo = "nnn";
                    rev = "v4.5";
                    sha256 = "sha256-uToAgWpGaTPTMYJh1D0xgvE23GSIshv1OBlWxXI07Mk=";
                })
                + "/plugins";
            mappings = {
                c = "fzcd";
                v = "imgview";
                p = "preview-tui";
            };
        };
    };
}
