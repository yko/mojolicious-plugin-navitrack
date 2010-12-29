use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Mojolicious::Plugin::NaviTrack',
    license             => 'perl',
    dist_author         => 'Yaroslav Korshak <ykorshak@gmail.com>',
    dist_version_from   => 'lib/Mojolicious/Plugin/NaviTrack.pm',
    requires => {
        'Mojolicious' => 1.0,
        'Test::More' => 0,
        'version'    => 0,
    },
    add_to_cleanup      => [ 'mojolicious-plugin-navitrack-*' ],
);

$builder->create_build_script();
