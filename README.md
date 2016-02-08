p5-Devel-IPerl-Plugin-ProteinViewer
==================================
PV Plugin for the IPerl kernel of Jupyter Notebooks that enables inline 
visualization of protein structures.

SYNOPSIS
============
```perl
    [1] IPerl->load_plugin("ProteinViewer");
    ...
    [2] my $viewer = ProteinViewer->new(file => "some.pdb"); 
```

DESCRIPTION
============
This plugin aims to simplify inline visualization of molecular structures in the IPerl kernel of Jupyter Notebooks. It ecapsulates calls to PV, which is a javascript library that renders graphics with WebGL. The Perl implementation works from the [pvviewer, python scripts] (https://github.com/biasmv/pv/tree/master/pvviewer). 

IMPORTANT
============
This code doesn't work yet!!

