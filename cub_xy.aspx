<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr">
	<head>
		<title> </title>
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
			q_tables = 't';
			var q_name = "cub";
			var q_readonly = ['txtNoa','txtComp','txtProduct','txtSpec','txtWorker','txtWorker2'];
			var q_readonlys = ['txtDate2', 'txtOrdeno', 'txtNo2'];
			var q_readonlyt = [];
			var bbmNum = [['txtTotal',10,0,1]];
			var bbsNum = [];
			var bbtNum = [];
			var bbmMask = [];
			var bbsMask = [];
			var bbtMask = [];
			q_sqlCount = 6;
			brwCount = 6;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'noa';
			q_desc = 1;
			brwCount2 = 5;
			aPop = new Array(
				['txtOrdeno', '', 'view_ordes', 'noa,no2,productno,product,spec,mount,custno,comp,memo', 'txtOrdeno,txtNo2,txtProductno,txtProduct,txtSpec,txtTotal,txtCustno,txtComp,txtMemo', ''],
				['txtCustno', 'lblCust', 'cust', 'noa,comp', 'txtCustno,txtComp', 'cust_b.aspx'],
				['txtProductno', 'lblProduct', 'ucc', 'noa,product,spec', 'txtProductno,txtProduct,txtSpec', 'ucc_b.aspx'],
				['txtTggno_', '', 'tgg', 'noa,comp', 'txtTggno_,txtTgg_', ""],
				['txtProcessno_', 'btnProcessno_', 'process', 'noa,process,tggno,tgg', 'txtProcessno_,txtProcess_,txtTggno_,txtTgg_', 'process_b.aspx'],
				['txtProductno__', 'btnProductno__', 'ucc', 'noa,product', 'txtProductno__,txtProduct__', 'ucc_b.aspx']
			);

			$(document).ready(function() {
				bbmKey = ['noa'];
				bbsKey = ['noa', 'noq'];
				bbtKey = ['noa', 'noq'];
				q_brwCount();
				q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
				//取得類別
				//q_gt('cub_typea', '', 0, 0, 0, "cub_typea");
			});

			function main() {
				if (dataErr) {
					dataErr = false;
					return;
				}
				mainForm(0);
			}
			
			function currentData() {}
			currentData.prototype = {
				data : [],
				exclude : ['txtNoa','txtDatea','txtOrdeno','txtNo2','txtWorker','txtWorker2'],  //bbm
				excludes : [''], //bbs
				excludet : [''], //bbt
				copy : function() {
					this.data = new Array();
					for (var i in fbbm) {
						var isExclude = false;
						for (var j in this.exclude) {
							if (fbbm[i] == this.exclude[j] ) {
								isExclude = true;
								break;
							}
						}
						if (!isExclude ) {
							this.data.push({
								field : fbbm[i],
								value : $('#' + fbbm[i]).val()
							});
						}
					}
					//bbs
					for (var i in fbbs) {
						for(var j = 0; j < q_bbsCount; j++) {
							var isExcludes = false;
							for (var k in this.excludes) {
								if (fbbs[i] == this.excludes[k] ) {
									isExcludes = true;
									break;
								}
							}
							if (!isExcludes ) {
								this.data.push({
									field : fbbs[i]+'_'+j,
									value : $('#' + fbbs[i]+'_'+j).val()
								});
							}
						}
					}
					//bbt
					for (var i in fbbt) {
						for(var j = 0; j < q_bbtCount; j++) {
							var isExcludet = false;
							for (var k in this.excludet) {
								if (fbbt[i] == this.excludet[k] ) {
									isExcludet = true;
									break;
								}
							}
							if (!isExcludet ) {
								this.data.push({
									field : fbbt[i]+'__'+j,
									value : $('#' + fbbt[i]+'__'+j).val()
								});
							}
						}
					}
				},
				/*貼上資料*/
				paste : function() {
					for (var i in this.data) {
					   	$('#' + this.data[i].field).val(this.data[i].value);
				   	}
				}
			};
			var curData = new currentData();

			function sum() {
				for (var j = 0; j < q_bbsCount; j++) {
					var t_dime = dec($('#txtDime_' + j).val());
					$('#txtBdime_' + j).val(round(q_mul(t_dime, 0.93), 2));
					$('#txtEdime_' + j).val(round(q_mul(t_dime, 1.07), 2));
				}
			}

			function mainPost() {
				q_getFormat();
				bbmMask = [['txtDatea', r_picd], ['txtBdate', r_picd], ['txtEdate', r_picd]];
				bbsMask = [['txtDate2', r_picd], ['txtDatea', r_picd]];
				q_mask(bbmMask);
				bbsNum = [['txtMount', 15, q_getPara('vcc.mountPrecision'), 1]];
				bbtNum = [['txtMount', 15, q_getPara('vcc.mountPrecision'), 1]];
				
				q_cmbParse("combTypea", '西餐紙,火柴,筷子套,刀叉套,比薩盒,蛋糕盒,店卡,名片,餐盒,聯單,背心袋,炸雞盤,薯條杯,雜類,炸雞盒,紙袋,手提紙袋,瓦楞紙,帽子,桌巾紙,紙盒,公文袋,牙千套,紙包吸,紙包可吸,紙包可彩吸,紙包彩吸,紙包白色吸,白色吸,其他');
				
				//$('title').text("連續製令單"); //IE8會有問題
				document.title='連續製令單'
				
				$('#btnOrdes').click(function() {
					var t_custno = trim($('#txtCustno').val());
					var t_where = '';
					if (t_custno.length > 0) {
						t_where = " isnull(enda,0)!=1 and isnull(cancel,0)!=1";
						t_where += " and left(productno,2)!='##' and left(custno,2)!='##' ";//非正式編號
						t_where += " and custno='"+t_custno+"'";
						//只有印刷才會進來 印刷編號=客戶編號-流水號
						t_where += " and charindex('"+t_custno+"-',productno)=1 ";
						if (!emp($('#txtOrdeno').val()))
							t_where += " and charindex(noa,'" + $('#txtOrdeno').val() + "')>0 ";
						t_where = t_where;
					} else {
						alert('請輸入客戶編號!!');
						return;
					}
					q_box("ordes_b_xy.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'ordes', "95%", "650px", q_getMsg('popOrde'));
				});
			}

			function q_gtPost(t_name) {
				switch (t_name) {
					/*case 'cub_typea':
						var as = _q_appendData("view_cub", "", true);
						if (as[0] != undefined) {
		                    var t_item = "";
		                    for (i = 0; i < as.length; i++) {
		                        t_item = t_item + (t_item.length > 0 ? ',' : '') + as[i].typea;
		                    }
		                    q_cmbParse("combTypea", t_item, '');
		                }
						break;*/
					case q_name:
						if (q_cur == 4)
							q_Seek_gtPost();
						break;
				}
			}

			function q_stPost() {
				if (!(q_cur == 1 || q_cur == 2))
					return false;
			}

			function q_boxClose(s2) {
				var ret;
				switch (b_pop) {
					case 'ordes':
						if (q_cur > 0 && q_cur < 4) {
							if (!b_ret || b_ret.length == 0){
								b_pop = '';
								return;
							}else{
								$('#txtCustno').val(b_ret[0].custno);
								$('#txtComp').val(b_ret[0].comp);
								$('#txtOrdeno').val(b_ret[0].noa);
								$('#txtNo2').val(b_ret[0].no2);
								$('#txtProductno').val(b_ret[0].productno);
								$('#txtProduct').val(b_ret[0].product);
								$('#txtSpec').val(b_ret[0].spec);
								$('#txtTotal').val(b_ret[0].mount);
								$('#txtMemo').val(b_ret[0].memo);
							}
						}
						break;
					case 'bbs_tgg':
						if (q_cur > 0 && q_cur < 4) {
							if (!b_ret || b_ret.length == 0){
								b_pop = '';
								return;
							}else{
								$('#txtTggno_'+b_seq).val(b_ret[0].noa);
								$('#txtTgg_'+b_seq).val(b_ret[0].comp);
							}
						}
						break;
					case q_name + '_s':
						q_boxClose2(s2);
						break;
				}
				b_pop = '';
			}

			function _btnSeek() {
				if (q_cur > 0 && q_cur < 4)
					return;
					
				q_box('cub_xy_s.aspx', q_name + '_s', "500px", "400px", q_getMsg("popSeek"));
			}

			function btnIns() {
				if($('#checkCopy').is(':checked'))
            		curData.copy();
                	_btnIns();
            	if($('#checkCopy').is(':checked'))
	                curData.paste();
				$('#txtNoa').val('AUTO');
				$('#txtDatea').val(q_date());
				$('#txtDatea').focus();
			}

			function btnModi() {
				if (emp($('#txtNoa').val()))
					return;
				_btnModi();
				$('#txtDatea').focus();
			}

			function btnPrint() {
				q_box('z_cub_xyp.aspx' + "?;;;noa=" + trim($('#txtNoa').val()) + ";" + r_accy, '', "95%", "95%", q_getMsg("popPrint"));
			}

			function btnOk() {
				if ($('#txtDatea').val().length == 0 || !q_cd($('#txtDatea').val())) {
					alert(q_getMsg('lblDatea') + '錯誤。');
					return;
				}
				sum();
				if(q_cur==1)
					$('#txtWorker').val(r_name);
				else
					$('#txtWorker2').val(r_name);

				var t_noa = trim($('#txtNoa').val());
				var t_date = trim($('#txtDatea').val());
				if (t_noa.length == 0 || t_noa == "AUTO")
					q_gtnoa(q_name, replaceAll(q_getPara('sys.key_cub') + (t_date.length == 0 ? q_date() : t_date), '/', ''));
				else
					wrServer(t_noa);
			}

			function wrServer(key_value) {
				var i;
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
				_btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
			}

			function bbsSave(as) {
				if (!as['tggno']) {
					as[bbsKey[1]] = '';
					return;
				}
				q_nowf();
				as['noa'] = abbm2['noa'];
				return true;
			}

			function bbtSave(as) {
				if (!as['productno']) {
					as[bbtKey[1]] = '';
					return;
				}
				q_nowf();
				return true;
			}

			function refresh(recno) {
				_refresh(recno);
				//取得類別
				//q_gt('cub_typea', '', 0, 0, 0, "cub_typea");
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

			function btnPlut(org_htm, dest_tag, afield) {
				_btnPlus(org_htm, dest_tag, afield);
			}

			function bbsAssign() {
				for (var i = 0; i < q_bbsCount; i++) {
					$('#lblNo_' + i).text(i + 1);
					if (!$('#btnMinus_' + i).hasClass('isAssign')) {
						$('#btnTggno_'+i).click(function() {
							t_IdSeq = -1;  /// 要先給  才能使用 q_bodyId()
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							t_where = "noa in (select tggno from processs where noa='"+$('#txtProcessno_'+b_seq).val()+"') or noa='"+$('#txtTggno_'+b_seq).val()+"'";
							q_box("tgg_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'bbs_tgg', "500px", "680px", "");
						});
					}
				}
				_bbsAssign();
			}

			function bbtAssign() {
				for (var i = 0; i < q_bbtCount; i++) {
					$('#lblNo__' + i).text(i + 1);
					if (!$('#btnMinut__' + i).hasClass('isAssign')) {
					}
				}
				_bbtAssign();
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

			function onPageError(error) {
				alert("An error occurred:\r\n" + error.Message);
			}
			
	        var orde_no2='',orde_pno='',orde_product='',orde_custno='',orde_comp='',orde_pop=true;
	        function q_popPost(s1) {
			   	switch (s1) {
			        case 'txtOrdeno':
			        	if(orde_pop){
			        		orde_no2=$('#txtNo2').val();
			        		orde_custno=$('#txtCustno').val();
			        		orde_comp=$('#txtComp').val();
			        		orde_pno=$('#txtProductno').val();
			        		orde_product=$('#txtProduct').val();
			        		orde_pop=false;
			        	}else{
			        		orde_pop=true;
			        		$('#txtNo2').val(orde_no2);
			        		$('#txtCustno').val(orde_custno);
			        		$('#txtComp').val(orde_comp);
			        		$('#txtProductno').val(orde_pno);
			        		$('#txtProduct').val(orde_product);
			        	}
			   			
			        break;
			   	}
			}
			
			function combTypea_chg() {
				var cmb = document.getElementById("combTypea");
				if (!q_cur)
					cmb.value = '';
				else
					$('#txtTypea').val(cmb.value);
				cmb.value = '';
			}
		</script>
		<style type="text/css">
			#dmain {
				/*overflow: hidden;*/
			}
			.dview {
				float: left;
				border-width: 0px;
			}
			.tview {
				border: 5px solid gray;
				font-size: medium;
				background-color: black;
			}
			.tview tr {
				height: 30px;
			}
			.tview td {
				padding: 2px;
				text-align: center;
				border-width: 0px;
				background-color: #FFFF66;
				color: blue;
			}
			.dbbm {
				float: left;
				width: 70%;
				/*margin: -1px;
				 border: 1px black solid;*/
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
				width: 1%;
			}
			.tbbm tr td span {
				float: right;
				display: block;
				width: 5px;
				height: 10px;
			}
			.tbbm tr td .lbl {
				float: right;
				color: black;
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

			.num {
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
			input[type="text"], input[type="button"] {
				font-size: medium;
			}
			.dbbs {
				width: 1260px;
			}
			.dbbs .tbbs {
				margin: 0;
				padding: 2px;
				border: 2px lightgrey double;
				border-spacing: 1;
				border-collapse: collapse;
				font-size: medium;
				color: blue;
				/*background: #cad3ff;*/
				background: lightgrey;
				width: 100%;
			}
			.dbbs .tbbs tr {
				height: 35px;
			}
			.dbbs .tbbs tr td {
				text-align: center;
				border: 2px lightgrey double;
			}
			.dbbs .tbbs select {
				border-width: 1px;
				padding: 0px;
				margin: -1px;
				font-size: medium;
			}
			#dbbt {
				width: 1000px;
			}
			#tbbt {
				margin: 0;
				padding: 2px;
				border: 2px pink double;
				border-spacing: 1;
				border-collapse: collapse;
				font-size: medium;
				color: blue;
				background: pink;
				width: 100%;
			}
			#tbbt tr {
				height: 35px;
			}
			#tbbt tr td {
				text-align: center;
				border: 2px pink double;
			}
		</style>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	>
		<!--#include file="../inc/toolbar.inc"-->
		<div id='dmain'>
			<div class="dview" id="dview" >
				<table class="tview" id="tview" >
					<tr>
						<td style="width:20px; color:black;"><a id='vewChk'> </a></td>
						<td style="width:80px; color:black;"><a id='vewNoa'> </a></td>
						<td style="width:100px; color:black;"><a id='vewDatea'> </a></td>
						<td style="width:100px; color:black;"><a id='vewComp'>客戶 </a></td>
					</tr>
					<tr>
						<td><input id="chkBrow.*" type="checkbox" style=''/></td>
						<td id='noa' style="text-align: center;">~noa</td>
						<td id='datea' style="text-align: center;">~datea</td>
						<td id='comp,4' style="text-align: center;">~comp,4</td>
					</tr>
				</table>
			</div>
			<div class='dbbm'>
				<table class="tbbm" id="tbbm">
					<tr style="height:1px;">
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td class="tdZ"> </td>
					</tr>
					<tr>
						<td><span> </span><a id="lblDatea" class="lbl"> </a></td>
						<td><input id="txtDatea" type="text" class="txt c1"/></td>
						<td><span> </span><a class="lbl">類別</a></td>
						<td>
							<input id="txtTypea" type="text" class="txt c1" style="width: 85%;"/>
							<select id="combTypea" class="txt" style="width: 15%;" onchange='combTypea_chg()'> </select>
						</td>
						<td><span> </span><a id="lblNoa" class="lbl"> </a></td>
						<td><input id="txtNoa" type="text" class="txt c1"/></td>
						<td>
							<input id="checkCopy" type="checkbox" style="float:left;"/>
							<span> </span><a id='lblCopy' class="lbl" style="float:left;"> </a>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id="lblCust" class="lbl btn" >客戶</a></td>
						<td><input id="txtCustno" type="text" class="txt c1"/></td>
						<td colspan="2"><input id="txtComp" type="text" class="txt c1"/></td>
						<td> <input id="btnOrdes" type="button" value='訂單匯入'  style="float:right;"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblOrdeno" class="lbl" >訂單編號</a></td>
						<td><input id="txtOrdeno" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblNo2" class="lbl" >訂序</a></td>
						<td><input id="txtNo2" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblProduct" class="lbl btn" >製成品</a></td>
						<td><input id="txtProductno" type="text" class="txt c1"/></td>
						<td colspan="2"><input id="txtProduct" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblSpec" class="lbl" >規格</a></td>
						<td colspan="3"><input id="txtSpec" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblMount" class="lbl" >數量</a></td>
						<td><input id="txtTotal" type="text" class="txt num c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblMemo" class="lbl" > </a></td>
						<td colspan="3"><input id="txtMemo" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblWorker" class="lbl" > </a></td>
						<td><input id="txtWorker" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblWorker2" class="lbl" > </a></td>
						<td><input id="txtWorker2" type="text" class="txt c1"/></td>
					</tr>
				</table>
			</div>
			<div class='dbbs'>
				<table id="tbbs" class='tbbs'>
					<tr style='color:white; background:#003366;' >
						<td style="width:20px;">
							<input id="btnPlus" type="button" style="font-size: medium; font-weight: bold;" value="＋"/>
						</td>
						<td style="width:20px;"> </td>
						<td style="width:100px;"><a id='lblProcessno_s'>製程編號</a></td>
						<td style="width:150px;"><a id='lblProcess'>製程名稱</a></td>
						<td style="width:150px;"><a id='lblTggno_s'>廠商編號</a></td>
						<td style="width:180px;"><a id='lblTgg'>廠商名稱</a></td>
						<td style="width:120px;"><a id='lblMount'>數量</a></td>
						<td style="width:150px;"><a id='lblNeed'>製造要求</a></td>
						<td style="width:150px;"><a id='lblMemo_s'>備註</a></td>
					</tr>
					<tr style='background:#cad3ff;'>
						<td align="center">
							<input id="btnMinus.*" type="button" style="font-size: medium; font-weight: bold;" value="－"/>
							<input id="txtNoq.*" type="text" style="display: none;"/>
						</td>
						<td><a id="lblNo.*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
						<td>
							<input id="txtProcessno.*" type="text" class="txt c1" style="width: 75%;"/>
							<input class="btn"  id="btnProcessno.*" type="button" value='.' style=" font-weight: bold;" />
						</td>
						<td><input id="txtProcess.*" type="text" class="txt c1"/></td>
						<td>
							<input id="txtTggno.*" type="text" class="txt c1" style="width: 83%;"/>
							<input class="btn"  id="btnTggno.*" type="button" value='.' style=" font-weight: bold;" />
						</td>
						<td><input id="txtTgg.*" type="text" class="txt c1"/></td>
						<td><input id="txtMount.*" type="text" class="txt c1 num"/></td>
						<td><input id="txtNeed.*" type="text" class="txt c1"/></td>
						<td><input id="txtMemo.*" type="text" class="txt c1"/></td>
					</tr>
				</table>
			</div>
		</div>
		<input id="q_sys" type="hidden" />
		<div id="dbbt" class='dbbt'>
			<table id="tbbt" class="tbbt">
				<tr class="head" style="color:white; background:#003366;">
					<td style="width:20px;">
						<input id="btnPlut" type="button" style="font-size: medium; font-weight: bold;" value="＋"/>
					</td>
					<td style="width:20px;"> </td>
					<td style="width:120px; text-align: center;">原料編號</td>
					<td style="width:180px; text-align: center;">原料名稱</td>
					<td style="width:100px; text-align: center;">數量</td>
					<td style="width:200px; text-align: center;">備註</td>
				</tr>
				<tr>
					<td>
						<input id="btnMinut..*" type="button" style="font-size: medium; font-weight: bold;" value="－"/>
						<input class="txt" id="txtNoq..*" type="text" style="display: none;"/>
					</td>
					<td><a id="lblNo..*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
					<td>
						<input id="txtProductno..*" type="text" class="txt c1" style="width: 85%;"/>
						<input class="btn"  id="btnProductno..*" type="button" value='.' style=" font-weight: bold;" />
					</td>
					<td><input id="txtProduct..*" type="text" class="txt c1"/></td>
					<td><input id="txtMount..*" type="text" class="txt c1 num"/></td>
					<td><input id="txtMemo..*" type="text" class="txt c1"/></td>
				</tr>
			</table>
		</div>
	</body>
</html>