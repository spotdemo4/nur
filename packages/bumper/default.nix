{
  system,
}:
(builtins.getFlake "github:spotdemo4/bumper/47e22c10f86c5db6679c74ac50c223973daf93ab" # v0.5.0
).packages."${system}".default
