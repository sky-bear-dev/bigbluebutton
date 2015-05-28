/**
* BigBlueButton open source conferencing system - http://www.bigbluebutton.org/
*
* Copyright (c) 2012 BigBlueButton Inc. and by respective authors (see below).
*
* This program is free software; you can redistribute it and/or modify it under the
* terms of the GNU Lesser General Public License as published by the Free Software
* Foundation; either version 3.0 of the License, or (at your option) any later
* version.
*
* BigBlueButton is distributed in the hope that it will be useful, but WITHOUT ANY
* WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
* PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public License along
* with BigBlueButton; if not, see <http://www.gnu.org/licenses/>.
*
*/
package org.bigbluebutton.web.controllers

import grails.converters.*
import org.bigbluebutton.api.MeetingService
import org.bigbluebutton.api.Util
import org.bigbluebutton.api.domain.Meeting
import org.bigbluebutton.api.domain.UserSession
import org.bigbluebutton.presentation.UploadedPresentation
import org.bigbluebutton.web.services.PresentationService

class PresentationController {
  MeetingService meetingService
  PresentationService presentationService
  
  def index = {
    println 'in PresentationController index'
    render(view:'upload-file') 
  }
  
  def list = {						      				
    def f = confInfo()
    println "conference info ${f.conference} ${f.room}"
    def presentationsList = presentationService.listPresentations(f.conference, f.room)

    if (presentationsList) {
      withFormat {				
        xml {
          render(contentType:"text/xml") {
            conference(id:f.conference, room:f.room) {
              presentations {
                for (s in presentationsList) {
                  presentation(name:s)
                }
              }
            }
          }
        }
      }
    } else {
      render(view:'upload-file')
    }
  }

  def delete = {		
    def filename = params.presentation_name
    def f = confInfo()
    presentationService.deletePresentation(f.conference, f.room, filename)
    flash.message = "file ${filename} removed" 
    redirect( action:list )
  }

  def uploadPreflight = {
    log.info("PresentationController:uploadPreflight")

    boolean reject = false

    UserSession us = null
    Meeting meeting = null

    if (!session["user-token"]) {
      log.debug("Upload rejected: missing user-token in session")
      reject = true
    } else {
      us = meetingService.getUserSession(session["user-token"])
      if (us == null) {
        log.debug("Upload rejected: could not find session for user-token")
        reject = true
      } else {
        meeting = meetingService.getMeeting(us.meetingID)
        if (meeting == null || meeting.isForciblyEnded()) {
          log.debug("Upload rejected: meeting is not present or ended")
          reject = true
        }
      }
    }

    if (reject) {
      return render(status: 403, text: "Presentation upload not permitted")
    }

    return render(status: 200, text: "Presentation upload permitted")
  }

  def upload = {
    log.info("PresentationController:upload")

    boolean reject = false

    UserSession us = null
    Meeting meeting = null

    if (!session["user-token"]) {
      log.debug("Upload rejected: missing user-token in session")
      reject = true
    } else {
      us = meetingService.getUserSession(session["user-token"])
      if (us == null) {
        log.debug("Upload rejected: could not find session for user-token")
        reject = true
      } else {
        meeting = meetingService.getMeeting(us.meetingID)
        if (meeting == null || meeting.isForciblyEnded()) {
          log.debug("Upload rejected: meeting is not present or ended")
          reject = true
        }
      }
    }

    if (reject) {
      return render(status: 403, text: "Cannot upload presentation")
    }

    def file = request.getFile('fileUpload')
    if (!file || file.empty) {
      return render(status: 400, text: 'Presentation file cannot be empty')
    }

    def presFilename = file.getOriginalFilename()
    def filenameExt = Util.getFilenameExt(presFilename);
    String presentationDir = presentationService.getPresentationDir()
    def presId = Util.generatePresentationId(presFilename)
    File uploadDir = Util.createPresentationDirectory(meetingId, presentationDir, presId)
    if (uploadDir != null) {
      def newFilename = Util.createNewFilename(presId, filenameExt)
      def pres = new File(uploadDir.absolutePath + File.separatorChar + newFilename )
      file.transferTo(pres)

      def presentationBaseUrl = presentationService.presentationBaseUrl
      UploadedPresentation uploadedPres = new UploadedPresentation(meetingId, presId, presFilename, presentationBaseUrl);
      uploadedPres.setUploadedFile(pres);
      presentationService.processUploadedPresentation(uploadedPres)
    }
    return render(status: 202, text: "Presentation uploaded, now processing")
  }

