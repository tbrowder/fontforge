#!/usr/bin/env raku

use Inline::Python;
use Test;

plan 302;

my $py = Inline::Python.new();
$py.run(q/
from logging import warn
def test(obj):
    try:
        obj.ok(1)
    except Exception as e:
        warn(e)
    for i in range(100):
        retval = obj.test('Raku')
        obj.ok(retval == 'Raku')
        retval = obj.test('Raku')
        obj.ok(retval == 'Raku')
        retval = obj.test('Perl', 6)
        obj.ok(retval == ['Perl', 6])
/);

class Foo {
    method ok($value) {
        ok($value);
    }
    method test(*@args) {
        return |@args;
    }
}

my $foo = Foo.new;
$foo.ok(1);

$py.call('__main__', 'test', $foo);

# vim: ft=perl6

