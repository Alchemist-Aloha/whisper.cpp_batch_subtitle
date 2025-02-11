# Setup Guide

Powershell script to batch transcribe videos with `ffmpeg` and `whisper.cpp`. 

## 1. Install `ffmpeg` and add ffmpeg directory to environment variables

## 2. Build `whisper.cpp` based on your hardware setting. Download the model needed.  
https://github.com/ggerganov/whisper.cpp/tree/master

Change `$whisperPath` and `$modelPath` as needed in `whisper.cpp_transcribe.ps1`.
	
## 3. Run `whisper.cpp_transcribe.ps1` and type in the directory of your video folder.
