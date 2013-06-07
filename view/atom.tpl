%import util
%import config
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
<title>{{ config.BLOG_TITLE }}</title>
<subtitle>By {{ config.BLOGGER_NAME }}</subtitle>
<link rel="alternate" type="text/html" href="{{ config.HOME_URL }}" />
<link rel="self" type="application/atom+xml" href="{{ config.ATOM_URL }}" />
<id>{{ config.BLOG_URL }}</id>

<updated>{{ util.zulutime(articles[0][2]) }}</updated>
<rights>Copyright © {{ util.copyyear() }}, {{ config.BLOGGER_NAME }}</rights>

%for title, body, pubdate, slug in articles:
<entry>
	<title>{{ title }}</title>
	<link rel="alternate" type="text/html" href="{{ config.BLOG_URL }}{{ util.dateurl(pubdate) }}/{{ slug }}" />
	<id>tag:{{ config.HOME_URL }},{{ pubdate.year }}:{{ slug }}</id>
	<published>{{ util.zulutime(pubdate) }}</published>
	<updated>{{ util.zulutime(pubdate) }}</updated>
	<author>
		<name>{{ config.BLOGGER_NAME }}</name>
		<uri>{{ config.HOME_URL }}</uri>
	</author>
	<content type="html" xml:base="{{ config.BLOG_URL }}" xml:lang="en">
	<![CDATA[
		{{! body }}
	]]>
	</content>
  </entry>
%end
</feed>
