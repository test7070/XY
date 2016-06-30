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
		<link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
		<script src="css/jquery/ui/jquery.ui.core.js"></script>
		<script src="css/jquery/ui/jquery.ui.widget.js"></script>
		<script src="css/jquery/ui/jquery.ui.datepicker_tw.js"></script>
		<script type="text/javascript">
			this.errorHandler = null;
			function onPageError(error) {
				alert("An error occurred:\r\n" + error.Message);
			}
			q_desc = 1;
			q_tables = 's';
			var q_name = "orde";
			var q_readonly = ['txtNoa', 'txtWorker', 'txtWorker2', 'txtComp', 'txtCno', 'txtAcomp', 'txtMoney', 'txtTax', 'txtTotal', 'txtTotalus', 'txtSales', 'txtOrdbno', 'txtOrdcno','txtVccno','txtApv','textInvomemo','textConn'];
			var q_readonlys = ['txtTotal', 'txtQuatno', 'txtNo2', 'txtNo3', 'txtC1', 'txtNotv'];
			var bbmNum = [['txtTotal', 10, 0, 1], ['txtMoney', 10, 0, 1], ['txtTax', 10, 0, 1],['txtFloata', 10, 5, 1], ['txtTotalus', 15, 2, 1]];
			var bbsNum = [];
			var bbmMask = [];
			var bbsMask = [];
			q_sqlCount = 6;
			brwCount = 6;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'odate';
			brwCount2 = 14;
			
			aPop = new Array(
					['txtProductno_', '', 'ucaucc', 'noa,product,unit,spec,style', 'txtProductno_,txtProduct_,txtUnit_,txtSpec_,txtClassa_', 'ucaucc_b.aspx'],
					['txtSalesno', 'lblSales', 'sss', 'noa,namea', 'txtSalesno,txtSales', 'sss_b.aspx'],
					['txtCno', 'lblAcomp', 'acomp', 'noa,acomp', 'txtCno,txtAcomp', 'acomp_b.aspx'],
					['txtCustno', 'lblCust', 'cust', 'noa,comp,nick,tel,invoicetitle', 'txtCustno,txtComp,txtNick,txtTel', 'cust_b.aspx'],
					['ordb_txtTggno_', '', 'tgg', 'noa,comp', 'ordb_txtTggno_,ordb_txtTgg_', '']
			);
			
			$(document).ready(function() {
				bbmKey = ['noa'];
				bbsKey = ['noa', 'no2'];
				//q_bbsLen = 10;
				q_brwCount();
				//q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
				q_gt('acomp', 'stop=1 ', 0, 0, 0, "cno_acomp");
				q_gt('flors_coin', '', 0, 0, 0, "flors_coin");
				q_gt('uccgb', '', 0, 0, 0, "");
				$('#txtOdate').focus();
				q_gt('sss', "where=^^noa='"+r_userno+"'^^", 0, 0, 0, "sssissales");
			});

			function main() {
				if (dataErr) {
					dataErr = false;
					return;
				}
				mainForm(1);
			}
			
			function currentData() {
			}

			currentData.prototype = {
				data : [],
				exclude : ['chkEnda','txtWorker','txtWorker2'], //bbm
				excludes : ['chkEnda'], //bbs
				copy : function() {
					this.data = new Array();
					for (var i in fbbm) {
						var isExclude = false;
						for (var j in this.exclude) {
							if (fbbm[i] == this.exclude[j]) {
								isExclude = true;
								break;
							}
						}
						if (!isExclude) {
							this.data.push({
								field : fbbm[i],
								value : $('#' + fbbm[i]).val()
							});
						}
					}
					//bbs
					for (var i in fbbs) {
						for (var j = 0; j < q_bbsCount; j++) {
							var isExcludes = false;
							for (var k in this.excludes) {
								if (fbbs[i] == this.excludes[k]) {
									isExcludes = true;
									break;
								}
							}
							if (!isExcludes) {
								this.data.push({
									field : fbbs[i] + '_' + j,
									value : $('#' + fbbs[i] + '_' + j).val()
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
					if(emp($('#txtPostname').val())){
						$('#txtPostname').val($('#txtNoa').val());
					}
					
				}
			};
			var curData = new currentData();

			function sum() {
				var t1 = 0, t_unit, t_mount, t_weight = 0;
				for (var j = 0; j < q_bbsCount; j++) {
					t_unit = $('#txtUnit_' + j).val();
					//t_mount = (!t_unit || emp(t_unit) || trim( t_unit).toLowerCase() == 'kg' ? $('#txtWeight_' + j).val() : $('#txtMount_' + j).val()); // 計價量
					t_mount = $('#txtMount_' + j).val();
					// 計價量
					//t_weight = t_weight + dec( $('#txtWeight_' + j).val()) ; // 重量合計
					$('#txtTotal_' + j).val(round(q_mul(dec($('#txtPrice_' + j).val()), dec(t_mount)), 0));

					q_tr('txtNotv_' + j, q_sub(q_float('txtMount_' + j), q_float('txtC1' + j)));
					t1 = q_add(t1, dec($('#txtTotal_' + j).val()));
				}
				$('#txtMoney').val(round(t1, 0));
				if (!emp($('#txtPrice').val()))
					$('#txtTranmoney').val(round(q_mul(t_weight, dec($('#txtPrice').val())), 0));
				// $('#txtWeight').val(round(t_weight, 0));
				q_tr('txtTotal', q_add(t1, dec($('#txtTax').val())));
				q_tr('txtTotalus', q_mul(q_float('txtMoney'), q_float('txtFloata')));
				calTax();
			}
			
			var x_ordevccumm=false;
			function mainPost() {
				q_getFormat();
				bbmMask = [['txtOdate', r_picd], ['txtMon', r_picm]];
				q_mask(bbmMask);
				bbsMask = [['txtDatea', r_picd]];
				bbsNum = [ ['txtMount', 9, q_getPara('vcc.mountPrecision'), 1], ['txtTotal', 10, 0, 1],['txtC1', 10, q_getPara('vcc.mountPrecision'), 1], ['txtNotv', 10, q_getPara('vcc.mountPrecision'), 1],['txtDime', 15, 0, 1]];
				//['txtPrice', 12, q_getPara('vcc.pricePrecision'), 1],
				q_cmbParse("cmbStype", q_getPara('vcc.stype'));
				//q_cmbParse("cmbCoin", q_getPara('sys.coin'));
				q_cmbParse("combPaytype", q_getPara('vcc.paytype'));
				q_cmbParse("cmbTrantype", q_getPara('sys.tran'));
				q_cmbParse("cmbTaxtype", q_getPara('sys.taxtype'));
				q_cmbParse("combClassa",' ,便,印','s');
				q_cmbParse("cmbSource",'0@ ,1@寄庫,2@庫出,3@公關品,4@樣品','s');
				q_cmbParse("cmbConform", '@,隨貨@隨貨,月結@月結,週結@週結,PO@PO');

				var t_where = "where=^^ 1=0 ^^";
				q_gt('custaddr', t_where, 0, 0, 0, "");
				
				/*$('#txtMemo').change(function(){
					if ($('#txtMemo').val().substr(0,1)=='*')
						$('#txtMon').removeAttr('readonly');
					else
						$('#txtMon').attr('readonly', 'readonly');
				});
				
				$('#txtMon').click(function(){
					if ($('#txtMon').attr("readonly")=="readonly" && (q_cur==1 || q_cur==2))
						q_msg($('#txtMon'), "月份要另外設定，請在"+q_getMsg('lblMemo')+"的第一個字打'*'字");
				}).change(function() {
					if(!emp($('#txtMon').val())){
						if($('#txtMon').val()<=q_getPara('sys.edate').substr(0,6)){
							alert('帳款月份禁止低於關帳日');
							$('#txtMon').val('');
						}
					}
				});*/
				
				$('#btnPlusCust').click(function(){
					q_box('cust.aspx','pluscust', "95%", "95%", '新增客戶');
				});

				$('#btnOrdei').click(function() {
					if (q_cur != 1 && $('#cmbStype').find("option:selected").text() == '外銷')
						q_box("ordei.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";noa='" + $('#txtNoa').val() + "';" + r_accy + ";" + q_cur, 'ordei', "95%", "95%", q_getMsg('popOrdei'));
				});
				$('#btnQuat').click(function() {
					if(q_cur==1 || q_cur==2)
						btnQuat();
				});
				$('#txtFloata').change(function() {
					sum();
				});
				$('#txtTotal').change(function() {
					sum();
				});
				$('#txtAddr').change(function() {
					var t_custno = trim($(this).val());
					if (!emp(t_custno)) {
						focus_addr = $(this).attr('id');
						var t_where = "where=^^ noa='" + t_custno + "' ^^";
						q_gt('cust', t_where, 0, 0, 0, "");
					}
				});
				$('#txtAddr2').change(function() {
					var t_custno = trim($(this).val());
					if (!emp(t_custno)) {
						focus_addr = $(this).attr('id');
						var t_where = "where=^^ noa='" + t_custno + "' ^^";
						q_gt('cust', t_where, 0, 0, 0, "");
					}
				});

				$('#txtCustno').change(function() {
					if(copycustno!='' && copycustno.substr(0,5)!=$('#txtCustno').val().substr(0,5)){
						curData.paste();
						if(q_cur==1)
							$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val('AUTO');
						alert('非總店與相關分店!!');
					}
					/*for(var j=0 ;j<q_bbsCount;j++){
						$('#btnMinus_'+j).click();
					}*/
					
					if (!emp($('#txtCustno').val())) {
						var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^";
						q_gt('custaddr', t_where, 0, 0, 0, "");
					}
				}).focusin(function() {
					q_msg($(this),'請輸入客戶編號');
				});
				
				$('#txtCustorde').change(function() {
					//105/02/25 //檢查客單編號同一個客戶是否重覆 給提示 考慮類似西雅圖跟瓦城
					if(!emp($('#txtCustorde').val())){
						var t_where = "where=^^ noa!='" + $('#txtNoa').val() + "' and custno='"+$('#txtCustno').val()+"' and custorde='"+$('#txtCustorde').val()+"' ^^";
						q_gt('view_orde', t_where, 0, 0, 0, "checkcustorde", r_accy, 1);
						var as = _q_appendData("view_orde", "", true);
						if (as[0] != undefined) {
							alert('客單編號重複輸入，請檢查是否重覆下訂單!!');
						}
					}
				});
				
				$('#lblCustx').click(function() {
					if(copycustno!=''){
						q_box("cust_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";left(noa,5)='" + copycustno.substr(0,5) + "';" + r_accy + ";" + q_cur, 'custx', "95%", "95%", q_getMsg('lblCust'));
					}
				});
				
				//105/06/03 檢查訂單客戶是否重覆下訂單
				$('#btnOrderep').click(function() {
					q_box("z_orde.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";;" + r_accy + ";" + q_cur, 'z_orde', "95%", "95%", $('#btnOrderep').val());
				});

				$('#btnCredit').click(function() {
					if (!emp($('#txtCustno').val())) {
						q_box("z_credit.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";custno='" + $('#txtCustno').val() + "';" + r_accy + ";" + q_cur, 'ordei', "95%", "95%", q_getMsg('btnCredit'));
					}
				});
				
				$('#btnApv').click(function(e){
					if($('#chkCancel').prop('checked')){
						alert('訂單已取消');
						return;
					}
					if($('#chkEnda').prop('checked')){
						alert('訂單已結案');
						return;
					}
					
					//1050224 檢查客戶是否可以核可 同時判斷總店含集團
					var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^";
					q_gt('cust', t_where, 0, 0, 0, "getcuststatus", r_accy, 1);
					var x_err="";
					var t_status=q_getPara('cust.status').split(',');
					var as = _q_appendData("cust", "", true);
					if (as[0] != undefined) {
						if(as[0].status!='1' && as[0].status!='2'){
							var x_status='';
							for(var i=0;i<t_status.length;i++){
								if(as[0].status==t_status[i].split('@')[0]){
									x_status=t_status[i].split('@')[1];
									break;
								}
							}
							x_err='客戶【'+x_status+'】請聯絡業務!!';
						}
						if(x_err.length==0 && $('#txtCustno').val().length>5){ //判斷總店
							var t_tcustno=$('#txtCustno').val().substr(0,5);
							var t_where = "where=^^ noa='" + t_tcustno + "' ^^";
							q_gt('cust', t_where, 0, 0, 0, "getcuststatus2", r_accy, 1);
							var as2 = _q_appendData("cust", "", true);
							if (as2[0] != undefined) {
								if(as2[0].status!='1' && as2[0].status!='2'){
									var x_status='';
									for(var i=0;i<t_status.length;i++){
										if(as2[0].status==t_status[i].split('@')[0]){
											x_status=t_status[i].split('@')[1];
											break;
										}
									}
									x_err='總店【'+x_status+'】請聯絡業務!!';
								}
							}
						}
						if(x_err.length==0 && as[0].grpno!=''){//判斷集團
							var t_where = "where=^^ noa='" + as[0].grpno + "' ^^";
							q_gt('cust', t_where, 0, 0, 0, "getcuststatus3", r_accy, 1);
							var as3 = _q_appendData("cust", "", true);
							if (as3[0] != undefined) {
								if(as3[0].status!='1' && as3[0].status!='2'){
									var x_status='';
									for(var i=0;i<t_status.length;i++){
										if(as3[0].status==t_status[i].split('@')[0]){
											x_status=t_status[i].split('@')[1];
											break;
										}
									}
									x_err='集團【'+x_status+'】請聯絡業務!!';
								}
							}
						}
						if(x_err.length>0){
							alert(x_err);
							return;
						}
					}else{
						alert('客戶編號錯誤!!');
						return;
					}
					
					if(r_rank>"2"){//1050111 5以上 //1050113改成3以上
	                    Lock(1, {
	                        opacity : 0
						});
						q_func('qtxt.query.apv', 'orde.txt,apv,'+ encodeURI(r_userno) + ';' + encodeURI($('#txtNoa').val()));
					}else{
						alert("無核可權限!!");
					}
                });
				
				$('#btnStore2').click(function() {
					if(!emp($('#txtCustno').val())){
						var t_custno=$('#txtCustno').val().substr(0,$('#txtCustno').val().indexOf('-'));
						if(t_custno=='') 
							t_custno=$('#txtCustno').val();
						var t_where = "where=^^ a.storeno2 like '"+t_custno +"%' and a.noa !='"+$('#txtNoa').val()+"' and isnull(a.productno,'')!='' ^^";
						//var t_where = "where=^^ a.noa!='"+$('#txtNoa').val()+"' and b.custno='" + t_custno + "' and isnull(productno,'')!='' ^^";
						q_gt('vcc_xy_store2', t_where, 0, 0, 0, "store2_store2", r_accy);
					}else{
						alert("請輸入客戶編號!!");
					}
					$('#div_store2').hide();
				});
				$('#btnClose_div_store2').click(function() {
					$('#div_store2').toggle();
				});
				////-----------------以下為addr2控制事件---------------
				$('#btnAddr2').mousedown(function(e) {
					var t_post2 = $('#txtPost2').val().split(';');
					var t_addr2 = $('#txtAddr2').val().split(';');
					var maxline=0;//判斷最多有幾組地址
					t_post2.length>t_addr2.length?maxline=t_post2.length:maxline=t_addr2.length;
					maxline==0?maxline=1:maxline=maxline;
					var rowslength=document.getElementById("table_addr2").rows.length-1;
					for (var j = 1; j < rowslength; j++) {
						document.getElementById("table_addr2").deleteRow(1);
					}
					
					for (var i = 0; i < maxline; i++) {
						var tr = document.createElement("tr");
						tr.id = "bbs_"+i;
						tr.innerHTML = "<td id='addr2_tdBtn2_"+i+"'><input class='btn addr2' id='btnAddr_minus_"+i+"' type='button' value='-' style='width: 30px' onClick=minus_addr2("+i+") /></td>";
						tr.innerHTML+= "<td id='addr2_tdPost2_"+i+"'><input id='addr2_txtPost2_"+i+"' type='text' class='txt addr2' value='"+t_post2[i]+"' style='width: 70px'/></td>";
						tr.innerHTML+="<td id='addr2_tdAddr2_"+i+"'><input id='addr2_txtAddr2_"+i+"' type='text' class='txt c1 addr2' value='"+t_addr2[i]+"' /></td>";
						var tmp = document.getElementById("addr2_close");
						tmp.parentNode.insertBefore(tr,tmp);
					}
					readonly_addr2();
					$('#div_addr2').show();
				});
				$('#btnAddr_plus').click(function() {
					var rowslength=document.getElementById("table_addr2").rows.length-2;
					var tr = document.createElement("tr");
						tr.id = "bbs_"+rowslength;
						tr.innerHTML = "<td id='addr2_tdBtn2_"+rowslength+"'><input class='btn addr2' id='btnAddr_minus_"+rowslength+"' type='button' value='-' style='width: 30px' onClick=minus_addr2("+rowslength+") /></td>";
						tr.innerHTML+= "<td id='addr2_tdPost2_"+rowslength+"'><input id='addr2_txtPost2_"+rowslength+"' type='text' class='txt addr2' value='' style='width: 70px' /></td>";
						tr.innerHTML+="<td id='addr2_tdAddr2_"+rowslength+"'><input id='addr2_txtAddr2_"+rowslength+"' type='text' class='txt c1 addr2' value='' /></td>";
						var tmp = document.getElementById("addr2_close");
						tmp.parentNode.insertBefore(tr,tmp);
				});
				$('#btnClose_div_addr2').click(function() {
					if(q_cur==1||q_cur==2){
						var rows=document.getElementById("table_addr2").rows.length-3;
						var t_post2 = '';
						var t_addr2 = '';
						for (var i = 0; i <= rows; i++) {
							if(!emp($('#addr2_txtPost2_'+i).val())||!emp($('#addr2_txtAddr2_'+i).val())){
								t_post2 += $('#addr2_txtPost2_'+i).val()+';';
								t_addr2 += $('#addr2_txtAddr2_'+i).val()+';';
							}
						}
						$('#txtPost2').val(t_post2.substr(0,t_post2.length-1));
						$('#txtAddr2').val(t_addr2.substr(0,t_addr2.length-1));
					}
					$('#div_addr2').hide();
				});
				//----------------------------------------------------------------
				$('#lblOrde2ordb').click(function(){
					$('#lblOrde2ordb').text('讀取資料中...');
					$('#lblOrde2ordb').removeClass('btn');
					
					var t_where = "where=^^ ['" + q_date() + "','','')  where productno=b.productno ^^";
					var t_where1 = "where[1]=^^ ua.productno=b.productno and ua.tggno=c.tggno and ub.mount>b.mount and ua.pricedate>='" + q_date() + "' ^^";
					var t_where2 = "where[2]=^^ cb.productno=b.productno and cb.enda!=1 and cb.cancel!=1 ^^";
					var t_where3 = "where[3]=^^ a.noa='"+$('#txtNoa').val()+"' and c.noa!='' ^^";
					q_gt('orde_ordb', t_where+t_where1+t_where2+t_where3, 0, 0, 0, "orde_ordb", r_accy);
				});
				
				$('#btnClose_div_ordb').click(function() {	
					//寫入ordb
					var orde_data='';
					var rows=document.getElementById("table_ordb").rows.length-2;
					for (var i = 0; i <= rows; i++) {
						if(dec($('#ordb_txtObmount_'+i).val())>0){
							orde_data += $('#ordb_txtNoa_'+i).val()+'^';
							orde_data += $('#ordb_txtNo2_'+i).val()+'^';
							orde_data += $('#ordb_txtObmount_'+i).val()+'^';
							orde_data += $('#ordb_txtTggno_'+i).val()+'^';
							orde_data += $('#ordb_txtInprice_'+i).val();
						}
						orde_data=orde_data+'##';
					}
					var t_where = r_accy+ ';' + r_userno+ ';' + q_getPara('sys.key_ordb')+ ';' + orde_data;
					q_func('qtxt.query.ordb', 'orde.txt,orde2ordb,' + t_where);
					
					//------------------------------------------------------
					$('#div_ordb').hide();
					q_cur=0;
					$('#lblOrde2ordb').addClass('btn');
					HiddenTreat();
				});
				$('#btnClose_div_ordb2').click(function() {	
					$('#div_ordb').hide();
					q_cur=0;
					$('#lblOrde2ordb').addClass('btn');
					HiddenTreat();
				});
				
				//------------------------------------------------------------------
				$('#btnOrdem').click(function() {
					q_box("ordem_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";noa='" + $('#txtNoa').val() + "';" + r_accy + ";" + q_cur, 'ordem', "95%", "95%", q_getMsg('popOrdem'));
				});
				$('#chkCancel').click(function(){
					if($(this).prop('checked')){
						for(var k=0;k<q_bbsCount;k++){
							$('#chkCancel_'+k).prop('checked',true);
						}
					}
				});
				
				$('#txtVccno').click(function(){
					t_where = '';
					t_vccno = $('#txtVccno').val();
					if (t_vccno.length > 0) {
						t_where = "noa='" + t_vccno + "'";
						q_box("vcc_xy.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'vcc', "95%", "95%", "出貨單");
					}
				});
				
				$('#btnOrdetoVcc').click(function() {
					//20160113 多預交日不轉單，或單一預交日
					var t_datea=$('#txtDatea_0').val();
					var date_rep=false;
					for(var i=0;i<q_bbsCount;i++){
						if(t_datea!=$('#txtDatea_'+i).val()){
							date_rep=true;
							break;
						}
					}
					if(date_rep){
						alert("多預交日禁止轉出貨單!!");
						return;
					}
					
					/*if(emp($('#txtMon').val())){
						alert("帳款月份空白!!");
						return;
					}*/
					
					if(emp($('#txtApv').val())){
						alert("請先核准!!");
						return;
					}
					
					//檢查是否已收款
					if(!x_ordevccumm && !emp($('#txtVccno').val())){
						var t_where = " where=^^ vccno='" + $('#txtVccno').val() + "'^^";
						q_gt('umms', t_where, 0, 0, 0, 'ordevccumm', r_accy);
						return;
					}
					x_ordevccumm=false;
					//檢查是否已轉出貨
					if(!emp($('#txtVccno').val())){ //由訂單轉出貨單 直接更新出貨單
						//檢查是否自動產生發票
						var t_where = "where=^^ charindex(noa,'"+$('#txtVccno').val()+"')>0 ^^";
						q_gt('view_vcc', t_where, 0, 0, 0, "checkVcchasvcca");
					}else{
						var t_where = "where=^^ charindex('"+$('#txtNoa').val()+"',ordeno)>0 ^^";
						q_gt('view_vcc', t_where, 0, 0, 0, "checkordetoVcc");
					}
				});
			}
			
			//addr2控制事件vvvvvv-------------------
			function minus_addr2(seq) {	
				$('#addr2_txtPost2_'+seq).val('');
				$('#addr2_txtAddr2_'+seq).val('');
			}
			
			function readonly_addr2() {
				if(q_cur==1||q_cur==2){
					$('.addr2').removeAttr('disabled');
				}else{
					$('.addr2').attr('disabled', 'disabled');
				}
			}
			
			//addr2控制事件^^^^^^--------------------
			
			function q_boxClose(s2) {
				var ret;
				switch (b_pop) {
					case 'btn_ucaucc':
						if (q_cur > 0 && q_cur < 4) {
							b_ret = getb_ret();
							if (!b_ret || b_ret.length == 0)
								return;
							if(b_ret[0]!=undefined){
								$('#txtProductno_'+b_seq).val(b_ret[0].noa);
								$('#txtProduct_'+b_seq).val(b_ret[0].product);
								$('#txtUnit_'+b_seq).val(b_ret[0].unit);
								$('#txtSpec_'+b_seq).val(b_ret[0].spec);
								$('#txtClassa_'+b_seq).val(b_ret[0].style);
							}
						}
						break;
					case 'quats':
						if (q_cur > 0 && q_cur < 4) {
							b_ret = getb_ret();
							if (!b_ret || b_ret.length == 0)
								return;
							//刪除沒有品編的資料 103/12/27 由於訂單會帶入報價資料(含沒有編號的產品)所以不鎖
							/*for (var i = 0; i < b_ret.length; i++) {
								if(b_ret[i].productno==''){
									b_ret.splice(i, 1);
									i--;
								}
							}*/
							
							if(b_ret[0]!=undefined){
								//取得報價的第一筆匯率等資料
								var t_where = "where=^^ noa='" + b_ret[0].noa + "' ^^";
								q_gt('view_quat', t_where, 0, 0, 0, "", r_accy);
							}

							var i, j = 0;
							ret = q_gridAddRow(bbsHtm, 'tbbs', 'txtProductno,txtProduct,txtSpec,txtSizea,txtDime,txtUnit,txtPrice,txtMount,txtQuatno,txtNo3,txtClassa,txtClass'
							, b_ret.length, b_ret, 'productno,product,spec,sizea,dime,unit,price,mount,noa,no3,classa,class', 'txtProductno,txtProduct,txtSpec');
							/// 最後 aEmpField 不可以有【數字欄位】
							sum();
							bbsAssign();
						}
						break;
					case 'cust':
						if (q_cur > 0 && q_cur < 4) {
							b_ret = getb_ret();
							if (!b_ret || b_ret.length == 0)
								curData.paste();
							else{
								if(copycustno!='' && copycustno.substr(0,5)!=b_ret[0].noa.substr(0,5)){
									curData.paste();
									if(q_cur==1)
										$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val('AUTO');
									alert('非總店與相關分店!!');
								}
							}
						}
						break;
					case 'custx':
						if (q_cur > 0 && q_cur < 4) {
							b_ret = getb_ret();
							if (!b_ret || b_ret.length == 0)
								curData.paste();
							else{
								if(copycustno!='' && copycustno.substr(0,5)!=b_ret[0].noa.substr(0,5)){
									curData.paste();
									if(q_cur==1)
										$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val('AUTO');
									alert('非總店與相關分店!!');
								}else{
									$('#txtCustno').val(b_ret[0].noa);
									$('#txtComp').val(b_ret[0].comp);
									$('#txtNick').val(b_ret[0].nick);
									$('#txtTel').val(b_ret[0].tel);
									
									var t_where = "where=^^ noa='" + b_ret[0].noa + "' ^^";
									q_gt('cust', t_where, 0, 0, 0, "cust_detail");
									var t_where = "where=^^ noa='" + b_ret[0].noa + "' ^^";
									q_gt('custm', t_where, 0, 0, 0, "cust_detail2");
								}
							}
						}
						break;
					case q_name + '_s':
						if(issales && s2[1]!=undefined)
							s2[1]="where=^^"+replaceAll(replaceAll(s2[1],'where=^^',''),'^^','')+" and salesno='"+r_userno+"' "+"^^";
						q_boxClose2(s2);
						break;
				}
				b_pop = '';
				AutoNo2();
			}

			function browTicketForm(obj) {
				//資料欄位名稱不可有'_'否則會有問題
				if (($(obj).attr('readonly') == 'readonly') || ($(obj).attr('id').substring(0, 3) == 'lbl')) {
					if ($(obj).attr('id').substring(0, 3) == 'lbl')
						obj = $('#txt' + $(obj).attr('id').substring(3));
					var noa = $.trim($(obj).val());
					var openName = $(obj).attr('id').split('_')[0].substring(3).toLowerCase();
					if (noa.length > 0) {
						switch (openName) {
							case 'ordbno':
								q_box("ordb.aspx?;;;charindex(noa,'" + noa + "')>0;" + r_accy, 'ordb', "95%", "95%", q_getMsg("popOrdb"));
								break;
							case 'ordcno':
								q_box("ordc.aspx?;;;noa='" + noa + "';" + r_accy, 'ordc', "95%", "95%", q_getMsg("popOrdc"));
								break;
							case 'quatno':
								q_box("quat_xy.aspx?;;;noa='" + noa + "';" + r_accy, 'quat', "95%", "95%", q_getMsg("popQuat"));
								break;
						}
					}
				}
			}
			
			var uccgb;
			var focus_addr = '';
			var z_cno = r_cno, z_acomp = r_comp, z_nick = r_comp.substr(0, 2);
			var issales=false;
			function q_gtPost(t_name) {
				switch (t_name) {
					case 'cust_orde':
						var as = _q_appendData("view_orde", "", true);
						if (as[0] != undefined) {
							alert('客戶訂單尚有未交貨產品，請確認是否有重複下單!!');
						}
						break;
					case 'btnDel_orde':
						var as = _q_appendData("view_vccs", "", true);
						if (as[0] != undefined) {
							alert('訂單已出貨【'+as[0].noa+'】禁止刪除!!');
						}else{
							_btnDele();
						}
						break;
					case 'orde_Modi':
						var as = _q_appendData("view_vccs", "", true);
						if(r_rank<"5"){ //4以下禁止修改
							if (as[0] != undefined) {
								orde2vcc_modi=false;
								alert('已轉出貨【'+as[0].noa+'】禁止修改!!!');
							}else{
								orde2vcc_modi=true;
								btnModi();
							}
						}else{//5~7可修改數量
							if (as[0] != undefined) {
								alert('已轉出貨【'+as[0].noa+'】只可修改數量!!!');
								orde2vcc57=true;
							}else{
								orde2vcc57=false;
							}
							orde2vcc_modi=true;
							btnModi();
						}
						break;
					case 'custm':
						var as = _q_appendData("custm", "", true);
						if (as[0] != undefined) {
							$('#textInvomemo').val(as[0].invomemo+(as[0].p23!=''?(" "+as[0].p23+"聯"):''));
							$('#textConn').val(as[0].conn);
							
							var t_custno=as[0].noa;
							var t_where = "where=^^ noa='" + t_custno + "' ^^";
							q_gt('cust', t_where, 0, 0, 0, "getcust",r_accy,1);
							var ass = _q_appendData("cust", "", true);
							if (ass[0] != undefined) {
								$('#textInvomemo').val($('#textInvomemo').val()+' '+ass[0].invoicetitle+' '+ass[0].serial);
							}
						}
						break;
					case 'uccgb':
						//中類
						var as = _q_appendData("uccgb", "", true);
						uccgb=as;
						if (as[0] != undefined) {
							var t_item = "@";
							for ( i = 0; i < as.length; i++) {
								t_item = t_item + (t_item.length > 0 ? ',' : '') + as[i].noa + '@'+ as[i].namea;
							}
							q_cmbParse("combGroupbno", t_item,'s');
						}
						break;
					case 'sssissales':
						var as = _q_appendData("sss", "", true);
	                        if (as[0] != undefined) {
	                        	issales=(as[0].issales=="true"?true:false);
	                        	if(issales)
	                        		q_content = "where=^^salesno='" + r_userno + "'^^";
							}
							q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
						break;
					case 'cno_acomp':
						var as = _q_appendData("acomp", "", true);
						if (as[0] != undefined) {
							z_cno = as[0].noa;
							z_acomp = as[0].acomp;
							z_nick = as[0].nick;
						}
						break;
					case 'flors_coin':
						var as = _q_appendData("flors", "", true);
						var z_coin='';
						for ( i = 0; i < as.length; i++) {
							z_coin+=','+as[i].coin;
						}
						if(z_coin.length==0) z_coin=' ';
						
						q_cmbParse("cmbCoin", z_coin);
						if(abbm[q_recno])
							$('#cmbCoin').val(abbm[q_recno].coin);
						
						break;
					case 'orde_ordb':
						var as = _q_appendData("view_orde", "", true);
						var rowslength=document.getElementById("table_ordb").rows.length-1;
						for (var j = 1; j < rowslength; j++) {
							document.getElementById("table_ordb").deleteRow(1);
						}
							
						for (var i = 0; i < as.length; i++) {
							var tr = document.createElement("tr");
							tr.id = "bbs_"+i;
							tr.innerHTML= "<td id='ordb_tdNo2_"+i+"'><input id='ordb_txtNo2_"+i+"' type='text' value='"+as[i].no2+"' style='width: 45px' disabled='disabled' /><input id='ordb_txtNoa_"+i+"' type='text' value='"+as[i].noa+"' style='width: 45px;display:none' disabled='disabled' /></td>";
							tr.innerHTML+="<td id='ordb_tdProdcut_"+i+"'><input id='ordb_txtProdcut_"+i+"' type='text' value='"+as[i].product+"' style='width: 200px' disabled='disabled' /></td>";
							tr.innerHTML+="<td id='ordb_tdMount_"+i+"'><input id='ordb_txtMount_"+i+"' type='text' value='"+as[i].mount+"' style='width: 80px;text-align: right;' disabled='disabled' /></td>";
							tr.innerHTML+="<td id='ordb_tdSafemount_"+i+"'><input id='ordb_txtSafemount_"+i+"' type='text' value='"+dec(as[i].safemount)+"' style='width: 80px;text-align: right;' disabled='disabled' /></td>";
							tr.innerHTML+="<td id='ordb_tdStmount_"+i+"'><input id='ordb_txtStmount_"+i+"' type='text' value='"+as[i].stmount+"' style='width: 80px;text-align: right;' disabled='disabled' /></td>";
							tr.innerHTML+="<td id='ordb_tdOcmount_"+i+"'><input id='ordb_txtOcmount_"+i+"' type='text' value='"+dec(as[i].ocmount)+"' style='width: 80px;text-align: right;' disabled='disabled' /></td>";
							//庫存-訂單數量>安全量?不需請購:abs(安全量-(庫存-訂單數量))
							tr.innerHTML+="<td id='ordb_tdObmount_"+i+"'><input id='ordb_txtObmount_"+i+"' type='text' value='"+(q_sub(dec(as[i].stmount),dec(as[i].mount))>as[i].safemount?0:Math.abs(q_sub(dec(as[i].safemount),q_sub(dec(as[i].stmount),dec(as[i].mount)))))+"' class='num' style='width: 80px;text-align: right;' /></td>";
							tr.innerHTML+="<td id='ordb_tdTggno_"+i+"'><input id='ordb_txtTggno_"+i+"' type='text' value='"+as[i].tggno+"' style='width: 150px'  /><input id='ordb_txtTgg_"+i+"' type='text' value='"+as[i].tgg+"' style='width: 200px' disabled='disabled' /></td>";
							tr.innerHTML+="<td id='ordb_tdInprice_"+i+"'><input id='ordb_txtInprice_"+i+"' type='text' value='"+(dec(as[i].tggprice)>0?as[i].tggprice:as[i].inprice)+"' class='num' style='width: 80px;text-align: right;' /></td>";
								
							var tmp = document.getElementById("ordb_close");
							tmp.parentNode.insertBefore(tr,tmp);
						}
						$('#lblOrde2ordb').text(q_getMsg('lblOrde2ordb'));
						$('#div_ordb').show();
						
						var SeekF= new Array();
						$('#table_ordb td').children("input:text").each(function() {
							if($(this).attr('disabled')!='disabled')
								SeekF.push($(this).attr('id'));
						});
						
						SeekF.push('btn_div_ordb');
						$('#table_ordb td').children("input:text").each(function() {
							$(this).keydown(function(event) {
								if( event.which == 13) {
									$('#'+SeekF[SeekF.indexOf($(this).attr('id'))+1]).focus();
									$('#'+SeekF[SeekF.indexOf($(this).attr('id'))+1]).select();
								}
							});
						});
						
						$('#table_ordb td .num').each(function() {
							$(this).keyup(function() {
								var tmp=$(this).val();
								tmp=tmp.match(/\d{1,}\.{0,1}\d{0,}/);
								$(this).val(tmp);
							});
						});
						
						refresh(q_recno);
						q_cur=2;
						break;
					case 'msg_ucc':
						var as = _q_appendData("ucc", "", true);
						t_msg = '';
						if (as[0] != undefined) {
							t_msg = "銷售單價：" + dec(as[0].saleprice) + "<BR>";
						}
						//客戶售價
						//不用apv 抓sign
						if(!emp($('#txtProductno_'+b_seq).val())){
							var t_custno = trim($('#txtCustno').val());
							var t_odate = trim($('#txtOdate').val());
							var t_pno = trim($('#txtProductno_'+b_seq).val());
							var t_where = '';
							if (emp(t_custno))
								t_custno='#non';
							if (emp(t_odate))
								t_odate='#non';
							if (emp(t_pno))
								t_pno='#non';
							var t_where = t_odate+ ';'+t_custno+ ';'+t_pno;
							q_func('qtxt.query.msg_quat_xy', 'cust_ucc_xy.txt,quatimport,' + t_where);
							
							//t_where="where=^^ noa+'_'+odate+'_'+productno in (select MIN(a.noa)+'_'+MIN(a.odate)+'_'+b.productno from view_quat a left join view_quats b on a.noa=b.noa where isnull(b.enda,0)=0 and isnull(b.cancel,0)=0 "+q_sqlPara2("a.custno", $('#txtCustno').val())+" and a.datea>='"+q_date()+"' group by b.productno)";
							//t_where+=" and productno='"+$('#txtProductno_'+b_seq).val()+"' and isnull(enda,0)=0 and isnull(cancel,0)=0 "+q_sqlPara2("custno", $('#txtCustno').val()) +" and datea>='"+q_date()+"' ^^";
							//q_gt('view_quats', t_where, 0, 0, 0, "msg_quat_xy");
						}else{
							var t_where = "where=^^ custno='" + $('#txtCustno').val() + "' and datea<'" + q_date() + "' ^^ stop=1";
							q_gt('view_quat', t_where, 0, 0, 0, "msg_quat", r_accy);	
						}
						break;
					case 'msg_quat':
						var as = _q_appendData("view_quat", "", true);
						var quat_price = 0;
						if (as[0] != undefined) {
							for (var i = 0; i < as.length; i++) {
								if (as[0].productno == $('#txtProductno_' + b_seq).val())
									quat_price = dec(as[i].price);
							}
						}
						t_msg = t_msg + "最近報價單價：" + quat_price + "<BR>";
						//最新出貨單價
						var t_where = "where=^^ custno='" + $('#txtCustno').val() + "' and noa in (select noa from vccs" + r_accy + " where productno='" + $('#txtProductno_' + b_seq).val() + "' and price>0 ) ^^ stop=1";
						q_gt('vcc', t_where, 0, 0, 0, "msg_vcc", r_accy);
						break;
					case 'msg_quat_xy':
						var as = _q_appendData("view_quats", "", true);
						if (as[0] != undefined) {
							t_msg = t_msg + "最近報價單價：" + dec(as[0].price) + "<BR>";
						}else{
							t_msg = t_msg + "最近報價單價：無<BR>";
						}
						//最新出貨單價
						var t_where = "where=^^ custno='" + $('#txtCustno').val() + "' and noa in (select noa from vccs" + r_accy + " where productno='" + $('#txtProductno_' + b_seq).val() + "' and price>0 ) ^^ stop=1";
						q_gt('vcc', t_where, 0, 0, 0, "msg_vcc", r_accy);
						break;
					case 'msg_vcc':
						var as = _q_appendData("vccs", "", true);
						var vcc_price = 0;
						if (as[0] != undefined) {
							for (var i = 0; i < as.length; i++) {
								if (as[0].productno == $('#txtProductno_' + b_seq).val())
									vcc_price = dec(as[i].price);
							}
						}
						t_msg = t_msg + "最近出貨單價：" + vcc_price;
						q_msg($('#txtPrice_' + b_seq), t_msg);
						break;
					case 'msg_stk':
						var as = _q_appendData("stkucc", "", true);
						var stkmount = 0;
						t_msg = '';
						for (var i = 0; i < as.length; i++) {
							stkmount = q_add(stkmount, dec(as[i].mount));
						}
						t_msg = "庫存量：" + stkmount;
						q_msg($('#txtMount_' + b_seq), t_msg);
						break;
					case 'source_stk':
						var as = _q_appendData("view_vccs", "", true);
						if (as[0] != undefined) {
							if(dec(as[0].stkmount)>=$('#txtMount_'+b_seq).val())
								$('#cmbSource_'+b_seq).val('2').change();
							else
								$('#cmbSource_'+b_seq).val('0').change();
						}else{
							$('#cmbSource_'+b_seq).val('0').change();
						}
						break;
					case 'custaddr':
						var as = _q_appendData("custaddr", "", true);
						var t_item = " @ ";
						if (as[0] != undefined) {
							for ( i = 0; i < as.length; i++) {
								t_item = t_item + (t_item.length > 0 ? ',' : '') + as[i].post + '@' + as[i].addr;
							}
						}
						document.all.combAddr.options.length = 0;
						q_cmbParse("combAddr", t_item);
						break;
					case 'view_quat':
						var as = _q_appendData("view_quat", "", true);
						if (as[0] != undefined) {
							$('#txtFloata').val(as[0].floata);
							$('#cmbCoin').val(as[0].coin);
							//105/02/18 付款和業務不覆蓋
							//$('#txtPaytype').val(as[0].paytype);
							//$('#txtSalesno').val(as[0].salesno);
							//$('#txtSales').val(as[0].sales);
							$('#txtContract').val(as[0].contract);
							//105/02/17 交運方式不覆蓋
							//$('#cmbTrantype').val(as[0].trantype);
							//104/09/14 報價地址不覆蓋
							//$('#txtTel').val(as[0].tel);
							//$('#txtFax').val(as[0].fax);
							//$('#txtPost').val(as[0].post);
							//$('#txtAddr').val(as[0].addr);
							//$('#txtPost2').val(as[0].post2);
							//$('#txtAddr2').val(as[0].addr2);
							
							//$('#cmbTaxtype').val(as[0].taxtype);
							sum();
						}
						break;
					case 'keyin_productno_xy':
						var as = _q_appendData("view_quats", "", true);
						if (as[0] != undefined) {
							$('#txtPrice_'+b_seq).val(as[0].price);
							$('#txtQuatno_'+b_seq).val(as[0].noa);
							$('#txtNo3_'+b_seq).val(as[0].no3);	
							sum();
							HiddenTreat();
						}
						break;
					case 'btnOk_xy':
						var as = _q_appendData("view_quats", "", true);
						var error_productno='';
						var product_in_quat=false;
						for (var i = 0; i < q_bbsCount; i++) {
							if(!emp($('#txtProductno_'+i).val()) && $('#cmbSource_'+i).val()!='2' && $('#cmbSource_'+i).val()!='3' && $('#cmbSource_'+i).val()!='4' ){
								product_in_quat=false;
								for (var j = 0; j < as.length; j++) {
									if(!emp($('#txtQuatno_'+i).val()) && !emp($('#txtNo3_'+i).val())){
										if($('#txtQuatno_'+i).val()==as[j].noa && $('#txtNo3_'+i).val()==as[j].no3){
											product_in_quat=true;
											if(dec($('#txtPrice_'+i).val())< dec(as[j].price)){
												error_productno+=$('#txtProductno_'+i).val()+' '+$('#txtProduct_'+i).val()+' 訂單單價小於報價單價!!\n'
											}
											break;
										}
									}else if(as[j].productno==$('#txtProductno_'+i).val()){
										product_in_quat=true;
										if(as[j].price>dec($('#txtPrice_'+i).val())){
											error_productno+=$('#txtProductno_'+i).val()+' '+$('#txtProduct_'+i).val()+' 訂單單價小於報價單價!!\n'
										}
										break;
									}
								}
								//103/12/18暫時拿掉
								/*if(!product_in_quat){
									error_productno+=$('#txtProductno_'+i).val()+' '+$('#txtProduct_'+i).val()+' 沒有報價資料!!\n'
								}*/
							}
						}
						
						if(error_productno.length>0){
							alert(error_productno);
						}else{
							check_quat_xy=true;
							btnOk();
						}
						break;	
					case 'cust':
						var as = _q_appendData("cust", "", true);
						if (as[0] != undefined && focus_addr != '') {
							$('#' + focus_addr).val(as[0].addr_fact);
							focus_addr = '';
						}
						break;
					case 'cust_detail':
						var as = _q_appendData("cust", "", true);
						var x_err='';
						if (as[0] != undefined) {
							$('#txtFax').val(as[0].fax);
							$('#txtPost').val(as[0].zip_comp);
							$('#txtAddr').val(as[0].addr_comp);
							$('#txtPost2').val(as[0].zip_home);
							$('#txtAddr2').val(as[0].addr_home);
							$('#txtPaytype').val(as[0].paytype);
							$('#cmbTrantype').val(as[0].trantype);
							$('#txtSalesno').val(as[0].salesno);
							$('#txtSales').val(as[0].sales);
							
							var t_status=q_getPara('cust.status').split(',');
							if(as[0].status!='1' && as[0].status!='2'){
								var x_status='';
								for(var i=0;i<t_status.length;i++){
									if(as[0].status==t_status[i].split('@')[0]){
										x_status=t_status[i].split('@')[1];
										break;
									}
								}
								x_err='客戶【'+x_status+'】請聯絡業務!!';
							}
							
							if(x_err.length==0 && as[0].noa.length>5){ //判斷總店
								var t_tcustno=as[0].noa.substr(0,5);
								var t_where = "where=^^ noa='" + t_tcustno + "' ^^";
								q_gt('cust', t_where, 0, 0, 0, "getcuststatus2", r_accy, 1);
								var as2 = _q_appendData("cust", "", true);
								if (as2[0] != undefined) {
									if(as2[0].status!='1' && as2[0].status!='2'){
										var x_status='';
										for(var i=0;i<t_status.length;i++){
											if(as2[0].status==t_status[i].split('@')[0]){
												x_status=t_status[i].split('@')[1];
												break;
											}
										}
										x_err='總店【'+x_status+'】請聯絡業務!!';
									}
								}
							}
							if(x_err.length==0 && as[0].grpno!=''){//判斷集團
								var t_where = "where=^^ noa='" + as[0].grpno + "' ^^";
								q_gt('cust', t_where, 0, 0, 0, "getcuststatus3", r_accy, 1);
								var as3 = _q_appendData("cust", "", true);
								if (as3[0] != undefined) {
									if(as3[0].status!='1' && as3[0].status!='2'){
										var x_status='';
										for(var i=0;i<t_status.length;i++){
											if(as3[0].status==t_status[i].split('@')[0]){
												x_status=t_status[i].split('@')[1];
												break;
											}
										}
										x_err='集團【'+x_status+'】請聯絡業務!!';
									}
								}
							}
							if(x_err.length>0)
								alert(x_err);
						}
						break;
					case 'cust_detail2':
						var as = _q_appendData("custm", "", true);
						if (as[0] != undefined) {
							var t_taxtype=as[0].taxtype;
							var taxtype='0',xy_taxtypetmp=q_getPara('sys.taxtype').split(',');
							for (var i=0;i<xy_taxtypetmp.length;i++){
								if(xy_taxtypetmp[i].split('@')[1]==t_taxtype)
									taxtype=xy_taxtypetmp[i].split('@')[0];
							}
							$('#cmbTaxtype').val(taxtype);
							$('#cmbConform').val(as[0].invomemo);
							
							$('#textInvomemo').val(as[0].invomemo+(as[0].p23!=''?(" "+as[0].p23+"聯"):''));
							$('#textConn').val(as[0].conn);
							var t_custno=as[0].noa;
							var t_where = "where=^^ noa='" + t_custno + "' ^^";
							q_gt('cust', t_where, 0, 0, 0, "getcust",r_accy,1);
							var ass = _q_appendData("cust", "", true);
							if (ass[0] != undefined) {
								$('#textInvomemo').val($('#textInvomemo').val()+' '+ass[0].invoicetitle+' '+ass[0].serial);
							}
						}
						break;
					case 'store2_store2':
						var as = _q_appendData("view_vccs", "", true);
						for (var i = 0; i < as.length; i++) {
							if(dec(as[i].stkmount)==0){
								as.splice(i, 1);
								i--;
							}
						}
						if (as[0] == undefined) {
							alert("無寄庫量");
							break;
						}
						var rowslength=document.getElementById("table_store2").rows.length-1;
							for (var j = 1; j < rowslength; j++) {
								document.getElementById("table_store2").deleteRow(1);
							}
						var store2_row=0;
					
						for (var i = 0; i < as.length; i++) {
							//倉庫庫存
							var tr = document.createElement("tr");
							tr.id = "store2_"+j;
							tr.innerHTML = "<td><input id='store2_txtProductno_"+store2_row+"' type='text' class='txt c1' value='"+as[i].productno+"' disabled='disabled'/></td>";
							tr.innerHTML+="<td><input id='store2_txtProduct_"+store2_row+"' type='text' class='txt c1' value='"+as[i].product+"' disabled='disabled' /></td>";
							tr.innerHTML+= "<td><input id='store2_txtSpec_"+store2_row+"' type='text' class='txt c1' value='"+as[i].spec+"' disabled='disabled'/></td>";
							tr.innerHTML+="<td><input id='store2_txtStore_"+store2_row+"' type='text' class='txt c1' value='"+as[i].store2+"' disabled='disabled' /></td>";
							tr.innerHTML+="<td><input id='store2_txtMount_"+store2_row+"' type='text' class='txt c1 num' value='"+dec(as[i].stkmount)+"' disabled='disabled'/></td>";
							var tmp = document.getElementById("store2_close");
							tmp.parentNode.insertBefore(tr,tmp);
							store2_row++;
						}
						$('#div_store2').css('top', $('#btnStore2').offset().top+25);
						$('#div_store2').css('left', $('#btnStore2').offset().left-parseInt($('#div_store2').css('width'))-5);
						$('#div_store2').toggle();
						break;
					case 'flors':
						var as = _q_appendData("flors", "", true);
						if (as[0] != undefined) {
							q_tr('txtFloata',as[0].floata);
							sum();
						}
						break;
					case 'quatimport':
						var as = _q_appendData("view_quats", "", true);
						//移除相同的報價單
						for(var i = 0; i < as.length; i++){
							for (var j = 0; j < q_bbsCount; j++) {
								if(as[i].noa==$('#txtQuatno_'+j).val() && as[i].no3==$('#txtNo3_'+j).val()){
									as.splice(i, 1);
									i--;
									break;
								}
							}
						}
						
						if(as[0]!=undefined){
							//取得報價的第一筆匯率等資料
							var t_where = "where=^^ noa='" + as[0].noa + "' ^^";
							q_gt('view_quat', t_where, 0, 0, 0, "", r_accy);
						}
						
						q_gridAddRow(bbsHtm, 'tbbs', 'txtProductno,txtProduct,txtSpec,txtSizea,txtDime,txtUnit,txtPrice,txtMount,txtQuatno,txtNo3,txtClassa,txtClass'
						, as.length, as, 'productno,product,spec,sizea,dime,unit,price,mount,noa,no3,classa,class', 'txtProductno,txtProduct,txtSpec');
						sum();
						
						if(as.length>0){
							for (var i = 0; i < q_bbsCount; i++) {
								if(dec($('#txtMount_'+i).val())==0)
									$('#txtMount_'+i).val('');
							}
						}
						$('#txtMount_0').focus();
						bbsAssign();
						break;
					case 'ordevccumm':
						var as = _q_appendData("umms", "", true);
						if (as[0] != undefined) {
							var z_msg = "", t_paysale = 0;
							for (var i = 0; i < as.length; i++) {
								t_paysale = parseFloat(as[i].paysale.length == 0 ? "0" : as[i].paysale);
								if (t_paysale != 0)
									z_msg += String.fromCharCode(13) + '收款單號【' + as[i].noa + '】 ' + FormatNumber(t_paysale);
							}
							if (z_msg.length > 0) {
								alert('已沖帳:' + z_msg);
								return;
							}
						}else{
							x_ordevccumm=true;
							$('#btnOrdetoVcc').click();
						}
						break;
					case 'checkVcchasvcca':
						var as = _q_appendData("view_vcc", "", true);
						if (as[0] != undefined) {
							if(as[0].isgenvcca=="true")
								alert('出貨單【自動產生發票】禁止更新出貨單!!');
							else if (as[0].invono.length>0){
								alert('出貨單已產生或指定發票禁止更新出貨單!!');
							}else
								q_func('vcc_post.post.a1', r_accy + ',' + $('#txtVccno').val() + ',0');
						}else{
							alert('出貨單遺失，重新產生出貨單!!');
							q_func('qtxt.query.post1', 'cust_ucc_xy.txt,orde2vcc,' + encodeURI(r_accy) + ';' + encodeURI($('#txtNoa').val())+ ';1;' + encodeURI(r_userno));
						}
						break;
					case 'checkordetoVcc':
						var as = _q_appendData("view_vcc", "", true);
						if (as[0] != undefined) {
							alert('訂單已自行轉出貨單【'+as[0].noa+'】!!');
						}else{
							if(emp($('#txtVccno').val())){
								q_func('qtxt.query.post1', 'cust_ucc_xy.txt,orde2vcc,' + encodeURI(r_accy) + ';' + encodeURI($('#txtNoa').val())+ ';1;' + encodeURI(r_userno));
							}else{
								q_func('vcc_post.post.a1', r_accy + ',' + $('#txtVccno').val() + ',0');
							}
						}
						break;
					case 'startdate':
						var as = _q_appendData('cust', '', true);
						var t_startdate='';
						if (as[0] != undefined) {
							t_startdate=as[0].startdate;
						}
						if(t_startdate.length==0 || ('00'+t_startdate).slice(-2)=='00' || $('#txtOdate').val().substr(7, 2)<('00'+t_startdate).slice(-2)){
							$('#txtMon').val($('#txtOdate').val().substr(0, 6));
						}else{
							var t_date=$('#txtOdate').val();
							var nextdate=new Date(dec(t_date.substr(0,3))+1911,dec(t_date.substr(4,2))-1,1);
				    		nextdate.setMonth(nextdate.getMonth() +1)
				    		t_date=''+(nextdate.getFullYear()-1911)+'/'+(nextdate.getMonth()<9?'0':'')+(nextdate.getMonth()+1);
							$('#txtMon').val(t_date);
						}
						check_startdate=true;
						btnOk();
						break;
					case q_name:
						if (q_cur == 4)
							q_Seek_gtPost();
						break;
				}
			}

			function btnQuat() {
				var t_custno = trim($('#txtCustno').val());
				var t_odate=trim($('#txtOdate').val());
				var t_where = '';
				if (t_custno.length > 0) {
					//104/09/10 直接匯入 要直接打數量
					if (emp(t_custno))
						t_custno='#non';
					if (emp(t_odate))
						t_odate='#non';
					var t_pno='#non';
					
					var t_where = t_odate+ ';'+t_custno+ ';'+t_pno;
					q_func('qtxt.query.quatimport', 'cust_ucc_xy.txt,quatimport,' + t_where);
					
					//q_gt('view_quats', "where=^^"+t_where+"^^", 0, 0, 0, "quatimport");
					//q_box("quat_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'quats', "95%", "95%", $('#btnQuat').val());
				}else {
					alert(q_getMsg('msgCustEmp'));
				}
			}
			
			var check_quat_xy=false,check_startdate=false;
			function btnOk() {
				if(!$('#div_cost').is(':hidden')){
					var t_class=$.trim($('#combClassa_'+b_seq).val());
					if(t_class=='印')
						$('#cost_txtCost0').focus();
					else
						$('#cost_txtWdate').focus();
					return;
				}
				
				if(!$('#div_spec').is(':hidden')){
					$('#spec_txtSpec_0').focus();
					return;
				}
				
				//出貨單數量0不存檔 104/09/10
				for(var k=0;k<q_bbsCount;k++){
					if(dec($('#txtMount_'+k).val())==0){
						$('#btnMinus_'+k).click();
					}
				}
				
				t_err = '';
				t_err = q_chkEmpField([['txtNoa', q_getMsg('lblNoa')], ['txtCustno', q_getMsg('lblCustno')], ['txtCno', q_getMsg('btnAcomp')]]);
				if (t_err.length > 0) {
					alert(t_err);
					return;
				}
				
				//105/06/14 增加mon
				/*if(!check_startdate && emp($('#txtMon').val())){
				//if(!check_startdate && $('#txtMemo').val().substr(0,1)!='*'){	
					var t_where = "where=^^ noa='"+$('#txtCustno').val()+"' ^^";
					q_gt('cust', t_where, 0, 0, 0, "startdate", r_accy);
					return;
				}
				
				if($('#txtMon').val()<=q_getPara('sys.edate').substr(0,6)){
					alert('帳款月份禁止低於關帳日');
					return;
				}*/
				
				//105/02/25 //檢查客單編號同一個客戶是否重覆 給提示 考慮類似西雅圖跟瓦城
				if(!emp($('#txtCustorde').val())){
					var t_where = "where=^^ noa!='" + $('#txtNoa').val() + "' and custno='"+$('#txtCustno').val()+"' and custorde='"+$('#txtCustorde').val()+"' ^^";
					q_gt('view_orde', t_where, 0, 0, 0, "checkcustorde", r_accy, 1);
					var as = _q_appendData("view_orde", "", true);
					if (as[0] != undefined) {
						alert('客單編號重複輸入，請檢查是否重覆下訂單!!');
					}
				}
				
				//105/0217 //檢查客戶是否可以出貨 //0224 可打訂單並提示但不可核可 同時判斷總店含集團
				var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^";
				q_gt('cust', t_where, 0, 0, 0, "getcuststatus", r_accy, 1);
				var x_err="";
				var t_status=q_getPara('cust.status').split(',');
				var as = _q_appendData("cust", "", true);
				if (as[0] != undefined) {
					if(as[0].status!='1' && as[0].status!='2'){
						var x_status='';
						for(var i=0;i<t_status.length;i++){
							if(as[0].status==t_status[i].split('@')[0]){
								x_status=t_status[i].split('@')[1];
								break;
							}
						}
						x_err='客戶【'+x_status+'】請聯絡業務!!';
					}
					if(x_err.length==0 && $('#txtCustno').val().length>5){ //判斷總店
						var t_tcustno=$('#txtCustno').val().substr(0,5);
						var t_where = "where=^^ noa='" + t_tcustno + "' ^^";
						q_gt('cust', t_where, 0, 0, 0, "getcuststatus2", r_accy, 1);
						var as2 = _q_appendData("cust", "", true);
						if (as2[0] != undefined) {
							if(as2[0].status!='1' && as2[0].status!='2'){
								var x_status='';
								for(var i=0;i<t_status.length;i++){
									if(as2[0].status==t_status[i].split('@')[0]){
										x_status=t_status[i].split('@')[1];
										break;
									}
								}
								x_err='總店【'+x_status+'】請聯絡業務!!';
							}
						}
					}
					if(x_err.length==0 && as[0].grpno!=''){//判斷集團
						var t_where = "where=^^ noa='" + as[0].grpno + "' ^^";
						q_gt('cust', t_where, 0, 0, 0, "getcuststatus3", r_accy, 1);
						var as3 = _q_appendData("cust", "", true);
						if (as3[0] != undefined) {
							if(as3[0].status!='1' && as3[0].status!='2'){
								var x_status='';
								for(var i=0;i<t_status.length;i++){
									if(as3[0].status==t_status[i].split('@')[0]){
										x_status=t_status[i].split('@')[1];
										break;
									}
								}
								x_err='集團【'+x_status+'】請聯絡業務!!';
							}
						}
					}
					if(x_err.length>0)
						alert(x_err);
				}else{
					alert('客戶編號錯誤!!');
					return;
				}
				
				//檢查產品是否在報價單中，並判斷單價，不在報價單中或單價小於報價金額不能存檔
				if(!check_quat_xy){
					var t_custno = trim($('#txtCustno').val());
					var t_odate = trim($('#txtOdate').val());
					var t_pno='#non';
					var t_where = '';
					if (emp(t_custno))
						t_custno='#non';
					if (emp(t_odate))
						t_odate='#non';
						var t_where = t_odate+ ';'+t_custno+ ';'+t_pno;
					q_func('qtxt.query.btnOk_xy', 'cust_ucc_xy.txt,quatimport,' + t_where);
					return;
				}
				check_quat_xy=false;
				check_startdate=false;
				
				//105/04/25  判斷 客戶主檔 有運費單價  並 判斷訂單是有運費 沒有給提示
				var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^";
				q_gt('custm', t_where, 0, 0, 0, "getcustmtranprice",r_accy,1);
				var as = _q_appendData("custm", "", true);
				if (as[0] != undefined) {
					if(dec(as[0].tranprice)>0){
						var t_tranprice=-1;
						for (var j = 0; j < q_bbsCount; j++) {
							if($('#txtProduct_'+j).val()=='運費' || $('#txtSpec_'+j).val()=='運費'){
								t_tranprice=dec($('#txtPrice_'+j).val());
								break;
							}
						}
						if(t_tranprice==-1){
							alert('客戶需收運費，請確認訂單運費!!');
						}
						if(t_tranprice==0){
							alert('客戶需收運費，訂單運費金額為0!!');
						}
					}
				}
				
				//1030419 當專案沒有勾 BBM的取消和結案被打勾BBS也要寫入
				if(!$('#chkIsproj').prop('checked')){
					for (var j = 0; j < q_bbsCount; j++) {
						if($('#chkEnda').prop('checked'))
							$('#chkEnda_'+j).prop('checked','true');
						if($('#chkCancel').prop('checked'))
							$('#chkCancel_'+j).prop('checked','true')
					}
				}
				
				if (q_cur == 1)
					$('#txtWorker').val(r_name);
				else
					$('#txtWorker2').val(r_name);
				sum();

				var s1 = $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val();
				if (s1.length == 0 || s1 == "AUTO")
					q_gtnoa(q_name, replaceAll(q_getPara('sys.key_orde') + $('#txtOdate').val(), '/', ''));
				else
					wrServer(s1);
			}

			function _btnSeek() {
				if (q_cur > 0 && q_cur < 4)
					return;
				q_box('orde_xy_s.aspx', q_name + '_s', "500px", "580px", q_getMsg("popSeek"));
			}

			function combPaytype_chg() {
				var cmb = document.getElementById("combPaytype");
				if (!q_cur)
					cmb.value = '';
				else
					$('#txtPaytype').val(cmb.value);
				cmb.value = '';
			}
			
			function coin_chg() {
				var t_where = "where=^^ ('" + $('#txtOdate').val() + "' between bdate and edate) and coin='"+$('#cmbCoin').find("option:selected").text()+"' ^^";
				q_gt('flors', t_where, 0, 0, 0, "");
			}

			function combAddr_chg() {
				if (q_cur == 1 || q_cur == 2) {
					$('#txtAddr2').val($('#combAddr').find("option:selected").text());
					$('#txtPost2').val($('#combAddr').find("option:selected").val());
				}
			}
			
			var pno_keyin_apop=false; //避免change 與apop 重複執行
			function bbsAssign() {
				for (var j = 0; j < (q_bbsCount == 0 ? 1 : q_bbsCount); j++) {
					if (!$('#btnMinus_' + j).hasClass('isAssign')) {
						$('#btnMinus_' + j).click(function() {
							btnMinus($(this).attr('id'));
							AutoNo2();
						});
						$('#btnProduct_' + j).click(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							var t_where='';
							if($('#txtCustno').val().length>0){
								t_where=" exists (select * from view_quats where custno='"+$('#txtCustno').val()+"' and view_ucaucc.noa=productno)";
								q_box("ucaucc_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where+";"+r_accy, 'btn_ucaucc', "550px", "700px", '');	
							}
						});
						$('#txtProductno_' + j).focusin(function() {
							pno_keyin_apop=false;
						});
						
						/*$('#txtProductno_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							//q_change($(this), 'ucc', 'noa', 'noa,product,unit');
							if($('#txtProductno_' + b_seq).val().indexOf('-')>0){
								if($('#txtProductno_' + b_seq).val().substr(0,5)!=$('#txtCustno').val().substr(0,5)){
									$('#txtProductno_' + b_seq).val('');
								}
							}
							
							if(!emp($('#txtProductno_'+b_seq).val())){
								
								var t_custno = trim($('#txtCustno').val());
								var t_odate = trim($('#txtOdate').val());
								var t_pno = trim($('#txtProductno_'+b_seq).val());
								var t_where = '';
								if (t_custno.length > 0 && t_pno.length>0) {
									//104/09/10 直接匯入 要直接打數量
									if (emp(t_custno))
										t_custno='#non';
									if (emp(t_odate))
										t_odate='#non';
									if (emp(t_pno))
										t_pno='#non';
									
									var t_where = t_odate+ ';'+t_custno+ ';'+t_pno;
									q_func('qtxt.query.keyin_productno_xy', 'cust_ucc_xy.txt,quatimport,' + t_where);
								}else {
									alert(q_getMsg('msgCustEmp'));
									$('#txtCustno').focus();
									$('#btnMinus_'+b_seq).click();
									return;
								}
							}
							AutoNo2();
						});*/
						
						$('#cmbSource_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if($('#cmbSource_' + b_seq).val()!='0' && $('#cmbSource_' + b_seq).val()!='1'){
								//105/01/08 寄庫、寄出... 備註 直接為 寄庫、寄出...X件 
								$('#txtMemo_'+b_seq).val($('#cmbSource_' + b_seq).find("option:selected").text()+'：'+$('#txtMount_' + b_seq).val()+$('#txtUnit_' + b_seq).val());
																
								/*
								if(!emp($('#txtMemo_'+b_seq).val()))
									$('#txtMemo_'+b_seq).val($('#cmbSource_' + b_seq).find("option:selected").text()+'：'+$('#txtMount_' + b_seq).val()+$('#txtUnit_' + b_seq).val()+','+$('#txtMemo_'+b_seq).val());
								else 
									$('#txtMemo_'+b_seq).val($('#cmbSource_' + b_seq).find("option:selected").text()+'：'+$('#txtMount_' + b_seq).val()+$('#txtUnit_' + b_seq).val());
								*/
								$('#txtPrice_'+b_seq).val('0');
								
							}else{
								$('#txtMemo_'+b_seq).val('');
								if($('#cmbSource_' + b_seq).val()=='1'){
									$('#txtMemo_'+b_seq).val($('#cmbSource_' + b_seq).find("option:selected").text()+'：'+$('#txtMount_' + b_seq).val()+$('#txtUnit_' + b_seq).val());
								}
								
								if(!emp($('#txtQuatno_'+b_seq).val()) && !emp($('#txtNo3_'+b_seq).val())){
									var t_where="where=^^noa='"+$('#txtQuatno_'+b_seq).val()+"' and no3='"+$('#txtNo3_'+b_seq).val()+"' ^^"
									q_gt('view_quats', t_where, 0, 0, 0, "keyin_productno_xy");
								}else{//重新尋找新單價
									var t_custno = trim($('#txtCustno').val());
									var t_odate = trim($('#txtOdate').val());
									var t_pno = trim($('#txtProductno_'+b_seq).val());
									
									if(!emp(t_pno)){
										var t_where = '';
										if (t_custno.length > 0) {
											if (emp(t_custno))
												t_custno='#non';
											if (emp(t_odate))
												t_odate='#non';
											if (emp(t_pno))
												t_pno='#non';
											var t_where = t_odate+ ';'+t_custno+ ';'+t_pno;
											q_func('qtxt.query.keyin_productno_xy2', 'cust_ucc_xy.txt,quatimport,' + t_where);
										}else {
											alert(q_getMsg('msgCustEmp'));
											$('#txtCustno').focus();
											$('#btnMinus_'+b_seq).click();
											return;
										}
									}
								}
							}
							sum();
						});

						$('#txtUnit_' + j).focusout(function() {
							sum();
						});
						// $('#txtWeight_' + j).focusout(function () { sum(); });
						$('#txtPrice_' + j).focusout(function() {
							if(q_cur==1 || q_cur==2){
								$(this).val(round(dec($(this).val()),4));
								sum();
							}
						});
						$('#txtMount_' + j).focusout(function() {
							if (q_cur == 1 || q_cur == 2) {
								t_IdSeq = -1;
								q_bodyId($(this).attr('id'));
								b_seq = t_IdSeq;
								/*if (!emp($('#txtProductno_' + b_seq).val())) {
									var t_custno=$('#txtCustno').val().substr(0,$('#txtCustno').val().indexOf('-'));
									if(t_custno=='') 
										t_custno=$('#txtCustno').val();
									
									var t_where = "where=^^ a.storeno2 like '"+t_custno +"%' and isnull(a.productno,'')='"+$('#txtProductno_' + b_seq).val()+"' ^^";
									q_gt('vcc_xy_store2', t_where, 0, 0, 0, "source_stk", r_accy);
								}*/
								sum();
								if(dec($('#txtMount_'+b_seq).val())>0 && dec($('#txtTotal_'+b_seq).val())<100 && ($('#cmbSource_'+b_seq).val()=='0' || $('#cmbSource_'+b_seq).val()=='1')){
									alert('產品小計金額低於100或等於0，請確認輸入單價或單位是否正確!!')
								}else if(dec($('#txtMount_'+b_seq).val())>0 && dec($('#txtTotal_'+b_seq).val())>50000 && ($('#cmbSource_'+b_seq).val()=='0' || $('#cmbSource_'+b_seq).val()=='1')){
									alert('產品小計金額大於50000，請確認輸入單價或單位是否正確!!')
								}
							}
						});
						$('#txtTotal_' + j).focusout(function() {
							sum();
						});

						$('#txtMount_' + j).focusin(function() {
							if (q_cur == 1 || q_cur == 2) {
								t_IdSeq = -1;
								q_bodyId($(this).attr('id'));
								b_seq = t_IdSeq;
								if (!emp($('#txtProductno_' + b_seq).val())) {
									//庫存
									var t_where = "where=^^ ['" + q_date() + "','','"+$('#txtProductno_' + b_seq).val()+"')  ^^";
									q_gt('calstk', t_where, 0, 0, 0, "msg_stk", r_accy);
								}
							}
						});
						$('#txtPrice_' + j).focusin(function() {
							if (q_cur == 1 || q_cur == 2) {
								t_IdSeq = -1;
								q_bodyId($(this).attr('id'));
								b_seq = t_IdSeq;
								if (!emp($('#txtProductno_' + b_seq).val())) {
									//金額
									var t_where = "where=^^ noa='" + $('#txtProductno_' + b_seq).val() + "' ^^ stop=1";
									q_gt('ucc', t_where, 0, 0, 0, "msg_ucc", r_accy);
								}
							}
						});

						$('#btnBorn_' + j).click(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							t_where = "noa='" + $('#txtNoa').val() + "' and no2='" + $('#txtNo2_' + b_seq).val() + "'";
							q_box("z_born.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'born', "95%", "95%", q_getMsg('lblBorn'));
						});
						$('#btnNeed_' + j).click(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							t_where = "productno='" + $('#txtProductno_'+ b_seq).val() + "' and product='" + $('#txtProduct_' + b_seq).val() + "'";
							q_box("z_vccneed.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'Need', "95%", "95%", q_getMsg('lblNeed'));
						});

						$('#btnVccrecord_' + j).click(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							t_where = "custno='" + $('#txtCustno').val() + "' and comp='" + $('#txtComp').val() + "' and productno='" + $('#txtProductno_' + b_seq).val() + "' and product='" + $('#txtProduct_' + b_seq).val() + "' and ordeno='"+$('#txtNoa').val()+"' and no2='"+$('#txtNo2_'+b_seq).val()+"' ";
							q_box("z_vccrecord.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'vccrecord', "95%", "95%", q_getMsg('lblRecord_s'));
						});
						
						$('#btnScheduled_' + j).click(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if (!emp($('#txtProductno_' + b_seq).val())) {
								t_where = "noa='"+$('#txtProductno_' + b_seq).val()+"' and product='"+$('#txtProduct_' + b_seq).val()+"' ";
								q_box("z_scheduled.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'scheduled', "95%", "95%", q_getMsg('PopScheduled'));
							}
						});
						
						$('#btnOrdemount_' + i).click(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							t_where = "title='本期訂單' and bdate='"+q_cdn(q_date(),-61)+"' and edate='"+q_cdn(q_date(),+61)+"' and noa='"+$('#txtProductno_' + b_seq).val()+"' and product='"+$('#txtProduct_' + b_seq).val()+"' ";
							q_box("z_workgorde.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'scheduled', "95%", "95%", q_getMsg('PopScheduled'));
						});
						
						$('#txtClassa_'+j).focusout(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if($('#txtClassa_'+b_seq).val()=='印' || $('#txtClassa_'+b_seq).val()=='便'){
								$('#combClassa_' + b_seq).val($('#txtClassa_'+b_seq).val());
								$('#combClassa_' + b_seq).focusout();
							}else{
								$('#combClassa_' + b_seq).val('');
							}
						});
						
						$('#combClassa_' + j).focusout(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							
							$('#txtClassa_'+b_seq).val($('#combClassa_'+b_seq).val());
							
							var t_class=$.trim($('#combClassa_'+b_seq).val());
							if(t_class.length>0 &&(q_cur==1 || q_cur==2)){
								var t_html='';
								if(t_class=='印'){
									t_html="<table id='table_cost' style='width:610px;text-align: center;' border='1' cellpadding='2'  cellspacing='0'><tr>";
									t_html+="<td style='width:100px'>版費</td>";
									t_html+="<td style='width:100px'>刀模費</td>";
									t_html+="<td style='width:100px'>訂金</td>";
									t_html+="<td style='width:100px'>工期</td>";
									t_html+="<td style='width:150px'>其他</td>";
									t_html+="<td> </td></tr><tr>";
									t_html+="<td><input id='cost_txtCost0' type='text' class='txt num c1'/></td>";	
									t_html+="<td><input id='cost_txtCost1' type='text' class='txt num c1'/></td>";
									t_html+="<td><input id='cost_txtDeposit' type='text' class='txt c1'/></td>";
									t_html+="<td><input id='cost_txtWdate' type='text' class='txt c1'/></td>";
									t_html+="<td><input id='cost_txtOther' type='text' class='txt c1'/></td>";
								}
								if(t_class=='便'){
									t_html="<table id='table_cost' style='width:310px;text-align: center;' border='1' cellpadding='2'  cellspacing='0'><tr>";
									t_html+="<td style='width:100px'>交貨日</td>";
									t_html+="<td style='width:150px'>其他</td>";
									t_html+="<td> </td></tr><tr>";
									t_html+="<td><input id='cost_txtWdate' type='text' class='txt c1'/></td>";
									t_html+="<td><input id='cost_txtOther' type='text' class='txt c1'/></td>";
								}
								t_html+="<td><input id='btnClose_div_cost' type='button' value='確定' style='width:55px'></td></tr></table>";
								
								$('#div_cost').html(t_html);
								
								var SeekF= new Array();
								$('#table_cost td').children("input:text").each(function() {
									SeekF.push($(this).attr('id'));
								});
								SeekF.push('btnClose_div_cost');
								
								$('#table_cost td').children("input:text").each(function() {
									$(this).mousedown(function(e) {
										$(this).focus();
										$(this).select();
									});
										
									$(this).bind('keydown', function(event) {
										keypress_bbm(event, $(this), SeekF, SeekF[$.inArray($(this).attr('id'),SeekF)+1]);	
									});
								});
								$('#div_cost').css('top',$('#combClassa_'+b_seq).offset().top-parseInt($('#div_cost').css('height')));
								$('#div_cost').css('left',$('#combClassa_'+b_seq).offset().left+50);
								
								$('#div_cost').show();
								if(t_class=='印')
									$('#cost_txtCost0').focus();
								if(t_class=='便')
									$('#cost_txtWdate').focus();
									
								$('#btnClose_div_cost').click(function() {
									var t_memo='';
									
									if(t_class=='印'){
										//判斷下兩行是否存在版費 或 刀模費
										var iscost1=-1,iscost2=-1;
										if($('#txtProduct_'+(b_seq+1)).length>0){//判斷物件是否存在
											if($('#txtProduct_'+(dec(b_seq)+1)).val().indexOf('版費')>-1){
												iscost1=dec(b_seq)+1;
											}
											if($('#txtProduct_'+(dec(b_seq)+1)).val().indexOf('刀模費')>-1){
												iscost2=dec(b_seq)+1;
											}
										}
										if($('#txtProduct_'+(b_seq+2)).length>0){//判斷物件是否存在
											if($('#txtProduct_'+(dec(b_seq)+2)).val().indexOf('版費')>-1){
												iscost1=dec(b_seq)+2;
											}
											if($('#txtProduct_'+(dec(b_seq)+2)).val().indexOf('刀模費')>-1){
												iscost2=dec(b_seq)+2;
											}
										}
										
										//版費處理
										if(!emp($('#cost_txtCost0').val())){
											if(iscost1>-1){//存在版費>>改費用金額
												q_tr('txtPrice_'+iscost1,dec($('#cost_txtCost0').val()));
											}else{
												q_bbs_addrow('bbs', b_seq, 1);
												$('#txtProductno_'+(dec(b_seq)+1)).val('ZE001');
												$('#txtProduct_'+(dec(b_seq)+1)).val('其他費用');
												$('#txtSpec_'+(dec(b_seq)+1)).val('版費');
												$('#txtMount_'+(dec(b_seq)+1)).val(1);
												$('#txtPrice_'+(dec(b_seq)+1)).val($('#cost_txtCost0').val());
												AutoNo2();
											}
											sum();	
										}
										
										//刀模費處理
										if(!emp($('#cost_txtCost1').val())){
											if(iscost2>-1){
												q_tr('txtPrice_'+iscost2,dec($('#cost_txtCost1').val()));
											}else{
												var t_iscost1=0;
												if($('#txtProduct_'+(b_seq+1)).length>0){
													if($('#txtProduct_'+(b_seq+1)).val().indexOf('版費')>-1){
														t_iscost1=1;
													}
												}
												q_bbs_addrow('bbs', (dec(b_seq)+t_iscost1), 1);
												$('#txtProductno_'+((dec(b_seq)+t_iscost1)+1)).val('ZE004');
												$('#txtProduct_'+((dec(b_seq)+t_iscost1)+1)).val('其他費用');
												$('#txtSpec_'+((dec(b_seq)+t_iscost1)+1)).val('刀模費');
												$('#txtMount_'+((dec(b_seq)+t_iscost1)+1)).val(1);
												$('#txtPrice_'+((dec(b_seq)+t_iscost1)+1)).val($('#cost_txtCost1').val());
												AutoNo2();
											}
											sum();
										}
									}
									
									//訂金
									if(t_class=='印'){
										if($('#cost_txtDeposit').val()!='')
											t_memo=t_memo+(t_memo.length>0?' ':'')+'訂金：'+$('#cost_txtDeposit').val();
									}
									//工期,交貨日
									if($('#cost_txtWdate').val()!=''){
										if(t_class=='印'){
											t_memo=t_memo+(t_memo.length>0?' ':'')+'工期：'+$('#cost_txtWdate').val();
										}
										if(t_class=='便'){
											t_memo=t_memo+(t_memo.length>0?' ':'')+'交貨日：'+$('#cost_txtWdate').val();
										}
									}
									//其他
									if($('#cost_txtOther').val()!=''){
										t_memo=t_memo+(t_memo.length>0?' ':'')+$('#cost_txtOther').val();
									}
									
									if(t_memo.length>0)
										$('#txtMemo_'+b_seq).val($('#txtMemo_'+b_seq).val()+($('#txtMemo_'+b_seq).val().length>0?' ':'')+t_memo);
									
									$('#div_cost').hide();
									$('#txtSizea_'+b_seq).focus();
								});
							}
						});
						
						$('#txtSizea_'+j).focusin(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							var t_class=$.trim($('#combClassa_'+b_seq).val());
							if(!$('#div_cost').is(':hidden')){
								if(t_class=='印')
									$('#cost_txtCost0').focus();
								if(t_class=='便')
									$('#cost_txtWdate').focus();
							}
						});
						
						$('#combGroupbno_'+j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							
							if($('#combGroupbno_'+b_seq).find("option:selected").text()!=''){
								$('#txtProduct_'+b_seq).val($('#combGroupbno_'+b_seq).find("option:selected").text());
								$('#combClassa_'+b_seq).val('印');
								$('#txtClassa_'+b_seq).val('印');
							}
							
							$('#combGroupbno_'+b_seq)[0].selectedIndex=0;
						});
						
						$('#btnSpec_'+j).click(function() {
							//顯示規格
							var t_spec="";
							for (var i = 0; i < uccgb.length; i++) {
								if($('#txtProduct_'+b_seq).val()==uccgb[i].namea){
									t_spec=uccgb[i].spec;
									break;	
								}
							}
							if(t_spec.length>0){
								t_spec=t_spec.split(',');
								var t_html='';
								t_html="<table id='table_spec' style='width:"+(t_spec.length*100)+"px;text-align: center;' border='1' cellpadding='2'  cellspacing='0'>";
								t_html+="<tr><td style='width:35px'>規格</td>";
								for (var i = 0; i < t_spec.length; i++) {
									var t_namea=t_spec[i];
									if(t_namea.indexOf('#')>-1){
										t_namea=t_namea.split('#')[0];
									}
									if(t_namea.indexOf('^')>-1){
										t_namea=t_namea.split('^')[0];
									}
									t_html+="<td>"+t_namea+"</td>";	
								}
								t_html+="<td> </td></tr><tr><td>值</td>";
								for (var i = 0; i < t_spec.length; i++) {
									var t_default='';
									if(t_spec[i].indexOf('#')>-1)
										var t_default=t_spec[i].split('#')[1];
									
									if(t_spec[i].indexOf('^')>-1){
										t_html+="<td style='width:100px;'><input id='spec_txtSpec_"+i+"' type='text' class='txt c1' style='width:75px;' value='"+t_default+"'/>";
										t_html+="<select id='spec_cmbSpec_"+i+"' class='txt c1' style='width: 20px; float: right;'>";
										t_html+=" <option value=''></option>";
										for (var k = 1; k < t_spec[i].split('^').length-1; k++) {
											t_html+=" <option value='"+t_spec[i].split('^')[k]+"'>"+t_spec[i].split('^')[k]+"</option>";
										}
										t_html+=" </select>";
									}else{
										t_html+="<td><input id='spec_txtSpec_"+i+"' type='text' class='txt c1' value='"+t_default+"'/>";
									}
									
									t_html+="</td>";
								}
								t_html+="<td><input id='btnClose_div_spec' type='button' value='確定' style='width:55px'></td></tr></table>";
								$('#div_spec').html(t_html);
								
								$('#table_spec td').children("select").each(function() {
									var n=$(this).attr('id').split('_')[2];
									$('#spec_cmbSpec_'+n).click(function() {
										if($('#spec_cmbSpec_'+n).val()!='')
											$('#spec_txtSpec_'+n).val($('#spec_cmbSpec_'+n).val());
									});
								});
								
								var SeekF= new Array();
								$('#table_spec td').children("input:text").each(function() {
									SeekF.push($(this).attr('id'));
								});
								SeekF.push('btnClose_div_spec');
								
								$('#table_spec td').children("input:text").each(function() {
									$(this).mousedown(function(e) {
										$(this).focus();
										$(this).select();
									});
										
									$(this).bind('keydown', function(event) {
										keypress_bbm(event, $(this), SeekF, SeekF[$.inArray($(this).attr('id'),SeekF)+1]);	
									});
								});
								$('#div_spec').css('top',$('#combGroupbno_'+b_seq).offset().top-parseInt($('#div_spec').css('height')));
								$('#div_spec').css('left',$('#combGroupbno_'+b_seq).offset().left+20);
								$('#div_spec').show();
								$('#spec_txtSpec_0').focus();
							}
							
							$('#btnClose_div_spec').click(function() {
								var t_spec='';
								$('#table_spec td').children("input:text").each(function() {
									if($(this).val()!='')
										t_spec=t_spec+(t_spec.length>0?' ':'')+$(this).val();
								});
								if(t_spec.length>0)
									$('#txtSpec_'+b_seq).val(t_spec);
								
								$('#div_spec').hide();
								$('#txtSpec_'+b_seq).focus();
								
								AutoNo2();
							});
						});
					}
				}
				_bbsAssign();
				HiddenTreat();
				$('.yellow').css('background-color','yellow');
				if (q_cur<1 && q_cur>2) {
					for (var j = 0; j < q_bbsCount; j++) {
						$('#txtDatea_'+j).datepicker( 'destroy' );
					}
				} else {
					for (var j = 0; j < q_bbsCount; j++) {
						$('#txtDatea_'+j).removeClass('hasDatepicker')
						$('#txtDatea_'+j).datepicker();
					}
				}
			}
			
			var copycustno='';
			function btnIns() {
				var t_bbscounts=q_bbsCount;
				if ($('#checkCopy').is(':checked')){
					curData.copy();
					copycustno=$('#txtCustno').val();
				}else{
					copycustno='';
				}
				_btnIns();
				if ($('#checkCopy').is(':checked')){
					while(t_bbscounts>=q_bbsCount){
						q_bbs_addrow('bbs',0,0);
					}
					curData.paste();
				}
				
				//copy_field();
				
				$('#chkIsproj').attr('checked', true);
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val('AUTO');
				$('#txtCno').val(z_cno);
				$('#txtAcomp').val(z_acomp);
				$('#txtOdate').val(q_date());
				$('#txtCustno').focus();
				$('#txtVccno').val('');

				var t_where = "where=^^ 1=0 ^^";
				q_gt('custaddr', t_where, 0, 0, 0, "");
			}
			
			var orde2vcc_modi=false;
			var orde2vcc57=false;
			function btnModi() {
				if (emp($('#txtNoa').val()))
					return;
				
				//105/02/03 開放5~7可以修改數量
				if(!orde2vcc_modi && r_rank<"8"){
					var t_where = "where=^^ ordeno='" + $('#txtNoa').val() + "' ^^";
					q_gt('view_vccs', t_where, 0, 0, 0, "orde_Modi");
					return;
				}
					
				_btnModi();
				//copy_field();
				$('#txtCustno').focus();
				$('.yellow').css('background-color','yellow');
				if (!emp($('#txtCustno').val())) {
					var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^";
					q_gt('custaddr', t_where, 0, 0, 0, "");
				}
				orde2vcc_modi=false;
				
				//105/05/03 已轉製令單,但又修改訂單的問題 只開放數量修改
				if(r_rank<"8" && q_cur==2){
					q_gt('view_cub', "where=^^ ordeno='" + $('#txtNoa').val() + "' ^^", 0, 0, 0, "istocub",r_accy,1);
					var as = _q_appendData("view_cub", "", true);
					if(as[0]!=undefined){
						alert('訂單【'+$('#txtNoa').val()+'】已轉製令單!!');
						$('#btnPlus').attr('disabled', 'disabled');
						for (var j = 0; j < q_bbsCount; j++) {
							$('#btnMinus_'+j).attr('disabled', 'disabled');
							$('#txtProductno_'+j).attr('disabled', 'disabled');
							$('#btnProduct_'+j).attr('disabled', 'disabled');
							$('#txtProduct_'+j).attr('disabled', 'disabled');
							$('#combGroupbno_'+j).attr('disabled', 'disabled');
							$('#txtSpec_'+j).attr('disabled', 'disabled');
							$('#btnSpec_'+j).attr('disabled', 'disabled');
							$('#txtClassa_'+j).attr('disabled', 'disabled');
							$('#combClassa_'+j).attr('disabled', 'disabled');
							$('#txtSizea_'+j).attr('disabled', 'disabled');
							$('#txtDime_'+j).attr('disabled', 'disabled');
							$('#txtUnit_'+j).attr('disabled', 'disabled');
							$('#txtPrice_'+j).attr('disabled', 'disabled');
							$('#cmbSource_'+j).attr('disabled', 'disabled');
							//$('#txtDatea_'+j).attr('disabled', 'disabled');
							$('#txtMemo_'+j).attr('disabled', 'disabled');
						}
					}
				}
			}

			function btnPrint() {
                var t_where = "noa='" + $.trim($('#txtNoa').val()) + "'";
                q_box("z_ordep_xy.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, '', "95%", "95%", q_getMsg('popPrint'));
			}

			function wrServer(key_value) {
				var i;
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
				xmlSql = '';
				if (q_cur == 2)
					xmlSql = q_preXml();

				_btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
				
			}

			function bbsSave(as) {
				if (!as['productno'] && !as['product'] && !as['spec'] && !dec(as['total'])) {
					as[bbsKey[1]] = '';
					return;
				}
				q_nowf();
				as['type'] = abbm2['type'];
				as['mon'] = abbm2['mon'];
				as['noa'] = abbm2['noa'];
				as['odate'] = abbm2['odate'];

				if (!emp(abbm2['datea']))
					as['datea'] = abbm2['datea'];

				as['custno'] = abbm2['custno'];
				as['comp'] = abbm2['comp'];

				if (!as['enda'])
					as['enda'] = 'N';
				t_err = '';
				if (as['price'] != null && (dec(as['price']) > 99999999 || dec(as['price']) < -99999999))
					t_err = q_getMsg('msgPriceErr') + as['price'] + '\n';

				if (as['total'] != null && (dec(as['total']) > 999999999 || dec(as['total']) < -99999999))
					t_err = q_getMsg('msgMoneyErr') + as['total'] + '\n';

				if (t_err) {
					alert(t_err);
					return false;
				}

				return true;
			}

			function refresh(recno) {
				_refresh(recno);
				$('input[id*="txt"]').click(function() {
					browTicketForm($(this).get(0));
				});
				$('#div_addr2').hide();
				HiddenTreat();
				
				var emp_productno=false;
				for (var j = 0; j < q_bbsCount; j++) {
					if (!q_cur) {
						$('#combGroupbno_'+j).attr('disabled', 'disabled');
						$('#combClassa_'+j).attr('disabled', 'disabled');
					}else{
						$('#combGroupbno_'+j).removeAttr('disabled');
						$('#combClassa_'+j).removeAttr('disabled');
					}
					
					if(emp($('#txtProductno_'+j).val()) && !emp($('#txtProduct_'+j).val()))
						emp_productno=true;
				}
				if(!emp($('#txtCustno').val())){//1050113
					t_where = " where=^^ noa='" + $('#txtCustno').val() + "'^^";
					q_gt('custm', t_where, 0, 0, 0, '', r_accy);
				}
			}

			function readonly(t_para, empty) {
				_readonly(t_para, empty);
				if(q_cur==1){
					$('#btnPlusCust').show();
				}else{
					$('#btnPlusCust').hide();
				}
				if (t_para) {
					$('#lblAcomp').show();$('#lblAcompx').hide();
					$('#lblCust').show();$('#lblCustx').hide();
					$('#btnOrdei').removeAttr('disabled');
					$('#combAddr').attr('disabled', 'disabled');
					if(r_rank<'3') // 0107暫時不開放 //1028重新開放並限制權限
						$('#btnOrdetoVcc').attr('disabled', 'disabled');
					else
						$('#btnOrdetoVcc').removeAttr('disabled');
						
					$('#txtOdate').datepicker( 'destroy' );
					for (var j = 0; j < q_bbsCount; j++) {
						$('#combGroupbno_'+j).attr('disabled', 'disabled');
						$('#combClassa_'+j).attr('disabled', 'disabled');
					}
					$('#checkCopy').removeAttr('disabled');
					$('#btnQuat').removeAttr('disabled');
				} else {
					$('#checkCopy').attr('disabled', 'disabled');
					$('#btnOrdei').attr('disabled', 'disabled');
					$('#combAddr').removeAttr('disabled');
					$('#btnOrdetoVcc').attr('disabled', 'disabled');
					$('#txtOdate').datepicker();
					for (var j = 0; j < q_bbsCount; j++) {
						$('#combGroupbno_'+j).removeAttr('disabled');
						$('#combClassa_'+j).removeAttr('disabled');
					}
				}
				var emp_productno=false;
				for (var j = 0; j < q_bbsCount; j++) {
					if(emp($('#txtProductno_'+j).val()) && !emp($('#txtProduct_'+j).val()))
						emp_productno=true;
				}
				
				$('#div_addr2').hide();
				readonly_addr2();
				HiddenTreat();
				$('.yellow').css('background-color','yellow');
				
				if (q_cur == 1 || q_cur == '2')
                    $('#btnApv').attr('disabled', 'disabled');
                else
                    $('#btnApv').removeAttr('disabled');
                    
				/*if ($('#txtMemo').val().substr(0,1)=='*' && (q_cur==1 || q_cur==2))
					$('#txtMon').removeAttr('readonly');
				else
					$('#txtMon').attr('readonly', 'readonly');*/
			}
			
			function AutoNo2(){
				var maxno2='001';
				for (var j = 0; j < q_bbsCount; j++) {
					if((!emp($('#txtProductno_'+j).val())) || (!emp($('#txtProduct_'+j).val()))){
						$('#txtNo2_'+j).val(maxno2);
						maxno2=('000'+(dec(maxno2)+1)).substr(-3);
					}
					if(emp($('#txtProductno_'+j).val()) && emp($('#txtProduct_'+j).val())){
						$('#txtNo2_'+j).val('');
					}
				}
			}
			
			function HiddenTreat() {
				/*if (r_rank<9){
					$('.bonus').hide();
				}*/
				
				for (var j = 0; j < q_bbsCount; j++) {
					if(!emp($('#txtQuatno_'+j).val()) || !q_authRun(7)){
						//$('#txtProductno_'+j).attr('disabled', 'disabled'); //1050127 開放修改 輸入相同產品 
						//$('#btnProduct_'+j).attr('disabled', 'disabled');
						$('#txtProduct_'+j).attr('disabled', 'disabled');
						$('#txtSpec_'+j).attr('disabled', 'disabled');
						$('#txtClassa_'+j).attr('disabled', 'disabled');
						$('#txtSizea_'+j).attr('disabled', 'disabled');
						$('#txtDime_'+j).attr('disabled', 'disabled');
						$('#txtUnit_'+j).attr('disabled', 'disabled');
						$('#txtPrice_'+j).attr('disabled', 'disabled');
						$('#combGroupbno_'+j).attr('disabled', 'disabled');
						$('#combClassa_'+j).attr('disabled', 'disabled');
					}else{
						//$('#txtProductno_'+j).removeAttr('disabled');
						//$('#btnProduct_'+j).removeAttr('disabled');
						$('#txtProduct_'+j).removeAttr('disabled');
						$('#txtSpec_'+j).removeAttr('disabled');
						$('#txtClassa_'+j).removeAttr('disabled');
						$('#txtSizea_'+j).removeAttr('disabled');
						$('#txtDime_'+j).removeAttr('disabled');
						$('#txtUnit_'+j).removeAttr('disabled');
						$('#txtPrice_'+j).removeAttr('disabled');
						$('#combGroupbno_'+j).removeAttr('disabled');
						$('#combClassa_'+j).removeAttr('disabled');
					}
					
					if(orde2vcc57 && q_cur==2 && r_rank<'8'){
						$('#btnPlus').attr('disabled', 'disabled');
						for (var j = 0; j < q_bbsCount; j++) {
							$('#btnMinus_'+j).attr('disabled', 'disabled');
							$('#txtProductno_'+j).attr('disabled', 'disabled');
							$('#btnProduct_'+j).attr('disabled', 'disabled');
							$('#txtProduct_'+j).attr('disabled', 'disabled');
							$('#combGroupbno_'+j).attr('disabled', 'disabled');
							$('#txtSpec_'+j).attr('disabled', 'disabled');
							$('#btnSpec_'+j).attr('disabled', 'disabled');
							$('#txtClassa_'+j).attr('disabled', 'disabled');
							$('#combClassa_'+j).attr('disabled', 'disabled');
							$('#txtSizea_'+j).attr('disabled', 'disabled');
							$('#txtDime_'+j).attr('disabled', 'disabled');
							$('#txtUnit_'+j).attr('disabled', 'disabled');
							$('#txtPrice_'+j).attr('disabled', 'disabled');
							$('#cmbSource_'+j).attr('disabled', 'disabled');
							$('#txtDatea_'+j).attr('disabled', 'disabled');
							$('#txtMemo_'+j).attr('disabled', 'disabled');
						}
					}
					
					//copy_field();
				}
				
				if(emp($('#txtOrdbno').val()) && q_cur<1 && q_cur>2){
					$('#lblOrde2ordb').show();
					$('#lblOrdbno').hide();
				}else{
					$('#lblOrde2ordb').hide();
					$('#lblOrdbno').show();
				}
				
			}
			
			//20160109 取消該功能
			function copy_field() {
				if(!emp($('#txtPostname').val()) && (q_cur==1||q_cur==2) ){
					for(var i=0 ;i<fbbm.length;i++){
						if(!(fbbm[i]=='txtOdate' || fbbm[i]=='cmbStype' || fbbm[i]=='txtCustorde' || fbbm[i]=='txtMemo'
						|| fbbm[i]=='txtAddr2' || fbbm[i]=='txtPost2' || fbbm[i]=='cmbTaxtype'
						|| fbbm[i]=='chkIsproj' || fbbm[i]=='chkEnda' || fbbm[i]=='chkCancel'
						|| fbbm[i]=='cmbCoin' || fbbm[i]=='txtFloata' || fbbm[i]=='txtCustno'))
							$('#'+fbbm[i]).attr('disabled', 'disabled');
					}
					if(q_cur==2)
						$('#txtCustno').attr('disabled', 'disabled');
						
					$('#lblAcomp').hide();
					$('#lblAcompx').text($('#lblAcomp').text()).show();
					$('#lblCust').hide();
					$('#lblCustx').text($('#lblCust').text()).show();
					$('#btnPlusCust').hide();
					$('#lblAcomp').hide();
					$('#lblCust').hide();
					$('#combPaytype').attr('disabled', 'disabled');
					$('#btnQuat').attr('disabled', 'disabled');
					$('#btnPlus').attr('disabled', 'disabled');
					
					for(var j=0 ;j<q_bbsCount;j++){
						for(var i=0 ;i<fbbs.length;i++){
							if(!(fbbs[i]=='txtMount' || fbbs[i]=='txtMemo' || fbbs[i]=='txtDatea'))
								$('#'+fbbs[i]+'_'+j).attr('disabled', 'disabled');
						}
						$('#btnProduct_'+j).attr('disabled', 'disabled');
						$('#combGroupbno_'+j).attr('disabled', 'disabled');
						$('#combClassa_'+j).attr('disabled', 'disabled');
					}
				}
			}

			function btnMinus(id) {
				_btnMinus(id);
				HiddenTreat();
				AutoNo2();
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
				
				q_gt('view_cub', "where=^^ ordeno='" + $('#txtNoa').val() + "' ^^", 0, 0, 0, "istocub",r_accy,1);
				var as = _q_appendData("view_cub", "", true);
				if(as[0]!=undefined){
					alert('訂單【'+$('#txtNoa').val()+'】已轉製令單 禁止刪除!!');
					return;
				}
				
				//0107 判斷是否轉出貨單
				var t_where = "where=^^ ordeno='"+$('#txtNoa').val()+"' ^^";
				q_gt('view_vccs', t_where, 0, 0, 0, "btnDel_orde");
			}

			function btnCancel() {
				_btnCancel();
			}

			function q_popPost(s1) {
				switch (s1) {
					case 'txtCustno':
						if (!emp($('#txtCustno').val())) {
							if(copycustno!='' && copycustno.substr(0,5)!=$('#txtCustno').val().substr(0,5)){
								curData.paste();
								if(q_cur==1)
									$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val('AUTO');
								alert('非總店與相關分店!!');
							}
							/*for(var j=0 ;j<q_bbsCount;j++){
								$('#btnMinus_'+j).click();
							}*/
							
							var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^";
							q_gt('custaddr', t_where, 0, 0, 0, "");
							
							var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^";
							q_gt('cust', t_where, 0, 0, 0, "cust_detail");
							var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^";
							q_gt('custm', t_where, 0, 0, 0, "cust_detail2");
							
							//06/03提示是否有未出訂單
							var t_where = "where=^^ custno='" + $('#txtCustno').val() + "' and isnull(enda,0)!=1 and isnull(cancel,0)!=1 ^^";
							q_gt('view_orde', t_where, 0, 0, 0, "cust_orde");
						}
						break;
					case 'txtProductno_':
						if(!emp($('#txtProductno_'+b_seq).val())){
							if($('#txtProductno_' + b_seq).val().indexOf('-')>0){
								if($('#txtProductno_' + b_seq).val().substr(0,5)!=$('#txtCustno').val().substr(0,5)){
									$('#btnMinus_'+b_seq).click();
									break;
								}
							}
							
							//1050524直接帶入主檔 不判斷
							/*if($('#txtSpec_'+b_seq).val().indexOf('印')>-1 || $('#txtProductno_'+b_seq).val().indexOf($('#txtCustno').val()+"-")>-1){
								$('#combClassa_'+b_seq).val('印');
								$('#txtClassa_'+b_seq).val('印');
							}else{
								$('#combClassa_'+b_seq).val('便');
								$('#txtClassa_'+b_seq).val('便');
								$('#txtDime_'+b_seq).val(0);
							}*/
							
							var t_custno = trim($('#txtCustno').val());
							var t_odate = trim($('#txtOdate').val());
							var t_pno = trim($('#txtProductno_'+b_seq).val());
							var t_where = '';
							if (t_custno.length > 0 && t_pno.length>0) {
								//104/09/10 直接匯入 要直接打數量
								if (emp(t_custno))
									t_custno='#non';
								if (emp(t_odate))
									t_odate='#non';
								if (emp(t_pno))
									t_pno='#non';
								
								var t_where = t_odate+ ';'+t_custno+ ';'+t_pno;
								q_func('qtxt.query.keyin_productno_xy', 'cust_ucc_xy.txt,quatimport,' + t_where);
								
								//12/11 核准判斷暫時拿掉 等上線後再放入 不用apv 抓sign
								/*t_where="where=^^ noa+'_'+odate+'_'+productno in (select MIN(a.noa)+'_'+MIN(a.odate)+'_'+b.productno from view_quat a left join view_quats b on a.noa=b.noa where isnull(b.enda,0)=0 and isnull(b.cancel,0)=0 "
								+q_sqlPara2("a.custno", t_custno.substr(0,5))+" and a.datea>='"+q_date()+"' group by b.productno)";
								t_where+=" and productno='"+$('#txtProductno_'+b_seq).val()+"' and isnull(enda,0)=0 and isnull(cancel,0)=0 "+q_sqlPara2("custno", t_custno) +" and datea>='"+q_date()+"' ^^";
								q_gt('view_quats', t_where, 0, 0, 0, "keyin_productno_xy");*/
							}else {
								alert(q_getMsg('msgCustEmp'));
								$('#txtCustno').focus();
								$('#btnMinus_'+b_seq).click();
								return;
							}
						}
						AutoNo2();
						break;
				}
			}
			
			function q_stPost() {
				if (!(q_cur == 1 || q_cur == 2))
					return false;
					
				var isorde_ucc=false;
				for (var j = 0; j < q_bbsCount; j++) {
					if(!emp($('#txtProduct_'+j).val()) && emp($('#txtProductno_'+j).val())){
						isorde_ucc=true;
						break;
					}
				}
				//if(isorde_ucc){ //1050113暫時拿掉 判斷是否會進來做q_stPost
					var t_paras = $('#txtNoa').val()+ ';'+r_accy;
					q_func('qtxt.query.orde_ucc', 'cust_ucc_xy.txt,orde_ucc,' + t_paras);
					//isorde_ucc=false;
				//}
				
				if(q_cur==2 && !emp($('#txtVccno').val())){//修改後重新產生 避免資料不對應
					alert('請核准後更新出貨單!!');
					/*if (confirm("是否要更新出貨單?"))
						$('#btnOrdetoVcc').click();*/
				}
			}
			
			function q_funcPost(t_func, result) {
				switch(t_func) {
					case 'qtxt.query.apv':
                        var as = _q_appendData("tmp0", "", true, true);
                        if (as[0] != undefined) {
                            var err = as[0].err;
                            var msg = as[0].msg;
                            var ordeno = as[0].ordeno;
                            var userno = as[0].userno;
                            var namea = as[0].namea;
                            if (err == '1') {
                                $('#txtApv').val(namea);
                                for (var i = 0; i < abbm.length; i++) {
                                    if (abbm[i].noa == ordeno) {
                                        abbm[i].apv = namea;
                                        break;
                                    }
                                }
                            } else {
                                alert(msg);
                            }
                        }
                        Unlock(1);
                        break;
					case 'qtxt.query.quatimport':
						var as = _q_appendData("tmp0", "", true, true);
						//移除相同的報價單
						for(var i = 0; i < as.length; i++){
							for (var j = 0; j < q_bbsCount; j++) {
								if(as[i].noa==$('#txtQuatno_'+j).val() && as[i].no3==$('#txtNo3_'+j).val()){
									as.splice(i, 1);
									i--;
									break;
								}
							}
						}
						
						if(as[0]!=undefined){
							//取得報價的第一筆匯率等資料
							var t_where = "where=^^ noa='" + as[0].noa + "' ^^";
							q_gt('view_quat', t_where, 0, 0, 0, "", r_accy);
						}
						
						var t_n=0,t_emp=false;
						for (var i = 0; i < q_bbsCount; i++) {
							if(emp($('#txtProductno_'+i).val()) && emp($('#txtProduct_'+i).val()) && emp($('#txtSpec_'+i).val())){
								t_n=i;
								t_emp=true;
								break;
							}
						}
						if(!t_emp && t_n==0){
							t_n=q_bbsCount;
						}
						
						q_gridAddRow(bbsHtm, 'tbbs', 'txtProductno,txtProduct,txtSpec,txtSizea,txtDime,txtUnit,txtPrice,txtMount,txtQuatno,txtNo3,txtClassa,txtClass'
						, as.length, as, 'productno,product,spec,sizea,dime,unit,price,mount,noa,no3,classa,class', 'txtProductno,txtProduct,txtSpec');
						sum();
						
						if(as.length>0){
							for (var i = 0; i < q_bbsCount; i++) {
								if(dec($('#txtMount_'+i).val())==0)
									$('#txtMount_'+i).val('');
							}
						}
						$('#txtMount_'+t_n).focus();
						AutoNo2();
						bbsAssign();
						break;
					case 'qtxt.query.keyin_productno_xy':
						var as = _q_appendData("tmp0", "", true, true);
						
						if(pno_keyin_apop){
							break;
						}
						pno_keyin_apop=true;
						
						$('#btnMinus_'+b_seq).click();
						q_gridAddRow(bbsHtm, 'tbbs', 'txtProductno,txtProduct,txtSpec,txtSizea,txtDime,txtUnit,txtPrice,txtMount,txtQuatno,txtNo3,txtClassa,txtClass'
						, as.length, as, 'productno,product,spec,sizea,dime,unit,price,mount,noa,no3,classa,class', 'txtProductno,txtProduct,txtSpec');
						
						/*if(as[0]!=undefined ){
							$('#txtProductno_'+b_seq).val(as[0].productno);
							$('#txtProduct_'+b_seq).val(as[0].product);
							$('#txtSpec_'+b_seq).val(as[0].spec);
							$('#txtSizea_'+b_seq).val(as[0].sizea);
							$('#txtDime_'+b_seq).val(as[0].dime);
							$('#txtUnit_'+b_seq).val(as[0].unit);
							$('#txtPrice_'+b_seq).val(as[0].price);
							$('#txtMount_'+b_seq).val(as[0].mount);
							$('#txtQuatno_'+b_seq).val(as[0].noa);
							$('#txtNo3_'+b_seq).val(as[0].no3);
							$('#txtClassa_'+b_seq).val(as[0].classa);
							$('#txtClass_'+b_seq).val(as[0].class);
						}*/
						sum();
						HiddenTreat();
						AutoNo2();
						break;
					case 'qtxt.query.keyin_productno_xy2':
						var as = _q_appendData("tmp0", "", true, true);
						if (as[0] != undefined) {
							$('#txtPrice_'+b_seq).val(as[0].price);
							$('#txtQuatno_'+b_seq).val(as[0].noa);
							$('#txtNo3_'+b_seq).val(as[0].no3);
							sum();
							HiddenTreat();	
						}
						break;
					case 'qtxt.query.btnOk_xy':
						var as = _q_appendData("tmp0", "", true, true);
						var error_productno='';
						var product_in_quat=false;
						for (var i = 0; i < q_bbsCount; i++) {
							if(!emp($('#txtProductno_'+i).val()) && $('#cmbSource_'+i).val()!='2' && $('#cmbSource_'+i).val()!='3' && $('#cmbSource_'+i).val()!='4' ){
								product_in_quat=false;
								for (var j = 0; j < as.length; j++) {
									if(!emp($('#txtQuatno_'+i).val()) && !emp($('#txtNo3_'+i).val())){
										if($('#txtQuatno_'+i).val()==as[j].noa && $('#txtNo3_'+i).val()==as[j].no3){
											product_in_quat=true;
											if(dec($('#txtPrice_'+i).val())< dec(as[j].price)){
												error_productno+=$('#txtProductno_'+i).val()+' '+$('#txtProduct_'+i).val()+' 訂單單價小於報價單價!!\n'
											}
											break;
										}
									}else if(as[j].productno==$('#txtProductno_'+i).val()){
										product_in_quat=true;
										if(dec(as[j].price)>dec($('#txtPrice_'+i).val())){
											error_productno+=$('#txtProductno_'+i).val()+' '+$('#txtProduct_'+i).val()+' 訂單單價小於報價單價!!\n'
										}
										break;
									}
								}
								//103/12/18暫時拿掉
								/*if(!product_in_quat){
									error_productno+=$('#txtProductno_'+i).val()+' '+$('#txtProduct_'+i).val()+' 沒有報價資料!!\n'
								}*/
							}
						}
						
						if(error_productno.length>0){
							alert(error_productno);
						}else{
							check_quat_xy=true;
							btnOk();
						}
						break;
					case 'qtxt.query.msg_quat_xy':
						var as = _q_appendData("tmp0", "", true, true);
						if (as[0] != undefined) {
							t_msg = t_msg + "最近報價單價：" + dec(as[0].price) + "<BR>";
						}else{
							t_msg = t_msg + "最近報價單價：無<BR>";
						}
						//最新出貨單價
						var t_where = "where=^^ custno='" + $('#txtCustno').val() + "' and noa in (select noa from vccs" + r_accy + " where productno='" + $('#txtProductno_' + b_seq).val() + "' and price>0 ) ^^ stop=1";
						q_gt('vcc', t_where, 0, 0, 0, "msg_vcc", r_accy);
						break;
					case 'qtxt.query.ordb':
						var as = _q_appendData("tmp0", "", true, true);
						if (as[0] != undefined) {
							alert("已成功轉成請購單【"+as[0].ordbnos.substr(0,as[0].ordbnos.length-1)+"】!!");
						} else {
							alert('轉請購單失敗!!');
						}
						break;
					case 'qtxt.query.orde_ucc':
						//var as = _q_appendData("tmp0", "", true, true);
						var s2=[];
						s2[0]=q_name + '_s';
						s2[1]="where=^^ noa<='"+$('#txtNoa').val()+"' ^^"
						if(issales)
							s2[1]="where=^^"+replaceAll(replaceAll(s2[1],'where=^^',''),'^^','')+" and salesno='"+r_userno+"' "+"^^";
						q_boxClose2(s2);
						break;
					case 'vcc_post.post.a1':
                		q_func('qtxt.query.post0', 'cust_ucc_xy.txt,orde2vcc,' + encodeURI(r_accy) + ';' + encodeURI($('#txtNoa').val())+ ';0;' + encodeURI(r_userno));
                		break;
                	case 'qtxt.query.post0':
                        q_func('qtxt.query.post1', 'cust_ucc_xy.txt,orde2vcc,' + encodeURI(r_accy) + ';' + encodeURI($('#txtNoa').val())+ ';1;' + encodeURI(r_userno));
                        break;
					case 'qtxt.query.post1':
						var as = _q_appendData("tmp0", "", true, true);
						var t_invono='';
							if (as[0] != undefined) {
								abbm[q_recno]['vccno'] = as[0].vccno;
								$('#txtVccno').val(as[0].vccno);
								
								//vcc.post內容
								if(!emp($('#txtVccno').val())){
									q_func('vcc_post.post', r_accy + ',' + $('#txtVccno').val() + ',1');
								}
							}
							if(q_cur==2 && !emp($('#txtVccno').val()))
                        		alert('已更新出貨單!!');
                        	else
                        		alert('成功轉出出貨單!!');
                        break;
					default:
						break;
				}
			}
			
			//插入欄位
			function q_bbs_addrow(bbsbbt,row,topdown){
	        	//取得目前行
	            var rows_b_seq=dec(row)+dec(topdown);
	            if(bbsbbt=='bbs'){
		            q_gridAddRow(bbsHtm, 'tbbs', 'txtNo2', 1);
		            //目前行的資料往下移動
					for (var i = q_bbsCount-1; i >=rows_b_seq; i--) {
						for (var j = 0; j <fbbs.length; j++) {
		      				if(i!=rows_b_seq)
								$('#'+fbbs[j]+'_'+i).val($('#'+fbbs[j]+'_'+(i-1)).val());
							else
								$('#'+fbbs[j]+'_'+i).val('');
						}
					}
				}
				if(bbsbbt=='bbt'){
					q_gridAddRow(bbtHtm, 'tbbt', fbbt, 1, '', '', '', '__');
		            //目前行的資料往下移動
					for (var i = q_bbtCount-1; i >=rows_b_seq; i--) {
						for (var j = 0; j <fbbt.length; j++) {
		      				if(i!=rows_b_seq)
								$('#'+fbbt[j]+'__'+i).val($('#'+fbbt[j]+'__'+(i-1)).val());
							else
								$('#'+fbbt[j]+'__'+i).val('');
						}
					}
				}
	        }
		</script>
		<style type="text/css">
			#dmain {
				overflow: hidden;
			}
			.dview {
				float: left;
				width: 30%;
				border-width: 0px;
			}
			.tview {
				width: 100%;
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
			}
			.tbbm tr td .lbl.btn:hover {
				color: #FF8F19;
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
			.txt.c1 {
				width: 98%;
				float: left;
			}
			.txt.c2 {
				width: 48%;
				float: left;
			}
			.txt.c3 {
				width: 50%;
				float: left;
			}
			.txt.c6 {
				width: 25%;
			}
			.txt.c7 {
				width: 95%;
				float: left;
			}
			.num {
				text-align: right;
			}
			input[type="text"], input[type="button"] {
				font-size: medium;
			}
		</style>
	</head>
	<body>
		<!--#include file="../inc/toolbar.inc"-->
		<div id="div_ordb" style="position:absolute; top:180px; left:20px; display:none; width:1020px; background-color: #CDFFCE; border: 5px solid gray;">
			<table id="table_ordb" style="width:100%;" border="1" cellpadding='2' cellspacing='0'>
				<tr>
					<td style="width:45px;background-color: #f8d463;" align="center">訂序</td>
					<td style="width:200px;background-color: #f8d463;" align="center">品名</td>
					<td style="width:80px;background-color: #f8d463;" align="center">訂單數量</td>
					<td style="width:80px;background-color: #f8d463;" align="center">安全庫存</td>
					<td style="width:80px;background-color: #f8d463;" align="center">庫存數量</td>
					<td style="width:80px;background-color: #f8d463;" align="center">在途數量</td>
					<td style="width:80px;background-color: #f8d463;" align="center">採購數量</td>
					<td style="width:200px;background-color: #f8d463;" align="center">供應商</td>
					<td style="width:80px;background-color: #f8d463;" align="center">進貨單價</td>
				</tr>
				<tr id='ordb_close'>
					<td align="center" colspan='9'>
						<input id="btnClose_div_ordb" type="button" value="確定">
						<input id="btnClose_div_ordb2" type="button" value="取消">
					</td>
				</tr>
			</table>
		</div>
		
		<div id="div_addr2" style="position:absolute; top:244px; left:500px; display:none; width:530px; background-color: #CDFFCE; border: 5px solid gray;">
			<table id="table_addr2" style="width:100%;" border="1" cellpadding='2' cellspacing='0'>
				<tr>
					<td style="width:30px;background-color: #f8d463;" align="center">
						<input class="btn addr2" id="btnAddr_plus" type="button" value='＋' style="width: 30px" />
					</td>
					<td style="width:70px;background-color: #f8d463;" align="center">郵遞區號</td>
					<td style="width:430px;background-color: #f8d463;" align="center">指送地址</td>
				</tr>
				<tr id='addr2_close'>
					<td align="center" colspan='3'>
						<input id="btnClose_div_addr2" type="button" value="確定">
					</td>
				</tr>
			</table>
		</div>
		
		<div id="div_store2" style="position:absolute; top:300px; left:400px; display:none; width:680px; background-color: #CDFFCE; border: 5px solid gray;">
			<table id="table_store2" style="width:100%;" border="1" cellpadding='2'  cellspacing='0'>
				<tr id='store2_top'>
					<td style="background-color: #f8d463;width: 130px;" align="center">產品編號</td>
					<td style="background-color: #f8d463;width: 150px;" align="center">產品名稱</td>
					<td style="background-color: #f8d463;width: 200px;" align="center">規格</td>
					<td style="background-color: #f8d463;width: 100px;" align="center">寄庫倉庫</td>
					<td style="background-color: #f8d463;width: 100px;" align="center">寄庫數量</td>
				</tr>
				<tr id='store2_close'>
					<td align="center" colspan='5'>
						<input id="btnClose_div_store2" type="button" value="關閉視窗">
					</td>
				</tr>
			</table>
		</div>
		<div id='dmain' style="overflow:hidden;width: 1260px;">
			<div class="dview" id="dview">
				<table class="tview" id="tview">
					<tr>
						<td align="center" style="width:5%"><a id='vewChk'> </a></td>
						<td align="center" style="width:25%"><a id='vewDatea'> </a></td>
						<td align="center" style="width:25%"><a id='vewNoa'> </a></td>
						<td align="center" style="width:40%"><a id='vewComp'> </a></td>
					</tr>
					<tr>
						<td><input id="chkBrow.*" type="checkbox" style=''/></td>
						<td align="center" id='odate'>~odate</td>
						<td align="center" id='noa'>~noa</td>
						<td align="center" id='nick' style="text-align: left;">~nick</td>
					</tr>
				</table>
			</div>
			<div class='dbbm'>
				<table class="tbbm" id="tbbm" style="width: 872px;">
					<tr class="tr1" style="height: 0px">
						<td class="td1" style="width: 128px;"> </td>
						<td class="td2" style="width: 88px;"> </td>
						<td class="td3" style="width: 108px;"> </td>
						<td class="td4" style="width: 108px;"> </td>
						<td class="td5" style="width: 108px;"> </td>
						<td class="td6" style="width: 108px;"> </td>
						<td class="td7" style="width: 108px;"> </td>
						<td class="td7" style="width: 108px;"> </td>
					</tr>
					<tr class="tr1">
						<td class="td1">
							<input id="checkCopy" type="checkbox" style="float:left;"/>
							<a id='lblCopy' class="lbl" style="float:left;"> </a>
							<span> </span><a id='lblOdate' class="lbl"> </a>
						</td>
						<td class="td2"><input id="txtOdate" type="text" class="txt c1"/></td>
						<td class="td3"><span> </span><a id='lblMon' class="lbl"> </a></td>
						<td class="td4"><input id="txtMon" type="text" class="txt c1"/></td>
						<td class="td5"><span> </span><a id='lblStype' class="lbl"> </a></td>
						<td class="td6"><select id="cmbStype" class="txt c1"> </select></td>
						<td class="td7"><span> </span><a id='lblNoa' class="lbl"> </a></td>
						<td class="td8"><input id="txtNoa" type="text" class="txt c1"/></td>
					</tr>
					<tr class="tr2">
						<td class="td1"><span> </span>
							<a id="lblAcomp" class="lbl btn"> </a>
							<a id="lblAcompx" class="lbl btn" style="display: none;"> </a>
						</td>
						<td class="td2"><input id="txtCno" type="text" class="txt c1"/></td>
						<td class="td3" colspan="2"><input id="txtAcomp" type="text" class="txt c1"/></td>
						<td class="td5" ><span> </span><a id='lblContract' class="lbl"> </a></td>
						<td class="td6"colspan="2"><input id="txtContract" type="text" class="txt c1"/></td>
						<td class="td8" align="center"><input id="btnOrdei" type="button" /></td>
						<!--105/06/14沒使用暫時拿掉<input id="btnOrdem" type="button"/>-->
					</tr>
					<tr class="tr3">
						<td class="td1">
							<span> </span>
							<a id="lblCust" class="lbl btn"> </a>
							<a id="lblCustx" class="lbl btn" style="display: none;"> </a>
							<input class="btn" id="btnPlusCust" type="button" value='+' style="font-weight: bold;float: right;" />
						</td>
						<td class="td2"><input id="txtCustno" type="text" class="txt c1"/></td>
						<td class="td3" colspan="2"><input id="txtComp" type="text" class="txt c1"/>
							<input id="txtNick" type="hidden" class="txt c1"/>
						</td>
						<td class="td5"><span> </span><a id='lblPaytype' class="lbl"> </a></td>
						<td class="td6"><input id="txtPaytype" type="text" class="txt c1"/></td>
						<td class="td7">
							<select id="combPaytype" class="txt c1" onchange='combPaytype_chg()' > </select>
						</td>
						<td class="td8" align="center"><input id="btnCredit" type="button" value='' /></td>
					</tr>
					<tr class="tr4">
						<td class="td1"><span> </span><a id='lblTel' class="lbl"> </a></td>
						<td class="td2" colspan='3'><input id="txtTel" type="text" class="txt c1"/></td>
						<td class="td5"><span> </span><a id='lblFax' class="lbl"> </a></td>
						<td class="td6" colspan="2"><input id="txtFax" type="text" class="txt c1" /></td>
						<td class="td8" align="center">
							<input id="btnQuat" type="button" value='' />
						</td>
					</tr>
					<tr class="tr5">
						<td class="td1"><span> </span><a class="lbl">郵遞區號</a></td>
						<td class="td2"><input id="txtPost" type="text" class="txt c1"/></td>
						<td class="td1"><span> </span><a id='lblAddr' class="lbl"> </a></td>
						<td class="td3"colspan='3'><input id="txtAddr" type="text" class="txt c1"/></td>
						<td class="td7"><span> </span>
							<a id='lblOrdbno' class="lbl"> </a>
							<a id='lblOrde2ordb' class="lbl btn"> </a>
						</td>
						<td class="td8"><input id="txtOrdbno" type="text" class="txt c1"/></td>
					</tr>
					<tr class="tr6">
						<td class="td1"><span> </span><a class="lbl">指送區號</a></td>
						<td class="td2"><input id="txtPost2" type="text" class="txt c1"/></td>
						<td class="td1"><span> </span><a id='lblAddr2' class="lbl"> </a></td>
						<td class="td3" colspan='3'>
							<input id="txtAddr2" type="text" class="txt c1" style="width: 302px;"/>
							<select id="combAddr" style="width: 20px" onchange='combAddr_chg()'> </select>
						</td>
						<td class="td7"><input id="btnAddr2" type="button" value='...' style="width: 30px;height: 21px" /> <span> </span><a id='lblOrdcno' class="lbl"> </a></td>
						<td class="td8"><input id="txtOrdcno" type="text" class="txt c1"/></td>
					</tr>
					<tr class="tr7">
						<td class="td1"><span> </span><a id='lblTrantype' class="lbl"> </a></td>
						<td class="td2" colspan="2"><select id="cmbTrantype" class="txt c1" name="D1" > </select></td>
						<td class="td4"><span> </span><a id="lblSales" class="lbl btn"> </a></td>
						<td class="td5" colspan="2">
							<input id="txtSalesno" type="text" class="txt c2"/>
							<input id="txtSales" type="text" class="txt c3"/>
						</td>
						<td class="td7"><span> </span><a id='lblCustorde' class="lbl"> </a></td>
						<td class="td8"><input id="txtCustorde" type="text" class="txt c1"/></td>
					</tr>
					<tr class="tr8">
						<td class="td1"><span> </span><a id='lblMoney' class="lbl"> </a></td>
						<td class="td2" colspan='2'><input id="txtMoney" type="text" class="txt c1" style="text-align: center;"/></td>
						<td class="td4"><span> </span><a id='lblTax' class="lbl"> </a></td>
						<td class="td5"><input id="txtTax" type="text" class="txt num c1"/></td>
						<td class="td6"><select id="cmbTaxtype" class="txt c1" onchange='sum()' > </select></td>
						<td class="td7"><span> </span><a id='lblTotal' class="lbl"> </a></td>
						<td class="td8"><input id="txtTotal" type="text" class="txt num c1"/></td>
					</tr>
					<tr class="tr9">
						<td class="td1"><span> </span><a id='lblFloata' class="lbl"> </a></td>
						<td class="td2"><select id="cmbCoin" class="txt c1" onchange='coin_chg()'> </select></td>
						<td class="td3"><input id="txtFloata" type="text" class="txt num c1" /></td>
						<td class="td4"><span> </span><a id='lblTotalus' class="lbl"> </a></td>
						<td class="td5" colspan='2'><input id="txtTotalus" type="text" class="txt num c1"/></td>
						<td><input style="float: right;" class="btn" id="btnOrdetoVcc" type="button" value='轉出貨單' /> </td>
						<td><input id="txtVccno" type="text" class="txt c1"/></td>
					</tr>
					<tr class="tr10">
						<td class="td1"><span> </span><a id='lblWorker' class="lbl"> </a></td>
						<td class="td2"><input id="txtWorker" type="text" class="txt c1" /></td>
						<td class="td3"><input id="txtWorker2" type="text" class="txt c1" /></td>
						<td class="td4"><span> </span><a class="lbl">訂金</a></td>
						<td class="td6" colspan='2'><input id="txtWeight" type="text" class="txt num c1" /></td>
						<td class="td7"><input id="btnStore2" type="button" style="float: right;" value="寄庫顯示"/></td>
						<td class="td8">
							<input id="btnApv" type="button" style="float: left;" value="核可"/>
							<input id="txtApv" type="text" class="txt c1" style="width: 50px;"/>
						</td>
					</tr>
					<tr class="tr10">
						<td class="td7"><span> </span><a class="lbl">發票開立</a></td>
						<td class="td8" colspan="2"><select id="cmbConform" class="txt c1"> </select></td>
						<td> </td>
						<td colspan="2">
							<input id="chkIsproj" type="checkbox"/>
							<span> </span><a id='lblIsproj'> </a>
							<input id="chkEnda" type="checkbox"/>
							<span> </span><a id='lblEnda'> </a>
							<input id="chkCancel" type="checkbox"/>
							<span> </span><a id='lblCancel'> </a>
							<input id="txtPostname" type="hidden" />
						</td>
						<td><input id="btnOrderep" type="button" style="float: right;" value="訂單未交量"/></td>
					</tr>
					<tr class="tr10">
						<td class="td1"><span> </span><a class="lbl">發票資訊</a></td>
						<td class="td2" colspan="5"><input id="textInvomemo" type="text" class="txt c1" /></td>
						<td class="td4"><span> </span><a class="lbl">聯絡人員</a></td>
						<td class="td5"><input id="textConn" type="text" class="txt c1" /></td>
					</tr>
					<tr class="tr11">
						<td class="td1"><span> </span><a id='lblMemo' class='lbl'> </a></td>
						<td class="td2" colspan='7'>
							<textarea id="txtMemo" cols="10" rows="5" style="width: 99%;height: 50px;"> </textarea>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class='dbbs' style="width: 2200px;">
			<table id="tbbs" class='tbbs' border="1" cellpadding='2' cellspacing='1'>
				<tr style='color:White; background:#003366;' >
					<td align="center" style="width:40px;"><input class="btn" id="btnPlus" type="button" value='＋' style="font-weight: bold;" /></td>
					<td align="center" style="width:40px;"><a>項次</a></td>
					<td align="center" style="width:120px;"><a id='lblProductno'> </a></td>
					<td align="center" style="width:130px;"><a id='lblProduct_s'> </a></td>
					<td align="center" style="width:85px;"><a>版別</a></td>
					<td align="center" style="width:300px;"><a>規格</a></td>
					<td align="center" style="width:70px;"><a>最低<BR>訂購量</a></td>
					<td align="center" style="width:40px;display: none;"><a>色數</a></td>
					<td align="center" style="width:40px;"><a id='lblUnit'> </a></td>
					<td align="center" style="width:85px;"><a id='lblMount'> </a></td>
					<td align="center" style="width:60px;"><a >寄/出庫</a></td>
					<td align="center" style="width:80px;"><a id='lblPrices'> </a></td>
					<td align="center" style="width:100px;"><a id='lblTotal_s'> </a></td>
					<td align="center" style="width:85px;"><a id='lblDateas'> </a></td>
					<!--<td align="center" style="width:85px;" class="bonus"><a>獎金比例</a></td>-->
					<td align="center" style="width:85px;"><a id='lblGemounts'> </a></td>
					<td align="center" style="width:85px;"><a>未交量</a></td>
					<td align="center" ><a>備註</a></td>
					<td align="center" style="width:175px;"><a>報價單號</a></td>
					<td align="center" style="width:43px;"><a id='lblEndas'> </a></td>
					<td align="center" style="width:43px;"><a id='lblCancels'> </a></td>
					<td align="center" style="width:43px;"><a id='lblBorn'> </a></td>
					<td align="center" style="width:43px;"><a id='lblNeed'> </a></td>
					<td align="center" style="width:43px;"><a id='lblVccrecord'> </a></td>
					<td align="center" style="width:43px;"><a id='lblOrdemount'> </a></td>
					<td align="center" style="width:43px;"><a id='lblScheduled'> </a></td>
				</tr>
				<tr style='background:#cad3ff;'>
					<td align="center"><input class="btn" id="btnMinus.*" type="button" value='－' style=" font-weight: bold;" /></td>
					<td align="center">
						<input class="txt c1" id="txtNo2.*" type="text" />
					</td>
					<td align="center">
						<input class="txt c6" id="txtProductno.*" maxlength='30'type="text" style="width:75%;" />
						<input class="btn" id="btnProduct.*" type="button" value='.' style=" font-weight: bold;" />
					</td>
					<td>
						<input id="txtProduct.*" type="text" class="txt c1" style="width:100px;"/>
						<select id="combGroupbno.*" class="txt c1" style="width: 20px; float: right;"> </select>
					</td>
					<td>
						<input id="txtClassa.*" type="text" class="txt c1" style="width: 60px;"/>
						<select id="combClassa.*" class="txt c1" style="width:20px;float: right;"> </select>
					</td>
					<td>
						<input id="txtSpec.*" type="text" class="txt c1" style="width:270px;"/>
						<input class="btn" id="btnSpec.*" type="button" value='.' style=" font-weight: bold;" />
					</td>
					<td><input id="txtSizea.*" type="text" class="txt c1"/></td>
					<td style="display: none;"><input id="txtDime.*" type="text" class="txt c1 num"/></td>
					<td align="center"><input class="txt c7" id="txtUnit.*" type="text"/></td>
					<td><input class="txt num c7 yellow" id="txtMount.*" type="text"/></td>
					<td><select id="cmbSource.*" class="txt c1"> </select></td>
					<td><input class="txt num c7" id="txtPrice.*" type="text" /></td>
					<td><input class="txt num c7" id="txtTotal.*" type="text" /></td>
					<td><input class="txt c7 yellow" id="txtDatea.*" type="text" /></td>
					<!--<td class="bonus"><input class="txt num c7 bonus" id="txtClass.*" type="text" /></td>-->
					<td><input class="txt num c1" id="txtC1.*" type="text" /></td>
					<td><input class="txt num c1" id="txtNotv.*" type="text" /></td>
					<td><input class="txt c7" id="txtMemo.*" type="text" /></td>
					<td>
						<input class="txt" id="txtQuatno.*" type="text" style="width: 70%;" />
						<input class="txt" id="txtNo3.*" type="text" style="width: 20%;"/>
						<input id="recno.*" type="hidden" />
					</td>
					<td align="center"><input id="chkEnda.*" type="checkbox"/></td>
					<td align="center"><input id="chkCancel.*" type="checkbox"/></td>
					<td align="center"><input class="btn" id="btnBorn.*" type="button" value='.' style=" font-weight: bold;" /></td>
					<td align="center"><input class="btn" id="btnNeed.*" type="button" value='.' style=" font-weight: bold;" /></td>
					<td align="center"><input class="btn" id="btnVccrecord.*" type="button" value='.' style=" font-weight: bold;" /></td>
					<td align="center"><input class="btn" id="btnOrdemount.*" type="button" value='.' style=" font-weight: bold;" /></td>
					<td align="center"><input class="btn" id="btnScheduled.*" type="button" value='.' style=" font-weight: bold;" /></td>
				</tr>
			</table>
		</div>
		<div id="div_spec" style="position:absolute; top:300px; left:400px; display:none; background-color: #CDFFCE; border: 5px solid gray;"> </div>
		<div id="div_cost" style="position:absolute; top:300px; left:400px; display:none; background-color: #CDFFCE; border: 5px solid gray;"> </div>
		<input id="q_sys" type="hidden" />
	</body>
</html>