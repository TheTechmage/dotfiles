#!/usr/bin/env ruby
require 'net/smtp'
require 'pry'
require 'pry-nav'

CountFile = "../tmp/checkupdates.count"
DIR = File.expand_path(File.dirname(__FILE__))
Dir.chdir DIR

def send_email(to, opts)
	opts[:server]     ||= 'localhost'
	opts[:from]       ||= 'status@cron.frostyfrog.net'
	opts[:from_alias] ||= 'Cron'
	opts[:subject]    ||= '[FF] PS Cron'
	opts[:body]       ||= 'Unset Body'

	msg = <<EOM
From: #{opts[:from_alias]} <#{opts[:from]}>
To: <#{to}>
Subject: #{opts[:subject]}

#{opts[:body]}
EOM

	Net::SMTP.start(opts[:server]) do |smtp|
		smtp.send_message msg, opts[:from], to
	end
end


##   ######   #######  ########  ########
##  ##    ## ##     ## ##     ## ##
##  ##       ##     ## ##     ## ##
##  ##       ##     ## ##     ## ######
##  ##       ##     ## ##     ## ##
##  ##    ## ##     ## ##     ## ##
##   ######   #######  ########  ########

packages = `checkupdates`
pkgtotal = packages.split.length

unless File.exists? CountFile
	File.open(CountFile, "w") {|f| f.write("0")}
end
#binding.pry

cfile = File.open(CountFile, "r+")
newpkgs = cfile.read.strip.to_i
cfile.truncate(0)
cfile.seek(0)
cfile.write(pkgtotal.to_s)
cfile.close()

if pkgtotal == 0 and newpkgs != 0
	send_email "colton.wolkins@perfectsearchcorp.com", :body => "(You've updated recently... Yay! I'm happy naow~nya!)>  ฅ(^ω^ฅ)"
	exit
end

unless pkgtotal == newpkgs
	newpkgs = pkgtotal - newpkgs
	message = <<EOM
Detected #{newpkgs} new packages for a total of #{pkgtotal}.

#{packages}
EOM
	#puts message
	send_email "colton.wolkins@perfectsearchcorp.com", :body => message
end
