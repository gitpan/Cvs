package Cvs::Command::Commit;


use strict;
use Cvs::Result::Commit;
use Cvs::Cvsroot;
use base qw(Cvs::Command::Base);


sub init
{
    my($self, $param, @files) = @_;
    $self->SUPER::init(@_) or return;

    $self->default_params
    (
       recursive => 1,
	   message => "Commit by Cvs.pm $Cvs::VERSION",
	   force => 0,
    );
    $self->param($param);

    $self->command('commit');
	$self->push_arg('-f', $self->param->{force})
	  if $self->param->{force};
	$self->push_arg('-l')
	  unless $self->param->{recursive};
	$self->push_arg('-m', $self->param->{message})
	  if defined $self->param->{message};
    $self->push_arg('-r', $self->param->{revision})
      if defined $self->param->{revision};
	if (@files)
	{
	  $self->push_arg($_) for (@files);
	}
    $self->go_into_workdir(1);

    my $result = new Cvs::Result::Commit;
    $self->result($result);

    my $main = $self->new_context();
    $self->initial_context($main);

	my @errors = ();

	$main->push_handler
	(
	  qr/^new revision: (.*?); previous revision: (.*)$/, sub
	  {
		my ($ver) = @_;
		$result->set_revision($ver->[2], $ver->[1]);
	  }
	);
	$main->push_handler
	(
	  qr/^done$/, sub
	  {
		$result->success(1);
	  }
	);
	$main->push_handler
	(
	  qr/^cvs commit: (.*)$/, sub
	  {
		push @errors, shift->[1];
	  }
	);
	$main->push_handler
	(
	  qr/^cvs \[commit aborted\]: (.*)$/, sub
	  {
		push @errors, shift->[1];
		$result->success(0);
		$result->error(join "\n", @errors);
	  }
	);

    return $self;
}

1;
=pod

=head1 LICENCE

This library is free software; you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as
published by the Free Software Foundation; either version 2.1 of the
License, or (at your option) any later version.

This library is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
USA

=head1 COPYRIGHT

Copyright (C) 2003 - Olivier Poitrey
