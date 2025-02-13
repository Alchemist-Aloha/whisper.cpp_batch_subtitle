# Infinite loop to repeatedly process folders until the user manually exits (e.g., with Ctrl+C)
while ($true) {

    # Prompt user for input folder
    $inputFolder = Read-Host "Enter the path to the folder containing .m4v files"
    
    # Verify that the provided folder path exists
    if (-not (Test-Path $inputFolder)) {
        Write-Host "The folder '$inputFolder' does not exist. Please enter a valid folder path."
        continue  # Return to the beginning of the loop to prompt again
    }
    
    # Define the paths for Whisper CLI and the model file.
    $whisperPath = "E:\whisper.cpp\build\bin\Release\whisper-cli.exe"
    # $modelPath   = "E:\whisper.cpp\models\ggml-large-v3-turbo.bin"
    $modelPath   = "E:\whisper.cpp\models\ggml-large-v3.bin"
    # $modelPath   = "E:\whisper.cpp\models\ggml-medium.bin"
    $prompt = ""
    
    # Iterate over all .m4v files in the input folder
    Get-ChildItem -Path $inputFolder -Filter "*.m4v" | ForEach-Object {
        # Retrieve the full path of the video file
        $videoFile = $_.FullName
        
        # Generate a base name (without extension) for output files
        $baseName = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
        
        # Define the paths for the temporary audio file and the subtitle file
        $audioFile = Join-Path -Path $inputFolder -ChildPath "$baseName.wav"
        $srtFile   = Join-Path -Path $inputFolder -ChildPath "$baseName.srt"
    
        Write-Host "Processing: $videoFile"
    
        # Extract audio from the video file using FFmpeg.
        # This command converts the audio to a 16 kHz sample rate with 2 channels (stereo)
        ffmpeg -i "$videoFile"  -af "highpass=200,lowpass=3000,afftdn,dialoguenhance" -ar 16000 -ac 2 -c:a pcm_s16le "$audioFile"
    
        # Transcribe the audio file using Whisper.cpp.
        # The following options configure the number of threads (-t 4), disable context (--max-context 0),
        # enable transcript output (-tr true), set no speech threshold (--no-speech-thold 0.3),
        # set the word threshold (--word-thold 0.5), choose best-of 5,
        # automatically detect language (-l auto), set an endpoint threshold (-et 2.8), and generate an SRT file (-osrt).
        # The output file prefix is specified with -of.
        & $whisperPath -m "$modelPath" -t 4 --max-context 0 -tr true --no-speech-thold 0.1 --word-thold 0.5 --best-of 5 -l auto -et 2.8 -osrt --prompt "$prompt" -f "$audioFile" -of "$inputFolder\$baseName"
    
        # Optionally, remove the temporary audio file after transcription is complete.
        Remove-Item "$audioFile"
    }
    
    Write-Host "Transcription completed for all videos in '$inputFolder'."
    
    # Optionally, pause the script before processing a new folder.
    Write-Host "Press any key to process another folder, or Ctrl+C to exit..."
    [void][System.Console]::ReadKey($true)
}
