#!/usr/bin/env ruby
require 'net/smtp'
require 'digest'
#require 'pry'
#require 'pry-nav'

##  ######   #######  ##    ## ######## ####  ######   
## ##    ## ##     ## ###   ## ##        ##  ##    ##  
## ##       ##     ## ####  ## ##        ##  ##        
## ##       ##     ## ## ## ## ######    ##  ##   #### 
## ##       ##     ## ##  #### ##        ##  ##    ##  
## ##    ## ##     ## ##   ### ##        ##  ##    ##  
##  ######   #######  ##    ## ##       ####  ######   

CountFile = "../tmp/checkupdates.count"
DFCommitFiles = "../tmp/dotfiles"
DIR = File.expand_path(File.dirname(__FILE__))
Dir.chdir DIR
Hostname = Socket.gethostbyname(Socket.gethostname).first
Debug = false


##  ######## ##     ##    ###    #### ##       
##  ##       ###   ###   ## ##    ##  ##       
##  ##       #### ####  ##   ##   ##  ##       
##  ######   ## ### ## ##     ##  ##  ##       
##  ##       ##     ## #########  ##  ##       
##  ##       ##     ## ##     ##  ##  ##       
##  ######## ##     ## ##     ## #### ######## 

def send_email(to, opts)
	opts[:server]     ||= 'localhost'
	opts[:from]       ||= "#{Hostname}@status.frostyfrog.net"
	opts[:from_alias] ||= "#{Hostname.split(".").first}"
	opts[:subject]    ||= "Cron"
	opts[:body]       ||= 'Unset Body'

	msg = <<EOM
From: #{opts[:from_alias]} <#{opts[:from]}>
To: <#{to}>
Subject: [FF - #{Hostname.split(".").first}] #{opts[:subject]}

#{opts[:body]}
EOM

	unless Debug then
		Net::SMTP.start(opts[:server]) do |smtp|
			smtp.send_message msg, opts[:from], to
		end
	else
		puts msg
	end
end

##   ######   #######  ########  ########
##  ##    ## ##     ## ##     ## ##
##  ##       ##     ## ##     ## ##
##  ##       ##     ## ##     ## ######
##  ##       ##     ## ##     ## ##
##  ##    ## ##     ## ##     ## ##
##   ######   #######  ########  ########

ColorString = Debug ? "--color=always" : "--color=never"

if Hostname.split(".")[1] == "psearch"
	EMAILADDR = "colton.wolkins@perfectsearchcorp.com"
else
	EMAILADDR = "frostyfrog2@gmail.com"
end

def packages_check
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
		send_email EMAILADDR, :body => "(You've updated recently... Yay! I'm happy naow~nya!)>  ฅ(^ω^ฅ)", :subject => "Pacman"
		exit
	end

	unless pkgtotal == newpkgs
		newpkgs = pkgtotal - newpkgs
		message = <<EOM
Detected #{newpkgs} new packages for a total of #{pkgtotal} on #{Hostname}.

#{packages}
EOM
		#puts message
		send_email EMAILADDR, :body => message, :subject => "Pacman"
	end
end

def run_git
	Dir.mkdir(DFCommitFiles) unless File.exists?(DFCommitFiles)
	sha256 = Digest::SHA256.new
	`git fetch -q origin master`

	myhash = `git rev-parse --verify HEAD`
	remotehash = `git rev-parse --verify origin/master`
	if myhash == remotehash then
		return
	end

	behind_cmd = "git log #{ColorString} HEAD..origin/master"
	ahead_cmd = "git log #{ColorString} --branches --not --remotes=origin"

	behind = `#{behind_cmd}`
	behind_short = `#{behind_cmd} --oneline`
	#ahead = `git log --color=always origin/master..HEAD`
	ahead = `#{ahead_cmd}`
	ahead_short = `#{ahead_cmd} --oneline`
	file = File.join DFCommitFiles, "behind.hash"
	File.open(file, "w") {|f| f.write("0")} unless File.exists?(file)
	File.open(file, "r") {|f| f.read()}
	file = File.join DFCommitFiles, "ahead.hash"
	File.open(file, "w") {|f| f.write("0")} unless File.exists?(file)
	File.open(file, "r") {|f| f.read()}
	if behind_short.length > 1
		behind_message = <<EOM
#{behind_short.split("\n").length} commits behind origin:
#{behind_short}
#{behind}
========
EOM
	end
	if ahead_short.length > 1
		ahead_message = <<EOM
#{ahead_short.split("\n").length} commits ahead of origin:
#{ahead_short}
#{ahead}
EOM
	end
	message = <<EOM
on #{Hostname}.
#{[behind_message, ahead_message].reject(&:empty?).join("\n")}
EOM
	send_email EMAILADDR, :body => message, :subject => "Git needs updating!"
end

packages_check
run_git

__END__
frosty~/.files$ git rev-parse --verify HEAD
1bfbd0689b5ad19197281a762dd746e449b52a95
frosty~/.files$ git fetch origin master
Enter passphrase for key '/home/frosty/.ssh/id_rsa': 

frosty~/.files$ git log --color=always HEAD..origin/master

