{
package pvviewer::Command;
#Abstract: simple object for holding the receiver, method and arguments of a method call that can be translated to JS. 
use Moose;

use JSON::MaybeXS;

has 'receiver'  => ( is => 'ro' );
has 'command'   => ( is => 'ro', isa => 'Str' );
has 'args'      => ( is => 'ro', isa => 'ArrayRef' );
has 'kwargs'    => ( is => 'ro', isa => 'ArrayRef' );
has 'terminate' => ( is => 'ro', isa => 'Bool', default=> 0);

sub to_js {
  my $self = shift;
  my @all_args = [join(', ', map{_encode($_)} @{$self->args})]; 
  push @all_args, _encode($self->kwargs);

  my $args_string = join(', ', @all_args);
  my $t = $self->terminate ? ';' : '';
  my $call;
  unless ($self->receiver){
    $call = $self->command;
  }
  else{
    $call = sprintf("%s.%s", $self->receiver,$self->command);
  }
  return sprintf("%s(%s)%s", $call, $args_string,$self->command);
  
}

sub _encode {
  #this is pretty minimal for now.  wait for it to fail to rework
  my $obj  = shift;
  return $obj->to_js() if $obj->has_to_js;
  return encode_json($obj) if ref($obj) eq 'HASH';
  return JSON::MaybeXS->new->allow_nonref->encode($obj); 
}

no Moose;
__PACKAGE__->meta->make_immutable;
}
1;
