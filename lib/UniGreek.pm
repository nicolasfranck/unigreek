package UniGreek;
use utf8;
use strict;
use warnings;
use feature qw(:5.10);
use Unicode::Normalize;
use base qw(Exporter);

our @EXPORT_OK = qw(from_unigreek to_unigreek);

our $VERSION="0.1";
our %unigreek_to_utf8;
our %utf8_to_unigreek;

#see: http://www.typegreek.com/alphabet.key/ 
#see: http://www.mythfolklore.net/bibgreek/resources/typing.htm

sub from_unigreek { 
  my $str = $_[0];
  my(@parts)= $str =~ /(\X)/go;  

  my @output;
  my $current_combination = "";

  my $c = "";
  while(defined($c)){
    $c = shift(@parts);    
    while(defined($c) && exists($unigreek_to_utf8{ $current_combination.$c })){
      $current_combination.=$c;      
      $c = shift(@parts); 
    }
    if($current_combination ne ""){    
      my $greek_utf8 = $unigreek_to_utf8{ $current_combination };
      push @output,(defined($greek_utf8) ? $greek_utf8->[0] : $current_combination);
  
      #last char did not combine with current_combination
      if(defined($c)){        
        $current_combination = $c;
      }else{
        $current_combination = "";
      }
    }elsif(defined($c)){
      push @output,$c;
    }
  }
  if(scalar(@output) && $output[-1] eq "σ"){
    $output[-1] = "ς";
  }
  NFC(join("",@output));
}
sub to_unigreek {
  my $str = $_[0];
  my(@chars)= $str =~ /(\X)/go;
  my @output;
  for my $c(@chars){
    push @output,($utf8_to_unigreek{$c} // $c);
  }
  
  if(scalar(@output) && $output[-1] eq "ς"){
    $output[-1] = "s";
  }
  join("",@output);  
}

BEGIN {
  %unigreek_to_utf8 = (
    #format: "<unigreek>" => ["<utf8-greek>","<is-canical-unigreek>"]
    "a" => ["α",1],
    #one
    "a|" => ["ᾳ",1],
    "a)" => ["ἀ",1],
    "a(" => ["ἁ",1],
    "a\\" => ["ὰ",1],
    "a/" => ["ά",1],
    "a=" => ["ᾶ",1],

    #two (often two or more combinations lead to the same letter)
    "a\\|" => ["ᾲ",1],
    "a|\\" => ["ᾲ",0],

    "a/|" => ["ᾴ",1],
    "a|/" => ["ᾴ",0],

    "a)\\" => ["ἂ",1],
    "a\\)" => ["ἂ",0],

    "a)/" => ["ἄ",1],
    "a/)" => ["ἄ",0],

    "a(\\" => ["ἃ",1],
    "a\\(" => ["ἃ",0],

    "a(/" => ["ἅ",1],
    "a/(" => ["ἅ",0],

    "a)=" => ["ἆ",1],
    "a=)" => ["ἆ",0],

    "a=)" => ["ἆ",0],
    "a)=" => ["ἆ",1],

    "a(=" => ["ἇ",1],
    "a=(" => ["ἇ",0],

    "a|)" => ["ᾀ",1],
    "a)|" => ["ᾀ",0],

    "a(|" => ["ᾁ",1],
    "a|(" => ["ᾁ",0],

    "a=|" => ["ᾷ",1],
    "a|=" => ["ᾷ",0],

    #three
    #ᾂ
    "a)\\|" => ["ᾂ",1],
    "a)|\\" => ["ᾂ",0],
    "a\\|)" => ["ᾂ",0],
    "a\\)|" => ["ᾂ",0],
    "a|)\\" => ["ᾂ",0],
    "a|\\)" => ["ᾂ",0],
    #ᾄ
    "a)/|" => ["ᾄ",1],
    "a)|/" => ["ᾄ",0],
    "a/)|" => ["ᾄ",0],
    "a/|)" => ["ᾄ",0],
    "a|/)" => ["ᾄ",0],
    "a|)/" => ["ᾄ",0],

    #ᾃ
    "a(\\|" => ["ᾃ",1],
    "a(|\\" => ["ᾃ",0],
    "a\\|(" => ["ᾃ",0],
    "a\\(|" => ["ᾃ",0],
    "a|(\\" => ["ᾃ",0],
    "a|\\(" => ["ᾃ",0],
    #ᾅ
    "a(/|" => ["ᾅ",1],
    "a(|/" => ["ᾅ",0],
    "a/(|" => ["ᾅ",0],
    "a/|(" => ["ᾅ",0],
    "a|/(" => ["ᾅ",0],
    "a|(/" => ["ᾅ",0],
    #ᾆ
    "a)=|" => ["ᾆ",1],
    "a)|=" => ["ᾆ",0],
    "a=)|" => ["ᾆ",0],
    "a=|)" => ["ᾆ",0],
    "a|=)" => ["ᾆ",0],
    "a|)=" => ["ᾆ",0],
    #ᾇ
    "a(=|" => ["ᾇ",1],
    "a(|=" => ["ᾇ",0],
    "a=(|" => ["ᾇ",0],
    "a=|(" => ["ᾇ",0],
    "a|=(" => ["ᾇ",0],
    "a|(=" => ["ᾇ",0],

    "b" => ["β",1],
    "g" => ["γ",1],
    "d" => ["δ",1],

    "e" => ["ε",1],
    "e/" => ["έ",1],
    "e\\" => ["ὲ",1],
    "e)" => ["ἐ",1],
    "e(" => ["ἑ",1],

    "e)\\" => ["ἒ",1],
    "e\\)" => ["ἒ",0],

    "e)/" => ["ἔ",1],
    "e/)" => ["ἔ",0],

    "e(\\" => ["ἓ",1],
    "e\\(" => ["ἓ",0],

    "e(/" => ["ἕ",1],
    "e/(" => ["ἕ",0],  

    "z" => ["ζ",1],

    "h" => ["η",1],
    #one
    "h\\" => ["ὴ",1],
    "h/" => ["ή",1],
    "h)" => ["ἠ",1],
    "h(" => ["ἡ",1],
    "h=" => ["ῆ",1],
    "h|" => ["ῃ",1],

    #two  
    "h)\\" => ["ἢ",1],
    "h\\)" => ["ἢ",0],

    "h)/" => ["ἤ",1],
    "h/)" => ["ἤ",0],

    "h(\\" => ["ἣ",1],
    "h\\(" => ["ἣ",0],

    "h(/" => ["ἥ",1],
    "h/(" => ["ἥ",0],

    "h)=" => ["ἦ",1],
    "h=)" => ["ἦ",0],

    "h(=" => ["ἧ",1],
    "h=(" => ["ἧ",0],

    "h|)" => ["ᾐ",1],
    "h)|" => ["ᾐ",0],

    "h(|" => ["ᾑ",1],
    "h|(" => ["ᾑ",0],

    "h=|" => ["ῇ",1],
    "h|=" => ["ῇ",0],

    "h\\|" => ["ῂ",1],
    "h|\\" => ["ῂ",0],

    "h/|" => ["ῄ",1],
    "h|/" => ["ῄ",0],

    #three
    #ᾒ
    "h)\\|" => ["ᾒ",1],
    "h)|\\" => ["ᾒ",0],
    "h\\)|" => ["ᾒ",0],
    "h\\|)" => ["ᾒ",0],
    "h|)\\" => ["ᾒ",0],
    "h|\\)" => ["ᾒ",0],
    #ᾔ
    "h)/|" => ["ᾔ",1],
    "h)|/" => ["ᾔ",0],
    "h/)|" => ["ᾔ",0],
    "h/|)" => ["ᾔ",0],
    "h|/)" => ["ᾔ",0],
    "h|)/" => ["ᾔ",0],
    #ᾓ
    "h(\\|" => ["ᾓ",1],
    "h(|\\" => ["ᾓ",0],
    "h\\(|" => ["ᾓ",0],
    "h\\|(" => ["ᾓ",0],
    "h|\\(" => ["ᾓ",0],
    "h|(\\" => ["ᾓ",0],
    #ᾕ
    "h(/|" => ["ᾕ",1],
    "h(|/" => ["ᾕ",0],
    "h/(|" => ["ᾕ",0],
    "h/|(" => ["ᾕ",0],
    "h|/(" => ["ᾕ",0],
    "h|(/" => ["ᾕ",0],
    #ᾖ
    "h)=|" => ["ᾖ",1],
    "h)|=" => ["ᾖ",0],
    "h=)|" => ["ᾖ",0],
    "h=|)" => ["ᾖ",0],
    "h|=)" => ["ᾖ",0],
    "h|)=" => ["ᾖ",0],
    #ᾗ
    "h(=|" => ["ᾗ",1],
    "h(|=" => ["ᾗ",0],
    "h=(|" => ["ᾗ",0],
    "h=|(" => ["ᾗ",0],
    "h|=(" => ["ᾗ",0],
    "h|(=" => ["ᾗ",0],

    "q" => ["θ",1],

    "i" => ["ι",1],
    #one
    "i\\" => ["ὶ",1],
    "i/" => ["ί",1],
    "i(" => ["ἱ",1],
    "i)" => ["ἰ",1],
    "i=" => ["ῖ",1],
    "i+" => ["ϊ",1],
    
    #two
    "i)\\" => ["ἲ",1],
    "i\\)" => ["ἲ",0],

    "i)/" => ["ἴ",1],
    "i/)" => ["ἴ",0],

    "i(\\" => ["ἳ",1],
    "i\\(" => ["ἳ",0],

    "i(/" => ["ἵ",1],
    "i/(" => ["ἵ",0],

    "i)=" => ["ἶ",1],
    "i=)" => ["ἶ",0],

    "i(=" => ["ἷ",1],
    "i=(" => ["ἷ",0],

    "i+\\" => ["ῒ",0],
    "i\\+" => ["ῒ",1],

    "i/+" => ["ΐ",1],
    "i+/" => ["ΐ",0],

    "k" => ["κ",1],
    "l" => ["λ",1],
    "m" => ["μ",1],
    "n" => ["ν",1],
    "c" => ["ξ",1],

    "o" => ["ο",1],
    "o\\" => ["ὸ",1],
    "o/" => ["ό",1],
    "o)" => ["ὀ",1],
    "o(" => ["ὁ",1],

    "o)\\" => ["ὂ",1],
    "o\\)" => ["ὂ",0],

    "o)/" => ["ὄ",1],
    "o/)" => ["ὄ",0],

    "o(\\" => ["ὃ",1],
    "o\\(" => ["ὃ",0],

    "o(/" => ["ὅ",1],
    "o/(" => ["ὅ",0],

    "p" => ["π",1],
    "r" => ["ρ",1],
    "s" => ["σ",1],
    #todo: s op einde van een string moet ς  
    "s." => ["ς.",0],
    "s " => ["ς ",0],
    "s," => ["ς,",0],
    "s?" => ["ς;",0],
    "s;" => ["ς·",0],
    "s:" => ["ς·",0],

    #In standard beta code, a j represents a terminal sigma and an s represents a regular sigma. On TypeGreek, j and s are interchangeable.
    "j" => ["ς",1],
    "j." => ["ς.",1],
    "j " => ["ς ",1],
    "j," => ["ς,",1],
    "j?" => ["ς;",1],
    "j;" => ["ς·",1],
    "j:" => ["ς·",1],

    
    "t" => ["τ",1],

    "u" => ["υ",1],
    #one
    "u\\" => ["ὺ",1],
    "u/" => ["ύ",1],
    "u)" => ["ὐ",1],
    "u(" => ["ὑ",1],
    "u=" => ["ῦ",1],
    #two
    "u)\\" => ["ὒ",1],
    "u\\)" => ["ὒ",0],

    "u)/" => ["ὔ",1],
    "u/)" => ["ὔ",0],

    "u(\\" => ["ὓ",1],
    "u\\(" => ["ὓ",0],

    "u(/" => ["ὕ",1],
    "u/(" => ["ὕ",0],

    "u)=" => ["ὖ",1],
    "u=)" => ["ὖ",0],

    "u(=" => ["ὗ",1],
    "u=(" => ["ὗ",0],

    "f" => ["φ",1],
    "x" => ["χ",1],
    "y" => ["ψ",1],

    "w" => ["ω",1],
    #one
    "w\\" => ["ὼ",1],
    "w/" => ["ώ",1],
    "w)" => ["ὠ",1],
    "w(" => ["ὡ",1],
    "w=" => ["ῶ",1],
    "w|" => ["ῳ",1],

    #two(TODO: omgekeerde richting)
    "w)\\" => ["ὢ",1],
    "w\\)" => ["ὢ",0],

    "w)/" => ["ὤ",1],
    "w/)" => ["ὤ",0],

    "w(\\" => ["ὣ",1],
    "w\\(" => ["ὣ",0],

    "w(/" => ["ὥ",1],
    "w/(" => ["ὥ",0],

    "w)=" => ["ὦ",1],
    "w=)" => ["ὦ",0],

    "w(=" => ["ὧ",1],
    "w=(" => ["ὧ",],

    "w\\|" => ["ῲ",1],
    "w|\\" => ["ῲ",0],

    "w/|" => ["ῴ",1],
    "w|/" => ["ῴ",0],

    "w)|" => ["ᾠ",1],
    "w|)" => ["ᾠ",0],

    "w(|" => ["ᾡ",1],
    "w|(" => ["ᾡ",0],

    "w|=" => ["ῷ",1],
    "w=|" => ["ῷ",0],

    #three
    #ᾦ
    "w)=|" => ["ᾦ",1],
    "w)|=" => ["ᾦ",0],
    "w=|)" => ["ᾦ",0],
    "w|=)" => ["ᾦ",0],
    "w=)|" => ["ᾦ",0],
    "w=|)" => ["ᾦ",0],
    #ᾧ
    "w(=|" => ["ᾧ",1],
    "w(|=" => ["ᾧ",0],
    "w=|(" => ["ᾧ",0],
    "w|=(" => ["ᾧ",0],
    "w=(|" => ["ᾧ",0],
    "w=|(" => ["ᾧ",0],

    "v" => ["ϝ",1],

    "A" => ["Α",1],
    #one
    "A\\" => ["Ὰ",1],
    "A/" => ["Ά",1],
    "A)" => ["Ἀ",1],
    "A(" => ["Ἁ",1],
    "A|" => ["ᾼ",1],

    #two
    "A)\\" => ["Ἂ",1],
    "A\\)" => ["Ἂ",0],

    "A)/" => ["Ἄ",1],
    "A/)" => ["Ἄ",0],

    "A(\\" => ["Ἃ",1],  
    "A\\(" => ["Ἃ",0],

    "A(/" => ["Ἅ",1],
    "A/(" => ["Ἅ",0],

    "A)=" => ["Ἆ",1],
    "A=)" => ["Ἆ",0],

    "A(=" => ["Ἇ",1],
    "A=(" => ["Ἇ",0],

    "A|)" => ["ᾈ",0],
    "A)|" => ["ᾈ",1],

    "A(|" => ["ᾉ",1],
    "A|(" => ["ᾉ",0],

    #three
    #ᾊ
    "A)\\|" => ["ᾊ",1],
    "A)|\\" => ["ᾊ",0],
    "A\\)|" => ["ᾊ",0],
    "A\\|)" => ["ᾊ",0],
    "A|)\\" => ["ᾊ",0],
    "A|\\)" => ["ᾊ",0],
    #ᾌ
    "A)/|" => ["ᾌ",1],
    "A)|/" => ["ᾌ",0],
    "A/)|" => ["ᾌ",0],
    "A/|)" => ["ᾌ",0],
    "A|)/" => ["ᾌ",0],
    "A|/)" => ["ᾌ",0],
    #ᾋ
    "A(\\|" => ["ᾋ",1],
    "A(|\\" => ["ᾋ",0],
    "A\\(|" => ["ᾋ",0],
    "A\\|(" => ["ᾋ",0],
    "A|\\(" => ["ᾋ",0],
    "A|(\\" => ["ᾋ",0],
    #ᾍ
    "A(/|" => ["ᾍ",1],
    "A(|/" => ["ᾍ",0],
    "A/(|" => ["ᾍ",0],
    "A/|(" => ["ᾍ",0],
    "A|(/" => ["ᾍ",0],
    "A|/(" => ["ᾍ",0],
    #ᾎ
    "A)=|" => ["ᾎ",1],
    "A)|=" => ["ᾎ",0],
    "A=)|" => ["ᾎ",0],
    "A=|)" => ["ᾎ",0],
    "A|=)" => ["ᾎ",0],
    "A|)=" => ["ᾎ",0],

    #ᾏ
    "A(=|" => ["ᾏ",1],
    "A(|=" => ["ᾏ",0],
    "A=(|" => ["ᾏ",0],
    "A=|(" => ["ᾏ",0],
    "A|=(" => ["ᾏ",0],
    "A|(=" => ["ᾏ",0],

    "B" => ["Β",1],
    "G" => ["Γ",1],
    "D" => ["Δ",1],

    "E" => ["Ε",1],
    #one
    "E\\" => ["Ὲ",1],
    "E/" => ["Έ",1],
    "E)" => ["Ἐ",1],
    "E(" => ["Ἑ",1],
    #two
    "E)\\" => ["Ἒ",1],
    "E\\)" => ["Ἒ",0],

    "E)/" => ["Ἔ",1],
    "E/)" => ["Ἔ",0],

    "E(\\" => ["Ἓ",1],
    "E\\(" => ["Ἓ",0],

    "E(/" => ["Ἕ",1],
    "E/(" => ["Ἕ",0],

    "Z" => ["Ζ",1],

    "H" => ["Η",1],
    #one
    "H)" => ["Ἠ",1],
    "H(" => ["Ἡ",1],  
    "H\\" => ["Ὴ",1],
    "H/" => ["Ή",1],
    "H|" => ["ῌ",1],
      #sorry no such thing..
      #"H=" => ["",1],
   
    "H)\\" => ["Ἢ",1],
    "H\\)" => ["Ἢ",0],

    "H)/" => ["Ἤ",1],
    "H/)" => ["Ἤ",0],

    "H(\\" => ["Ἣ",1],
    "H\\(" => ["Ἣ",0],

    "H(/" => ["Ἥ",1],
    "H/(" => ["Ἥ",0],

    "H)=" => ["Ἦ",1],
    "H=)" => ["Ἦ",0],

    "H(=" => ["Ἧ",1],
    "H=(" => ["Ἧ",0],

    "H|)" => ["ᾘ",0],
    "H)|" => ["ᾘ",1],

    "H(|" => ["ᾙ",1],
    "H|(" => ["ᾙ",0],   

    #three
    #ᾚ
    "H)\\|" => ["ᾚ",1],
    "H)|\\" => ["ᾚ",0],
    "H\\|)" => ["ᾚ",0],
    "H\\)|" => ["ᾚ",0],
    "H|)\\" => ["ᾚ",0],
    "H|\\)" => ["ᾚ",0],
    #ᾜ
    "H)/|" => ["ᾜ",1],
    "H)|/" => ["ᾜ",0],
    "H/)|" => ["ᾜ",0],
    "H/|)" => ["ᾜ",0],
    "H|)/" => ["ᾜ",0],
    "H|/)" => ["ᾜ",0],
    #ᾛ
    "H(\\|" => ["ᾛ",1],
    "H(|\\" => ["ᾛ",0],
    "H\\(|" => ["ᾛ",0],
    "H\\|(" => ["ᾛ",0],
    "H|\\(" => ["ᾛ",0],
    "H|(\\" => ["ᾛ",0],
    #ᾝ
    "H(/|" => ["ᾝ",1],
    "H(|/" => ["ᾝ",0],
    "H/(|" => ["ᾝ",0],
    "H/|(" => ["ᾝ",0],
    "H|(/" => ["ᾝ",0],
    "H|/(" => ["ᾝ",0],
    #ᾞ
    "H)=|" => ["ᾞ",1],
    "H)|=" => ["ᾞ",0],
    "H=|)" => ["ᾞ",0],
    "H=)|" => ["ᾞ",0],
    "H|=)" => ["ᾞ",0],
    "H|)=" => ["ᾞ",0],

    #ᾟ
    "H(=|" => ["ᾟ",1],
    "H(|=" => ["ᾟ",0],
    "H=(|" => ["ᾟ",0],
    "H=|(" => ["ᾟ",0],
    "H|(=" => ["ᾟ",0],
    "H|=(" => ["ᾟ",0],

    "Q" => ["Θ",1],

    "I" => ["Ι",1],
    #one
    "I\\" => ["Ὶ",1],
    "I/" => ["Ί",1],
    "I)" => ["Ἰ",1],
    "I(" => ["Ἱ",1],
    
    #two
    "I)\\" => ["Ἲ",1],
    "I\\)" => ["Ἲ",0],

    "I)/" => ["Ἴ",1],
    "I/)" => ["Ἴ",0],

    "I(\\" => ["Ἳ",1],
    "I\\(" => ["Ἳ",0],

    "I(/" => ["Ἵ",1],
    "I/(" => ["Ἵ",0],

    "I)=" => ["Ἶ",1],
    "I=)" => ["Ἶ",0],

    "I(=" => ["Ἷ",1],
    "I=(" => ["Ἷ",0],

    "K" => ["Κ",1],
    "L" => ["Λ",1],
    "M" => ["Μ",1],
    "N" => ["Ν",1],
    "C" => ["Ξ",1],

    "O" => ["Ο",1],
    #one  
    "O\\" => ["Ὸ",1],
    "O/" => ["Ό",1],
    "O)" => ["Ὀ",1],
    "O(" => ["Ὁ",1],
    #two
    "O)\\" => ["Ὂ",1],
    "O\\)" => ["Ὂ",0],

    "O)/" => ["Ὄ",1],
    "O/)" => ["Ὄ",0],

    "O(\\" => ["Ὃ",1],
    "O\\(" => ["Ὃ",0],

    "O(/" => ["Ὅ",1],
    "O/(" => ["Ὅ",0],

    "P" => ["Π",1],
    "R" => ["Ρ",1],
    "S" => ["Σ",1],
    "T" => ["Τ",1],

    "U" => ["Υ",1],
    #one  
    "U\\" => ["Ὺ",1],
    "U/" => ["Ύ",1],

    # 'U)' werk niet?
    #"U)" => ["",1],

    "U(" => ["Ὑ",1],

    # 'U)' werk niet?
    #"U)\\" => ["",1],
    #"U)/" => ["",1],

    "U(\\" => ["Ὓ",1],
    "U\\(" => ["Ὓ",0],

    "U(/" => ["Ὕ",1],
    "U/(" => ["Ὕ",0],

    # 'U)' werk niet?
    #"U)=" => ["",1],

    "U(=" => ["Ὗ",1],
    "U=(" => ["Ὗ",0],


    "F" => ["Φ",1],
    "X" => ["Χ",1],
    "Y" => ["Ψ",1],

    "W" => ["Ω",1],
    #one
    "W|" => ["ῼ",1],
    "W\\" => ["Ὼ",1],
    "W/" => ["Ώ",1],
    "W)" => ["Ὠ",1],
    "W(" => ["Ὡ",1],
      #sorry
      #"W=" => ["",1],

    #two
    "W)\\" => ["Ὢ",1],
    "W\\)" => ["Ὢ",0],

    "W)/" => ["Ὤ",1],
    "W/)" => ["Ὤ",0],

    "W(\\" => ["Ὣ",1],
    "W\\(" => ["Ὣ",0],

    "W(/" => ["Ὥ",1],
    "W/(" => ["Ὥ",0],

    "W)=" => ["Ὦ",1],
    "W=)" => ["Ὦ",0],

    "W(=" => ["Ὧ",1],
    "W=(" => ["Ὧ",0],

    #three
    #  ᾪ
    "W)|\\" => ["ᾪ",1],
    "W)\\|" => ["ᾪ",0],
    "W\\)|" => ["ᾪ",0],
    "W\\|)" => ["ᾪ",0],
    "W|)\\" => ["ᾪ",0],
    "W|\\)" => ["ᾪ",0],

    # ᾬ
    "W)/|" => ["ᾬ",1],
    "W)|/" => ["ᾬ",0],
    "W/)|" => ["ᾬ",0],
    "W/|)" => ["ᾬ",0],
    "W|/)" => ["ᾬ",0],
    "W|)/" => ["ᾬ",0],

    # ᾫ
    "W(\\|" => ["ᾫ",1],
    "W(|\\" => ["ᾫ",0],
    "W\\(|" => ["ᾫ",0],
    "W\\|(" => ["ᾫ",0],
    "W|\\(" => ["ᾫ",0],
    "W|(\\" => ["ᾫ",0],

    # ᾭ
    "W(/|" => ["ᾭ",1],
    "W(|/" => ["ᾭ",0],
    "W/(|" => ["ᾭ",0],
    "W/|(" => ["ᾭ",0],
    "W|/(" => ["ᾭ",0],
    "W|(/" => ["ᾭ",0],

    # ᾮ
    "W)=|" => ["ᾮ",1],
    "W)=|" => ["ᾮ",0],
    "W=)|" => ["ᾮ",0],
    "W=|)" => ["ᾮ",0],
    "W|=)" => ["ᾮ",0],
    "W|)=" => ["ᾮ",0],

    # ᾯ
    "W)=|" => ["ᾯ",1],
    "W)=|" => ["ᾯ",0],
    "W=)|" => ["ᾯ",0],
    "W=|)" => ["ᾯ",0],
    "W|=)" => ["ᾯ",0],
    "W|)=" => ["ᾯ",0],

    "V" => ["Ϝ",1],
    "," => [",",1],
    "?" => [";",1],
    ";" => ["·",1],
    "." => [".",1],
    ":" => ["·",1],
    "|" => ["ͺ",1]
  );

  for my $key(sort keys %unigreek_to_utf8){
    next unless $unigreek_to_utf8{$key}->[1];
    $utf8_to_unigreek{ $unigreek_to_utf8{$key}->[0] } = $key;
  }
}

=head1 NAME

  UniGreek - This module converts between an ascii-representation of polytonic Greek
  (i.e. old Greek) and the utf8-representation.

  The ascii-representation is taken from typegreek.com (http://www.typegreek.com), a web-based
  application, made by Randy Hoyt, that converts Roman lettercombination to Greek in utf8-format.

=head1 SYNOPSIS

  use strict;
  use utf8;
  use feature qw(:5.10);
  use UniGreek qw(from_unigreek to_unigreek);

  binmode STDOUT,":utf8";

  my $unigreek = "Mh=nin a)/eide qea/";
  #result: Μῆνιν ἄειδε θεά
  say UniGreek::from_unigreek($unigreek);

  my $utf8 = "Μῆνιν ἄειδε θεά";
  #result: Mh=nin a)/eide qea/
  say UniGreek::to_unigreek($utf8);

=head1 METHODS

=head2 from_unigreek(<ascii-string>)
  
  Converts from the ascii-representation to the real Greek letters in utf8.  

=head2 to_unigreek(<utf8-greek>)

  Converts from the Greek letters in utf8 to the ascii-representation

=head1 SEE ALSO

L<http://www.typegreek.com>
L<http://unigreek.phildow.net/>
L<http://www.mythfolklore.net/bibgreek/resources/typing.htm>

=cut
1;
