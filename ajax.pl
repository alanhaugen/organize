#!/usr/bin/perl

use strict;
use warnings;

use JSON;
use CGI;

my $cgi = CGI->new;

print $cgi->header('application/json;charset=UTF-8');

my $id = $cgi->param('data_id');    

#convert  data to JSON
my $op = JSON -> new -> utf8 -> pretty(1);
my $json = $op -> encode({
    result => $id
});

print $json;

