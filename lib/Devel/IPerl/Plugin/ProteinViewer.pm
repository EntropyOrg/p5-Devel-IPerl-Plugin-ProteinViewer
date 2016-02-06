package Devel::IPerl::Plugin::ProteinViewer;

use strict;
use warnings;

our $IPerl_compat = 1;

our $IPerl_format_info = {
    'SVG' => { suffix => '.svg', displayable => 'Devel::IPerl::Display::SVG' },
    'PNG' => { suffix => '.png', displayable => 'Devel::IPerl::Display::PNG' },
};

sub register {

    # needed for the plugin
    require Role::Tiny;

    Role::Tiny->apply_roles_to_package(
        q(Devel::IPerl::Plugin::ProteinViewer::IPerlRole));
}

sub pv_package {
   Devel::IPerl->display( IPerl->js( <<'JSreq' ) );
    require.config({
        packages: [
            {
                name: 'pv',
                location: '//rawgit.com/biasmv/pv/master',
                main: 'bio-pv.min'
            }
        ]
    });
   JSreq
}

sub load_pdb {
    my $pdb     = shift;    #file
    my $options = shift;    #hash
  
    my @ligs = @{$options->{ligands}};
  
    IPerl->display( IPerl->html( qq| <div id="pvgl" style="margin-left: auto; width:300px; height: 300px;"></div> | ) );
    IPerl->display( IPerl->js( <<'JS' ) );
      function load_pdb(pdb_id) {
        require( ["pv"], function(pv) {
          var pvObj = pv.Viewer(document.getElementById('pvgl'), 
                           { quality : 'high', width: 'auto', height : 'auto',
                             antialias : true, outline : true});

          var structure;

          function load(pdb_id) {
            $.get( $pdb )
              .done(
                  function(data) {
                        structure = pv.io.pdb(data);
                        console.log(structure);
                        preset();
                        pvObj.centerOn(structure);
                  });
        }
 
       function preset() {
          pvObj.clear();
          var ligand = structure.select({rnames : [@ligs]});
          pvObj.ballsAndSticks('ligand', ligand);
          pvObj.cartoon('protein', structure);
        }
        load(pdb_id);
      });
    }
    JS

    IPerl->display( IPerl->js( <<'JS' ) );
      load_pdb($pdb);
    JS

}

{

    package Devel::IPerl::Plugin::ProteinViewer::IPerlRole;

    use Moo::Role;
    use Capture::Tiny qw(capture_stderr capture_stdout);
    use File::Temp;

    sub iperl_data_representations {
        my ($cc) = @_;
        return unless $Devel::IPerl::Plugin::ProteinViewer::IPerl_compat;

        my $format = uc( $cc->format );
        my $format_info =
          $Devel::IPerl::Plugin::ProteinViewer::IPerl_format_info;

        return unless exists( $format_info->{$format} );

        my $suffix      = $format_info->{$format}{suffix};
        my $displayable = $format_info->{$format}{displayable};

        my $tmp = File::Temp->new( SUFFIX => $suffix );
        my $tmp_filename = $tmp->filename;
        capture_stderr(
            sub {
                $cc->write_output($tmp_filename);
            }
        );

        return $displayable->new( filename => $tmp_filename )
          ->iperl_data_representations;
    }

}

1;
