track_ind=0
while [ 1 ] ; do
	let "track_ind += 1"
	number_of_tracks=`wc -l "${2}"`
	number_of_tracks=($number_of_tracks)
	number_of_tracks=${number_of_tracks[0]}

	if [ $track_ind -ge $number_of_tracks ] ; then
		track_ind=0
	fi

	temp=$track_ind
	while read -r track_path ; do
		if [ $temp -eq 0 ] ; then 
			break
		fi
		let "temp -= 1"
	done < "${2}"
	sleep 1

	track_basename=`basename "$track_path"`
	rm -rf "${1}"/*.wav
	ffmpeg -i "$track_path" "${1}/${track_basename}.wav" < /dev/null
	aplay "${1}/${track_basename}.wav" < /dev/null &
	echo $! > "${3}"
	while [[ `ps cax | grep $!` ]] ; do
		sleep 2
	done
done
