<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title></title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
		<script src="css/jquery/ui/jquery.ui.core.js"></script>
		<script src="css/jquery/ui/jquery.ui.widget.js"></script>
		<script src="css/jquery/ui/jquery.ui.datepicker_tw.js"></script>
		<script type="text/javascript">
			var q_name = "cug_xy_s";
			var q_readonly = ['txtNoa', 'txtComp', 'txtTgg', 'txtMech'];
			aPop = new Array(
				['txtStationno', '', 'mech', 'noa,mech', 'txtStationno,txtStation', 'mech_b.aspx'],
				['txtProcessno', '', 'sss', 'noa,namea', 'txtProcessno,txtProcess', 'sss_b.aspx']
			);
			$(document).ready(function() {
				main();
			});
			function main() {
				mainSeek();
				q_gf('', q_name);
			}

			function q_gfPost() {
				q_getFormat();
				q_langShow();
				bbmMask = [['txtBdate', r_picd], ['txtEdate', r_picd]];
                q_mask(bbmMask);
				$('#txtNoa').focus();
			}

			function q_gtPost(t_name) {
				switch (t_name) {
				}
			}

			function q_seekStr() {
				var t_bdate = $.trim($('#txtBdate').val());
                var t_edate = $.trim($('#txtEdate').val());
				var t_noa = $.trim($('#txtNoa').val());
				var t_stationno = $.trim($('#txtStationno').val());
				var t_processno = $.trim($('#txtProcessno').val());
				
				var t_where = " 1=1 " + q_sqlPara2("datea", t_bdate,t_edate) + q_sqlPara2("noa", t_noa)+
										q_sqlPara2("stationno", t_stationno) +
										q_sqlPara2("processno", t_processno);
				
				t_where = ' where=^^' + t_where + '^^ ';
				return t_where;
			}
		</script>
		<style type="text/css">
			.seek_tr {
				color: white;
				text-align: center;
				font-weight: bold;
				BACKGROUND-COLOR: #76a2fe
			}
			input{
				font-size:medium;
			}
			.readonly{
				color: green;
				background: rgb(237, 237, 238);
			}
		</style>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();">
		<div style='width:400px; text-align:center;padding:15px;' >
			<table id="seek" border="1" cellpadding='3' cellspacing='2' style='width:100%;' >
				<tr class='seek_tr'>
					<td style="width:35%;"><a id='lblDatea'>開始日期</a></td>
					<td style="width:65%;  ">
					<input class="txt" id="txtBdate" type="text" style="width:90px; font-size:medium;" />
					<span style="display:inline-block; vertical-align:middle">&sim;</span>
					<input class="txt" id="txtEdate" type="text" style="width:93px; font-size:medium;" />
					</td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek' style="width:90px;"><a id='lblNoa'>排程單號</a></td>
					<td><input class="txt" id="txtNoa" type="text" style="width:220px;" /></td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek' style="width:90px;"><a id='lblStationno'>機台</a></td>
					<td style="width:215px;">
						<input class="txt" id="txtStationno" type="text" style="width:90px;" />
						&nbsp;
						<input class="txt" id="txtStation" type="text" style="width:120px;" disabled="disabled"/>
					</td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek' style="width:90px;"><a id='lblProcessno'>員工</a></td>
					<td style="width:215px;">
						<input class="txt" id="txtProcessno" type="text" style="width:90px;" />
						&nbsp;
						<input class="txt" id="txtProcess" type="text" style="width:120px;" disabled="disabled"/>
					</td>
				</tr>
			</table>
			<!--#include file="../inc/seek_ctrl.inc"-->
		</div>
	</body>
</html>