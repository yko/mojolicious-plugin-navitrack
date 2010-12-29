# Copyright (C) 2010, Yaroslav Korshak.

package Mojolicious::Plugin::NaviTrack;

use warnings;
use strict;
use Carp;

use base 'Mojolicious::Plugin';

our $VERSION = '0.0.1';

sub register {
    my ($self, $app, $opts) = @_;

    $opts ||= {};

    $app->renderer->add_helper(navipoint => \&navipoint);
    $app->renderer->add_helper(navitrack => \&navitrack);
    return $self;
}

sub navitrack {
    my $c = shift;
    navipoint($c, @_);
    my $tc      = $c->stash('template_class');
    my $content = $c->render_partial(
        template       => 'navipoint/navitrack',
        template_class => __PACKAGE__
    );

    $c->stash('template_class', $tc);
    return $content;
}

sub navipoint {
    my $c = shift;
    my @points;
    if (@_ > 0) {
        for (my $i = 0; $i <= $#_; $i += 2) {
            push @points, {'name' => $_[$i], 'url' => $_[$i + 1]};
        }
        @points = reverse @points;
    }
    else {
        my $name = shift;
        push @points, {'url' => $c->url_for($name), 'name' => $name};
    }
    my $store = $c->stash('_navipoints') || [];
    push @$store, @points;
    $c->stash('_navipoints', $store);
    return scalar @$store;
}

1;
__DATA__
@@ navipoint/navitrack.html.ep
<%== join "&rarr; ", map {
       "<a href='$_->{url}'>$_->{name}</a>\n"
     } reverse @{$self->stash('_navipoints')}; =%>
__END__

=head1 NAME

Mojolicious::Plugin::NaviTrack - plugin to automake navigation tracking


=head1 VERSION

This document describes Mojolicious::Plugin::NaviTrack version 0.0.1


=head1 SYNOPSIS

    use base 'Mojolicious';

    sub statup {
        my $self = shift;
        $self->plugin( 'navi_track' );
    }

Somewhere in template:

    % navipoint 'MyPoint';


Somewhere in layout:
 
    %== navitrack 'The First Point';

=head1 DESCRIPTION

Mojolicious::Plugin::NaviTrack should help autogenerate tracking navigation.

=head1 INTERFACE 

=head2 HELPERS 

=over

=item navipoint

Add point to navigation track. 
Accepts one parameter, if it's name of route or hash 
of pairs name => url

    navipoint 'somewhere';
or    
    navipoint 'Start' => '/', 
              'Point' => '/point'
              'End' => '/point/end';

=item navitrack

Generates full navitrack. Before generating 
passing all par ameters to L<navipoint>.

    navitrack;
or    
    navitrack 'The very first point' => '/'; 

=item register

Register the plugin.
Internal


=back

=head1 CONFIGURATION AND ENVIRONMENT

You can redefine default template creating
'navipoint/navitrack.html.ep' file in your templates dir.
All navipoints will be stored into $c->stash('_navipoints')
in reverse order. Each navipoint is a hashref with keys 'name' and 'link'.

=head1 DEPENDENCIES

Mojolicious.

=head1 AUTHOR

Yaroslav Korshak  C<< <ykorshak@gmail.com> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2010, Yaroslav Korshak C<< <ykorshak@gmail.com> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.
