# Subtitles

Subtitle files (.ASS) for videos.

- Use Aegisub to create subtitles: https://aegisub.org/
- Embed any fonts need by going to File -> Attachments and attaching each font you need. This makes display consistent cross-platform.
- Embed subtitles into video using FFMPEG: `ffmpeg -i stressPicoCutscene.mp4 -i stressPicoCutscene.ass  -map 0:v -map 0:a -map 1 -c:v copy -c:a copy -c:s ass -metadata:s:s:0 language=eng stressPicoCutscene_output.mkv`
  - MUST use MKV because the MP4 container doesn't support advanced subtitles?
