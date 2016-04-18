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
			var q_name = "cub_xy_s";
			var q_readonly = ['txtNoa', 'txtComp', 'txtTgg', 'txtMech'];
			aPop = new Array(
				['txtOrdeno', '', 'view_ordes', 'noa,no2,productno,product,custno,comp', 'txtOrdeno,txtNo2', ''],
				['txtCustno', 'lblCust', 'cust', 'noa,comp', 'txtCustno,txtComp', 'cust_b.aspx'],
				['txtProductno', 'lblProduct', 'ucc', 'noa,product', 'txtProductno,txtProduct', 'ucc_b.aspx']
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
				$('.readonly').attr('readonly',true);
				q_cmbParse("cmbTypea", '@全部,製造部,加工部,委外部');
				q_cmbParse("cmbEnda", '@全部,Y@Y,N@N');
			}

			function q_gtPost(t_name) {
				switch (t_name) {
				}
			}

			function q_seekStr() {
				var t_bdate = $.trim($('#txtBdate').val());
                var t_edate = $.trim($('#txtEdate').val());
				var t_noa = $.trim($('#txtNoa').val());
				var t_custno = $.trim($('#txtCustno').val());
				var t_pno = $.trim($('#txtProductno').val());
				var t_product = $.trim($('#txtProduct').val());
				var t_ordeno = $.trim($('#txtOrdeno').val());
				var t_no2 = $.trim($('#txtNo2').val());
				var t_typea = $.trim($('#cmbTypea').val());
				var t_enda = $('#cmbEnda').val();
                var t_worker =$('#txtWorker').val();
				
				var t_where = " 1=1 " + q_sqlPara2("datea", t_bdate,t_edate) + q_sqlPara2("noa", t_noa)+
										q_sqlPara2("typea", t_typea) +
										q_sqlPara2("custno", t_custno) +
										q_sqlPara2("productno", t_pno) +
										q_sqlPara2("ordeno", t_ordeno)+q_sqlPara2("no2", t_no2) + q_sqlPara2("worker", t_worker);
										
				if(t_enda=='Y')
					t_where += " and isnull(enda,0)=1 ";
				if(t_enda=='N')
					t_where += " and isnull(enda,0)=0 ";
					
				if(t_product.length>0)
					t_where += " and charindex('"+t_product+"',product)>0 ";
				
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
					<td   style="width:35%;"><a id='lblDatea'> </a></td>
					<td style="width:65%;  ">
					<input class="txt" id="txtBdate" type="text" style="width:90px; font-size:medium;" />
					<span style="display:inline-block; vertical-align:middle">&sim;</span>
					<input class="txt" id="txtEdate" type="text" style="width:93px; font-size:medium;" />
					</td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek' style="width:90px;"><a id='lblNoa'> </a></td>
					<td><input class="txt" id="txtNoa" type="text" style="width:220px;" /></td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek' style="width:90px;"><a id='lblTypea'>類別</a></td>
					<td><select id="cmbTypea" class="txt c1"> </select></td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblEnda'>結案</a></td>
					<td><select id="cmbEnda" class="txt c1" style="font-size:medium;"> </select></td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek' style="width:90px;"><a id='lblCust'> </a></td>
					<td style="width:215px;">
						<input class="txt" id="txtCustno" type="text" style="width:90px;" />
						&nbsp;
						<input class="txt readonly" id="txtComp" type="text" style="width:120px;" />
					</td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek' style="width:90px;"><a id='lblProduct'> </a></td>
					<td style="width:215px;">
						<input class="txt" id="txtProductno" type="text" style="width:90px;" />
						&nbsp;
						<input class="txt" id="txtProduct" type="text" style="width:120px;" />
					</td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek' style="width:90px;"><a id='lblOrdeno'> </a></td>
					<td style="width:215px;">
						<input class="txt" id="txtOrdeno" type="text" style="width:150px;" />
						&nbsp;
						<input class="txt" id="txtNo2" type="text" style="width:60px;" />
					</td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblWorker'>操作者 </a></td>
					<td><input class="txt" id="txtWorker" type="text" style="width:215px; font-size:medium;" /></td>
				</tr>
			</table>
			<!--#include file="../inc/seek_ctrl.inc"-->
		</div>
	</body>
</html>