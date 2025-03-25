{ pkgs, ... }:
{
  programs.git.includes = [
    {
      condition = "hasconfig:remote.*.url:*dev.azure.com:v3/PG-NM/**";
      contents = {
        user = {
          email = "pavlo.yeremenko@globallogic.com";
          name = "Pavlo Yeremenko";
          signingKey = "~/.ssh/ado";
        };
        gpg = {
          format = "ssh";
        };
        commit = {
          gpgSign = true;
        };
        tag = {
          gpgSign = true;
        };
      };
    }
  ];

}
