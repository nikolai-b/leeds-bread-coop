print 'compost.py 0.4 - green action email scraper'
print 'pete.shadbolt@gmail.com\nnikolai.berkoff@gmail.com'

print '\n\
This program is free software: you can redistribute it and/or modify\n\
it under the terms of the GNU General Public License as published by\n\
the Free Software Foundation, either version 3 of the License, or\n\
(at your option) any later version.\n\
\n\
This program is distributed in the hope that it will be useful,\n\
but WITHOUT ANY WARRANTY; without even the implied warranty of\n\
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n\
GNU General Public License for more details.\n\
\n\
You should have received a copy of the GNU General Public License\n\
along with this program.  If not, see <http://www.gnu.org/licenses/>.\n\
'


import urllib2
import re
import time, datetime
import sys
from datetime import date
#from  smtplib import SMTP
import smtplib
from datetime import datetime
from dateutil import tz

#def unique(s):
#    n = len(s)
#    if n == 0:
#        return []
#    u = []
#    for x in s:
#        if x not in u:
#            u.append(x)
#    return u


def createhtmlmail (html, subject):
      	"""Create a mime-message that will render HTML in popular
	   MUAs, text in better ones"""
	import MimeWriter
	import mimetools
	import cStringIO

	out = cStringIO.StringIO() # output buffer for our message
	htmlin = cStringIO.StringIO(html)

	writer = MimeWriter.MimeWriter(out)
	#
	# set up some basic headers... we put subject here
	# because smtplib.sendmail expects it to be in the
	# message body
	#
	writer.addheader("Subject", subject)
	writer.addheader("MIME-Version", "1.0")
	#
	# start the multipart section of the message
	# multipart/alternative seems to work better
	# on some MUAs than multipart/mixed
	#
	writer.startmultipartbody("alternative")
	writer.flushheaders()
	#
	# start the html subpart of the message
	#
	subpart = writer.nextpart()
	subpart.addheader("Content-Transfer-Encoding", "quoted-printable")
	#
	# returns us a file-ish object we can write to
	#
	pout = subpart.startbody("text/html", [("charset", 'uk-ascii')])
	mimetools.encode(htmlin, pout, 'quoted-printable')
	htmlin.close()
	#
	# Now that we're done, close our writer and
	# return the message body
	#
	writer.lastpart()
	msg = out.getvalue()
	out.close()

	return msg

def sendmail(message):
	"""sends an email using smtplib"""
	print 'sending mail...'
	try:
#		s = smtplib.SMTP("smtp.gmail.com", 587)
#		s = smtplib.SMTP_SSL('smtps.leeds.ac.uk',465)
		s = smtplib.SMTP_SSL("interceptor.websitewelcome.com", 465)
		s.set_debuglevel(1)

		AUTHREQUIRED = 1 # if you need to use SMTP AUTH set to 1
		smtpuser = "webmaster@greenactionleeds.org.uk"# 'unigreen'
		smtppass = 'BombayMix!' #'sbfcmlm2'
           #     s.ehlo()
           #     s.starttls()
           #     s.ehlo()

                s.login(smtpuser, smtppass)

                messageHTML = createhtmlmail(message, 'Upcoming Events')
                s.sendmail('webmaster@greenactionleeds.org.uk', 'nikolai.berkoff@gmail.com', messageHTML) # from , to
		s.close()
		print 'done.'
	except Exception, exc:
        	sys.exit( "mail failed; %s" % str(exc) )
		print 'hello nikolai, i think there is probably a problem with smtp email sending.'
		print 'you might need to change the server address in the script'
		f = open('message.html', 'w')
		f.write(message)
		f.close()

def notags(value):
	""" strips xml tags from a string """
	return re.sub(r'<[^>]*?>', '', value)

def gethtml(url):
	""" returns the html at a given url as a string """
	print 'fetching %s ...' % url
	response=urllib2.urlopen(url)
	html=response.read()
	print 'done.'
	return html

def getposts(html):
	""" searches for all posts on the page. returns a list of strings """
	x,y=0,0
	output=[]
	while x!=-1:
		x=homepage.find('<item>',y)
		y=homepage.find('</item>',x+1)
		output.append(homepage[x:y])
	return output[:-1] #chop off the last one, it's useless

def gettitle(post):
	""" gets the title of a post """
	tag='<title>'
	x=post.find(tag)+len(tag)
	tag='</title>'
	y=post.find(tag, x)
	print 'gettitle=%s' % notags(post[x:y])
	return  notags(post[x:y])

def geturl(post):
	""" gets the url of a post """
	tag='<link>'
	x=post.find(tag)+len(tag)	#get into the vicinity
	y=post.find('</link>', x+1)
	#print 'geturl=http://www.greenactionleeds.org.uk%s' % post[x+1:y-1]
	return 'http://www.greenactionleeds.org.uk%s' % post[x:y]

def getdate(post):
	""" gets the date of a post """
	tag='pubDate>'
	x=post.find(tag)+len(tag)
	tag='(All day)'
	y=post.find(tag,x)
	#take the fourth line and strip it
