use inc::Module::Install;
name 'Data-Layered';
all_from 'lib/Data/Layered.pm';

build_requires 'Test::More';
use_test_base;
auto_include_deps;
author_tests('xt');
auto_set_repository;
WriteAll;
