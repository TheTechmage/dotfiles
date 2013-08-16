#!/bin/sh
ps -eo size,pid,comm= --sort -size |\
	awk '
{
	hr[1024**2]="GB";
	hr[1024]="MB";
	for (x=1024**3; x>=1024; x/=1024){
		if ($1>=x){
			printf ("%.2f %s\t- ", $1/x, hr[x]);
			break
		}
	}
}
{
	printf ("%-6s%-10s", $2, $3)
}
{
	for (x=4;x<=NF;x++){
		printf ("%s",$x)
	} print ("\n")
}
	'|\
	sed '/^$/d'|\
	grep -v PID|\
	head -n 10
