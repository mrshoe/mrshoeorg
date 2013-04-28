<article>
<h2>The Bo</h2>
<p>
<img src="http://mrshoe.smugmug.com/Airplanes/N4WR/i-9qBTLdn/0/L/IMG0749-L.jpg" />
</p>
<p>
&nbsp;&nbsp;&nbsp;&nbsp;On Saturday, June 16, 2012, I took delivery of N4WR, a 1967 Beechcraft Bonanza. This is my
second airplane. I bought it three days after earning my Private Pilot Certificate.
</p>
<style>
table.manuals {
	margin: 0px 0px 8px 18px;
}
table.manuals td {
	height: 2.3em;
}
table.manuals td.icon {
	text-align: center;
    width: 50px;
}
</style>
<script>
var i = 500;
function formatNum(x) {
	return x.toFixed(2).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
function calculate_wb()
{
	var weight = 2110.32;
	var moment = 171183.05;

	var w = parseInt($('#frontseats').val());
	var m = w * 85;
	weight += w;
	moment += m;
	$('#frontseats_moment').html(formatNum(m/100.0));

	w = parseInt($('#backseats').val());
	m = w * 121;
	weight += w;
	moment += m;
	$('#backseats_moment').html(formatNum(m/100.0));

	w = parseInt($('#baggage').val());
	m = w * 150;
	weight += w;
	moment += m;
	$('#baggage_moment').html(formatNum(m/100.0));

	var fuel = parseInt($('#fuel').val());
	w = fuel * 6;
	m = w * 75;
	weight += w;
	moment += m;
	$('#fuel_moment').html(formatNum(m/100.0));

	$('#ramp_weight').html(formatNum(weight));
	$('#ramp_cg').html(formatNum(moment/weight));
	$('#ramp_moment').html(formatNum(moment));

	// start up and taxi
	w = 6;
	m = w * 75;
	weight -= w;
	moment -= m;
	$('#takeoff_weight').html(formatNum(weight));
	$('#takeoff_cg').html(formatNum(moment/weight));
	$('#takeoff_moment').html(formatNum(moment));

	// burn down to 15 gallons
	w = (fuel - 15) * 6;
	m = w * 75;
	weight -= w;
	moment -= m;
	$('#landing_weight').html(formatNum(weight));
	$('#landing_cg').html(formatNum(moment/weight));
	$('#landing_moment').html(formatNum(moment));
}
$(function() { setInterval(calculate_wb, 500); });
</script>
<h3>Manuals</h3>
<p>
<table class="manuals">
<tr>
	<td>Coming soon...</td>
</tr>
<!--
<tr>
	<td class="icon"><a href="/static/N5779V/FuelTotalizer.pdf"><img src="/static/icons/fuel_icon.png" /></td>
	<td><a href="/static/N5779V/FuelTotalizer.pdf">Fuel Totalizer</td>
</tr>
<tr>
	<td class="icon"><a href="/static/N5779V/EGT.pdf"><img src="/static/icons/speedometer_icon.png" /></a></td>
	<td><a href="/static/N5779V/EGT.pdf">Exhaust Gas Temperature Gauge</a></td>
</tr>
<tr>
	<td class="icon"><a href="/static/N5779V/ApolloGX55GPS.pdf"><img src="/static/icons/radar_icon.png" /></a></td>
	<td><a href="/static/N5779V/ApolloGX55GPS.pdf">Apollo GX55 GPS</a></td>
</tr>
<tr>
	<td class="icon"><a href="/static/N5779V/GPSCheatSheet.pdf"><img src="/static/icons/signpost_icon.png" /></a></td>
	<td><a href="/static/N5779V/GPSCheatSheet.pdf">GPS Cheat Sheet</a></td>
</tr>
<tr>
	<td class="icon"><a href="/static/N5779V/OilPressureTemp.pdf"><img src="/static/icons/thermometer_icon.png" /></a></td>
	<td><a href="/static/N5779V/OilPressureTemp.pdf">Oil Pressure and Temperature</a></td>
</tr>
<tr>
	<td class="icon"><a href="/static/N5779V/DigitalClock.pdf"><img src="/static/icons/stopwatch_icon.png" /></a></td>
	<td><a href="/static/N5779V/DigitalClock.pdf">Digital Clock</a></td>
</tr>
-->
</table>
</p>
<h3>Weight <span class="amp">&amp;</span> Balance</h3>
<style>
input {
	border:1px solid #555;
	padding:2px;
}
</style>
<p>
<table>
<tr>
	<th></th>
	<th>Weight</th>
	<th>Arm</th>
	<th>Moment/100</th>
</tr>
<tr>
	<td>Basic Empty Weight</td>
	<td>2,110.32</td>
	<td>81.12</td>
	<td>171,183.05</td>
</tr>
<tr>
	<td>Front Seats</td>
	<td><input name="frontseats" id="frontseats" value="400" /></td>
	<td>85</td>
	<td id="frontseats_moment"></td>
</tr>
<tr>
	<td>Back Seats</td>
	<td><input name="backseats" id="backseats" value="0" /></td>
	<td>121</td>
	<td id="backseats_moment"></td>
</tr>
<tr>
	<td>Baggage</td>
	<td><input name="baggage" id="baggage" value="30" /></td>
	<td>150</td>
	<td id="baggage_moment"></td>
</tr>
<tr>
	<td>Fuel</td>
	<td><input name="fuel" id="fuel" value="80" /></td>
	<td>75</td>
	<td id="fuel_moment"></td>
</tr>
<tr>
	<td>Ramp Condition</td>
	<td id="ramp_weight"></td>
	<td id="ramp_cg"></td>
	<td id="ramp_moment"></td>
</tr>
<tr>
	<td>Takeoff Condition</td>
	<td id="takeoff_weight"></td>
	<td id="takeoff_cg"></td>
	<td id="takeoff_moment"></td>
</tr>
<tr>
	<td>Landing Condition</td>
	<td id="landing_weight"></td>
	<td id="landing_cg"></td>
	<td id="landing_moment"></td>
</tr>
</table>
</p>
<!--
<p>
<img src="/static/N5779V/overhead_diagram.png"/>
</p>
-->
</article>
%rebase view/base title='N4WR'
