# ${license-info}
# ${developer-info}
# ${author-info}

###############################################################################
# This is 'php.pm', a ncm-php's file
###############################################################################
#
#
###############################################################################
# Coding style: emulate <TAB> characters with 4 spaces, thanks!
###############################################################################
#
# Example NCM Component with NVA API config access
#
###############################################################################

package NCM::Component::php;
#
# a few standard statements, mandatory for all components
#

use strict;
use NCM::Component;
use vars qw(@ISA $EC);
@ISA = qw(NCM::Component);
$EC=LC::Exception::Context->new->will_store_all;

use NCM::Check;

use EDG::WP4::CCM::Element;
use EDG::WP4::CCM::Resource;
use File::Copy;


# my $mainconf = "/etc/httpd/conf/httpd.conf";
my $cdbpath = "/software/components/php/conf";
my $swpath = "/etc";

my $phpconf = "$swpath/php.ini";

my @ltr = (localtime())[0..5];
my @lt = reverse(@ltr);
$lt[0] += 1900;
$lt[1] += 1;
my $timestamp = join("-", @lt[0..2]) . " " . join(':', @lt[3..5]);


my $header = " \
#################################################################################
# File generated by NCM component
# $timestamp
#################################################################################


";


sub save_config($$) {

    my ($self, $conffile) = @_;

    if ( -e $conffile && ! -e $conffile. ".orig") {
        move($conffile, $conffile . ".orig")
    } else {
        move($conffile, $conffile . ".ncm_save")
    }

}


sub php_config ($$) {


    my $self = shift;
    my $element = shift;
    my $conffile = shift;

    $self->save_config($conffile) if -f $conffile;
    unless (open (OF, ">$conffile")) {
        $self->error("Cannot open config file $conffile: $!");
        exit;
    }
    print OF $header;

    
    my %phphash = $element->getHash();
    my @phparr = sort(keys(%phphash));

#     my $tmpvar = 0;
    for (my $tmpvar=0; $tmpvar<$#phparr-1; $tmpvar++) {
        if ($phparr[$tmpvar] eq 'main') {
            $phparr[$tmpvar] = $phparr[0];
            $phparr[0] = 'main';
        }
    }

    my $phpitem = "";
    foreach $phpitem (@phparr) {
    
        my $confelem = $phphash{$phpitem};
        my $confname = $confelem->getName();

        $self->error("$confname is 'property' instead of 'resource'")
            if $confelem->isProperty();

        my %confhash = $confelem->getHash();
        my @items = sort(keys(%confhash));
        my $confsect_name = "";
        my $confsect_prep_name = "";
        if (defined($confhash{'name'})) {
            $self->error("$confname/name is 'resource' instead of 'property'")
                if $confhash{'name'}->isResource();
            $confsect_name = $confhash{'name'}->getValue();
        }
        if (defined($confhash{'prep_name'})) {
            $self->error("$confname/prep_name is 'resource' instead of 'property'")
                if $confhash{'prep_name'}->isResource();
            $confsect_prep_name = $confhash{'prep_name'}->getValue();
        }

        print OF "\n[$confsect_name]\n" if $confsect_name;

        my $item = "";
        foreach $item (@items) {
        
            my $itemelem = $confhash{$item};
            my $itemname = $itemelem->getName();
            next if $itemname =~ /(prep_)?name/;

            if ($itemelem->isResource()) {
            
                my $subitemelem = $confelem->getNextElement();
                my $subitemname = $subitemelem->getName();
                $self->error("$subitemname is 'resource' instead of 'property'")
                    if $subitemelem->isResource();
                my $subitemval = $subitemelem->getValue();

                print OF "$confsect_prep_name." if $confsect_prep_name;
                print OF "$itemname.$subitemname = $subitemval\n";
                next
            }
            my $itemval = $itemelem->getValue();

            print OF "$confsect_prep_name." if $confsect_prep_name;
            print OF "$itemname = $itemval\n";

        }

    }
    close(OF);


}


##########################################################################
sub Configure($$) {
##########################################################################
  
    my ($self,$config)=@_;

    ###########################################################################
    # BDII2Oracle
    ###########################################################################

    # Gettting CDB tree
    $self->error("$cdbpath doesn\'t exist ") && return
        unless $config->elementExists($cdbpath);
    my $element = $config->getElement($cdbpath);


    # Processing CDB tree

    my $elemname = $element->getName();

    $self->error("$elemname is 'property' instead of 'resource'")
        if $element->isProperty();

    $self->php_config($element, $phpconf);


} 


1; # Perl module requirement.
