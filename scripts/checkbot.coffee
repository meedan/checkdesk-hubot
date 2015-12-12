#
#   Description:
#     Newsbot intelligence. Sends a link to the Checkdesk memebuster.
#
#   Configuration:
#     None
#
#   Commands:
#     memebuster [link to .jpg or .gif]
#       opens a new link in the memebuster with the specified image as the background image
#
#   Notes:
#     TODO: Optionally you can also pass a headline.
#
#     TODO: The credit is always set in environment variables that live in the hubot. (maybe?)
#
#     TODO: If you don't have the link you can invoke memebuster without a link like this:
#
#       @rex memebuster
#         "ok what kind of link are you debunking? [reply image or tweet]"
#       @rex image
#         "ok do you have a link to the image? "
#         "I'm sorry the link has to be hosted online. Tweet it and give me the link to your Tweet?"
#
#     TODO: In the initial pass, source order of the paramaters is unfortunate ... Possibly the syntax could look like this:
#       Eg: @rex memebuster image:"http://path/to/image.jpg" headline:"hell no" stamp:"false" credit:"Andy"
#
#     TODO: Support checkdesk links
#
#     If you see a report like:
#       "https://bellingcat.checkdesk.org/en/report/971"
#
#     Get the image of the media, eg, the video:
#       "ytp-cued-thumbnail-overlay"
#
#     Then get the status:
#       ".status-name"
#
#   Author:
#    Meedan, Chris Blow

memebusterUrl = "http://memebuster.checkdesk.org"
fallbackStatement = "Try uploading an image at #{memebusterUrl}"

cheerio = require('cheerio')

module.exports = (robot) ->
  robot.respond /(memebuster|mb|checkdesk) (http.*?)/i, (msg) ->
    link = msg.match[2]
    msg.send "starting ..."

    if /facebook.com/.test(link)
      msg.send "I don't support facebook yet ..."
      msg.send "Try uploading an image at #{memebusterUrl}"
      return
    if /twitter.com/.test(link)
      # Get the tweet and scrape the image(s)
      msg.send "That looks like a twitter link ..."
      robot.http(link).get() (err, res, body) ->
        $ = cheerio.load(body)
        msg.send "loaded #{link} ..."
        # Get the first image
        msg.send "I'm going to get the image ..."
        imageMarkup = $('.AdaptiveMedia-photoContainer img')
        if imageMarkup
          imageURL = imageMarkup[0].attribs.src
          msg.send "http://localhost:4567?image=#{imageURL}"
        else
          msg.send "I didn't find any images"
          msg.send "Try uploading one at #{memebusterUrl}"
    else
      msg.send "I didn't see any links I understood"
      msg.send fallbackStatement

  robot.error (err, res) ->
    robot.logger.error "Sorry, I didn't understand #{robot.name}"
    res.send "I'm confused"
    msg.send "Try uploading an image at #{memebusterUrl}"
