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
PKGFile = "../tmp/checkupdates.pkgs"
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
#

EMAILADDR = "system-status@frostyfrog.net"

def send_email(to, opts)
	hostname = "#{Hostname.split(".").first}"
	domain = "#{Hostname.split(".", 2).last}"
	opts[:server]     ||= 'localhost'
	opts[:from]       ||= "#{hostname}@#{domain}"
	opts[:from_alias] ||= "#{hostname}"
	opts[:subject]    ||= "Cron"
	opts[:body]       ||= 'Unset Body'

	msg = <<EOM
From: #{opts[:from_alias]} <#{opts[:from]}>
To: <#{to}>
Subject: [FF2 - #{Hostname.split(".").first}] #{opts[:subject]}

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

def packages_check
	packages = `checkupdates`
	pkgtotal = packages.split("\n").length

	unless File.exists? CountFile
		File.open(CountFile, "w") {|f| f.write("0")}
	end
	unless File.exists? PKGFile
		File.open(PKGFile, "w") {|f| f.write("")}
	end
	#binding.pry

	cfile = File.open(CountFile, "r+")
	pkgfile = File.open(PKGFile, "r+")

	file1lines = pkgfile.readlines
	updated_pkgs = []
	packages.lines.each do |e|
		if(!file1lines.include?(e))
			updated_pkgs.push e
		end
	end
	updated_pkgs = updated_pkgs.join
	def update_pkglist(pkgfile, updated_pkgs)
		pkgfile.truncate(0)
		pkgfile.seek(0)
		pkgfile.write(updated_pkgs)
		pkgfile.close()
	end

	newpkgs = cfile.read.strip.to_i
	cfile.truncate(0)
	cfile.seek(0)
	cfile.write(pkgtotal.to_s)
	cfile.close()

	if pkgtotal > newpkgs
		newpkgs = pkgtotal - newpkgs
		message = <<EOM
Detected #{newpkgs} new packages for a total of #{pkgtotal} on #{Hostname}.

New Packages:
#{updated_pkgs}

All Packages:
#{packages}
EOM
		#puts message
		send_email EMAILADDR, :body => message, :subject => "Pacman"
		update_pkglist pkgfile, packages
	elsif pkgtotal == 0 and newpkgs != 0
		message = "(You've updated recently... Yay! I'm happy naow~nya!)>  ฅ(^ω^ฅ)"
		send_email EMAILADDR, :body => message, :subject => "Pacman"
		update_pkglist pkgfile, packages
	elsif pkgtotal < newpkgs
		message = <<EOM
「　   You've updated recently... Yay!
　　I'd be extremely happy, except...
　　 There are even more packages for
　　   you to update. Whaaaahaaahaha!　」> .·´¯`(>▂<)´¯`·.

---------------------------------------------------------------------------

Detected #{newpkgs} new packages on #{Hostname}.

All Packages:
#{packages}
EOM
		send_email EMAILADDR, :body => message, :subject => "Pacman"
		update_pkglist pkgfile, packages
	end

end

def run_git
	Dir.mkdir(DFCommitFiles) unless File.exists?(DFCommitFiles)
	#sha256 = Digest::SHA256.new
	`git fetch -q origin master`

	myhash = `git rev-parse --verify HEAD`
	remotehash = `git rev-parse --verify origin/master`
	if myhash == remotehash then
	#	send_email EMAILADDR, :body => "test", :subject => "[TEST] Git needs updating!"
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
	behind_message = ""
	ahead_message = ""
	if behind_short.length > 1
		behind_message = <<EOM
#{behind_short.split("\n").length} commit(s) behind origin:
#{behind_short}
#{behind}
========
EOM
	end
	if ahead_short.length > 1
		ahead_message = <<EOM
#{ahead_short.split("\n").length} commit(s) ahead of origin:
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

system("which checkupdates 2>&1| grep /check")
if $?.exitstatus == 0 then
	packages_check
end
run_git

__END__
frosty~/.files$ git rev-parse --verify HEAD
1bfbd0689b5ad19197281a762dd746e449b52a95
frosty~/.files$ git fetch origin master
Enter passphrase for key '/home/frosty/.ssh/id_rsa': 

frosty~/.files$ git log --color=always HEAD..origin/master