#	print 'getdate=%s' % post[x:y].replace('<span class="date-display-start">', '')
	if y!=-1: return (post[x:y-1]+"T00:00").replace('<span class="date-display-start">', '').strip()
	y=post.find(':',x)+3
        tag='</pubDate>'
        y=post.find(tag,x)
	print 'getdate=%s' % post[y-19:y]
	return post[y-19:y]

def getlocation(post):
	""" gets the location of a post """
        tag='category>'
	x=post.find(tag)
	if x==-1:
		print 'getlocation=  "Unknown"'
		return (" Unknown ")
	x=x+len(tag)
        tag='</category'
	y=post.find(tag,x)
	print 'getlocation=%s' % post[x:y]
	return post[x:y]

def getsubmitted(post):
	""" gets the date when a post was submitted """
	tag='<span class="submitted">'
	x=post.find(tag)+len(tag)
	x=post.find(' on ',x)+4
	y=post.find('</span>',x)
#	print 'getsubmitted=%s' % post[x:y].strip()
	return post[x:y].strip()

def getcontent(post):
	""" gets the body text of a post """
	cpost=gethtml(geturl(post))

	tag='<div class="article-content">'
	x=cpost.find(tag)
	#find the closing div

	y=cpost.find('<table id="attachments"',x)
	if y!=-1: return cpost[x:y]
	y=cpost.find('<section class=',x)
	return cpost[x:y]

def ddmmyy(s):
	""" extracts a ddmmyy-type date from somewhere in a string """
	p = re.compile(r"\d+/\d+/\d+")
	s=p.search(s)
	if s==None: return ''
	return s.group()

class item:
	""" class used to store items so we can conveniently sort the list """
	def __init__(self,post):
		self.title=gettitle(post)
		self.date=getdate(post)
		self.location=getlocation(post)
		self.url=geturl(post)
#		self.submitted=getsubmitted(post)
		self.content=getcontent(post)

		#calculate this post's age in days
		from_zone =tz.gettz('GMT')
		to_zone = tz.gettz('Europe/London')
		gmt = datetime.strptime(self.date, '%Y-%m-%dT%H:%M:%S')
		gmt= gmt.replace(tzinfo=from_zone)
		self.date= gmt.astimezone(to_zone)
		now_epoch=time.mktime(time.localtime())
		event_epoch=time.mktime(time.strptime(self.date.strftime('%Y-%m-%d %H:%M:%S'), '%Y-%m-%d %H:%M:%S'))
		self.age=(event_epoch-now_epoch)/(60.*60.*24.)
		#calculate a sort date, expressed in epoch seconds  2011-09-25T12:00
#		if self.date=='None specified':
#			self.sortdate=time.mktime(time.strptime(self.submitted, '%a, %d/%m/%Y - %H:%M'))
#		else:

		print 'ddd=%s' % self.date
		self.sortdate=time.mktime(time.strptime(self.date.strftime('%Y-%m-%d %H:%M:%S'), '%Y-%m-%d %H:%M:%S'))
		self.dateT=time.strptime(self.date.strftime('%Y-%m-%d %H:%M:%S'), '%Y-%m-%d %H:%M:%S')

	def __cmp__(self, other):	#lets us write items.sort()
		return other.sortdate-self.sortdate


#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#pull down and parse the last few pages from greenactionleeds.org.uk
items=[]
homepage=gethtml('http://www.greenactionleeds.org.uk/calendar/rss.xml')
for p in getposts(homepage): items.append(item(p))

#sort them
items.sort()
items.reverse()

#format the email
message='\
<p>Hi Richard,</p>\
<p>Here is the automated event list.  This is being sent to you and should be checked before being sent out to the greenaction list.</p>\
<p>Cheers,</p>\
<p>Nikolai</p>\
<p>x</p>\
<p>To UNSUBSCRIBE from your email list send an email to</p>\n\
<p><a href="mailto:greenaction-unsubscribe@lists.riseup.net" target="_blank">greenaction-unsubscribe@lists.riseup.net</a></p>\n\
<p>To post here add your event to our <a href="http://www.greenactionleeds.org.uk" target="_blank">website</a>.  Please post events early so they can appear here.&nbsp; Here is a digest of what is happening this week with a few beyond (might not actually be all events). </p>\n\
<br />\n\
<u>SUMMARY</u><br />\n\
'
format='\n<b>%s - <a href="%s" target="_blank">%s</a> @ %s </b>\n<br /><br />\n'

for i in items:
	if i.age<40: message+=format % (time.strftime("%a %d %b - %H:%M",i.dateT),i.url,i.title,i.location)

format='\
\n\
***********************\n\n\
<br /><br />\n\
<b>%s - <a href="%s" target="_blank">%s</a> @ %s </b>\n\
<br />\n\
%s\n\
<br /><br /><br />\n'
message+='\
\n<br /><br />\n\
<u>DETAILS</u>\n\
<br /><br />\n\
'
for i in items:
	if i.age<40: message+=format % (time.strftime("%a %d %b - %H:%M",i.dateT),i.url,i.title,i.location,i.content)

#send it
open('output.html','w').write(message)
sendmail(message)

