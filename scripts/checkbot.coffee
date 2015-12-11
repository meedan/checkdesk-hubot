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
#     TODO: The credit is always set in environment variables that live in the hubot.
#
#     TODO: If you don't have the link you can go through an interactive dialog like this:
#     (Invoke memebuster without a link)
#       @rex memebuster
#         "ok what kind of link are you debunking? [reply image or tweet]"
#       @rex image
#         "ok do you have a link to the image? "
#         "I'm sorry the link has to be hosted online. Tweet it and give me the link to your Tweet?"
#
#   TODO: In the initial pass, source order of the paramaters is unfortunate ... Possibly the syntax could look like this to avoid this:
#       Eg: @rex memebuster image:"http://path/to/image.jpg" headline:"hell no" stamp:"false" credit:"Andy"
#
#   Author:
#    Meedan, Chris Blow

cheerio = require('cheerio')
base64 = require('node-base64-image');

# # Indicate that you are defining a script
# module.exports = (robot) ->
#   # Define your regular expressions to match
#   robot.respond /memebuster (.*)/i, (msg) ->
#     # Get the query and form the search url
#     link = msg.match[1]

module.exports = (robot) ->
  robot.respond /memebuster (.*)/i, (res) ->
    link = res.match[1]

    # Get the tweet and scrape the image(s)
    robot.http(link).get() (err, res, body) ->
      $ = cheerio.load(body)
      imageMarkup = $('.AdaptiveMedia-photoContainer img')
      imagePath = imageMarkup[0].attribs.src
      # TODO: handle more than one image in a tweet

      b64options = {string: true}
      # Encode the image so we can send it in the url
      base64.base64encoder imagePath, b64options, (err, imagePath) ->
        if err
          console.log(err)
          return

        console.log(imagePath)
