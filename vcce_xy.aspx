<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr">
	<head>
		<title></title>
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

			q_desc = 1;
			q_tables = 's';
			var q_name = "vcce";
			var q_readonly = ['txtNoa', 'txtWorker', 'txtWorker2', 'txtComp', 'txtAcomp', 'txtSales','txtDriver','txtCardeal','txtWeight','txtTotal'];
			var q_readonlys = ['txtCustno','txtComp','txtOrdeno','txtOdate','txtAdjweight','txtEcount'];
			var bbmNum = [['txtWeight', 15, 0, 1],['txtTotal', 15, 0, 1]];
			var bbsNum = [['txtAdjcount', 10, 0, 1], ['txtAdjweight', 10, 0, 1], ['txtEcount', 10, 0, 1]];
			var bbmMask = [];
			var bbsMask = [];
			q_sqlCount = 6;
			brwCount = 6;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'Datea';
			aPop = new Array(
				//['txtOrdeno', '', 'vcc', 'noa,custno,comp', 'txtOrdeno', ''],
				['txtSalesno', 'lblSaless', 'sss', 'noa,namea', 'txtSalesno,txtSales', 'sss_b.aspx'],
				['txtCno', 'lblAcomp', 'acomp', 'noa,acomp', 'txtCno,txtAcomp', 'acomp_b.aspx'],
				['txtDriverno', 'lblDriver', 'sss', 'noa,namea', 'txtDriverno,txtDriver', 'sss_b.aspx'],
				['txtCardealno', 'lblCardeal', 'cardeal', 'noa,comp', 'txtCardealno,txtCardeal', 'cardeal_b.aspx']
			);

			$(document).ready(function() {
				bbmKey = ['noa'];
				bbsKey = ['noa', 'noq'];
				q_brwCount();
				q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
				q_gt('acomp', 'stop=1 ', 0, 0, 0, "cno_acomp");
				q_gt('sss', "where=^^ typea='司機' ^^", 0, 0, 0, "driver_sss");
			});

			function main() {
				if (dataErr) {
					dataErr = false;
					return;
				}

				mainForm(1);
			}

			function mainPost() {
				q_getFormat();
				bbmMask = [['txtDatea', r_picd],['txtBdate', r_picd],['txtEdate', r_picd]];
				q_mask(bbmMask);

				$('#btnVccimport').click(function() {
					var t_post = $('#txtZip_post').val();
					var t_vccno = $('#txtOrdeno').val();
					var t_bdate = $('#txtBdate').val();
					var t_edate = $('#txtEdate').val();
					
					var t_where = "noa in (select noa from view_vccs where isnull(mount,0)-isnull(tranmoney2,0)>0 or isnull(tranmoney3,0)>0 and noa not in(select ordeno from view_vcces where isnull(enda,0)=0 and noa!='"+$('#txtNoa').val()+"' ) group by noa )";
					if(t_post.length>0)
						t_where+=" and left((case when isnull(post2,'')!='' then post2 else post end),"+t_post.length+")='"+t_post+"'";
					if(t_vccno.length>0)
						t_where+=" and noa='"+t_vccno+"'";
					if(t_edate==''){
						t_edate='999/99/99'
					}
					t_where+=" and (datea between '"+t_bdate+"' and '"+t_edate+"')";
					
					q_box("vcc_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'vcc', "95%", "95%", $('#btnVccimport').val());
				});

				$('#txtOrdeno').change(function() {
					var t_ordeno = trim($('#txtOrdeno').val());
					if (!emp(t_ordeno)) {
						var t_where = "where=^^ noa='" + t_ordeno + "' and noa in (select noa from view_vccs where isnull(mount,0)-isnull(tranmoney2,0)>0 or isnull(tranmoney3,0)>0 and noa not in(select ordeno from view_vcces where isnull(enda,0)=0 and noa!='"+$('#txtNoa').val()+"' ) group by noa )^^";
						q_gt('view_vcc', t_where, 0, 0, 0, "", r_accy);
					}
				});
				
				$('#txtDriverno').change(function() {
					var t_driverno = trim($('#txtDriverno').val());
					if (!emp(t_driverno)) {
						var t_where = "where=^^ driverno='" + t_driverno + "' and datea ='"+$('#txtDatea').val()+"' ^^";
						q_gt('vcce', t_where, 0, 0, 0, "driver_repeat", r_accy);
					}
				});
				
				$('#combDriver').change(function() {
					if(q_cur>0&&q_cur<4){
						$('#txtDriverno').val($('#combDriver').val())
						$('#txtDriver').val($('#combDriver').find("option:selected").text())
						var t_driverno = trim($('#txtDriverno').val());
						if (!emp(t_driverno)) {
							var t_where = "where=^^ driverno='" + t_driverno + "' and datea ='"+$('#txtDatea').val()+"' ^^";
							q_gt('vcce', t_where, 0, 0, 0, "driver_repeat", r_accy);
						}
					}
					$('#combDriver')[0].selectedIndex=0;
				});
			}

			function q_boxClose(s2) {
				var ret;
				switch (b_pop) {
					case 'vcc':
						if (q_cur > 0 && q_cur < 4) {
							if (!b_ret || b_ret.length == 0){
								b_pop = '';
								return;
							}
							//清除已存在bbs的資料
							for (var i = 0; i < b_ret.length; i++) {
								for (var j = 0; j < q_bbsCount; j++) {
	                                if (b_ret[i].noa==$('#txtOrdeno_'+j).val()) {
	                                    b_ret.splice(i, 1);
	                                    i--;
	                                    break;
	                                }
                                }
                                if(b_ret[i]!=undefined){
	                                if(b_ret[i].typea=='2'){
	                                	b_ret[i].total=-1*dec(b_ret[i].total);
	                                }
                                }
                            }
							
							ret = q_gridAddRow(bbsHtm, 'tbbs', 'txtOrdeno,txtCustno,txtComp,txtOdate,txtAdjweight,txtEcount', b_ret.length, b_ret, 'noa,custno,comp,datea,total,unpay', 'txtOrdeno');
						}
						sum();
						break;
					case q_name + '_s':
						q_boxClose2(s2);
						break;
				}
				b_pop = '';
			}

			var z_cno = r_cno, z_acomp = r_comp, z_nick = r_comp.substr(0, 2);
			function q_gtPost(t_name) {
				switch (t_name) {
					case 'driver_sss':
						var as = _q_appendData("sss", "", true);
						var t_item = " @ ";
						if (as[0] != undefined) {
							for ( i = 0; i < as.length; i++) {
								t_item = t_item + (t_item.length > 0 ? ',' : '') + as[i].noa + '@' + as[i].namea;
							}
						}
						q_cmbParse("combDriver", t_item);
						break;
					case 'driver_repeat':
						var as = _q_appendData("vcce", "", true);
						if (as[0] != undefined) {
							alert($('#txtDriverno').val()+' '+$('#txtDriver').val()+'在'+$('#txtDatea').val()+'已排派車 請確認是否重複派車!!');
						}
						break;
					case 'cno_acomp':
						var as = _q_appendData("acomp", "", true);
						if (as[0] != undefined) {
							z_cno = as[0].noa;
							z_acomp = as[0].acomp;
							z_nick = as[0].nick;
						}
						break;
					case 'view_vcc':
						var as_vcc = _q_appendData("view_vcc", "", true);
						if (as_vcc[0] != undefined){
							//清除已存在bbs的資料
							for (var i = 0; i < as_vcc.length; i++) {
								for (var j = 0; j < q_bbsCount; j++) {
	                                if (as_vcc[i].noa==$('#txtOrdeno_'+j).val()) {
	                                	alert('出貨資料已存在表身');
	                                    as_vcc.splice(i, 1);
	                                    i--;
	                                    break;
	                                }
                                }
								if(as_vcc[i].typea=='2'){
									as_vcc[i].total=-1*dec(as_vcc[i].total);
								}
                            }
							q_gridAddRow(bbsHtm, 'tbbs', 'txtOrdeno,txtCustno,txtComp,txtOdate,txtAdjweight,txtEcount', as_vcc.length, as_vcc, 'noa,custno,comp,datea,total,unpay', 'txtOrdeno');
						}else{
							alert('出貨單已派車或無出貨資料!!');
						}
						break;
					case q_name:
						if (q_cur == 4)
							q_Seek_gtPost();
						break;
				}
			}
			
			function q_stPost() {
				if (!(q_cur == 1 || q_cur == 2))
					return false;
				if (q_cur == 1 || q_cur == 2)
					q_func('qtxt.query.c0', 'vcce_xy.txt,post,' + r_accy + ';' + encodeURI($('#txtNoa').val())+ ';0');
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
				sum();

				var s1 = $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val();
				if (s1.length == 0 || s1 == "AUTO")
					q_gtnoa(q_name, replaceAll(q_getPara('sys.key_vcce') + $('#txtDatea').val(), '/', ''));
				else
					wrServer(s1);
			}

			function _btnSeek() {
				if (q_cur > 0 && q_cur < 4)
					return;

				q_box('vcce_xy_s.aspx', q_name + '_s', "500px", "460px", q_getMsg("popSeek"));
			}

			function bbsAssign() {
				for (var j = 0; j < q_bbsCount; j++) {
					if (!$('#btnMinus_' + j).hasClass('isAssign')) {
						$('#txtAdjcount_' + j).change(function() {
							sum();
						});
						$('#chkEnda_' + j).click(function() {
							t_IdSeq = -1;  /// 要先給  才能使用 q_bodyId()
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if($(this).prop('checked')){
								q_tr('txtAdjcount_'+b_seq,q_float('txtEcount_'+b_seq));
							}
							sum();
						});
					}
				}
				_bbsAssign();
				$('#chkEnda').click(function() {
					if(q_cur==1 || q_cur==2){
						if($('#chkEnda').prop('checked')){
							for (var j = 0; j < q_bbsCount; j++) {
								$('#chkEnda_'+j).prop('checked',true);
								q_tr('txtAdjcount_'+j,q_float('txtEcount_'+j));
							}
						}else{
							for (var j = 0; j < q_bbsCount; j++) {
								$('#chkEnda_'+j).prop('checked',false);
								q_tr('txtAdjcount_'+j,0);
							}
						}
						sum();
					}
				});
			}

			function btnIns() {
				_btnIns();
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val('AUTO');
				$('#txtCno').val(z_cno);
				$('#txtAcomp').val(z_acomp);
				$('#txtDatea').val(q_date());
				$('#txtCardealno').focus();
				$('#txtBdate').val(q_date());
				$('#txtEdate').val(q_date());
				
				$('#txtSalesno').val(r_userno);
				$('#txtSales').val(r_name);
			}

			function btnModi() {
				if (emp($('#txtNoa').val()))
					return;
				_btnModi();
				$('#txtBdate').val(q_date());
				$('#txtEdate').val(q_date());
				$('#txtDatea').focus();
			}

			function btnPrint() {
				t_where = "noa='" + $('#txtNoa').val() + "'";
				q_box("z_vcce_xyp.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, '', "95%", "95%", q_getMsg('popPrint'));
			}

			function wrServer(key_value) {
				var i;

				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
				_btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
				
			}

			function bbsSave(as) {
				if (!as['ordeno']) {
					as[bbsKey[1]] = '';
					return;
				}

				q_nowf();
				as['datea'] = abbm2['datea'];

				return true;
			}

			function sum() {
				var t_weight=0,t_total=0;
				for (var j = 0; j < q_bbsCount; j++) {
					if(!$('#chkEnda_'+j).prop('checked')){
						$('#txtAdjcount_'+j).val(0);
					}
					
					//t_weight=q_add(t_weight,q_float('txtAdjweight_'+j));
					t_weight=q_add(t_weight,q_float('txtEcount_'+j));
					t_total=q_add(t_total,q_float('txtAdjcount_'+j));
				}
				q_tr('txtWeight',t_weight);
				q_tr('txtTotal',t_total);
			}

			function refresh(recno) {
				_refresh(recno);
			}
			

			function readonly(t_para, empty) {
				_readonly(t_para, empty);
				if(t_para){
					$('#chkEnda').attr('disabled', 'disabled');
					$('#btnVccimport').attr('disabled', 'disabled');
				}else{
					$('#chkEnda').removeAttr('disabled');
					$('#btnVccimport').removeAttr('disabled');
				}
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
				//_btnDele();
				if (!confirm(mess_dele))
					return;
				q_cur = 3;
				q_func('qtxt.query.c2', 'vcce_xy.txt,post,' + r_accy + ';' + encodeURI($('#txtNoa').val())+ ';0');
			}

			function btnCancel() {
				_btnCancel();
			}

			function q_popPost(s1) {
				switch (s1) {
					case 'txtDriverno':
						var t_driverno = trim($('#txtDriverno').val());
						if (!emp(t_driverno)) {
							var t_where = "where=^^ driverno='" + t_driverno + "' and datea ='"+$('#txtDatea').val()+"' ^^";
							q_gt('vcce', t_where, 0, 0, 0, "driver_repeat", r_accy);
						}
					break;
				}
			}
			
			function q_funcPost(t_func, result) {
				switch(t_func) {
					case 'qtxt.query.c0':
						q_func('qtxt.query.c1', 'vcce_xy.txt,post,' + r_accy + ';' + encodeURI($('#txtNoa').val())+';1');
						break;
					case 'qtxt.query.c1':
						
						break;
					case 'qtxt.query.c2':
						_btnOk($('#txtNoa').val(), bbmKey[0],'', '', 3)
						break;
						
				}
			}

		</script>
		<style type="text/css">
			#dmain {
			}
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
				/*width: 9%;*/
			}
			.tbbm .tdZ {
				width: 3%;
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
				width: 97%;
				float: left;
			}
			.txt.c2 {
				width: 40%;
				float: left;
			}
			.txt.c3 {
				width: 26%;
				float: left;
			}
			.txt.c4 {
				width: 25%;
				float: left;
			}
			.txt.c5 {
				width: 60%;
				float: left;
			}
			.txt.c6 {
				width: 25%;
			}
			.txt.c7 {
				width: 98%;
				float: left;
			}
			.txt.c8 {
				float: left;
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
				width: auto;
			}
			.tbbm select {
				border-width: 1px;
				padding: 0px;
				margin: -1px;
				font-size: medium;
			}
			.dbbs {
				width: 100%;
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
			.tbbs {
				FONT-SIZE: medium;
				COLOR: blue;
				TEXT-ALIGN: left;
				BORDER: 1PX LIGHTGREY SOLID;
				width: 100%;
				height: 98%;
			}
		</style>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();">
		<!--#include file="../inc/toolbar.inc"-->
		<div id='dmain' style="width: 1260px;">
			<div class="dview" id="dview" style="float: left;  width:32%;"  >
				<table class="tview" id="tview"   border="1" cellpadding='2'  cellspacing='0' style="background-color: #FFFF66;">
					<tr>
						<td align="center" style="width:5%"><a id='vewChk'> </a></td>
						<td align="center" style="width:20%"><a id='vewDatea'> </a></td>
						<td align="center" style="width:30%"><a id='vewNoa'> </a></td>
						<td align="center" style="width:25%">司機</td>
						<td align="center" style="width:20%">車號</td>
					</tr>
					<tr>
						<td><input id="chkBrow.*" type="checkbox" style=' '/></td>
						<td align="center" id='datea'>~datea</td>
						<td align="center" id='noa'>~noa</td>
						<td align="center" id='driver'>~driver</td>
						<td align="center" id='carno'>~carno</td>
					</tr>
				</table>
			</div>
			<div class='dbbm' style="width: 68%;float:left">
				<table class="tbbm"  id="tbbm"   border="0" cellpadding='2'  cellspacing='0'>
					<tr class="tr0" style="height: 0px;">
						<td class="td1" style="width: 120px;"> </td>
						<td class="td2" style="width: 105px;"> </td>
						<td class="td3" style="width: 105px;"> </td>
						<td class="td4" style="width: 105px;"> </td>
						<td class="td5" style="width: 105px;"> </td>
						<td class="td6" style="width: 105px;"> </td>
						<td class="td7" style="width: 105px;"> </td>
						<td class="td8" style="width: 105px;"> </td>
					</tr>
					<tr class="tr1">
						<td class="td1"><span> </span><a id="lblDatea" class="lbl"> </a></td>
						<td class="td2"><input id="txtDatea"  type="text" class="txt c1"/></td>
						<td class="td3"><span> </span><a id="lblNoa" class="lbl"> </a></td>
						<td class="td4" colspan="2"><input id="txtNoa"  type="text" class="txt c1"/></td>
					</tr>
					<tr class="tr2">
						<td class="td1"><span> </span><a id="lblAcomp" class="lbl btn"> </a></td>
						<td class="td2"><input id="txtCno"  type="text" class="txt c1"/></td>
						<td class="td3" colspan="3"><input id="txtAcomp"  type="text" class="txt c7"/></td>
						<td class="td6"><span> </span><a id="lblSaless" class="lbl btn">派車人員 </a></td>
						<td class="td7"><input id="txtSalesno"  type="text" class="txt c1"/></td>
						<td class="td8"><input id="txtSales"  type="text" class="txt c1"/></td>
					</tr>
					<tr class="tr3">
						<td class="td1"><span> </span><a id="lblCardeal" class="lbl btn"> </a></td>
						<td class="td2"><input id="txtCardealno"  type="text" class="txt c1"/></td>
						<td class="td3" colspan="3"><input id="txtCardeal"  type="text" class="txt c7"/></td>
					</tr>
					<tr class="tr4">
						<td class="td1"><span> </span><a id="lblDriver" class="lbl btn"> </a></td>
						<td class="td2">
							<input id="txtDriverno"  type="text" class="txt c1" style="width: 85px;"/>
							<select id="combDriver" class="txt c1" style="width: 20px"> </select>
						</td>
						<td class="td3"><input id="txtDriver"  type="text" class="txt c1"/></td>
						<td class="td4"><span> </span><a id="lblCarno" class="lbl"> </a></td>
						<td class="td5"><input id="txtCarno"  type="text" class="txt c1"/></td>
					</tr>
					<tr class="tr5">
						<td class="td1"><span> </span> <a class="lbl"> 出貨單號</a></td>
						<td class="td2" colspan="2"><input id="txtOrdeno"  type="text" class="txt c1"/></td>
						<td class="td4"><span> </span><a class="lbl">郵遞區號</a></td>
						<td class="td5"><input id="txtZip_post"  type="text" class="txt c1"/></td>
					</tr>
					<tr class="tr5">
						<td class="td1"><span> </span> <a class="lbl">出貨日期</a></td>
						<td class="td2" colspan="2">
							<input id="txtBdate"  type="text" class="txt c2"/><a style="float: left;">~</a>
							<input id="txtEdate"  type="text" class="txt c2"/>
						</td>
						<td class="td4" colspan="2"><input id="btnVccimport" type="button" value="出貨、庫出匯入"/></td>
					</tr>
					<tr class="tr6">
						<td class="td1"><span> </span><a id="lblMemo" class="lbl"> </a></td>
						<td class="td2" colspan="8"><textarea id="txtMemo" cols="5" rows="10" style="width: 99%;height: 50px;"> </textarea></td>
					</tr>
					<tr class="tr7">
						<td class="td1"><span> </span><a class="lbl">應收金額</a></td>
						<td class="td2"><input id="txtWeight" type="text" class="txt num c1" /></td>
						<td class="td3"><span> </span><a class="lbl">收款金額</a></td>
						<td class="td4"><input id="txtTotal" type="text" class="txt num c1" /></td>
						<td class="td5"><span> </span><a id='lblWorker' class="lbl"> </a></td>
						<td class="td6"><input id="txtWorker" type="text" class="txt c1" /></td>
						<td class="td7"><span> </span><a id='lblWorker2' class="lbl"> </a></td>
						<td class="td8"><input id="txtWorker2" type="text" class="txt c1" /></td>
					</tr>
				</table>
			</div>
			<div class='dbbs' >
				<table id="tbbs" class='tbbs'  border="1"  cellpadding='2' cellspacing='1'  >
					<tr style='color:White; background:#003366;' >
						<td align="center">
							<input class="btn"  id="btnPlus" type="button" value='+' style="font-weight: bold;"  />
						</td>
						<td align="center" style="width:10%;">客戶編號</td>
						<td align="center" style="width:18%;">客戶名稱</td>
						<td align="center" style="width:10%;">出貨單號</td>
						<td align="center" style="width:10%;">出貨日期</td>
						<td align="center" style="width:10%;">出貨金額</td>
						<td align="center" style="width:10%;">未收金額</td>
						<td align="center" style="width:6%;">已送貨<input id="chkEnda" type="checkbox"/></td>
						<td align="center" style="width:10%;">已收金額</td>
						<td align="center"><a id='lblMemo_s'> </a></td>
					</tr>
					<tr style='background:#cad3ff;'>
						<td style="width:1%;">
							<input class="btn"  id="btnMinus.*" type="button" value='-' style=" font-weight: bold;" />
							<input id="txtNoq.*" type="text" style="display:none;"/>
						</td>
						<td><input class="txt c1" id="txtCustno.*" type="text" /></td>
						<td><input class="txt c1" id="txtComp.*" type="text" /></td>
						<td><input class="txt c1" id="txtOrdeno.*" type="text" /></td>
						<td><input class="txt c1" id="txtOdate.*" type="text" /></td>
						<td><input class="txt num c1" id="txtAdjweight.*" type="text"/></td>
						<td><input class="txt num c1" id="txtEcount.*" type="text"/></td>
						<td align="center"><input id="chkEnda.*" type="checkbox"/></td>
						<td><input class="txt num c1" id="txtAdjcount.*" type="text" /></td>
						<td><input class="txt c1" id="txtMemo.*" type="text" /></td>
					</tr>
				</table>
			</div>
		</div>
		<input id="q_sys" type="hidden" />
	</body>
</html>