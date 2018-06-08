#!/bin/bash

src_file=`readlink -f $0`
src_dir=`dirname $src_file`
cd $src_dir

project_dir=~/.apollo
queue_path="${project_dir}/queue.txt"
tmp_dir="${project_dir}/.tmp"
player_pid_file_path="${project_dir}/.tmp/player.pid"
cur_track_pid_file_path="${project_dir}/.tmp/cur_track.pid"

if [ ! -e ${project_dir} ] ; then
	mkdir ${project_dir}
	mkdir ${tmp_dir}
fi

case "${1}" in
	"player" )
		case ${2} in
			"play" )
				bash player.sh "${tmp_dir}" "${queue_path}" "${cur_track_pid_file_path}" 2> /dev/null &
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
			* )
				echo "wrong command. try:"
				echo "apollo player play"
				echo "apollo player stop"
				echo "apollo player next"
				;;
		esac
		;;
	"queue" )
		case ${2} in
			"edit" )
				nano "${queue_path}"
				;;
			"clear" )
				rm "${queue_path}"
				touch "${queue_path}"
				;;

			"add" )
				args=( "$@" )
				for i in `seq 2 ${#args}`
				do
					abs_path=`readlink -f "${args[$i]}"`
					echo "$abs_path" >> "${queue_path}"
				done
				;;
			* )
				echo "apollo queue edit"
				echo "apollo queue clear"
				echo "apollo queue add <path/to/your/music(s)>"
				;;
		esac
		;;
	* )
		echo "wrong command. try:"
		echo "apollo player"
		echo "apollo queue"
		;;
esac
