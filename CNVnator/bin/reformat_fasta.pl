#!/usr/local/bin/perl
 
=head1 NAME
 
    reformat_fasta.pl
 
=head1 SYNOPSIS
 
    reformat_fasta.pl input_fasta output_fasta outputdir 
        where input_fasta is the input fasta file,
              output_fasta is the output fasta file,
              outputdir is the output directory for writing output files. 
 
=head1 DESCRIPTION
 
    This script takes an input fasta file (<input_fasta>), and writes it out
    to a new file (<output_fasta>) that has 60 letters (bases/amino acids) per line.
 
=head1 VERSION
  
    Perl script last edited 8-Feb-2013.
 
=head1 CONTACT
 
    alc@sanger.ac.uk (Avril Coghlan)
 
=cut
 
# 
# Perl script reformat_fasta.pl
# Written by Avril Coghlan (alc@sanger.ac.uk)
# 8-Feb-13.
# Last edited 8-Feb-2013.
# SCRIPT SYNOPSIS: reformat_fasta: rewrite a fasta file so that there are 60 characters per line of sequence.
#
#------------------------------------------------------------------#
 
# CHECK IF THERE ARE THE CORRECT NUMBER OF COMMAND-LINE ARGUMENTS:
 
use strict;
use warnings;
 
my $num_args               = $#ARGV + 1;
if ($num_args != 3)
{
    print "Usage of reformat_fasta.pl\n\n";
    print "perl reformat_fasta.pl <input_fasta> <output_fasta> <outputdir>\n";
    print "where <input_fasta> is the input fasta file,\n";
    print "      <output_fasta> is the output fasta file,\n";
    print "      <outputdir> is the output directory for writing output files\n";
    print "For example, >perl reformat_fasta.pl contigs.fa new_contigs.fa\n";
    print "/lustre/scratch108/parasites/alc/StrongyloidesCNVnator/sven7Feb2013\n";
    exit;
}
 
# FIND THE PATH TO THE INPUT FASTA FILE:                     
 
my $input_fasta            = $ARGV[0];
 
# FIND THE PATH TO THE OUTPUT FASTA FILE:
 
my $output_fasta           = $ARGV[1];
 
# FIND THE DIRECTORY TO USE FOR OUTPUT FILES:      
 
my $outputdir              = $ARGV[2];
 
#------------------------------------------------------------------#
 
# TEST SUBROUTINES: 
 
my $PRINT_TEST_DATA        = 0;   # SAYS WHETHER TO PRINT DATA USED DURING TESTING.
&test_print_seq($outputdir); 
&test_print_error;
&test_read_assembly($outputdir);
&test_reformat_fasta($outputdir);
 
#------------------------------------------------------------------#
 
# RUN THE MAIN PART OF THE CODE:
 
&run_main_program($outputdir,$input_fasta,$output_fasta);
 
print STDERR "FINISHED.\n";
 
#------------------------------------------------------------------#
 
# RUN THE MAIN PART OF THE CODE:
 
sub run_main_program
{
   my $outputdir           = $_[0]; # DIRECTORY TO PUT OUTPUT FILES IN.
   my $input_fasta         = $_[1]; # THE INPUT FASTA FILE  
   my $output_fasta        = $_[2]; # THE OUTPUT FASTA FILE 
   my $errorcode;                   # RETURNED AS 0 IF THERE IS NO ERROR.
   my $errormsg;                    # RETURNED AS 'none' IF THERE IS NO ERROR. 
 
   # READ IN THE INPUT FASTA FILE, AND MAKE THE OUTPUT FASTA FILE:
   ($errorcode,$errormsg)  = &reformat_fasta($outputdir,$input_fasta,$output_fasta);
   if ($errorcode != 0) { ($errorcode,$errormsg) = &print_error($errormsg,$errorcode,0); }
}
 
#------------------------------------------------------------------#
 
# TEST &reformat_fasta
 
