/pid=([0-9+])/{
	for(i=1;i<=NF;++i) {
		if($i~/pid=([0-9+])/) {
			split($i, procs, ",")
			for (PID in procs) {
				pid=procs[PID]
				if(pid~/pid=([0-9+])/) {
					match(pid,"[0-9]+",a)
					printf "%s ", a[0]
				}
			}
			
			#for(i2=1; i2 <= length(procs); i2++) {
			#	pid=procs[$i2]
			#	if($pid~/pid=([0-9+])/)
			#		print $pid
			#}
		}
	}
}
