<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr">
	<head>
		<title> </title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript">
			this.errorHandler = null;
			function onPageError(error) {
				alert("An error occurred:\r\n" + error.Message);
			}

			q_tables = 's';
			var q_name = "ina";
			var q_readonly = ['txtNoa','txtStation','txtComp','txtStore','txtCardeal','txtAddr','txtTranstart','txtWorker','txtWorker2','txtTotal'];
			var q_readonlys = ['txtTotal','txtRc2no','txtNamea'];
			var bbmNum = [['txtTotal', 15, 0, 1]];//, ['txtTranmoney', 15, 0, 1], ['txtPrice', 10, 2, 1]
			var bbsNum = [['txtMount', 10, 0, 1], ['txtPrice', 10, 2, 1], ['txtTotal', 15, 0, 1]];
			var bbmMask = [];
			var bbsMask = [];
			q_sqlCount = 6;
			brwCount = 6;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'Datea';
			aPop = new Array(
				//['txtPost', 'lblPost', 'addr', 'post,addr', 'txtPost', 'addr_b.aspx'],
				['txtPost', 'lblPost', 'addr2', 'noa,post', 'txtPost,txtAddr', 'addr2_b.aspx'],
				['txtStoreno', 'lblStore', 'store', 'noa,store', 'txtStoreno,txtStore', 'store_b.aspx'],
				['txtTggno', 'lblTgg_xy', 'tgg', 'noa,nick', 'txtTggno,txtComp', 'tgg_b.aspx'],
				['txtCardealno', 'lblCardeal', 'cardeal', 'noa,comp', 'txtCardealno,txtCardeal', 'cardeal_b.aspx'],
				['txtProductno_', 'btnProductno_', 'ucc_xy', 'noa,product,spec,unit', 'txtProductno_,txtProduct_,txtSpec_,txtUnit_', 'ucaucc_b.aspx']
			);
			$(document).ready(function() {
				bbmKey = ['noa'];
				bbsKey = ['noa', 'noq'];
				q_brwCount();
				q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
			});

			var abbsModi = [];

			function main() {
				if (dataErr) {
					dataErr = false;
					return;
				}

				mainForm(1);
			}
			
			var z_rc2no='';
			function mainPost() {
				q_getFormat();
				bbmMask = [['txtDatea', r_picd]];
				q_mask(bbmMask);
				//q_cmbParse("cmbTranstyle", q_getPara('sys.transtyle'));
				q_cmbParse("cmbItype", q_getPara('ina.typea'));
				//q_cmbParse("cmbTrantype", q_getPara('sys.tran'));
				
				/*$('#txtCardealno').change(function(){
					//取得車號下拉式選單
					var thisVal = $(this).val();
					var t_where = "where=^^ noa=N'" + thisVal + "' ^^";
					q_gt('cardeal', t_where, 0, 0, 0, "getCardealCarno");
				});*/
				
				$('#txtPrice').change(function(){
					sum();
				});
								
				$('#btnCub').click(function() {
					var t_where = '';
					t_where = " isnull(enda,0)!=1 and isnull(cancel,0)!=1";
					if (!emp($('#txtOrdeno').val()))
						t_where += " and charindex(noa,'" + $('#txtOrdeno').val() + "')>0 ";
					t_where = t_where;
					
					q_box("cub_xy_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'cub', "95%", "650px", $('#btnCub').val());
				});
			}

			function q_boxClose(s2) {
				var ret;
				switch (b_pop) {
					case 'cub':
						if (q_cur > 0 && q_cur < 4) {
							if (!b_ret || b_ret.length == 0){
								b_pop = '';
								return;
							}
							
							for (var i = 0; i < b_ret.length; i++) {
								b_ret[i].total=round(q_mul(dec(b_ret[i].notv),dec(b_ret[i].price)),0);
							}
							
							ret = q_gridAddRow(bbsHtm, 'tbbs', 'txtRc2no,txtProductno,txtProduct,txtSpec,txtUnit,txtMount,txtPrice,txtTotal,txtMemo,txtSssno,txtNamea'
							, b_ret.length, b_ret, 'noa,productno,product,spec,unit,notv,price,total,memo,custno,comp', 'txtProductno');
						}
						break;
					case q_name + '_s':
						q_boxClose2(s2);
						break;
				}
				b_pop = '';
			}
			function q_popPost(s1) {
				switch (s1) {
					/*case 'txtCardealno':
						//取得車號下拉式選單
						var thisVal = $('#txtCardealno').val();
						var t_where = "where=^^ noa=N'" + thisVal + "' ^^";
						q_gt('cardeal', t_where, 0, 0, 0, "getCardealCarno");
						break;*/
				}
			}

			var carnoList = [];
			var thisCarSpecno = '';
			function q_gtPost(t_name) {
				switch (t_name) {
					
					case q_name:
						if (q_cur == 4)
							q_Seek_gtPost();
						break;
				}
			}
			
			function q_stPost() {					
				for (var j = 0; j < q_bbsCount; j++) {
					if(!emp($('#txtRc2no_'+j).val()) ){//&& z_rc2no.indexOf($('#txtRc2no_'+j).val())==-1
						z_rc2no=z_rc2no+(z_rc2no.length>0?',':'')+$('#txtRc2no_'+j).val();
					}
				}
				
				//更新未交量
				if(z_rc2no.length>0){
					var x_rc2no=z_rc2no.split(',');
					for (var i = 0; i < x_rc2no.length; i++) {
						if(x_rc2no[i]!=''){
							q_func('qtxt.query.cubnotv_xy', 'cub.txt,cubnotv_xy,' + encodeURI(r_accy) + ';' + encodeURI(x_rc2no[i]));
							sleep(100);
						}
					}
					
					z_rc2no='';
				}
			}
			
			function sleep(milliseconds) {
                var start = new Date().getTime();
                for (var i = 0; i < 1e7; i++) {
                    if ((new Date().getTime() - start) > milliseconds) {
                        break;
                    }
                }
            }

			function btnOk() {
				t_err = q_chkEmpField([['txtNoa', q_getMsg('lblNoa')]]);
				if (t_err.length > 0) {
					alert(t_err);
					return;
				}
				if (q_cur == 1)
					$('#txtWorker').val(r_name);
				else
					$('#txtWorker2').val(r_name);
					
				var s1 = $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val();
				if (s1.length == 0 || s1 == "AUTO")
					q_gtnoa(q_name, replaceAll(q_getPara('sys.key_ina') + $('#txtDatea').val(), '/', ''));
				else
					wrServer(s1);
			}

			function _btnSeek() {
				if (q_cur > 0 && q_cur < 4)// 1-3
					return;
				q_box('ina_s.aspx', q_name + '_s', "500px", "330px", q_getMsg("popSeek"));
			}

			function bbsAssign() {
				for (var j = 0; j < q_bbsCount; j++) {
					if (!$('#btnMinus_' + j).hasClass('isAssign')) {
						$('#txtMount_' + j).change(function() {
							sum();
						});
						$('#txtPrice_' + j).change(function() {
							sum();
						});
						
						$('#txtRc2no_' + j).click(function() {
                            t_IdSeq = -1;
                            q_bodyId($(this).attr('id'));
                            b_seq = t_IdSeq;
                            var t_cubno = $.trim($("#txtRc2no_" + b_seq).val());
                            if (t_cubno.length > 0) {
                                var t_where = "noa='" + t_cubno + "'";
                                q_box("cub_xy.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, q_name, "98%", "98%", q_getMsg("popSeek"));
                            }
                        });
					}
				}
				_bbsAssign();
			}

			function btnIns() {
				_btnIns();
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val('AUTO');
				$('#txtDatea').val(q_date());
				$('#txtStoreno').val('A');
				$('#txtStore').val('總倉庫');
				$('#txtDatea').focus();
			}

			function btnModi() {
				if (emp($('#txtNoa').val()))
					return;
				_btnModi();
				
				//記錄存檔前的製令號
				for (var j = 0; j < q_bbsCount; j++) {
					if(!emp($('#txtRc2no_'+j).val())){
						z_rc2no=z_rc2no+(z_rc2no.length>0?',':'')+$('#txtRc2no_'+j).val();
					}
				}
				//取得車號下拉式選單
				/*var thisVal = $('#txtCardealno').val();
				var t_where = "where=^^ noa=N'" + thisVal + "' ^^";
				q_gt('cardeal', t_where, 0, 0, 0, "getCardealCarno");*/
				$('#txtProduct').focus();
			}

			function btnPrint() {
				q_box('z_inap.aspx' + "?;;;;" + r_accy + ";noa=" + trim($('#txtNoa').val()), '', "95%", "95%", q_getMsg("popPrint"));
			}

			function wrServer(key_value) {
				var i;
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
				_btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
			}

			function bbsSave(as) {
				if (!as['productno']) {
					as[bbsKey[1]] = '';
					return;
				}
				q_nowf();
				as['datea'] = abbm2['datea'];
				as['tggno'] = abbm2['tggno'];
				return true;
			}

			function sum() {
				var t_price=0,t_mount=0,t_total=0;
				var tranPrice=0;tranTotal=0;
				for (var j = 0; j < q_bbsCount; j++) {
					t_mount = dec($('#txtMount_' + j).val());
					t_price = dec($('#txtPrice_' + j).val());
					t_total = q_add(t_total,round(q_mul(t_price,t_mount), 0));
					$('#txtTotal_' + j).val(round(q_mul(t_price,t_mount), 0));
				}
				$('#txtTotal').val(t_total);
			}

			function refresh(recno) {
				_refresh(recno);
			}

			function readonly(t_para, empty) {
				_readonly(t_para, empty);
			}

			function btnMinus(id) {
				_btnMinus(id);
				sum();
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
				for (var j = 0; j < q_bbsCount; j++) {
					if(!emp($('#txtRc2no_'+j).val())){
						z_rc2no=z_rc2no+(z_rc2no.length>0?',':'')+$('#txtRc2no_'+j).val();
					}
				}
				_btnDele();
			}

			function btnCancel() {
				_btnCancel();
			}

		</script>
		<style type="text/css">
			#dmain {
				overflow: hidden;
			}
			.dview {
				float: left;
				width: 98%;
			}
			.tview {
				margin: 0;
				padding: 2px;
				border: 1px black double;
				border-spacing: 0;
				font-size: medium;
				background-color: #FFFF66;
				color: blue;
			}
			.tview td {
				padding: 2px;
				text-align: center;
				border: 1px black solid;
			}
			.dbbm {
				float: left;
				width: 98%;
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
			.txt.c2 {
				width: 38%;
				float: left;
			}
			.txt.c3 {
				width: 60%;
				float: left;
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
			.tbbm select {
				border-width: 1px;
				padding: 0px;
				margin: -1px;
				font-size: medium;
			}
			.tbbm textarea {
				font-size: medium;
			}

			input[type="text"], input[type="button"] {
				font-size: medium;
			}
			.dbbs .tbbs {
				margin: 0;
				padding: 2px;
				border: 2px lightgrey double;
				border-spacing: 1px;
				border-collapse: collapse;
				font-size: medium;
				color: blue;
				background: #cad3ff;
				width: 100%;
			}
			.dbbs .tbbs tr {
				height: 35px;
			}
			.dbbs .tbbs tr td {
				text-align: center;
				border: 2px lightgrey double;
			}
		</style>
	</head>
	<body>
		<!--#include file="../inc/toolbar.inc"-->
		<div id='dmain' style="width: 1260px;">
			<div class="dview" id="dview" style="float: left; width:32%;" >
				<table class="tview" id="tview" border="1" cellpadding='2' cellspacing='0' style="background-color: #FFFF66;">
					<tr>
						<td align="center" style="width:5%"><a id='vewChk'> </a></td>
						<td align="center" style="width:20%"><a id='vewDatea'> </a></td>
						<td align="center" style="width:25%"><a id='vewTgg_xy'>廠商簡稱</a></td>
					</tr>
					<tr>
						<td><input id="chkBrow.*" type="checkbox" style=' '/></td>
						<td align="center" id='datea'>~datea</td>
						<td align="center" id='comp'>~comp</td>
					</tr>
				</table>
			</div>
			<div class='dbbm' style="width: 68%;float:left">
				<table class="tbbm" id="tbbm" border="0" cellpadding='2' cellspacing='0'>
					<tr class="tr1">
						<td class='td1'><span> </span><a id="lblItype" class="lbl"> </a></td>
						<td class="td2"><select id="cmbItype" class="txt c1"> </select></td>
						<td class='td3'><span> </span><a id="lblDatea" class="lbl"> </a></td>
						<td class="td4"><input id="txtDatea" type="text" class="txt c1"/></td>
						<td class='td3'><span> </span><a id="lblNoa" class="lbl" > </a></td>
						<td class="td4"><input id="txtNoa" type="text" class="txt c1"/></td>
					</tr>
					<tr class="tr4">
						<td class='td1'><span> </span><a id="lblTgg_xy" class="lbl btn">廠商簡稱</a></td>
						<td class="td2" colspan="3">
							<input id="txtTggno" type="text" class="txt c2"/>
							<input id="txtComp" type="text" class="txt c3"/>
						</td>
						<td class='td5'><span> </span><a id="lblOrdeno" class="lbl" > </a></td>
						<td class="td6"><input id="txtOrdeno" type="text" class="txt c1"/></td>
					</tr>
					<tr class="tr5">
						<td class="td1"><span> </span><a id="lblStore" class="lbl btn" > </a></td>
						<td class="td2" colspan="3">
							<input id="txtStoreno" type="text" class="txt c2"/>
							<input id="txtStore" type="text" class="txt c3"/>
						</td>
						<td class='td5'> <input id="btnCub" type="button" value='製令單匯入'  style="float:right;"/></td>
					</tr>
					<!--<tr class="tr6">
						<td class="td1"><span> </span><a id="lblCardeal" class="lbl btn"> </a></td>
						<td class="td2" colspan="3">
							<input id="txtCardealno" type="text" class="txt c2"/>
							<input id="txtCardeal" type="text" class="txt c3"/>
						</td>
						<td class="td3"><span> </span><a id="lblCarno" class="lbl"> </a></td>
						<td class="td5">
							<input id="txtCarno" type="text" class="txt" style="width:75%;"/>
							<select id="combCarno" style="width: 20%;"> </select>
						</td>
					</tr>
					<tr class="tr6">
						<td class="td1"><span> </span><a id="lblTrantype" class="lbl"> </a></td>
						<td class="td2"><select id="cmbTrantype" class="txt c1"> </select></td>
						<td class='td5'><span> </span><a id="lblTranstyle" class="lbl" > </a></td>
						<td class="td6"><select id="cmbTranstyle" style="width: 100%;"> </select></td>
					</tr>
					<tr class="tr8">
						<td class="td3"><span> </span><a id="lblPrice" class="lbl"> </a></td>
						<td class="td4"><input id="txtPrice" type="text" class="txt num c1" /></td>
						<td class="td5"><span> </span><a id="lblTranmoney" class="lbl"> </a></td>
						<td class="td6"><input id="txtTranmoney" type="text" class="txt num c1" /></td>
					</tr>-->
					<tr>
						<td class="td1"><span> </span><a id="lblTotal" class="lbl"> </a></td>
						<td class="td2"><input id="txtTotal" type="text" class="txt num c1" /></td>
						<td class='td3'><span> </span><a id="lblWorker" class="lbl"> </a></td>
						<td class="td4"><input id="txtWorker" type="text" class="txt c1"/></td>	
						<td class='td3'><span> </span><a id="lblWorker2" class="lbl"> </a></td>
						<td class="td4"><input id="txtWorker2" type="text" class="txt c1"/></td>					
					</tr>
					<tr class="tr9">
						<td class='td1'><span> </span><a id="lblMemo" class="lbl"> </a></td>
						<td class="td2" colspan='5'><textarea id="txtMemo" cols="10" rows="5" style="width: 99%;height: 50px;"> </textarea></td>
					</tr>
				</table>
			</div>
		</div>
		<div class='dbbs' style="width: 1260px;">
			<table id="tbbs" class='tbbs' border="1" cellpadding='2' cellspacing='1' >
				<tr style='color:White; background:#003366;' >
					<td align="center" style="width:1%;">
						<input class="btn" id="btnPlus" type="button" value='＋' style="font-weight: bold;" />
					</td>
					<td align="center" style="width:13%;"><a id='lblProductno_s'> </a></td>
					<td align="center" style="width:20%;"><a id='lblProduct_s'> </a> <a>/</a> <a id='lblSpec' class="isSpec"> </a></td>
					<td align="center" style="width:6%;"><a id='lblUnit_s'> </a></td>
					<td align="center" style="width:9%;"><a id='lblMount_s'> </a></td>
					<td align="center" style="width:9%;"><a id='lblPrice_s'> </a></td>
					<td align="center" style="width:10%;"><a id='lblTotal_s'> </a></td>
					<td align="center"><a id='lblMemo_st'> </a></td>
					<td align="center" style="width:10%;"><a id='lblCust_s'>客戶簡稱</a></td>
					<td align="center" style="width:10%;"><a id='lblRc2no_s'>製令單號</a></td>
				</tr>
				<tr style='background:#cad3ff;'>
					<td><input class="btn" id="btnMinus.*" type="button" value='－' style=" font-weight: bold;" /></td>
					<td>
						<input id="txtProductno.*" type="text" style="width:80%;" />
						<input class="btn" id="btnProductno.*" type="button" value='.' style="width:1%;" />
					</td>
					<td>
						<input class="txt c1" id="txtProduct.*" type="text" />
						<input class="txt c1" id="txtSpec.*" type="text"/>
					</td>
					<td><input class="txt c1" id="txtUnit.*" type="text"/></td>
					<td><input class="txt num c1" id="txtMount.*" type="text" /></td>
					<td><input class="txt num c1" id="txtPrice.*" type="text" /></td>
					<td><input class="txt num c1" id="txtTotal.*" type="text" /></td>
					<td>
						<input class="txt c1" id="txtMemo.*" type="text" />
						<input id="txtNoq.*" type="text" style="display:none;" />
						<input id="recno.*" type="text" style="display:none;" />
					</td>
					<td>
						<input class="txt c1" id="txtNamea.*" type="text" />
						<input class="txt c1" id="txtSssno.*" type="hidden" />
					</td>
					<td><input class="txt c1" id="txtRc2no.*" type="text"/></td>
				</tr>
			</table>
		</div>
		<input id="q_sys" type="hidden" />
	</body>
</html>