sub test_reformat_fasta
{
   my $outputdir           = $_[0]; # DIRECTORY TO PUT OUTPUT FILES INTO
   my $input_fasta;                 # INPUT FASTA FILE
   my $output_fasta;                # OUTPUT FASTA FILE
   my $errormsg;                    # RETURNED AS 'none' FROM A FUNCTION IF THERE IS NO ERROR
   my $errorcode;                   # RETURNED AS 0 FROM A FUNCTION IF THERE IS NO ERROR
   my $expected_output_fasta;       # FILE WITH EXPECTED CONTENTS OF $output_fasta
   my $differences;                 # DIFFERENCES BETWEEN $output_fasta AND $expected_output_fasta
   my $length_differences;          # LENGTH OF $differences
   my $line;                        #  
 
   ($input_fasta,$errorcode,$errormsg) = &make_filename($outputdir);
   if ($errorcode != 0) { ($errorcode,$errormsg) = &print_error($errormsg,$errorcode,0); }
   open(INPUT_FASTA,">$input_fasta") || die "ERROR: test_reformat_fasta: cannot open $input_fasta\n";
   print INPUT_FASTA ">seq1\n";
   print INPUT_FASTA "AAAAAAAAAATTTTTTTTTTAAAAAAAAAATTTTTTTTTTAAAAAAAAAATTTTTTTTTTAAAAAAAAAATTTTTTTTTTAAAAAAAAAATTTTTTTTTT\n";
   print INPUT_FASTA ">seq2\n";
   print INPUT_FASTA "CCCCCCCCCCGGGGGGGGGGCCCCCCCCCCGGGGGGGGGGCCCCCCCCCCGGGGGGGGGGCCCCCCCCCCGGGGGGGGGGCCCCCCCCCCGGGGGGGGGG\n";
   close(INPUT_FASTA);
   ($output_fasta,$errorcode,$errormsg) = &make_filename($outputdir);
   if ($errorcode != 0) { ($errorcode,$errormsg) = &print_error($errormsg,$errorcode,0); }
   open(OUTPUT_FASTA,">$output_fasta") || die "ERROR: test_print_seq: cannot open $output_fasta\n";
   close(OUTPUT_FASTA);
   ($errorcode,$errormsg)  = &reformat_fasta($outputdir,$input_fasta,$output_fasta);
   if ($errorcode != 0) { print STDERR "ERROR: test_reformat_fasta: failed test1\n"; exit;}
   ($expected_output_fasta,$errorcode,$errormsg) = &make_filename($outputdir);
   if ($errorcode != 0) { ($errorcode,$errormsg) = &print_error($errormsg,$errorcode,0); }
   open(EXPECTED,">$expected_output_fasta") || die "ERROR: test_reformat_fasta: cannot open $expected_output_fasta\n";
   print EXPECTED ">seq1\n";
   print EXPECTED "AAAAAAAAAATTTTTTTTTTAAAAAAAAAATTTTTTTTTTAAAAAAAAAATTTTTTTTTT\n";
   print EXPECTED "AAAAAAAAAATTTTTTTTTTAAAAAAAAAATTTTTTTTTT\n";
   print EXPECTED ">seq2\n";
   print EXPECTED "CCCCCCCCCCGGGGGGGGGGCCCCCCCCCCGGGGGGGGGGCCCCCCCCCCGGGGGGGGGG\n";
   print EXPECTED "CCCCCCCCCCGGGGGGGGGGCCCCCCCCCCGGGGGGGGGG\n";
   close(EXPECTED);
   $differences            = "";
   open(TEMP,"diff $output_fasta $expected_output_fasta |");
   while(<TEMP>)
   {
      $line                = $_;
      $differences         = $differences.$line;
   }
   close(TEMP);  
   $length_differences     = length($differences);
   if ($length_differences != 0) { print STDERR "ERROR: test_reformat_fasta: failed test1 (output_fasta $output_fasta expected_output_fasta $expected_output_fasta)\n"; exit;}
   system "rm -f $output_fasta";
   system "rm -f $expected_output_fasta"; 
   system "rm -f $input_fasta";
}
 
#------------------------------------------------------------------#
 
# READ IN THE INPUT FASTA FILE, AND MAKE THE OUTPUT FASTA FILE:
 
