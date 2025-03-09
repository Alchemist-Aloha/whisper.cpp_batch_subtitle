# Setup Guide

2025-03-09 This script has been rewritten in python in [explicit_util](https://github.com/Alchemist-Aloha/explicit_util). The python code utilizes asyncio which should perform better than this script.

Powershell script to batch transcribe videos with `ffmpeg` and `whisper.cpp`.

## 1. Install `ffmpeg` and add ffmpeg directory to environment variables

<https://www.ffmpeg.org/download.html>

## 2. Build `whisper.cpp` based on your hardware setting. Download the model needed  

<https://github.com/ggerganov/whisper.cpp/tree/master>

Modify `$whisperPath` and `$modelPath` as needed in `whisper.cpp_transcribe.ps1`.

## 3. Modify cli arguments as needed

<https://github.com/ggerganov/whisper.cpp/tree/master/examples/cli>

## 4. Run `whisper.cpp_transcribe.ps1` and type in the directory of your video folder
