#!/usr/bin/env perl
#
## Copyright (C) 2010, Yaroslav Korshak.
#

use strict;
use warnings;

use Test::More tests => 13;


use FindBin;
use Mojolicious::Lite;
use Test::Mojo;

# Load plugin
my $plugin = plugin 'navi_track';

isa_ok($plugin, 'Mojolicious::Plugin::NaviTrack');

# Silence
app->log->level('error');

get '/content/end' => [layout => 'default'] => sub {
    my $self = shift;
    $self->render_partial('include');
    $self->render('index',
            layout => 'default');
};

get '/content' => sub {
    my $self = shift;
    $self->render('index',
            layout => 'default');
};

get '/' => sub {
    shift->render('empty',
            layout => 'default');
};

get '/multi' => sub {
    shift->render('multiple',
            layout => 'default');
};

my $t = Test::Mojo->new;

# GET /
$t->get_ok('/content/end')->status_is(200)
  ->content_is(<<'END');
<a href='/'>Start</a>
&rarr; <a href='/content'>Some content</a>
&rarr; <a href='/content/end'>Endpoint</a>
END

$t->get_ok('/content')->status_is(200)
  ->content_is(<<'END');
<a href='/'>Start</a>
&rarr; <a href='/content'>Some content</a>
END

$t->get_ok('/')->status_is(200)
  ->content_is(<<'END');
<a href='/'>Start</a>
END


$t->get_ok('/multi')->status_is(200)
  ->content_is(<<'END');
<a href='/'>Start</a>
&rarr; <a href='/multi'>One Multiple</a>
&rarr; <a href='/multi-multi'>Two Multiple</a>
END

__DATA__
@@ layouts/default.html.ep
<%= navitrack 'Start' => '/'; =%>
@@ empty.html.ep
test?
@@ index.html.ep
<% navipoint 'Some content' => '/content'; =%>
@@ include.html.ep
<% navipoint 'Endpoint' => '/content/end'; =%>
@@ multiple.html.ep
<% navipoint 'One Multiple' => '/multi', 'Two Multiple' => '/multi-multi'; =%>
