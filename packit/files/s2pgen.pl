#!/usr/bin/perl
#
# Quick script to parse Snort rules and generate packit 
# command-line args to trigger them. 
#
# This script works but it isn't even close to complete.
# -DB 10/08/2003

# Defaults 
$DEFAULT_PACKIT     = "packit";
$DEFAULT_ADDR	    = "10.0.0.1";
$DEFAULT_DATA       = "R";

# Host/Port definitions 
$EXTERNAL_NET_ADDR  = "10.0.0.1";
$HOME_NET_ADDR      = "192.168.0.4"; 
$HTTP_SERVER_ADDR   = "192.168.0.2";
$SQL_SERVER_ADDR    = "192.168.0.3";
$SMTP_SERVER_ADDR   = "192.168.0.4";
$TELNET_SERVER_ADDR = "192.168.0.5";
$AIM_SERVER_ADDR    = "192.168.0.6";
$ORACLE_PORT        = "1521"; 
$HTTP_PORT	    = "80";
$SHELLCODE_PORT	    = "81";

sub parse_rule
{
    my $rule = $_[0];

    if($rule =~ /^#/) { return -1; }

    $TTL = "";
    $TOS = "";
    $ID = "";
    $FBITS = ""; 
    $DSIZE = "";
    $CONTENT = "";
    $CLIST = ""; 
    $OFFSET = "";
    $DEPTH = "";
    $FLAGS = ""; 
    $SEQ = "";
    $ACK = "";
    $ITYPE = "";
    $ICODE = ""; 
    $ICMPID = "";
    $ICMPSEQ = "";
    $URICONTENT = ""; 
    $IPPROTO = "";
    $SAMEIP = "";
    $FLOW = ""; 
    $FOFFSET = "";
    $RBYTES = "";
    $DIST = "";
    $WITHIN = "";

    my ($header, $options) = split /\(/, $rule;

    @header_args = split / /, $header; 
    $PROTO     = $header_args[1];
    $SRCADDR   = $header_args[2];
    $SRCDATA   = $header_args[3];
    $DSTADDR   = $header_args[5];
    $DSTDATA   = $header_args[6];

    if($SRCADDR eq "any") 		  { $SRCADDR = "-s$DEFAULT_ADDR"; }
    elsif($SRCADDR eq "\$HOME_NET") 	  { $SRCADDR = "-s$HOME_NET_ADDR"; }
    elsif($SRCADDR eq "\$EXTERNAL_NET")	  { $SRCADDR = "-s$EXTERNAL_NET_ADDR"; }
    elsif($SRCADDR eq "\$AIM_SERVERS")    { $SRCADDR = "-s$AIM_SERVER_ADDR"; }
    elsif($SRCADDR eq "\$HTTP_SERVERS")   { $SRCADDR = "-s$HTTP_SERVER_ADDR"; }
    elsif($SRCADDR eq "\$SMTP_SERVERS")   { $SRCADDR = "-s$SMTP_SERVER_ADDR"; }
    elsif($SRCADDR eq "\$TELNET_SERVERS") { $SRCADDR = "-s$TELNET_SERVER_ADDR"; }
    elsif($SRCADDR eq "\$SQL_SERVERS") 	  { $SRCADDR = "-s$SQL_SERVER_ADDR"; }
    else 				  { $SRCADDR = "-s$SRCADDR"; }

    if($SRCDATA eq "any") 		  { $SRCDATA = "-S$DEFAULT_DATA"; }
    elsif($SRCDATA eq "\$ORACLE_PORTS")   { $SRCDATA = "-S$ORACLE_PORT"; }
    elsif($SRCDATA eq "\$HTTP_PORTS")	  { $SRCDATA = "-S$HTTP_PORT"; }
    else				  { $SRCDATA = "-S$SRCDATA"; }

    if($DSTADDR eq "any")		  { $DSTADDR = "-d$DEFAULT_ADDR"; }
    elsif($DSTADDR eq "\$HOME_NET") 	  { $DSTADDR = "-d$HOME_NET_ADDR"; }
    elsif($DSTADDR eq "\$EXTERNAL_NET")   { $DSTADDR = "-d$EXTERNAL_NET_ADDR"; }
    elsif($DSTADDR eq "\$HTTP_SERVERS")   { $DSTADDR = "-d$HTTP_SERVER_ADDR"; }
    elsif($DSTADDR eq "\$SMTP_SERVERS")   { $DSTADDR = "-d$SMTP_SERVER_ADDR"; }
    elsif($DSTADDR eq "\$AIM_SERVERS")    { $DSTADDR = "-d$AIM_SERVER_ADDR"; }
    elsif($DSTADDR eq "\$TELNET_SERVERS") { $DSTADDR = "-d$TELNET_SERVER_ADDR"; }
    elsif($DSTADDR eq "\$SQL_SERVERS")    { $DSTADDR = "-d$SQL_SERVER"; }
    else				  { $DSTADDR = "-d$DSTADDR"; }

    if($DSTDATA eq "any") 		  { $DSTDATA = "-D$DEFAULT_DATA"; }
    elsif($DSTDATA eq "\$ORACLE_PORTS")   { $DSTDATA = "-D$ORACLE_PORT"; }
    elsif($DSTDATA eq "\$HTTP_PORTS")	  { $DSTDATA = "-D$HTTP_PORT"; }
    else		 		  { $DSTDATA = "-D$DSTDATA"; }

    $options = subst_escapes($options, "0");
    $options =~ s/\)//g; 

    @option_args = split /;/, $options;   

    foreach $arg (@option_args)
    {
        ($option_id, $option_value) = split /:/, $arg; 
        $option_id =~ s/ //g;
        $option_id =~ tr/A-Z/a-z/;

        $option_value =~ s/^ //g;
        $option_value = subst_escapes($option_value, "1");

        if($option_id eq "msg")		    { $MSG = $option_value; } 
        elsif($option_id eq "ttl") 	    { $TTL = "-T $option_value"; }
        elsif($option_id eq "tos") 	    { $TOS = "-o $option_value"; }
        elsif($option_id eq "id") 	    { $ID = "-n $option_value"; }
        elsif($option_id eq "ipopts")       { print "ipopts currently unsupported\n"; }
        elsif($option_id eq "fragbits")     { $FBITS = $option_value; }
        elsif($option_id eq "dsize") 	    { $DSIZE = $option_value; }
        elsif($option_id eq "content") 	    { $CONTENT = $option_value; }
        elsif($option_id eq "content-list") { $CLIST = $option_value; }
        elsif($option_id eq "offset") 	    { $OFFSET = $option_value; }
        elsif($option_id eq "depth") 	    { $DEPTH = $option_value; }
        elsif($option_id eq "flags")  	    { $FLAGS = "-F $option_value"; }	
        elsif($option_id eq "seq") 	    { $SEQ = "-q $option_value"; }
        elsif($option_id eq "ack") 	    { $ACK = "-a $option_value"; }
        elsif($option_id eq "itype") 	    { $ITYPE = "-K $option_value"; }
        elsif($option_id eq "icode") 	    { $ICODE = "-C $option_value"; }
        elsif($option_id eq "icmp_id") 	    { $ICMPID = "-N $option_value"; }
        elsif($option_id eq "icmp_seq")     { $ICMPSEQ = "-Q $option_value"; }
        elsif($option_id eq "uricontent")   { $URICONTENT = $option_value; }
        elsif($option_id eq "ip_proto")     { $IPPROTO = "-V $option_value";}
        elsif($option_id eq "samepip") 	    { $SAMEIP = 1; } 
        elsif($option_id eq "flow") 	    { $FLOW = $option_value; }
        elsif($option_id eq "fragoffset")   { $FOFFSET = $option_value; }
        elsif($option_id eq "rawbytes")     { $RBYTES = $option_value; }
        elsif($option_id eq "distance")     { $DIST = $option_value; }
        elsif($option_id eq "within") 	    { $WITHIN = $option_value; }
    }

    $MSG =~ s/\"//g;
    print "echo $MSG\n"; 

    if(length($CONTENT) > 0)
    {
        $CONTENT =~ s/\"//g;
        $CONTENT = "-p \"0x " . string_to_hex($CONTENT) . "\"";
    }
   
    $TEMPLATE = "$DEFAULT_PACKIT -t $PROTO $SRCADDR $DSTADDR $CONTENT";

    if($PROTO eq "tcp")
    {
        print "$TEMPLATE $SRCDATA $DSTDATA $TTL $TOS $ID $SEQ $ACK $FLAGS\n";  
    }
    elsif($PROTO eq "udp")
    {
        print "$TEMPLATE $SRCDATA $DSTDATA $TTL $TOS $ID\n";  
    }
    elsif($PROTO eq "icmp")
    {
        print "$TEMPLATE $SRCDATA $DSTDATA $TTL $TOS $ID $ITYPE $ICODE $ICMPID $ICMPSEQ\n"; 
    }
    elsif($PROTO eq "ip")
    {
        $PROTO = "rawip";
        print "$TEMPLATE $TTL $TOS $ID $IPPROTO\n"; 
    }

    print "\n";

    return 1;
}


sub string_to_hex 
{
    my @chars = split //, $_[0];

    $hex = 0;
    $new_string = "";

    foreach $char (@chars)
    {
        if($char eq "|") 
        {
            if($hex == 1) { $hex = 0; }
            else	  { $hex = 1; } 
  
            $new_string = $new_string . " ";
            $count = 0;
        } 
        elsif($hex == 0)
        {
            $new_string = sprintf("%s %x", $new_string, ord $char);
        }
        else
        {
            if($char ne " ") { $count++; }
            else { $count = 0; }

            if($count == 3) 
            { 
                $char = " " . $char; 
                $count = 0; 
            }

            $new_string = $new_string . $char;
        }
    }
  
    $new_string =~ s/^ //g;
    $new_string =~ s/ $//g;

    return $new_string;
}


sub subst_escapes
{
    if($_[1] eq "1")
    {
        $string = $_[0];
 
        $string =~ s/\\ESC#SC/;/g;
        $string =~ s/\\ESC#CO/:/g;
        $string =~ s/\\ESC#QU/\"/g; 
        $string =~ s/\\ESC#BS/\\/g;
        $string =~ s/\\ESC#PP/|/g;

        $new_string = $string;
    }
    else
    {
        my @chars = split //, $_[0];

        $new_string = '';

        foreach $char (@chars)
        {
            if($char eq ";" && $old_char eq "\\")     { $char = "ESC#SC"; }
            elsif($char eq ":" && $old_char eq "\\")  { $char = "ESC#CO"; }
            elsif($char eq "\"" && $old_char eq "\\") { $char = "ESC#QU"; }
            elsif($char eq "\\" && $old_char eq "\\") { $char = "ESC#BS"; }
            elsif($char eq "|" && $old_char eq "\\")  { $char = "ESC#PP"; }

            $old_char = $char;

            $new_string = $new_string . $char;
        }
    }

    return $new_string;
}


foreach $file (@ARGV)
{
    if(!open(RF, "<$file"))
    {
        print STDERR "Error opening $file: $!\n";
    }
    else
    {
        @rules = <RF>;

        foreach $rule (@rules)     
        {
            chomp $rule;
            parse_rule($rule);
        }

        close RF;
    }
}

