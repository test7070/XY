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
			function onPageError(error) {
				alert("An error occurred:\r\n" + error.Message);
			}
			q_desc=1;
			q_tables = 's';
			var q_name = "cont";
			var q_readonly = ['txtNoa', 'txtWorker', 'txtWorker2','txtTotal'];
			var q_readonlys = ['txtNoq','txtTotal'];
			var bbmNum = [['txtTotal', 15, 0, 1]];
			var bbsNum = [['txtMount', 10, 0, 1],['txtPrice', 10, 2, 1],['txtTotal', 15, 0, 1]];
			var bbmMask = [];
			var bbsMask = [];
			q_sqlCount = 6;
			brwCount = 6;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'Datea';
			aPop = new Array( ['txtCustno', 'lblCustno_xy', 'cust', 'noa,comp', 'txtCustno,txtComp', 'cust_b.aspx']
							 ,['txtProductno_', 'btnProduct_', 'ucc', 'noa,product,unit', 'txtProductno_,txtProduct_,txtUnit', 'ucaucc_b.aspx']
							 ,['txtSales', 'lblSales_xy', 'sss', 'namea,noa', 'txtSales,txtSalesno', 'sss_b.aspx']
							 ,['txtCno','lblCno_xy','acomp','noa,acomp','txtCno,txtAcomp','acomp_b.aspx']
							 
			);
			$(document).ready(function() {
				bbmKey = ['noa'];
				bbsKey =[ 'noa','noq'];
				q_brwCount();
				q_gt(q_name, q_content, q_sqlCount, 1, 0, '');
			});
			
			//////////////////   end Ready
			
			function sum() {
				var t_total=0;
				if(q_cur==1 || q_cur==2){
					for(var j = 0; j < q_bbsCount; j++) {
						$('#txtTotal_'+j).val(q_mul(dec($('#txtMount_'+j).val()),dec($('#txtPrice_'+j).val())));
						t_total=q_add(t_total,dec($('#txtTotal_'+j).val()));
					}
					$('#txtTotal').val(t_total);
				}
			}
			
			function main() {
				if(dataErr) {
					dataErr = false;
					return;
				}
				mainForm(1);
			}
			
			var z_cno='',z_acomp='',z_nick='';
			function mainPost() {
				document.title='PO管理作業';
				q_getFormat();
				bbmMask = [['txtEnddate', r_picd],['txtDatea', r_picd],['txtDatea', r_picd]];
				bbsMask = [['txtUcolor', r_picd]];
				q_mask(bbmMask);
				q_gt('acomp', 'stop=1', 0, 0, 0, "");
				q_cmbParse("cmbKind", 'PO,備貨'); 
				q_cmbParse("combClass",' ,便,印','s');
				
				$('#btnUpload').change(function() {
					if(emp($('#txtNoa').val()) || q_cur==1 || q_cur==2){
						return;
					}
					var file = $(this)[0].files[0];
					if(file){
						Lock(1);
						var ext = '';
						var extindex = file.name.lastIndexOf('.');
						if(extindex>=0){
							ext = file.name.substring(extindex,file.name.length);
						}
						$('#txtConn_acomp').val(file.name);
						$('#txtConn_cust').val(guid()+Date.now()+ext);
						
						fr = new FileReader();
						fr.fileName = $('#txtConn_cust').val();
					    fr.readAsDataURL(file);
					    fr.onprogress = function(e){
							if ( e.lengthComputable ) { 
								var per = Math.round( (e.loaded * 100) / e.total) ; 
								$('#FileList').children().last().find('progress').eq(0).attr('value',per);
							}; 
						}
						fr.onloadstart = function(e){
							$('#FileList').append('<div styly="width:100%;"><progress id="progress" max="100" value="0" ></progress><progress id="progress" max="100" value="0" ></progress><a>'+fr.fileName+'</a></div>');
						}
						fr.onloadend = function(e){
							$('#FileList').children().last().find('progress').eq(0).attr('value',100);
							console.log(fr.fileName+':'+fr.result.length);
							var oReq = new XMLHttpRequest();
							oReq.upload.addEventListener("progress",function(e) {
								if (e.lengthComputable) {
									percentComplete = Math.round((e.loaded / e.total) * 100,0);
									$('#FileList').children().last().find('progress').eq(1).attr('value',percentComplete);
								}
							}, false);
							oReq.upload.addEventListener("load",function(e) {
								Unlock(1);
							}, false);
							oReq.upload.addEventListener("error",function(e) {
								alert("資料上傳發生錯誤!");
							}, false);
								
							oReq.timeout = 360000;
							oReq.ontimeout = function () { alert("Timed out!!!"); }
							oReq.open("POST", 'cont_xy_upload.aspx', true);
							oReq.setRequestHeader("Content-type", "text/plain");
							oReq.setRequestHeader("FileName", escape(fr.fileName));
							oReq.send(fr.result);//oReq.send(e.target.result);
						};
					}
					ShowDownlbl();
				});
				
				$('#lblDownload').click(function(){
					if($('#txtConn_cust').val().length>0 && $('#txtConn_acomp').val().length>0){
						$('#xdownload').attr('src','cont_xy_download.aspx?FileName='+$('#txtConn_acomp').val()+'&TempName='+$('#txtConn_cust').val());
                    }else if($('#txtConn_cust').val().length>0){
						$('#xdownload').attr('src','cont_xy_download.aspx?FileName='+$('#txtNoa').val()+'&TempName='+$('#txtConn_cust').val());
                    }else{    
						alert('無資料...!!');
					}
				});
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
					case 'acomp':
						var as = _q_appendData("acomp", "", true);
						if(as[0]!=undefined){
							z_cno=as[0].noa;
							z_acomp=as[0].acomp;
							z_nick = as[0].nick;
						}
						break;
					case 'uccgb':
						//中類
						var as = _q_appendData("uccgb", "", true);
						if (as[0] != undefined) {
							var t_item = "@";
							for ( i = 0; i < as.length; i++) {
								t_item = t_item + (t_item.length > 0 ? ',' : '') + as[i].noa + '@'+ as[i].namea;
							}
							q_cmbParse("combGroupbno", t_item,'s');
						}
						break; 
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
				
				if($('#cmbKind').val()=='PO' && emp($('#txtContract').val())){
					alert('請輸入PO號碼!!');
					return;
				}
				
				if (q_cur == 1)
					$('#txtWorker').val(r_name);
				else
					$('#txtWorker2').val(r_name);
					
				var t_noa = trim($('#txtNoa').val());
				var t_date = trim($('#txtDatea').val());
				if (t_noa.length == 0 || t_noa == "AUTO")
					q_gtnoa(q_name, replaceAll(q_getPara('sys.key_cont') + (t_date.length == 0 ? q_date() : t_date), '/', ''));
				else
					wrServer(t_noa);
			}

			function _btnSeek() {
				if(q_cur > 0 && q_cur < 4)// 1-3
					return;
				q_box('cont_xy_s.aspx', q_name + '_s', "500px", "350px", q_getMsg("popSeek"));
			}

			function bbsAssign() {
				for(var j = 0; j < q_bbsCount; j++) {
					$('#lblNo_' + j).text(j + 1);
					$('#txtClass_'+j).focusout(function() {
						t_IdSeq = -1;
						q_bodyId($(this).attr('id'));
						b_seq = t_IdSeq;
						if(q_cur==1 || q_cur==2){
							if($('#txtClass_'+b_seq).val()=='印' || $('#txtClass_'+b_seq).val()=='便'){
								$('#combClass_' + b_seq).val($('#txtClass_'+b_seq).val());
							}else{
								$('#combClass_' + b_seq).val('');
							}
						}
					});
					$('#combClassa_' + j).focusout(function() {
						t_IdSeq = -1;
						q_bodyId($(this).attr('id'));
						b_seq = t_IdSeq;
						if(q_cur==1 || q_cur==2){
							$('#txtClassa_'+b_seq).val($('#combClassa_'+b_seq).val());
						}
					});
					
					$('#txtMount_'+j).focusout(function() {sum();});
					$('#txtPrice_'+j).focusout(function() {sum();});
				}
				_bbsAssign();
				ShowDownlbl();
			}

			function btnIns() {
				_btnIns();
				$('#txtNoa').val('AUTO');
				$('#txtDatea').val(q_date());
				$('#txtCno').val(z_cno);
				$('#txtAcomp').val(z_acomp);
				ShowDownlbl();
			}

			function btnModi() {
				if(emp($('#txtNoa').val()))
					return;
				_btnModi();
				ShowDownlbl();
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
				ShowDownlbl();
			}
			
			function readonly(t_para, empty) {
				_readonly(t_para, empty);
				if(t_para){
                 	$('#btnUpload').attr('disabled', 'disabled');
                }else{
                	$('#btnUpload').removeAttr('disabled', 'disabled');
                }
			}
			
			function ShowDownlbl() {				
				$('#lblDownload').text('').hide();
				if(!emp($('#txtConn_cust').val()))
					$(this).text('下載').show();
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
						<td align="center" style="width:80px; color:black;"><a id='vewContract_xy'>PO</a></td>
						<td align="center" style="width:100px; color:black;"><a id='vewComp_xy'>簽約客戶</a></td>
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
						<td style="width:12%";> </td>
						<td style="width:20%";> </td>
						<td style="width:12%";> </td>
						<td style="width:20%";> </td>
						<td style="width:12%";> </td>
						<td style="width:20%";> </td>
						<td style="width:4%"; > </td>
					</tr>
					<tr>
						<td  ><span> </span><a id="lblNoa_xy" class="lbl">單據編號</a></td>
						<td ><input  id="txtNoa" type="text" class="txt c1"/></td>
						<td  ><span> </span><a id="lblContract_xy" class="lbl">PO</a></td>
						<td ><input id="txtContract"  type="text"  class="txt c1"/></td>
						<td ><span> </span><a  id="lblKind_xy" class="lbl">簽約類型</a></td>
						<td><select id="cmbKind" class="txt c1"> </select></td>
					</tr>
					<tr>
						<td ><span> </span><a  id="lblCno_xy" class="lbl btn">公司</a></td>
						<td><input id="txtCno" type="text" class="txt c1"/></td>
						<td  colspan="2"><input id="txtAcomp" type="text" class="txt c1"></td>
						<td ><span> </span><a id="lblDatea_xy" class="lbl">簽約日期</a></td>
						<td><input id="txtDatea" type="text"  class="txt c1"/></td>
					</tr>
					<tr>
						<td ><span> </span><a  id="lblCustno_xy" class="lbl btn">簽約客戶</a></td>
						<td><input id="txtCustno" type="text" class="txt c1"/></td>
						<td colspan="2"><input id="txtComp" type="text" class="txt c1"/></td>
						<td><span> </span><a  id="lblUpload_xy" class="lbl">PO上傳</a></td>
						<td>
							<input type="file" id="btnUpload" value="選擇檔案" style="width: 98%;"/>
							<input id="txtConn_acomp" type="hidden" class="txt c1"/><!--原檔名-->
							<input id="txtConn_cust" type="hidden" class="txt c1"/><!--上傳檔名-->
						</td>
					</tr>
					<tr>
						<td ><span> </span><a id="lblSales_xy" class="lbl btn">業務</a></td>
						<td><input id="txtSalesno" type="text" class="txt c1"/></td>
						<td colspan="2"><input id="txtSales" type="text" class="txt c1"></td>
						<td> </td>
						<td><a id="lblDownload"> </a></td>
					</tr>
					<tr>
						<td ><span> </span><a id="lblTotal_xy" class="lbl">小計</a></td>
						<td><input id="txtTotal" type="text"  class="txt num c1"/></td>
						<td ><span> </span><a id="lblWorker" class="lbl"> </a></td>
						<td><input id="txtWorker" type="text"  class="txt c1"/></td>
						<td ><span> </span><a id="lblWorker2" class="lbl"> </a></td>
						<td><input id="txtWorker2" type="text"  class="txt c1"/></td>
					</tr>
					<tr style="display: none;">
						<td colspan="6"><div style="width:100%;" id="FileList"> </div></td>
					</tr>
				</table>
			</div>
		<div class='dbbs' style="width: 1260px;">
			<table id="tbbs" class='tbbs'  border="1"  cellpadding='2' cellspacing='1'  >
				  <tr style='color:White; background:#003366;' >
					<td align="center" style="width:1%;"><input class="btn"  id="btnPlus" type="button" value='＋' style="font-weight: bold;"  /> </td>
					<td style="width:20px;"> </td>
					<td align="center"  style="width:120px;"><a id='lblProductno_xy_s'>產品編號</a></td>
					<td align="center" style="width:110px;"><a id='lblProduct_xy_s'>產品</a></td>
					<td align="center" style="width:55px;"><a id='lblClass_xy_s'>版別</a></td>
					<td align="center" style="width:300px;"><a id='lblSpec_xy_s'>規格</a></td>
					<td align="center" style="width:40px;"><a id='lblUnit_xy_s'>單位</a></td>
					<td align="center" style="width:85px;"><a id='lblMount_xy_s'>數量</a></td>
					<td align="center" style="width:85px;"><a id='lblPrice_xy_s'>單價</a></td>
					<td align="center" style="width:100px;"><a id='lblTotal_xy_s'>小計</a></td>
					<td align="center" style="width:80px;"><a id='lblUcolor_xy_s'>有效日期</a></td>
					<td align="center"><a id='lblMemon_xy_s'>備註</a></td>
				</tr>
				<tr style='background:#cad3ff;'>
					<td align="center"><input class="btn" id="btnMinus.*" type="button" value='－' style=" font-weight: bold;" /></td>
					<td>
						<a id="lblNo.*" style="font-weight: bold;text-align: center;display: block;"> </a>
						<input id="txtNoq.*" type="hidden"  class="txt c1"/>
					</td>
					<td>
						<input id="txtProductno.*" type="text" class="txt c1" style="width: 75%;"/>
						<input id="btnProduct.*" type="button" class="btn" value='.' style=" font-weight: bold;" />
					</td>
					<td><input id="txtProduct.*" type="text" class="txt c1"/></td>
					<td><input id="txtClass.*" type="text" class="txt c1"/></td>
					<td><input id="txtSpec.*" type="text" class="txt c1"/></td>
					<td><input id="txtUnit.*" type="text" class="txt c1"/></td>
					<td><input id="txtMount.*" type="text" class="txt num c1"/></td>
					<td><input id="txtPrice.*" type="text" class="txt num c1" /></td>
					<td><input id="txtTotal.*" type="text" class="txt num c1" /></td>
					<td><input id="txtUcolor.*" type="text" class="txt c1" /></td>
					<td><input id="txtMemo.*" type="text" class="txt c1" /></td>
				</tr>
			</table>
		</div>
	</div>
	<input id="q_sys" type="hidden" />
	</body>
</html>