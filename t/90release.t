use Test;
use File::Path;

plan test => 4;

use Cvs;
ok(1);

my $cvs = new Cvs 'cvs-test';
ok($cvs);

open(FILE, "> $ENV{PWD}/cvs-test/test.txt")
    or die "Cannot open file `$ENV{PWD}/cvs-test/test.txt': $!";
print FILE "test\n";
close(FILE);

my $result = $cvs->release({force => 1, delete_after => 1});
ok(!-d "cvs-test");
ok($result->altered, 1);
