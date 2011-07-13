%for title, body, pubdate in articles:
<article>
	<h2>{{ title }}</h2>
	<time>{{ util.datefmt(pubdate) }}</time>
	{{! body }}
</article>
%end
%rebase view/base
