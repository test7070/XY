<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<meta http-equiv="Content-Language" content="en-us" />
		<title> </title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src="../script/qj2.js" type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src="../script/qj_mess.js" type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript">
			var q_name = 'view_ordes', t_bbsTag = 'tbbs', t_content = "", afilter = [], bbsKey = ['noa'], as;
			//, t_where = '';
			var t_sqlname = 'ordes_xy_load';
			t_postname = q_name;
			brwCount = -1;
			brwCount2 = 0;
			var isBott = false;
			var txtfield = [], afield, t_data, t_htm;
			var i, s1;
			
			$(document).ready(function() {
				if (!q_paraChk())
					return;

				main();
			});

			function main() {
				if (dataErr) {
					dataErr = false;
					return;
				}
				mainBrow(6, t_content, t_sqlname, t_postname, r_accy);
				$('#btnTop').hide();
				$('#btnPrev').hide();
				$('#btnNext').hide();
				$('#btnBott').hide();
			}

			function bbsAssign() {
				_bbsAssign();
				for (var j = 0; j < q_bbsCount; j++) {
					$('#xradSel_'+j).click(function() {
						t_IdSeq = -1;
						q_bodyId($(this).attr('id'));
						b_seq = t_IdSeq;
						var t_ordeno=$('#txtNoa_'+b_seq).val(),t_datea=$('#txtDatea_'+b_seq).val();
						
						t_where = " isnull(enda,0)!=1 ";
						t_where += " and productno!='' ";
						t_where += " and (noa='"+t_ordeno+"') and (datea='"+t_datea+"')";
						t_where += " and (source!='2' or mount!=isnull((select SUM(tranmoney3) from view_vccs where ordeno=view_ordes"+r_accy+".noa and no2=view_ordes"+r_accy+".no2),0))";
						t_where = t_where;
						
						location.href = location.origin+replaceAll(location.pathname,'ordes_b2_xy','ordes_b')+"?" + r_userno + ";" + r_name + ";" + q_id + ";"+t_where+";"+r_accy;
						//q_box("ordes_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'ordes', "95%", "650px", q_getMsg('popOrde'));
					});
				}
			}

			function q_gtPost() {

			}

			function refresh() {
				_refresh();
			}

		</script>
		<style type="text/css">
			.seek_tr {
				color: white;
				text-align: center;
				font-weight: bold;
				BACKGROUND-COLOR: #76a2fe
			}
			input[type="text"], input[type="button"] {
				font-size: medium;
			}
		</style>
	</head>
	<body>
		<div  id="dbbs"  >
			<table id="tbbs" class='tbbs'  border="2"  cellpadding='2' cellspacing='1' style='width:100%'  >
				<tr style='color:White; background:#003366;' >
					<td align="center"> </td>
					<td align="center"><a id='lblNoa'> </a></td>
					<td align="center"><a id='lblDatea'> </a></td>
					<td align="center"><a id='lblComp'> </a></td>
				</tr>
				<tr  style='background:#cad3ff;'>
					<td style="width:1%;" align="center"><input name="sel"  id="xradSel.*" type="radio" /></td>
					<td style="width:30%;">
						<input class="txt" id="txtNoa.*" type="text" style="width:98%;"/>
						<input id="recno.*" type="hidden" />
					</td>
					<td style="width:20%;"><input class="txt" id="txtDatea.*" type="text" style="width:98%; text-align:left;"/></td>
					<td style="width:40%;"><input class="txt" id="txtComp.*" type="text" style="width:98%; text-align:left;"/></td>
				</tr>
			</table>
			<!--#include file="../inc/brow_ctrl.inc"-->
		</div>
	</body>
</html>