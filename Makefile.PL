use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Mojolicious::Plugin::NaviTrack',
    AUTHOR              => 'Yaroslav Korshak <ykorshak@gmail.com>',
    VERSION_FROM        => 'lib/Mojolicious/Plugin/NaviTrack.pm',
    ABSTRACT_FROM       => 'lib/Mojolicious/Plugin/NaviTrack.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'version'    => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'mojolicious-plugin-navitrack-*' },
);
