# Firefox Setup
{ pkgs, inputs, ... }:

{
  programs.firefox = {

      enable = true;
      
      profiles.xllvr = {

      /* Extensions */

	extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
	 bitwarden
	 ublock-origin
	 darkreader
	 tridactyl
	 # enhancer-for-youtube
	];

     };
      
      /* Policies */

      policies = {
       DisableTelemetry = true;
       DisableFirefoxStudies = true;
       EnableTrackingProtection = {
         Value = true;
	Locked = true;
	Cryptomining = true;
	Fingerprinting = true;
       };
       DisablePocket = true;
       DisableFirefoxScreenshots = true;
       OverrideFirstRunPage = "";
       OverridePostUpdatePage = "";
       DontCheckDefaultBrowser = true;
       SearchBar = "unified";
      };


  };
}