  def testConversion = {
    presentationService.testConversionProcess();
  }

  //handle external presentation server 
  def delegate = {		
    println '\nPresentationController:delegate'
    
    def presentation_name = request.getParameter('presentation_name')
    def conference = request.getParameter('conference')
    def room = request.getParameter('room')
    def returnCode = request.getParameter('returnCode')
    def totalSlides = request.getParameter('totalSlides')
    def slidesCompleted = request.getParameter('slidesCompleted')
    
        presentationService.processDelegatedPresentation(conference, room, presentation_name, returnCode, totalSlides, slidesCompleted)
    redirect( action:list)
  }
  
  def showSlide = {
    def presentationName = params.presentation_name
    def conf = params.conference
    def rm = params.room
    def slide = params.id
    
    InputStream is = null;
    try {
//			def f = confInfo()
      def pres = presentationService.showSlide(conf, rm, presentationName, slide)
      if (pres.exists()) {
        def bytes = pres.readBytes()
        response.addHeader("Cache-Control", "no-cache")
        response.contentType = 'application/x-shockwave-flash'
        response.outputStream << bytes;
      }	
    } catch (IOException e) {
      System.out.println("Error reading file.\n" + e.getMessage());
    }
    
    return null;
  }
  
  def showPngImage = {
	  def presentationName = params.presentation_name
	  def conf = params.conference
	  def rm = params.room
	  def slide = params.id
	  
	  InputStream is = null;
	  try {
  //			def f = confInfo()
		def pres = presentationService.showPngImage(conf, rm, presentationName, slide)
		if (pres.exists()) {
		  def bytes = pres.readBytes()
		  response.addHeader("Cache-Control", "no-cache")
		  response.contentType = 'image/png'
		  response.outputStream << bytes;
		}
	  } catch (IOException e) {
		System.out.println("Error reading file.\n" + e.getMessage());
	  }
	  
	  return null;
	}
  
  def showThumbnail = {
    
    def presentationName = params.presentation_name
    def conf = params.conference
    def rm = params.room
    def thumb = params.id
    println "Controller: Show thumbnails request for $presentationName $thumb"
    
    InputStream is = null;
    try {
      def pres = presentationService.showThumbnail(conf, rm, presentationName, thumb)
      if (pres.exists()) {
        println "Controller: Sending thumbnails reply for $presentationName $thumb"
        
        def bytes = pres.readBytes()
        response.addHeader("Cache-Control", "no-cache")
        response.contentType = 'image'
        response.outputStream << bytes;
      } else {
        println "$pres does not exist."
      }
    } catch (IOException e) {
      println("Error reading file.\n" + e.getMessage());
    }
    
    return null;
  }
  
  def showTextfile = {
	  def presentationName = params.presentation_name
	  def conf = params.conference
	  def rm = params.room
	  def textfile = params.id
	  log.debug "Controller: Show textfile request for $presentationName $textfile"
	  
	  InputStream is = null;
	  try {
		def pres = presentationService.showTextfile(conf, rm, presentationName, textfile)
		if (pres.exists()) {
		  log.debug "Controller: Sending textfiles reply for $presentationName $textfile"
		  
		  def bytes = pres.readBytes()
		  response.addHeader("Cache-Control", "no-cache")
		  response.contentType = 'plain/text'
		  response.outputStream << bytes;
		} else {
		  log.debug "$pres does not exist."
		}
	  } catch (IOException e) {
			log.error("Error reading file.\n" + e.getMessage());
	  }
	  
	  return null;
  }
  
