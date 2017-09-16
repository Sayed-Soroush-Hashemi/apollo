#!/usr/bin/bash

playlist_path='playlist.txt'
tmp_dir='.tmp'
player_pid_file_path='.tmp/player.pid'
cur_track_pid_file_path='.tmp/cur_track.pid'

case "${1}" in
	"player" )
		case ${2} in 
			"play" )
				bash player.sh "${tmp_dir}" "${playlist_path}" "${cur_track_pid_file_path}" 2> /dev/null &
				echo $! > "${player_pid_file_path}"
				;;
			"stop" )
				
				if [ -e "${player_pid_file_path}" ] ; then
					player_pid=`cat "${player_pid_file_path}"`
					kill ${player_pid}
					rm "${player_pid_file_path}"
				fi
				if [ -e "${cur_track_pid_file_path}" ] ; then
					cur_track_pid=`cat "${cur_track_pid_file_path}"`
					kill ${cur_track_pid}
					rm "${cur_track_pid_file_path}"
				fi
				;;
			"next" )
				cur_track_pid=`cat "${cur_track_pid_file_path}"`
				kill ${cur_track_pid}
				;;
		esac
		;;
	"playlist" )
		case ${2} in 
			"edit" )
				nano "${playlist_path}"
				;;
			"clear" )
				rm "${playlist_path}"
				touch "${playlist_path}"
				;;

			"add" )
				args=( "$@" )
				for i in `seq 2 ${#args}`
				do
					abs_path=`readlink -f "${args[$i]}"`
					echo "$abs_path" >> "${playlist_path}"
				done
				;;
		esac
		;;
esac
