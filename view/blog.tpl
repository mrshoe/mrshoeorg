%import util
%import config
<script>
function placeholder(p, elem) {
	elem.text(p);
	elem.val(p);
	elem.addClass('placeholder');
	elem.focus(function () {
		if (elem.text() == p && elem.val() == p) {
			elem.text('');
			elem.val('');
		}
		elem.removeClass('placeholder');
	});
	elem.blur(function () {
		if (elem.text() == '' && elem.val() == '') {
			elem.text(p);
			elem.val(p);
			elem.addClass('placeholder');
		}
	});
}
%if config.COMMENTS_ENABLED:
$(function(){
	placeholder('Name', $('#nameinput'));
	placeholder('Comment', $('#commentinput'));
	$('#jstest').val('valid');
});
%end
</script>
%for title, body, pubdate, slug, id in articles:
%pubdate = util.timezonefix(pubdate)
<article>
	<h2><a href="/blog/{{ util.dateurl(pubdate) }}/{{ slug }}">{{ title }}</a></h2>
	<time>{{ util.datefmt(pubdate) }}</time>
	{{! body }}
%if config.COMMENTS_ENABLED:
%if single_post == True:
<section id="comments">
%for commenter, comment, tstamp in comments:
<h3>{{ commenter }}</h3>
<time>{{ util.timefmt(tstamp) }}</time>
<p>{{ comment }}</p>
%end
<form method="POST">
<input name="jstest" id="jstest" type="hidden" value="" />
<input name="commenter" id="nameinput" />
<textarea name="comment" id="commentinput">
</textarea>
<input type="submit" name="submit" value="Submit" />
</form>
</section>
%else:
<h4><span><span class="dot">☙</span><a href="/blog/{{ util.dateurl(pubdate) }}/{{ slug }}#comments">{{ comment_counts.get(id, '0 comments') }}</a><span class="dot flipped">☙</span></span></h4>
%end
%end
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
%title = articles[0][0] if single_post == True else config.BLOGGER_NAME
%rebase view/base title=title
