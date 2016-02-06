p5-Devel-IPerl-Plugin-ProteinViewer
==================================
PV Plugin for the IPerl kernel of Jupyter Notebooks that enables inline 
visualization of protein structures.

please see *[HackaMol::X::Vina on MetaCPAN](https://metacpan.org/release/DEMIAN/HackaMol-X-Vina-0.01) for formatted documentation.

SYNOPSIS
============
```perl
    [1] IPerl->load_plugin("ProteinViewer");
    ...
    [2] load_pdb("some.pdb",{foo_pvoption => foo, bar_pvoption => bar}); 
```

DESCRIPTION
============
This plugin aims to simplify inline visualization of molecular structures. It ecapsulates calls to PV, which is a javascript library that renders graphics with WebGL.