  def show = {
    //def filename = params.id.replace('###', '.')
    def filename = params.presentation_name
    InputStream is = null;
    System.out.println("showing ${filename}")
    try {
      def f = confInfo()
      def pres = presentationService.showPresentation(f.conference, f.room, filename)
      if (pres.exists()) {
        System.out.println("Found ${filename}")
        def bytes = pres.readBytes()

        response.contentType = 'application/x-shockwave-flash'
        response.outputStream << bytes;
      }	
    } catch (IOException e) {
      System.out.println("Error reading file.\n" + e.getMessage());
    }
    
    return null;
  }
  
  def thumbnail = {
    def filename = params.id.replace('###', '.')
    System.out.println("showing ${filename} ${params.thumb}")
    def presDir = confDir() + File.separatorChar + filename
    try {
      def pres = presentationService.showThumbnail(presDir, params.thumb)
      if (pres.exists()) {
        def bytes = pres.readBytes()

        response.contentType = 'image'
        response.outputStream << bytes;
      }	
    } catch (IOException e) {
      System.out.println("Error reading file.\n" + e.getMessage());
    }
    
    return null;
  }

  def numberOfSlides = {
    def presentationName = params.presentation_name
    def conf = params.conference
    def rm = params.room
    
    def numThumbs = presentationService.numberOfThumbnails(conf, rm, presentationName)
      response.addHeader("Cache-Control", "no-cache")
      withFormat {						
        xml {
          render(contentType:"text/xml") {
            conference(id:conf, room:rm) {
              presentation(name:presentationName) {
                slides(count:numThumbs) {
                  for (def i = 1; i <= numThumbs; i++) {
                    slide(number:"${i}", name:"slide/${i}", thumb:"thumbnail/${i}", textfile:"textfile/${i}")
                  }
                }
              }
            }
          }
        }
      }		
  }
    
  def numberOfThumbnails = {
    def filename = params.presentation_name
    def f = confInfo()
    def numThumbs = presentationService.numberOfThumbnails(f.conference, f.room, filename)
      withFormat {				
        xml {
          render(contentType:"text/xml") {
            conference(id:f.conference, room:f.room) {
              presentation(name:filename) {
                thumbnails(count:numThumbs) {
                  for (def i=0;i<numThumbs;i++) {
                      thumb(name:"thumbnails/${i}")
                    }
                }
              }
            }
          }
        }
      }		
  }

  def numberOfPngs = {
    def filename = params.presentation_name
    def f = confInfo()
    def numPngs = presentationService.numberOfPngs(f.conference, f.room, filename)
      withFormat {
        xml {
          render(contentType:"text/xml") {
            conference(id:f.conference, room:f.room) {
              presentation(name:filename) {
                pngs(count:numPngs) {
                  for (def i=0;i<numPngs;i++) {
                      png(name:"pngs/${i}")
                    }
                }
              }
            }
          }
        }
      }
  }

  def numberOfTextfiles = {
	  def filename = params.presentation_name
	  def f = confInfo()
	  def numFiles = presentationService.numberOfTextfiles(f.conference, f.room, filename)
		withFormat {
		  xml {
			render(contentType:"text/xml") {
			  conference(id:f.conference, room:f.room) {
				presentation(name:filename) {
				  textfiles(count:numFiles) {
					for (def i=0;i<numFiles;i++) {
						textfile(name:"textfiles/${i}")
					  }
				  }
				}
			  }
			}
		  }
		}
	}
  
  def confInfo = {
//    	Subject currentUser = SecurityUtils.getSubject() 
//		Session session = currentUser.getSession()

      def fname = session["fullname"]
      def rl = session["role"]
      def conf = session["conference"]
      def rm = session["room"]
      println "Conference info: ${conf} ${rm}"
    return [conference:conf, room:rm]
  }
}

