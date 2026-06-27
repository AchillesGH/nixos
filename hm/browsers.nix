{
  inputs,
  config,
  pkgs,
  ...
}:

{
	programs.firefox.enable = true;
	policies = {
	       BlockAboutConfig              = false;
	};
}
