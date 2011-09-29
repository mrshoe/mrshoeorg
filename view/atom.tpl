%import util
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
<title>MrShoe.org Blog</title>
<subtitle>By David Shoemaker</subtitle>
<link rel="alternate" type="text/html" href="http://mrshoe.org/blog/" />
<link rel="self" type="application/atom+xml" href="http://mrshoe.org/blog/index.xml" />
<id>http://mrshoe.org/blog/</id>

<updated>{{ util.zulutime(articles[0][2]) }}</updated>
<rights>Copyright © {{ util.copyyear() }}, David Shoemaker</rights>

%for title, body, pubdate, slug in articles:
<entry>
	<title>{{ title }}</title>
	<link rel="alternate" type="text/html" href="http://mrshoe.org/blog/{{ util.dateurl(pubdate) }}/{{ slug }}" />
	<id>tag:mrshoe.org,{{ pubdate.year }}:{{ slug }}</id>
	<published>{{ util.zulutime(pubdate) }}</published>
	<updated>{{ util.zulutime(pubdate) }}</updated>
	<author>
		<name>David Shoemaker</name>
		<uri>http://mrshoe.org/</uri>
	</author>
	<content type="html" xml:base="http://mrshoe.org/blog/" xml:lang="en">
	<![CDATA[
		{{! body }}
	]]>
	</content>
  </entry>
%end
</feed>
