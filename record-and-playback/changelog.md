## Record and Playback changelog ##

### April 29, 2013 ###

- Archive phase writes to log files by meeting.

### December 29, 2023 ###

- bigbluebutton\record-and-playback\video\scripts\video.yml

  layout:
      width: 1280
      height: 720
      framerate: 24
      areas:
        - name: presentation
          x: 0
          y: 0
          width: 1280
          height: 720
        - name: webcam
          x: 0
          y: 0
          width: 1280
          height: 720    
        - name: deskshare
          x: 0
          y: 0
          width: 1280
          height: 720    
          pad: true      
        - name: webcam
          x: 960
          y: 500
          width: 270
          height: 200

  Using this layout, if both the screen and webcam are shared even once during the recording process, a video with the screen and webcam overlapping is created. This is good.
  However, if I disable screen sharing, the webcam layout (full screen) and webcam layout (small) are displayed in the recorded video.
  In this case I don't want to present a small webcam layout.
  I have already sent you a message regarding this to your mail (calvin.walton@kepstin.ca).
  If my message has been save to spam, please check and resolve this issue.

  Warm regards.
  Roman
  
