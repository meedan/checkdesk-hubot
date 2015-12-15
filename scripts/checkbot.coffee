#
#   Description:
#     Newsbot intelligence. Sends a link to the Checkdesk memebuster. The purpose of this script is to integrate http://memebuster.checkdesk.org. Add a social media link and get a new link back to a pre-configured membuster page. Part of a larger network of newsbots and workbench web-services.
#
#   The bot will attempt to:
#     • Tell you if it supports the given network (eg twitter, facebook)
#     • Try to find images in the Tweet
#     • Give clear errors and notices throughout the process
#     • Give basic help when asked
#
#   Configuration:
#     None
#
#   Commands:
#     The syntax is `memebuster [link]` like this:
#
#     @botname memebuster http://twitter.com/example/1234
#
#   Notes:
#     TODO: memebuster [link to .jpg or .gif]
#       opens a new link in the memebuster with the specified image as the background image
#
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
#     TODO: Support more than one parameter. But source order of the paramaters is difficult to use. ... Possibly the syntax could look like this:
#
#       Eg: @rex memebuster image:"http://path/to/image.jpg" headline:"hell no" stamp:"false" credit:"Andy"
#
#     TODO: Support checkdesk links
#
#     If you see a report like:
#       "https://bellingcat.checkdesk.org/en/report/971"
#
#     Get the image of the media, eg, the video in the media object:
#       "ytp-cued-thumbnail-overlay"
#
#     Then get the status from the report:
#       ".status-name"
#
#   Author:
#    Meedan, Chris Blow

memebusterUrl = "http://memebuster.checkdesk.org"
fallbackStatement = "Try uploading an image at #{memebusterUrl}"

cheerio = require('cheerio')

module.exports = (robot) ->

  robot.respond /(memebuster|mb|checkdesk help)/, (msg) ->
    msg.send "For help call 415 309 7900"
    msg.send fallbackStatement

  robot.respond /(memebuster|mb|checkdesk) (http.*)/i, (msg) ->
    link = msg.match[2]
    msg.send "starting with #{link}..."

    if /facebook.com/.test(link)
      msg.send "I don't support facebook yet ..."
      msg.send fallbackStatement
    else if /twitter.com/.test(link)
      # Get the tweet and scrape the image(s)
      msg.send "That looks like a twitter link ..."
      robot.http(link).get() (err, res, body) ->
        $ = cheerio.load(body)
        msg.send "loaded #{link} ..."
        # Get the first image
        msg.send "I'm going to get the image and add it to memebuster ..."
        imagesInTweet = $('.AdaptiveMedia-photoContainer img')
        msg.send "I found #{imagesInTweet.length} image#{if imagesInTweet.length > 1 then 's' else ''}"
        if imagesInTweet
          imageURL = imagesInTweet[0].attribs.src
          msg.send "http://localhost:4567?image=#{imageURL}"
        else
          msg.send "I didn't find any images"
          msg.send fallbackStatement
    else
      msg.send "I didn't see any links I understood"
      msg.send fallbackStatement

  robot.error (err, res) ->
    robot.logger.error "Sorry, I didn't understand"
    res.send "I'm confused"
    msg.send fallbackStatement
