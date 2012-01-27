%import util
%for title, body, pubdate, slug in articles:
%pubdate = util.timezonefix(pubdate)
<article>
	<h2><a href="/blog/{{ util.dateurl(pubdate) }}/{{ slug }}">{{ title }}</a></h2>
	<time>{{ util.datefmt(pubdate) }}</time>
	{{! body }}
</article>
%end
<table style="width:100%;margin-left:20px">
<tr>
%if previous is not None:
<td><a href="{{! previous }}">&laquo;</a></td>
%end
%if next is not None:
<td style="text-align:right"><a href="{{! next }}">&raquo;</a></td>
%end
</td>
</table>
%title = articles[0][0] if len(articles) == 1 else 'David Shoemaker'
%rebase view/base title=title
