{...}: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "xllvrr";
        email = "dan@dtsa.email";
      };
      aliases = {
        cm = "commit -am";
      };
      init.defaultBranch = "main";
    };
  };

  programs.delta.enable = true;
}
