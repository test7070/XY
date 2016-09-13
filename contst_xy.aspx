<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr">
	<head>
		<title></title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
		<script src="css/jquery/ui/jquery.ui.core.js"></script>
		<script src="css/jquery/ui/jquery.ui.widget.js"></script>
		<script src="css/jquery/ui/jquery.ui.datepicker_tw.js"></script>
		<script type="text/javascript">
			this.errorHandler = null;
			function onPageError(error) {
				alert("An error occurred:\r\n" + error.Message);
			}
			q_desc=1;
			q_tables = 's';
			var q_name = "cont";
			var q_readonly = ['txtNoa', 'txtWorker', 'txtWorker2'];
			var q_readonlys = ['txtNoq'];
			var bbmNum = [['txtTotal', 15, 0, 1]];
			var bbsNum = [['txtMount', 10, 0, 1],['txtPrice', 10, 2, 1],['txtTotal', 15, 0, 1]];
			var bbmMask = [];
			var bbsMask = [];
			q_sqlCount = 6;
			brwCount = 6;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'Datea';
			aPop = new Array( ['txtCustno', 'lblCustno', 'custtgg', 'noa,comp', 'txtCustno,txtComp', 'custtgg_b.aspx']
							 ,['txtProductno_', 'btnProduct_', 'ucc', 'noa,product', 'txtProductno_,txtProduct_', 'ucc_b.aspx']
							 , ['txtSales', 'lblSales', 'sss', 'namea,noa', 'txtSales,txtSalesno', 'sss_b.aspx']
			);
			$(document).ready(function() {
				bbmKey = ['noa'];
				bbsKey =[ 'noa','noq'];
				q_brwCount();
				q_gt(q_name, q_content, q_sqlCount, 1, 0, '');
			});
			
			//////////////////   end Ready
			function main() {
				if(dataErr) {
					dataErr = false;
					return;
				}
				mainForm(1);
			}
			function mainPost() {
				q_getFormat();
				bbmMask = [['txtEnddate', r_picd],['txtDatea', r_picd],['txtDatea', r_picd]];
				bbsMask = [['txtNo3', r_picd]];
				q_mask(bbmMask);
				q_gt('acomp', '', 0, 0, 0, "");
			}

			function q_boxClose(s2) {
				var ret;
				switch (b_pop) {
					case q_name + '_s':
						q_boxClose2(s2);
						break;
				}
				b_pop = '';
			}
			
			function q_gtPost(t_name) {
				switch (t_name) {
					case q_name:
						if (q_cur == 4)
							q_Seek_gtPost();
						break;
				}  /// end switch
			}

			function btnOk() {
				t_err = q_chkEmpField([['txtNoa', q_getMsg('lblNoa')]]);
				if(t_err.length > 0) {
					alert(t_err);
					return;
				}
				
				if (q_cur == 1)
					$('#txtWorker').val(r_name);
				else
					$('#txtWorker2').val(r_name);
					
				var t_noa = trim($('#txtNoa').val());
				var t_date = trim($('#txtDatea').val());
				if (t_noa.length == 0 || t_noa == "AUTO")
					q_gtnoa(q_name, replaceAll(q_getPara('sys.key_contst') + (t_date.length == 0 ? q_date() : t_date), '/', ''));
				else
					wrServer(t_noa);
			}

			function _btnSeek() {
				if(q_cur > 0 && q_cur < 4)// 1-3
					return;
				q_box('contst_xy_s.aspx', q_name + '_s', "500px", "330px", q_getMsg("popSeek"));
			}

			function bbsAssign() {
				for(var j = 0; j < q_bbsCount; j++) {
					$('#lblNo_' + j).text(j + 1);
				}
				_bbsAssign();
			}

			function btnIns() {
				_btnIns();
				size_change();
				$('#txtNoa').val('AUTO');
				$('#txtDatea').val(q_date());
			}

			function btnModi() {
				if(emp($('#txtNoa').val()))
					return;
				_btnModi();
			}

			function btnPrint() {
			}

			function wrServer(key_value) {
				var i;
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
				_btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
			}

			function bbsSave(as) {
				if(!as['productno']) {
					as[bbsKey[1]] = '';
					return;
				}
				q_nowf();
				return true;
			}

			function refresh(recno) {
				_refresh(recno);
				
			}
			
			
			function readonly(t_para, empty) {
				_readonly(t_para, empty);
			}
			
			function btnMinus(id) {
				_btnMinus(id);
			}

			function btnPlus(org_htm, dest_tag, afield) {
				_btnPlus(org_htm, dest_tag, afield);
			}

			function q_appendData(t_Table) {
				return _q_appendData(t_Table);
			}

			function btnSeek() {
				_btnSeek();
			}

			function btnTop() {
				_btnTop();
			}

			function btnPrev() {
				_btnPrev();
			}

			function btnPrevPage() {
				_btnPrevPage();
			}

			function btnNext() {
				_btnNext();
			}

			function btnNextPage() {
				_btnNextPage();
			}

			function btnBott() {
				_btnBott();
			}

			function q_brwAssign(s1) {
				_q_brwAssign(s1);
			}

			function btnDele() {
				_btnDele();
			}

			function btnCancel() {
				_btnCancel();
			}
		</script> 
	<style type="text/css">
		.dview {
			float: left;
			width: 28%;
		}
		.tview {
			margin: 0;
			padding: 2px;
			border: 1px black double;
			border-spacing: 0;
			font-size: medium;
			background-color: #FFFF66;
			color: blue;
			width: 100%;
		}
		.tview td {
			padding: 2px;
			text-align: center;
			border: 1px black solid;
		}
		.dbbm {
			float: left;
			width: 70%;
			margin: -1px;
			border: 1px black solid;
			border-radius: 5px;
		}
		.tbbm {
			padding: 0px;
			border: 1px white double;
			border-spacing: 0;
			border-collapse: collapse;
			font-size: medium;
			color: blue;
			background: #cad3ff;
			width: 100%;
		}
		.tbbm tr {
			height: 35px;
		}
		.tbbm tr td {
			width: 9%;
		}
		.tbbm .tdZ {
			width: 2%;
		}
		.tbbm tr td span {
			float: right;
			display: block;
			width: 5px;
			height: 10px;
		}
		.tbbm tr td .lbl {
			float: right;
			color: blue;
			font-size: medium;
		}
		.tbbm tr td .lbl.btn {
			color: #4297D7;
			font-weight: bolder;
			font-size: medium;
		}
		.tbbm tr td .lbl.btn:hover {
			color: #FF8F19;
		}
		.txt.c1 {
			width: 98%;
			float: left;
		}
		.txt.c6 {
			width: 85%;
			text-align:center;
		}
		.txt.c7 {
			width: 95%;
			float: left;
		}
		.txt.c8 {
			float:left;
			width: 65px;
		}
		.txt.num {
			text-align: right;
		}
		.tbbm td {
			margin: 0 -1px;
			padding: 0;
		}
		.tbbm td input[type="text"] {
			border-width: 1px;
			padding: 0px;
			margin: -1px;
			float: left;
		}
		.tbbm td input[type="button"] {
			float: left;
		}
		.tbbm select {
			border-width: 1px;
			padding: 0px;
			margin: -1px;
			font-size:medium;
		}
		.dbbs {
			float:left;
			width: 150%;
		}
		.tbbs a {
			font-size: medium;
		}
		.num {
			text-align: right;
		}
		.tbbs tr.error input[type="text"] {
			color: red;
		}
		input[type="text"], input[type="button"] {
			font-size: medium;
		}
		.trX{
			background: pink;
		}
		.trTitle{
			padding-left: 18px;
			font-size: 18px;
			font-weight: bolder;
			color: brown;
			letter-spacing: 5px;
		}
