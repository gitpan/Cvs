use strict;
use Test;
use Cwd;
use Data::Dumper;
use lib qw(/home/cottons/tarballs/Cvs-0.01/lib);

plan test => 3;

use Cvs;
ok(1);

my $cvs = new Cvs 'cvs-test';
ok($cvs);

open(FILE, "> $ENV{PWD}/cvs-test/test.txt")
	or die "Cannot open file `$ENV{PWD}/cvs-test/test.txt': $!";
print FILE "$$ test test";
close FILE;

my $commit = $cvs->commit({ recursive => 0, message => 'test commit', }, 'test.txt');
ok($commit->success());