sub reformat_fasta
{
   my $outputdir           = $_[0]; # DIRECTORY TO PUT OUTPUT FILES INTO
   my $input_fasta         = $_[1]; # INPUT FASTA FILE
   my $output_fasta        = $_[2]; # OUTPUT FASTA FILE
   my $errorcode           = 0;     # RETURNED AS 0 IF THERE IS NO ERROR
   my $errormsg            = "none";# RETURNED AS 'none' IF THERE IS NO ERROR
   my $SEQ;                         # HASH TABLE TO STORE THE SEQUENCES OF SCAFFOLDS/CHROMOSOMES
   my $name;                        # NAME OF A SCAFFOLD/CHROMOSOME
   my $seq;                         # SEQUENCE OF A SCAFFOLD/CHROMOSOME 
 
   # READ IN THE SEQUENCES OF THE SCAFFOLDS/CHROMOSOMES:
   ($SEQ,$errorcode,$errormsg) = &read_assembly($input_fasta);
   if ($errorcode != 0) { ($errorcode,$errormsg) = &print_error($errormsg,$errorcode,0); }
 
   # WRITE OUT EACH OF THE SEQUENCES TO THE OUTPUT FILE:
   open(OUTPUT_FASTA,">$output_fasta") || die "ERROR: write_new_fasta: cannot open $output_fasta\n";
   close(OUTPUT_FASTA);
   foreach $name (keys %{$SEQ})
   {
      if (!($SEQ->{$name}))
      {
         $errormsg         = "ERROR: reformat_fasta: do not know sequence for $name\n";
         $errorcode        = 1; # ERRORCODE=1 (SHOULDN'T HAPPEN, CAN'T TEST FOR)
         return($errorcode,$errormsg);
      }
      # PRINT OUT THE SEQUENCE: 
      $seq                 = $SEQ->{$name};
      ($errorcode,$errormsg) = &print_seq($output_fasta,$seq,$name);
      if ($errorcode != 0) { ($errorcode,$errormsg) = &print_error($errormsg,$errorcode); }
   } 
 
   return($errorcode,$errormsg);
}
 
#------------------------------------------------------------------#
 
# TEST &read_assembly
 
sub test_read_assembly
{
   my $outputdir           = $_[0]; # DIRECTORY WHERE WE CAN WRITE OUTPUT FILES
   my $assembly;                    # TEMPORARY ASSEMBLY FILE NAME 
   my $SEQ;                         # HASH TABLE WITH SEQUENCES OF SCAFFOLDS
   my $errorcode;                   # RETURNED AS 0 FROM A FUNCTION IF THERE IS NO ERROR
   my $errormsg;                    # RETURNED AS 'none' FROM A FUNCTION IF THERE IS NO ERROR 
 
   ($assembly,$errorcode,$errormsg) = &make_filename($outputdir);
   if ($errorcode != 0) { ($errorcode,$errormsg) = &print_error($errormsg,$errorcode,0); }
   open(ASSEMBLY,">$assembly") || die "ERROR: test_read_assembly: cannot open $assembly\n";
   print ASSEMBLY ">seq1\n";
   print ASSEMBLY "AAAAA\n";
   print ASSEMBLY ">seq2\n";
   print ASSEMBLY "AAAAATTTTT\n";
   print ASSEMBLY "\n";
   print ASSEMBLY ">seq3\n";
   print ASSEMBLY "AAAAA\n";
   print ASSEMBLY "TTTTT\n";
   print ASSEMBLY ">seq4\n";
   print ASSEMBLY ">seq5\n";
   print ASSEMBLY " AAA AA \n";
   close(ASSEMBLY);
   ($SEQ,$errorcode,$errormsg) = &read_assembly($assembly);
   if ($SEQ->{'seq1'} ne 'AAAAA' || $SEQ->{'seq2'} ne 'AAAAATTTTT' || $SEQ->{'seq3'} ne 'AAAAATTTTT' || defined($SEQ->{'seq4'}) || 
       $SEQ->{'seq5'} ne 'AAAAA' || $errorcode != 0) 
   { 
      print STDERR "ERROR: test_read_assembly: failed test1\n"; 
      exit;
   }
   system "rm -f $assembly";
 
   # TEST ERRORCODE=4:
   ($assembly,$errorcode,$errormsg) = &make_filename($outputdir);
   if ($errorcode != 0) { ($errorcode,$errormsg) = &print_error($errormsg,$errorcode,0); }
   open(ASSEMBLY,">$assembly") || die "ERROR: test_assembly: cannot open $assembly\n";
   print ASSEMBLY ">seq1\n";
   print ASSEMBLY "AAAAA\n";
   print ASSEMBLY ">seq2\n";
   print ASSEMBLY "AAAAATTTTT\n";
   print ASSEMBLY ">seq1\n";
   print ASSEMBLY "AAAAA\n";
   close(ASSEMBLY);
   ($SEQ,$errorcode,$errormsg) = &read_assembly($assembly);
   if ($errorcode != 4) { print STDERR "ERROR: test_assembly: failed test2\n"; exit;}
   system "rm -f $assembly";
 
   # TEST FOR ERRORCODE=5:
   ($assembly,$errorcode,$errormsg) = &make_filename($outputdir);
   if ($errorcode != 0) { ($errorcode,$errormsg) = &print_error($errormsg,$errorcode,0); }
   open(ASSEMBLY,">$assembly") || die "ERROR: test_assembly: cannot open $assembly\n";
   print ASSEMBLY "AAAAA\n";
   print ASSEMBLY ">seq2\n";
   print ASSEMBLY "AAAAATTTTT\n";
   print ASSEMBLY ">seq1\n";
   print ASSEMBLY "AAAAA\n";
   close(ASSEMBLY);
   ($SEQ,$errorcode,$errormsg) = &read_assembly($assembly);
   if ($errorcode != 5) { print STDERR "ERROR: test_assembly: failed test2\n"; exit;}
   system "rm -f $assembly";
 
}
 
