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
			var t_sqlname = 'ordes_xy2_load';
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
			
			var t_custno='',t_ordeno='';
			function bbsAssign() {
				_bbsAssign();
				for (var j = 0; j < q_bbsCount; j++) {
					//105/08/10 不同客戶不能選取 //105/08/11 不同訂單不能選取
					$('#chkSel_'+j).click(function() {
						t_IdSeq = -1;
						q_bodyId($(this).attr('id'));
						b_seq = t_IdSeq;
						if(t_ordeno.length>0){
							if(t_ordeno!=$('#txtNoa_'+b_seq).val()){
								$('#chkSel_'+b_seq).prop('checked',false);
								alert('不同訂單禁止選取!!')
							}
						}else{
							t_ordeno=$('#txtNoa_'+b_seq).val();
						}
						
						//如果清空
						if($('[type=checkbox]:checked').length==0){
							t_ordeno='';
						}
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
					<td align="center" style="width:1%;"> </td>
					<td align="center" style="width:10%;"><a id='lblDatea'>預交日</a></td>
					<td align="center" style="width:10%;"><a id='lblComp'>客戶</a></td>
					<td align="center" style="width:10%;"><a id='lblProductno'>產品編號</a></td>
					<td align="center" style="width:8%;"><a id='lblProduct'>品名</a></td>
					<td align="center" style="width:4%;"><a id='lblClassa'>版別</a></td>
					<td align="center" style="width:16%;"><a id='lblSpec'>規格</a></td>
					<td align="center" style="width:4%;"><a id='lblUnit'>單位</a></td>
					<td align="center" style="width:8%;"><a id='lblMount'>訂單量</a></td>
					<td align="center" style="width:8%;"><a id='lblNotv'>未交量</a></td>
					<td align="center" style="width:12%;"><a id='lblNoa'>訂單編號</a></td>
				</tr>
				<tr  style='background:#cad3ff;'>
					<td align="center"><input id="chkSel.*" type="checkbox"/></td>
					<td>
						<input class="txt" id="txtDatea.*" type="text" style="width:65%; text-align:left;"/>
						<input class="txt" id="txtIndate.*" type="text" style="width:30%; text-align:left;"/>
					</td>
					<td>
						<input class="txt" id="txtComp.*" type="text" style="width:98%; text-align:left;"/>
						<input class="txt" id="txtCustno.*" type="hidden" style="width:98%; text-align:left;"/>
					</td>
					<td><input class="txt" id="txtProductno.*" type="text" style="width:98%; text-align:left;"/></td>
					<td><input class="txt" id="txtProduct.*" type="text" style="width:98%; text-align:left;"/></td>
					<td><input class="txt" id="txtClassa.*" type="text" style="width:98%; text-align:left;"/></td>
					<td><input class="txt" id="txtSpec.*" type="text" style="width:98%; text-align:left;"/></td>
					<td><input class="txt" id="txtUnit.*" type="text" style="width:98%; text-align:left;"/></td>
					<td>
						<input class="txt" id="txtMount.*" type="text" style="width:98%; text-align:right;"/>
						<input class="txt" id="txtVccdime.*" type="hidden" style="width:98%; text-align:right;"/>
					</td>
					<td><input class="txt" id="txtNotv.*" type="text" style="width:98%; text-align:right;"/></td>
					<td>
						<input class="txt" id="txtNoa.*" type="text" style="width:75%;"/>
						<input class="txt" id="txtNo2.*" type="text" style="width:20%;"/>
						<input id="recno.*" type="hidden" />
					</td>
				</tr>
			</table>
			<!--#include file="../inc/pop_ctrl.inc"-->
		</div>
	</body>
</html>