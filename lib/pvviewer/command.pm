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
  my $all_args = join(', ', map{_encode($_)} @{$self->args}); 
}

sub _encode {
  my $obj  = shift;
  return $obj->to_js() if $obj->has_to_js;
  
}

no Moose;
__PACKAGE__->meta->make_immutable;
}
