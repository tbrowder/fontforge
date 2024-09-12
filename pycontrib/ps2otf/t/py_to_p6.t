#!/usr/bin/env raku

use v6;
use Test;
use Inline::Python;

my $py = Inline::Python.new();

is $py.run('5', :eval), 5;
is $py.run('5.5', :eval), 5.5;
is $py.run('u"Python"', :eval), 'Python';
is-deeply $py.run('[1, 2]', :eval), [1, 2];
is-deeply $py.run('[1, [2, 3]]', :eval), [1, [2, 3]];
is-deeply $py.run('{u"a": 1, u"b": 2}', :eval), {a => 1, b => 2};
is-deeply $py.run('{u"a": 1, u"b": {u"c": 3}}', :eval), {a => 1, b => {c => 3}};
is-deeply $py.run('[1, {u"b": {u"c": 3}}]', :eval), [1, {b => {c => 3}}];
ok $py.run('None', :eval) === Any, 'py None maps to p6 Any';

is $py.run('"Püthon"', :eval), 'Püthon', 'Unicode string';

is $py.run('"Püthon".encode("latin-1")', :eval).decode('latin-1'), 'Püthon', 'Buffer';

done-testing;

# vim: ft=raku
