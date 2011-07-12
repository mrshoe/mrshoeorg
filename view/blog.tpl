%for title, body in articles:
<article>
	<h2>{{ title }}</h2>
	{{ body }}
</article>
%end
%rebase view/base
