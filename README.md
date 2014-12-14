live-audio-splitter
===================

Shell script to create audio files from line-in, compressed in mp3 or ogg with configurable quality, size and duration.

Usage:  ./linein-splitter [TIME] [FILE TYPE]
  TIME: Time for each record in milisseconds
  FILE TYPE: use --ogg for oggVorbis and --mp3 for mp3 files
To kill all instances: ./linein-splitter --kill
Edit the linein-splitter file and change 'default config' to change other options

To use this script you will need to install vorbis-tools, sox and lame:
sox to record sound, lame to compress to mp3 file type and vorbis-tools to compress to ogg.
sudo apt-get install vorbis-tools sox lame

This shell script captures sound from line in or mic, write this to a wav file and converts to mp3 or ogg. Once finished, it calls itself again to continue.
Attention: The terminal can be blocked by this script and ctrl+c won't work, in this case you must open another terminal and execute this program with --kill parameter. This parameter will kill all instances



