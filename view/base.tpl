%import util
%import config
<!DOCTYPE html>
<html>
<head>
<title>{{ title }}</title>
<meta charset="UTF8">
<link rel="openid.server" href="http://www.myopenid.com/server" />
<link rel="openid.delegate" href="http://mrshoe.myopenid.com/" />
<meta http-equiv="X-XRDS-Location" content="http://mrshoe.myopenid.com/xrds" />
<link href='http://fonts.googleapis.com/css?family=Cabin:regular,bold' rel='stylesheet' type='text/css'>
<link rel="stylesheet" href="/static/site.css">
<link rel="alternate" type="application/atom+xml" href="/blog/index.xml" />
<!--[if IE]>
<script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
<![endif]-->
<script src="/static/raphael-min.js"></script>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.5.2/jquery.min.js"></script>
<script type="text/javascript">
var _gaq = _gaq || [];
_gaq.push(['_setAccount', '{{ config.GOOGLE_ANALYTICS_ACCOUNT }}']);
_gaq.push(['_trackPageview']);
(function() {
var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();
</script>
</head>
<body>
	<header>
		<a href="/">
		<div id="logo"></div>
		</a>
	</header>
	<section id="allcontent">
		%include
	</section>
	<footer>
		<section>&copy; 2011-{{ util.copyyear() }} {{ config.BLOGGER_NAME }}</section>
	</footer>
	<script>
function drawLogo(paper, ring1attrs, ring2attrs, shoeattrs) {
	var size = Math.min(paper.width, paper.height);
	paper.circle(size/2,size/2,(size/2) - (size/30)).attr(ring1attrs);
	paper.circle(size/2,size/2,(size/2) - (size/30) - (size/20)).attr(ring2attrs);
	var shoe = paper.path("m 26.714141,79.445845 c 0,0 7.49329,11.07314 12.05939,15.91645 0.9106,0.96588 1.91131,1.86848 3.02705,2.58764 0.70987,0.45755 1.48517,0.83347 2.29471,1.07412 1.22882,0.36528 2.52628,0.52864 3.80822,0.53705 1.54219,0.01 3.11395,-0.13703 4.58941,-0.58587 1.14891,-0.34951 2.21946,-0.9506 3.22235,-1.61118 0.80049,-0.52727 1.52708,-1.16979 2.19707,-1.85529 0.97888,-1.00154 1.92695,-2.06376 2.63646,-3.27117 0.41799,-0.71132 0.72012,-1.4962 0.92765,-2.29471 0.33004,-1.26991 0.46612,-2.59397 0.48823,-3.90588 0.0242,-1.43786 -0.0572,-2.89758 -0.39059,-4.29647 -0.21508,-0.90251 -0.64659,-1.74065 -1.02529,-2.58764 -0.26736,-0.59798 -0.56273,-1.18392 -0.87882,-1.75764 -2.64247,-4.79633 -8.49528,-14.06117 -8.49528,-14.06117 z m -3.873781,-7.33123 c 0,0 -10.24949,-12.63506 -13.9474602,-19.81643 C 6.6035296,47.852265 5.1882195,42.981255 3.9215197,38.143595 2.5777598,33.01157 1.7096998,27.746409 1.1596498,22.469967 0.87313989,19.721455 0.25263997,16.874789 0.88346989,14.184349 1.5040598,11.53756 2.7886198,8.8858315 4.7500895,7.0034795 7.4831696,4.3806465 11.21919,2.8897995 14.83092,1.6868745 c 1.63175,-0.54347 3.39118,-0.96211599 5.10947,-1.03570199 1.4973,-0.06412 3.06475,0.18667 4.418991,0.82856199 2.06641,0.979449 3.66228,2.770893 5.24756,4.418997 2.18303,2.269523 4.06349,4.8300655 5.79994,7.4570555 2.09065,3.162848 4.01578,6.464169 5.52374,9.942743 1.07692,2.484256 2.02031,5.065899 2.48569,7.733242 0.45915,2.631644 0.21549,5.338725 0.27619,8.009433 0.0476,2.094 -0.0343,4.19126 0.069,6.28326 0.10367,2.09994 0.002,4.25401 0.55237,6.28326 0.49299,1.81841 2.41664,5.10946 2.41664,5.10946 z");
	shoe.translate((size-63)/2, (size-100)/2).attr(shoeattrs).scale(size/150.0);
}
var paper=Raphael("logo", 180, 180);
drawLogo(paper, {'stroke-width': 7, 'stroke-opacity': 0.15}, {'stroke-width': 6, 'stroke-opacity': 0.15}, {'fill': 'black', 'stroke-opacity': 0.15, 'stroke-width': 6});
drawLogo(paper, {'stroke-width': 3}, {'stroke-width': 3}, {'fill': 'black'});

function doFlip(elem) {
	var el = $(elem);
	if (el.hasClass('flipped')) {
		el.addClass('unflip');
		el.removeClass('flipped');
		el.bind('webkitAnimationEnd', function (e) {
			el.removeClass('unflip');
			el.unbind('webkitAnimationEnd');
		});
	}
	else {
		el.addClass('flip');
		el.bind('webkitAnimationEnd', function (e) {
			el.removeClass('flip');
			el.addClass('flipped');
			el.unbind('webkitAnimationEnd');
		});
	}
}
	</script>
</body>
</html>
