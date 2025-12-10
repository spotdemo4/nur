{
  system,
}:
(builtins.getFlake "github:spotdemo4/bumper/dec2fb0d577c332bc244acfb6bd35ffc88703c21" # v0.4.5
).packages."${system}".default
