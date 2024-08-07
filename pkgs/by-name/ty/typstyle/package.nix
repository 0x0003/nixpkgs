{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2
, zlib
, stdenv
, darwin
, nix-update-script
, testers
, typstyle
}:

rustPlatform.buildRustPackage rec {
  pname = "typstyle";
  version = "0.11.30";

  src = fetchFromGitHub {
    owner = "Enter-tainer";
    repo = "typstyle";
    rev = "refs/tags/v${version}";
    hash = "sha256-pdIgngLn0y4+N4nD5b6E8UL1ftinWO9ofde1Vw3Pn7o=";
  };

  cargoHash = "sha256-+iBxVTwAzYpLio9BKD1hYsTw4GgK6CkmbyM5QIiswck=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.CoreServices
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  # Disabling tests requiring network access
  checkFlags = [
    "--skip=e2e"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = typstyle; };
  };

  meta = {
    changelog = "https://github.com/Enter-tainer/typstyle/blob/${src.rev}/CHANGELOG.md";
    description = "Format your typst source code";
    homepage = "https://github.com/Enter-tainer/typstyle";
    license = lib.licenses.asl20;
    mainProgram = "typstyle";
    maintainers = with lib.maintainers; [ drupol ];
  };
}