</style>
</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();">
	<!--#include file="../inc/toolbar.inc"-->
		<div id='dmain'>
			<div class="dview" id="dview" >
				<table class="tview" id="tview">
					<tr>
						<td align="center" style="width:20px; color:black;"><a id='vewChk'> </a></td>
						<td align="center" style="width:80px; color:black;"><a id='vewContract'>PO</a></td>
						<td align="center" style="width:100px; color:black;"><a id='vewComp'> </a></td>
					</tr>
					<tr>
						<td ><input id="chkBrow.*" type="checkbox" style=''/></td>
						<td align="center" id='contract'>~contract</td>
						<td align="center" id='comp'>~comp</td>
					</tr>
				</table>
			</div>
			<div class='dbbm'>
				<table class="tbbm"  id="tbbm">
					<tr style="height:1px;">
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td class="tdZ"></td>
					</tr>
					<tr>
						<td  ><span> </span><a  class="lbl">單據編號</a></td>
						<td ><input  id="txtNoa" type="text" class="txt c1"/></td>
						<td  ><span> </span><a class="lbl">PO</a></td>
						<td ><input id="txtContract"  type="text"  class="txt c1"/></td>
						<td ><span> </span><a  class="lbl">日期</a></td>
						<td><input id="txtDatea" type="text"  class="txt c1"/></td>
					</tr>
					<tr>
						<td ><span> </span><a  id="lblCustno" class="lbl btn">客戶</a></td>
						<td><input id="txtCustno" type="text" class="txt c1"/></td>
						<td colspan="2"><input id="txtComp" type="text" class="txt c1"></td>
						<td ><span> </span><a id="lblSales" class="lbl btn">業務</a></td>
						<td><input id="txtSalesno" type="text" class="txt c1"/></td>
						<td colspan="2"><input id="txtSales" type="text" class="txt c1"></td>
					</tr>
					<tr>
						<td ><span> </span><a class="lbl">小計</a></td>
						<td><input id="txtTotal" type="text"  class="txt num c1"/></td>
					</tr>
					
				</table>
			</div>
		<div class='dbbs' style="width: 1400px;">
			<table id="tbbs" class='tbbs'  border="1"  cellpadding='2' cellspacing='1'  >
				  <tr style='color:White; background:#003366;' >
					<td align="center" style="width:1%;"><input class="btn"  id="btnPlus" type="button" value='＋' style="font-weight: bold;"  /> </td>
					<td style="width:20px;"></td>
					<td align="center"  style="width:85px;"><a >產品編號</a></td>
					<td align="center" style="width:100px;"><a >產品</a></td>
					<td align="center" style="width:85px;"><a>版別</a></td>
					<td align="center" style="width:200px;"><a>規格</a></td>
					<td align="center" style="width:35px;"><a>單位</a></td>
					<td align="center" style="width:50px;"><a >數量</a></td>
					<td align="center" style="width:50px;"><a>價格</a></td>
					<td align="center" style="width:80px;"><a >小計</a></td>
					<td align="center" style="width:50px;"><a>有效日期</a></td>
				</tr>
				<tr style='background:#cad3ff;'>
					<td align="center"><input class="btn" id="btnMinus.*" type="button" value='－' style=" font-weight: bold;" /></td>
					<td><a id="lblNo.*" style="font-weight: bold;text-align: center;display: block;"></a></td>
					<td>
						<input class="txt c6" id="txtProductno.*" type="text" style="width: 80%;"/>
						<input class="btn" id="btnProduct.*" type="button" value='.' style=" font-weight: bold;" />
					</td>
					<td>
						<input id="txtProduct.*" type="text" class="txt c7" style="width: 80%;"/>
						<select id="combGroupbno.*" class="txt c1" style="width: 20px; float: right;"> </select>
					</td>
					<td>
						<input id="txtClass.*" type="text" class="txt c7" style="width: 80%;"/>
						<select id="combClass.*" class="txt c1" style="width:20px;float: right;"> </select>
					</td>
					<td  align="center">
						<input id="txtSpec.*" type="text" class="txt c6" style="width:85%;"/>
						<input class="btn" id="btnSpec.*" type="button" value='.' style=" font-weight: bold;" />
					</td>
					<td ><input class="txt c7" id="txtUnit.*" type="text"/></td>
					<td><input class="txt num c7 yellow" id="txtMount.*" type="text"/></td>
					<td><input class="txt num c7" id="txtPrice.*" type="text " /></td>
					<td><input class="txt num c7" id="txtTotal.*" type="text" /></td>
					<td><input class="txt c7" id="txtNo3.*" type="text" /></td>
				</tr>
			</table>
		</div>
	</div>
	<input id="q_sys" type="hidden" />
	</body>
</html>