#------------------------------------------------------------------#
 
# READ IN THE ASSEMBLY FILE:
# SUBROUTINE SYNOPSIS: read_assembly(): read fasta file of scaffold sequences into a hash
 
sub read_assembly       
{
   my $input_assembly      = $_[0]; # THE INPUT ASSEMBLY FILE
   my $errorcode           = 0;     # RETURNED AS 0 IF THERE IS NO ERROR
   my $errormsg            = "none";# RETURNED AS 'none' IF THERE IS NO ERROR
   my $line;                        # 
   my $scaffold            = "none";# NAME OF SCAFFOLD
   my @temp;                        # 
   my $seq;                         # SEQUENCE OF SCAFFOLD 
   my %SEQ                 = ();    # HASH TABLE FOR STORING SCAFFOLD SEQUENCE
 
   $seq                    = "";
   open(ASSEMBLY,"$input_assembly") || die "ERROR: read_assembly: cannot open $input_assembly\n";
   while(<ASSEMBLY>)
   {
      $line                = $_;
      chomp $line;
      if (substr($line,0,1) eq '>')
      {
         if ($seq ne "")
         {
            if ($scaffold eq 'none')
            {
               $errormsg   = "ERROR: read_assembly: do not know name of scaffold\n";
               $errorcode  = 5; # ERRORCODE=5 (TESTED FOR)
               return(\%SEQ,$errorcode,$errormsg);
            }
            if ($SEQ{$scaffold}) 
            {
               $errormsg   = "ERROR: read_assembly: already know sequence for scaffold $scaffold\n";
               $errorcode  = 4; # ERRORCODE=4 (TESTED FOR)
               return(\%SEQ,$errorcode,$errormsg);
            }
            $SEQ{$scaffold}= $seq;
            $seq           = "";
         }
         @temp             = split(/\s+/,$line);
         $scaffold         = $temp[0];
         $scaffold         = substr($scaffold,1,length($scaffold)-1);
      }
      else
      {
         $line             =~ s/\s+//g; # REMOVE SPACES
         $seq              = $seq.$line; 
      }
   }
   close(ASSEMBLY); 
   if ($seq ne "")
   {
      if ($scaffold eq 'none')
      {
         $errormsg         = "ERROR: read_assembly: do not know name of scaffold\n";
         $errorcode        = 5; # ERRORCODE=5 (TESTED FOR)
         return(\%SEQ,$errorcode,$errormsg);
      }
 
      if ($SEQ{$scaffold}) 
      {
         $errormsg         = "ERROR: read_assembly: already know sequence for scaffold $scaffold\n";
         $errorcode        = 4; # ERRORCODE=4 (TESTED FOR)
         return(\%SEQ,$errorcode,$errormsg);
      }
      $SEQ{$scaffold}      = $seq;
      $seq                 = "";
   }
 
   return(\%SEQ,$errorcode,$errormsg);
 
}
 
#------------------------------------------------------------------#
 
# PRINT OUT THE SEQUENCE: 
# SUBROUTINE SYNOPSIS: print_seq(): print out a fasta sequence to an output file, putting 60 characters per line
 
