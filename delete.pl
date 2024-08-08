#!/usr/bin/perl

use strict;
use warnings;

use JSON;
use CGI;
use DBI;

# Setup variables to connect to DB
my $data_source = q/DBI:mysql:organizer;127.0.0.1;3306/;
my $user = q/awh/;
my $password = q/scroll64/;

# Connect to the data source and get a handle for that connection.
my $dbh = DBI->connect($data_source, $user, $password)
    or die "Can't connect to $data_source: $DBI::errstr";

# Start ajax
my $cgi = CGI->new;

print $cgi->header('application/json;charset=UTF-8');

my $id = $cgi->param('data_id');    

my $sth = $dbh->prepare("SELECT todo_id FROM todos WHERE message='$id' ORDER BY todo_id DESC")
                   or die "prepare statement failed: $dbh->errstr()";

$sth->execute() or die "execution failed: $dbh->errstr()"; 

my $todo_id;

$todo_id = $sth->fetchrow();

$sth = $dbh->prepare("DELETE FROM inbox WHERE todo_id=$todo_id")
                   or die "prepare statement failed: $dbh->errstr()";
$sth->execute() or die "execution failed: $dbh->errstr()"; 
$sth = $dbh->prepare("DELETE FROM action WHERE todo_id=$todo_id")
                   or die "prepare statement failed: $dbh->errstr()";
$sth->execute() or die "execution failed: $dbh->errstr()"; 
$sth = $dbh->prepare("DELETE FROM wait WHERE todo_id=$todo_id")
                   or die "prepare statement failed: $dbh->errstr()";
$sth->execute() or die "execution failed: $dbh->errstr()"; 
$sth = $dbh->prepare("DELETE FROM long_term WHERE todo_id=$todo_id")
                   or die "prepare statement failed: $dbh->errstr()";
$sth->execute() or die "execution failed: $dbh->errstr()"; 

$sth->finish();
$dbh->disconnect();

#convert  data to JSON
my $op = JSON -> new -> utf8 -> pretty(1);
my $json = $op -> encode({
    result => $id
});

print $json;

