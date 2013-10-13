use strict;
use warnings;
use Module::Build;

my $build = Module::Build->new(
  module_name => 'greek-transliterate',
  dist_abstract => 'convert transliterated Greek (ascii) to real Greek letters in utf8 (and back). See http://www.typegreek.com/',
  license => 'perl',
  dist_author => [
    'Nicolas Franck <nicolas.franck@ugent.be>'
  ],
  build_requires => {
    'Test::Exception' => 0,
    'Test::More' => 0,
    'Unicode::Normalize' => 0
  },
  configure_requires => { 'Module::Build' => 0.40 },
  requires => {
    'perl' => '5.10.1',
  },
  create_license => 1,
  dist_version_from   => 'lib/Greek/Transliterate.pm',
  create_makefile_pl => 'traditional'
);

$build->create_build_script;
