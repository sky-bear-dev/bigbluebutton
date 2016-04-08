class Player {
  constructor() {
    this.meetingId = null;
    this.initialSeek = 0;
    this.mediaPath = null;

    this.title = document.querySelector("#title");
    this.meetingName = this.title.textContent;

    /* Close-captioning related properties */
    /* The list of available text tracks */
    this.textTracks = [];
    /* The currently selected text track */
    this.textTrack = null;

    /* Internal state of the media check */
    this._mediaHasVideo = null;
  }

  /* Initialize the player and start loading media.
   *
   * Returns a promise that resolves when the player is ready to use and
   * visible. */
  load() {
    this.parseArgs();
    this.mediaPath = `/presentation/${this.meetingId}`

    let meta = this.loadMetadata();
    let media = this.loadMedia();
    let slides = this.loadSlides();

    let title = meta.then(() => { this.updateTitle() });

    let p = Promise.all([meta, media, slides, title]);
    return p.then(() => { this.displayRecording() });
  }

  /* Parse the URL query string.
   * 
   * Sets instance variables based on the query string variables,
   * and verify that a meetingId (actually recording ID) was provided.
   */
  parseArgs() {
    let map = {};
    window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, (_, key, value) => {
      map[key] = value;
    });
    if (map["meetingId"]) {
      this.meetingId = map["meetingId"];
    }
    if (map["t"]) {
      this.initialSeek = this.parseTime(map["t"]);
    }
    if (!this.meetingId) {
      throw new Error("No recording ID was provided.");
    }
  }

  /* Load the recording metadata.
   *
   * Sets various variables based on information read from the meeting
   * metadata.xml; in particular, the meetingName.
   *
   * Returns a Promise that resolves once the variables are set.
   */
  loadMetadata() {
    return new Promise((resolve, reject) => {
      let req = new XMLHttpRequest();
      req.open("GET", `${this.mediaPath}/metadata.xml`);

      req.onreadystatechange = () => {
        if (req.readyState != 4) {
          return;
        }
        if (req.status != 200) {
          reject(new Error(`Failed to fetch recording metadata: ${req.status} ${req.statusText}`))
          return;
        }

        let doc = req.responseXML;
        if (!doc) {
          let parser = new DOMParser();
          doc = parser.parseFromString(req.responseText, "text/xml");
        }

        if (!doc) {
          reject(new Error("Failed to fetch recording metadata: Could not read XML document"));
          return;
        }

        let meetingName = doc.querySelector("meta > meetingName");
        if (meetingName) {
          this.meetingName = meetingName.textContent;
        }

        resolve();
      };

      req.send();
    });
  }

  /* Load the recording media.
   *
   * This function is responsible for checking whether the recording has video,
   * audio, and caption tracks, and creates the media element appropriately.
   *
   * Returns a Promise that resolves once the media element has been created
   * and inserted into the document.
   */
  loadMedia() {
    let haveVideo = this.checkMediaHasVideo();
    let captionInfo = this.loadCaptionInfo();

    return Promise.all([haveVideo, captionInfo]).then((l) => {
      let haveVideo = l[0];
      let captionInfo = l[1];

      let media = null;
      if (haveVideo) {
        media = document.createElement("video");
      } else {
        media = document.createElement("audio");
      }
      this.media = media;

      /* We expect the user to start playing this recording, since it's kind of
       * the entire point of the page. So set the preload hint. */
      media.setAttribute("preload", "auto");

      if (haveVideo) {
        let webmsource = document.createElement("source");
        webmsource.setAttribute("src", `${this.mediaPath}/video/webcams.webm`);
        webmsource.setAttribute("type", 'video/webm; codecs="vp8.0, vorbis"');
        media.appendChild(webmsource);
      } else {
        let webmsource = document.createElement("source");
        webmsource.setAttribute("src", `${this.mediaPath}/audio/audio.webm`);
        webmsource.setAttribute("type", 'audio/webm; codecs="vorbis"');

        let oggsource = document.createElement("source");
        oggsource.setAttribute("src", `${this.mediaPath}/audio/audio.ogg`);
        oggsource.setAttribute("type", 'audio/ogg; codecs="vorbis"');

        /* Browser Bug workaround: The ogg file should be preferred in Firefox,
         * since it has problems seeking in audio-only webm files. */
        if (navigator.userAgent.indexOf("Firefox") != -1) {
          media.appendChild(oggsource);
          media.appendChild(webmsource);
        } else {
          media.appendChild(webmsource);
          media.appendChild(oggsource);
        }
      }

      if (captionInfo.length > 0) {
        /* Add the caption tracks to the video element, if supported. */
        if (typeof(media.textTracks) === "undefined") {
          /* TODO: show a warning message here? */
          console.log("Browser does not support textTracks, captions won't be shown");
          this.textTracks = [];
        } else {
          for (let caption of captionInfo) {
            let track = document.createElement("track");
            track.setAttribute("src", `${this.mediaPath}/caption_${caption.locale}.vtt`);
            track.setAttribute("srclang", caption.locale.replace("_", "-"));
            track.setAttribute("label", caption.localeName);
            track.setAttribute("kind", "captions");
            media.appendChild(track);
          }
          this.textTracks = this.media.textTracks;
        }
      }

      /* Insert into dom */
      let mediaContainer = document.querySelector("#video");
      mediaContainer.appendChild(media);

      if (haveVideo) {
        this.haveVideo = true;
        document.body.classList.add("video");
      }

      this.setupControls();
    });
  }

  /* Check whether this recording has video or is audio only.
   * Returns a Promise resolving to either true (has video) or false (no video).
   */
  checkMediaHasVideo() {
    if (this._mediaHasVideo !== null) {
      return Promise.resolve(this._mediaHasVideo);
    } else {
      return new Promise((resolve, reject) => {
        let req = new XMLHttpRequest();
        req.open("HEAD", `${this.mediaPath}/video/webcams.webm`);
        req.onreadystatechange = () => {
          if (req.readyState != 4) {
            return;
          }
          if (req.status == 200) {
            this._mediaHasVideo = true;
          } else {
            this._mediaHasVideo = false;
          }
          resolve(this._mediaHasVideo);
        };
        req.send();
      });
    }
  }

  /* Read the captions.json file to find out whether captions are available,
   * and what their names & language codes are.
   * Returns a Promise resolving to a list of captions
   */
  loadCaptionInfo() {
    return new Promise((resolve, reject) => {
      let req = new XMLHttpRequest();
      req.open("GET", `${this.mediaPath}/captions.json`);
      req.onreadystatechange = () => {
        if (req.readyState != 4) {
          return;
        }
        if (req.status != 200) {
          /* captions.json can't be loaded, return an empty list. */
          resolve([]);
          return;
        }
        resolve(JSON.parse(req.responseText));
      };
      req.send();
    });
  }

  /* Create the media controls (play/pause button, position slider, etc.) */
  setupControls() {
    let container = document.getElementById("controls");

    this.setupPlayPauseBtn(container);
  }

  /* Create the play/pause button */
  setupPlayPauseBtn(container) {
    let div = document.createElement("div");
    div.className = "button-wrap";

    let btn = document.createElement("button");
    this.playPauseBtn = btn;
    btn.id = "playpause-button";
    btn.setAttribute("aria-controls", this.media.id);
    btn.addEventListener("click", (e) => {
      this.playPauseBtnClick();
    });

    div.appendChild(btn);
    container.appendChild(div);

    this.updatePlayPauseBtn();
  }

  /* Update the play/pause button state */
  updatePlayPauseBtn() {
    let btn = this.playPauseBtn;
    let media = this.media;
    if (media.paused && !media.seeking) {
      btn.textContent = "Play";
    } else {
      btn.textContent = "Pause";
    }
  }

  /* Handle clicking the play/pause button */
  playPauseBtnClick() {
    let media = this.media;
    if (media.paused) {
      media.play();
    } else {
      media.pause();
    }
  }

  loadSlides() {
  }
  updateTitle() {
    this.title.textContent = this.meetingName;
  }
  displayRecording() {
    document.body.classList.remove("loading");
  }

  /* Parse a youtube-style time string, like "1h14m10s" */
  parseTime(str) {
    let time = 0;
    let extractValue = /\d+/g;
    let extractUnit = /\D+/g;
    while (true) {
      let valueResult = extractValue.exec(str);
      let unitResult = extractUnit.exec(str);
      if (valueResult == null || unitResult == null) {
        break;
      }

      let unit = unitResult[0].toLowerCase();
      let value = parseInt(valueResult[0]);

      if (unit == "h") {
        value *= 3600;
      } else if (unit == "m") {
        value *= 60;
      }

      time += value;
    }
    return time;
  }
}

function setup() {
  try {
    window.player = new Player();
    window.player.load();

  } catch (e) {
    var li = document.getElementById("loading-indicator");
    li.textContent = "" + e;
  }
}


if (document.readyState == "interactive" || document.readyState == "complete") {
  setup();
} else {
  document.onreadystatechange = function() {
    if (document.readyState == "interactive" || document.readyState == "complete") {
      setup();
      document.onreadystatechange = null;
    }
  }
}
