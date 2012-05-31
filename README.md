Downloud
========

# What?

It's like http://www.fatdrop.co.uk/ but simpler. You setup your own instance with music releases. Each release has it's own page with embedded soundcloud players. When users leave their name, email address and a comment they can download a file (usually the full release). This is usually used by labels to send promotional copies to DJs. Have a look at a demo deployment here http://downloud.heroku.com/odd001josht

# Installation

In order to set this up you will have to deploy your own instance of the Sinatra app on Heroku. If you can't figure out what this means you should either use Fatdrop or drop me a mail at downloud@freenerd.de

### install rvm and ruby

```
curl -L get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install 1.9.2
```

### checkout and initialize the repo

```
git clone git@github.com:freenerd/downloud.git
cd downloud
echo 'rvm ruby-1.9.2@downloud --create' > .rvmrc
cd ../downloud
gem install bundler
bundle install
```

### run

```
rackup
```

if you want to develop locally shotgun might be your friend

```
gem install shotgun
shotgun
```

### Pre-deploy

 * Get an account at http://www.heroku.com
 * Install the heroku toolbelt https://toolbelt.heroku.com/

### Deploy

```
cd downloud
heroku login
heroku create --stack cedar
heroku addons:add sendgrid:starter
git push heroku master
```

# Configuration

Downloud has no database. All releases and assets are 'in code' and must be commited to the code base in order to be pushed to Heroku.

## First-run conf

Open ```downloud.rb``` and change the defaults.

 * ```email_to``` if no other email specified in the release the feedback will be sent to this address
 * ```email_from``` feedback email will be sent from this address
 * ```banner``` if no other banner is specified for the release this one is used. The banner is in ```/public/img/banners/default.png```. Please make sure that the banner is 300px by 300px

## Putting in a new release

Open ```releases.yml``` and copy/paste/change one of the releases there

  * the `key of the release` is at the same time is the permalink that the release will be reachable at. Please only use lower case ascii characters and numbers
  * in ```tracks``` are the tracks that will be available for streaming. Put in the URLs. If your tracks are private, put in the secret URLs with the secret token in the end (like /s-1273)
  * ```download``` is the URL to the file that will be downloadable once feedback is submitted. You can put in a public link to a file on Dropbox for example
  * ```email``` the email the feedback will be sent to. If no email specified the default email will be used

If you want to put in a different banner for the release, go to ```/public/img/banners/{the release name}.png```. The release name is the key of your release as you put in in in ```releases.yml```. Please make sure that the banner is 300px by 300px

Commit everything:

```
git add public
git commit -a
```

Deploy:

```
git push heroku master
```

Done, go check in your browser

# Limitations

This app can be deployed for free on Heroku, but with the free plan you will only be able to receive 200 feedback emails a day. Also the link to the download is not secured in any way. People will be able to share the download link you specified.

# License

Copyright (c) 2012 Johan Uhle

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
