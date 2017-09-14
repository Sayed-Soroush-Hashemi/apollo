import os
import random

import settings


def play():
	while True:
		with open(settings.playlist_path, 'r') as playlist_file:
			playlist = playlist_file.readlines()
			next_track_ind = random.randint(0, len(playlist)-1)
			next_track_path = playlist[next_track_ind].strip()
		
		next_track_name = os.path.basename(next_track_path).split('.')[:-1]
		next_track_name = '.'.join(next_track_name)
		
		os.system('rm -rf {0}/*.wav'.format(settings.tmp_dir))
		os.system('ffmpeg -i "{0}" "{1}/{2}.wav"'.format(
			next_track_path, 
			settings.tmp_dir, 
			next_track_name
		))
		os.system('aplay "{0}/{1}.wav"'.format(
			settings.tmp_dir, 
			next_track_name
		))


def edit_playlist():
	os.system('nano {0}'.format(settings.playlist_path))


if __name__ == '__main__':
	edit_playlist()
	play()
