#!/usr/bin/perl

$hist = [];

for ($i = 0; $i < 0x100; $i++) {
  $hist->[$i] = 0;
}

while (<>) {
  @vals = split(/\s*,\s*/);
  if( @vals[2] =~ /[[:xdigit:]]+/) {
    $i = hex(@vals[2]);
    $hist->[$i]++;
  }
}

for ($i = 0; $i < 0x100; $i++) {
  if (($i % 0x10) == 0x0) {
    printf("%02x:", $i);
  }
  printf(" %s", $hist->[$i] ? 'X' : ' ');
  if (($i % 0x10) == 0xf) {
    printf("\n");
  }
}
