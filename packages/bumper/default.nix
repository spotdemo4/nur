{
  system,
}:
(builtins.getFlake "github:spotdemo4/bumper/0b7f3117b7bd048abb22d66611e0f785db46b044" # v0.7.1
).packages."${system}".default
