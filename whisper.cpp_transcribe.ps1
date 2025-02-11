# Prompt user for input folder
$inputFolder = Read-Host "Enter the path to the folder containing .m4v files"
# $outputFolder = "$inputFolder\transcripts"
$whisperPath = "E:\whisper.cpp\build\bin\Release\whisper-cli.exe"
$modelPath = "E:\whisper.cpp\models\ggml-large-v3.bin"


# Iterate over all .m4v files in the input folder
Get-ChildItem -Path $inputFolder -Filter "*.m4v" | ForEach-Object {
    $videoFile = $_.FullName
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
    $audioFile = "$inputFolder\$baseName.wav"
    $srtFile = "$inputFolder\$baseName.srt"

    Write-Host "Processing: $videoFile"

    # Extract audio using FFmpeg
    ffmpeg -i "$videoFile" -ar 16000 -ac 2 -c:a pcm_s16le "$audioFile"

    # Transcribe using Whisper.cpp
    & $whisperPath -m "$modelPath" -t 4 --max-context 0 -tr true --word-thold 0.5 --best-of 7 -l auto -et 2.8 -osrt -f "$audioFile" -of "$inputFolder\$baseName"

    # Optionally, remove the audio file after transcription
    Remove-Item "$audioFile"
}

Write-Host "Transcription completed for all videos."