sub print_seq
{
   my $output_fasta        = $_[0]; # THE OUTPUT FASTA FILE
   my $seq                 = $_[1]; # THE SEQUENCE TO PRINT OUT
   my $scaffold            = $_[2]; # SCAFFOLD NAME
   my $errorcode           = 0;     # RETURNED AS 0 IF THERE IS NO ERROR
   my $errormsg            = "none";# RETURNED AS 'none' IF THERE IS NO ERROR
   my $length;                      # LENGTH OF SEQUENCE $seq
   my $offset;                      # 
   my $a_line;                      # A LINE OF THE SEQUENCE 
 
   $length                 = length($seq); 
   $offset                 = 0;
   open(FASTA,">>$output_fasta") || die "ERROR: write_new_fasta: cannot open $output_fasta\n";
   print FASTA ">$scaffold\n";
   while($offset < $length)
   {
      $a_line              = substr($seq,$offset,60);
      print FASTA "$a_line\n";
      $offset              = $offset + 60;
   } 
   close(FASTA);
 
   return($errorcode,$errormsg); 
}
 
#------------------------------------------------------------------#
 
# TEST &print_seq       
 
sub test_print_seq         
{
   my $outputdir           = $_[0]; # DIRECTORY TO WRITE OUTPUT FILES IN
   my $output_fasta;                # OUTPUT FILE
   my $seq;                         # SEQUENCE
   my $errorcode;                   # RETURNED AS 0 BY A FUNCTION IF THERE IS NO ERROR
   my $errormsg;                    # RETURNED AS 'none' BY A FUNCTION IF THERE IS NO ERROR 
   my $expected_output_fasta;       # FILE CONTAINING EXPECTED CONTENTS OF $output_fasta
   my $differences;                 # DIFFERENCES BETWEEN $output_fasta AND $expected_output_fasta
   my $line;                        # 
   my $length_differences;          # LENGTH OF $differences
 
   ($output_fasta,$errorcode,$errormsg) = &make_filename($outputdir);
   if ($errorcode != 0) { ($errorcode,$errormsg) = &print_error($errormsg,$errorcode,0); } 
   $seq                    = "AAAAATTTTTCCCCCGGGGGAAAAATTTTTCCCCCGGGGGAAAAATTTTTCCCCCGGGGGAAAAATTTTTCCCCCGGGGGAAAAATTTTTCCCCCGGGGGAAAAATTTTTCCCCCGGGGGAAAAATTTTTCCCCCGGGGG";
   open(OUTPUT_FASTA,">$output_fasta") || die "ERROR: test_print_seq: cannot open $output_fasta\n";
   close(OUTPUT_FASTA);
   ($errorcode,$errormsg)  = &print_seq($output_fasta,$seq,"seq1");
   if ($errorcode != 0) { print STDERR "ERROR: test_print_seq: failed test1\n"; exit;}
   ($expected_output_fasta,$errorcode,$errormsg) = &make_filename($outputdir);
   if ($errorcode != 0) { ($errorcode,$errormsg) = &print_error($errormsg,$errorcode,0); } 
   open(EXPECTED_OUTPUT,">$expected_output_fasta") || die "ERROR: test_print_to_output: cannot open $expected_output_fasta\n";
   print EXPECTED_OUTPUT ">seq1\n";
   print EXPECTED_OUTPUT "AAAAATTTTTCCCCCGGGGGAAAAATTTTTCCCCCGGGGGAAAAATTTTTCCCCCGGGGG\n";
   print EXPECTED_OUTPUT "AAAAATTTTTCCCCCGGGGGAAAAATTTTTCCCCCGGGGGAAAAATTTTTCCCCCGGGGG\n";
   print EXPECTED_OUTPUT "AAAAATTTTTCCCCCGGGGG\n";
   close(EXPECTED_OUTPUT); 
   $differences            = "";
   open(TEMP,"diff $output_fasta $expected_output_fasta |");
   while(<TEMP>)
   {
      $line                = $_;
      $differences         = $differences.$line;
   }
   close(TEMP);  
   $length_differences     = length($differences);
   if ($length_differences != 0) { print STDERR "ERROR: test_print_seq: failed test1 (output_fasta $output_fasta expected_output_fasta $expected_output_fasta)\n"; exit;}
   system "rm -f $output_fasta";
   system "rm -f $expected_output_fasta"; 
 
}
 
#------------------------------------------------------------------#
 
# SUBROUTINE TO MAKE A FILE NAME FOR A TEMPORARY FILE:
 
