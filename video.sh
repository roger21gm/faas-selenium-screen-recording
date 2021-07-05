#!/bin/sh

VIDEO_SIZE=${VIDEO_SIZE:-"1360x1020"}
FILE_NAME=${1:-"video.mp4"}
FRAME_RATE=${FRAME_RATE:-"15"}
CODEC=${CODEC:-"libx264"}
PRESET=${PRESET:-"-preset ultrafast"}

return_code=1
max_attempts=50
attempts=0
echo 'Checking if the display is open...'
until [ $return_code -eq 0 -o $attempts -eq $max_attempts ]; do
	xset -display 127.0.0.1:99 b off > /dev/null 2>&1
	return_code=$?
	if [ $return_code -ne 0 ]; then
		echo 'Waiting before next display check...'
		sleep 0.5
	fi
	attempts=$((attempts+1))
done

# exec replaces the video.sh process with ffmpeg, this makes easier to pass the process termination signal
exec ffmpeg -y -f x11grab -video_size ${VIDEO_SIZE} -r ${FRAME_RATE} -i 127.0.0.1:99.0 -codec:v ${CODEC} ${PRESET} -pix_fmt yuv420p "/videos/$FILE_NAME"
