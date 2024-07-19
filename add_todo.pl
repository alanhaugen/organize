#!/usr/bin/perl

use strict;
use warnings;

use JSON;
use CGI;
use DBI;

# Setup variables to connect to DB
my $data_source = q/DBI:mysql:organizer;127.0.0.1;3306/;
my $user = q/root/;
my $password = q//;

# Connect to the data source and get a handle for that connection.
my $dbh = DBI->connect($data_source, $user, $password)
    or die "Can't connect to $data_source: $DBI::errstr";

# Start ajax
my $cgi = CGI->new;

print $cgi->header('application/json;charset=UTF-8');

my $id = $cgi->param('data_id');    

my $sth = $dbh->prepare("INSERT INTO todos(message) VALUES('$id')")
                   or die "prepare statement failed: $dbh->errstr()";

#$sth->execute() or die "execution failed: $dbh->errstr()"; 

$sth->finish();
$dbh->disconnect();

#convert  data to JSON
my $op = JSON -> new -> utf8 -> pretty(1);
my $json = $op -> encode({
    result => $id
});

print $json;

