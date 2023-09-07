wget -v https://filesamples.com/samples/video/webm/sample_1920x1080.webm -O input.webm
ffmpeg -i input.webm -c:v mjpeg output.mp4
file output.mp4