sub make_filename
{
   my $outputdir             = $_[0]; # OUTPUT DIRECTORY TO WRITE TEMPORARY FILE NAME TO
   my $found_name            = 0;     # SAYS WHETHER WE HAVE FOUND A FILE NAME YET
   my $filename              = "none";# NEW FILE NAME TO USE 
   my $errorcode             = 0;     # RETURNED AS 0 IF THERE IS NO ERROR
   my $errormsg              = "none";# RETURNED AS 'none' IF THERE IS NO ERROR
   my $poss_filename;                 # POSSIBLE FILE NAME TO USE
   my $random_number;                 # RANDOM NUMBER TO USE IN TEMPORARY FILE NAME
 
   while($found_name == 0)
   {
      $random_number         = rand();
      $poss_filename         = $outputdir."/tmp".$random_number;
      if (!(-e $poss_filename))
      {
         $filename           = $poss_filename;
         $found_name         = 1;
      } 
   } 
   if ($found_name == 0 || $filename eq 'none')
   {
      $errormsg              = "ERROR: make_filename: found_name $found_name filename $filename\n";
      $errorcode             = 6; # ERRORCODE=6 
      return($filename,$errorcode,$errormsg);
   }
 
   return($filename,$errorcode,$errormsg); 
}
 
#------------------------------------------------------------------#
 
# TEST &print_error
 
sub test_print_error
{
   my $errormsg;                    # RETURNED AS 'none' FROM A FUNCTION IF THERE WAS NO ERROR
   my $errorcode;                   # RETURNED AS 0 FROM A FUNCTION IF THERE WAS NO ERROR
 
   ($errormsg,$errorcode)  = &print_error(45,45,1);
   if ($errorcode != 12) { print STDERR "ERROR: test_print_error: failed test1\n"; exit;}
 
   ($errormsg,$errorcode)  = &print_error('My error message','My error message',1);
   if ($errorcode != 11) { print STDERR "ERROR: test_print_error: failed test2\n"; exit;}
 
   ($errormsg,$errorcode)  = &print_error('none',45,1);
   if ($errorcode != 13) { print STDERR "ERROR: test_print_error: failed test3\n"; exit;} 
 
   ($errormsg,$errorcode)  = &print_error('My error message', 0, 1);
   if ($errorcode != 13) { print STDERR "ERROR: test_print_error: failed test4\n"; exit;}
}
 
#------------------------------------------------------------------#
 
# PRINT OUT AN ERROR MESSAGE AND EXIT.
 
sub print_error
{
   my $errormsg            = $_[0]; # THIS SHOULD BE NOT 'none' IF AN ERROR OCCURRED.
   my $errorcode           = $_[1]; # THIS SHOULD NOT BE 0 IF AN ERROR OCCURRED.
   my $called_from_test    = $_[2]; # SAYS WHETHER THIS WAS CALLED FROM test_print_error OR NOT
 
   if ($errorcode =~ /[A-Z]/ || $errorcode =~ /[a-z]/) 
   { 
      if ($called_from_test == 1)
      {
         $errorcode = 11; $errormsg = "ERROR: print_error: the errorcode is $errorcode, should be a number.\n"; # ERRORCODE=11
         return($errormsg,$errorcode);
      }
      else 
      { 
         print STDERR "ERROR: print_error: the errorcode is $errorcode, should be a number.\n"; 
         exit;
      }
   }
 
   if (!($errormsg =~ /[A-Z]/ || $errormsg =~ /[a-z]/)) 
   { 
      if ($called_from_test == 1)
      {
         $errorcode = 12; $errormsg = "ERROR: print_error: the errormessage $errormsg does not seem to contain text.\n"; # ERRORCODE=12
         return($errormsg,$errorcode);
      }
      else
      {
         print STDERR "ERROR: print_error: the errormessage $errormsg does not seem to contain text.\n"; 
         exit;
      }
   }
 
   if    ($errormsg eq 'none' || $errorcode == 0) 
   { 
      if ($called_from_test == 1)
      {
         $errorcode = 13; $errormsg = "ERROR: print_error: errormsg $errormsg, errorcode $errorcode.\n"; # ERRORCODE=13
         return($errormsg,$errorcode);
      }
      else 
      {
         print STDERR "ERROR: print_error: errormsg $errormsg, errorcode $errorcode.\n"; 
         exit;
      }
   }
   else                                           
   { 
      print STDERR "$errormsg"; 
      exit;                                                      
   } 
 
   return($errormsg,$errorcode);
}
 
#------------------------------------------------------------------#

