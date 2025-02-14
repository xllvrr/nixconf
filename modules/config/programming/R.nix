{ config, pkgs, lib, ... } :

let
    cfg = config.programs.R;
in

    with lib; 

{
    options = {
        programs.R = {
            enable = mkOption {
                default = false;
                type = with types; bool;
                description = "Enable R";
            };
        };
    };

    config = mkIf cfg.enable {
        environment.systemPackages = 
            with pkgs;
            let
                R-with-my-packages = rWrapper.override{
                    packages = with rPackages; [

                        # System Tools
                        languageserver
                        openxlsx

                        # Data Cleaning
                        tidyverse
                        data_table

                        # Data Analysis
                        bnlearn
                        brms
                        lavaan
                        psych
                        tidymodels

                        # Data Visualisation
                        sjPlot
                        interactions

                        # Formatting
                        kableExtra

                    ];
                };
            in [
                R-with-my-packages
                pandoc
            ];
    };
}
