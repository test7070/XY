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
			var q_name = "vcc";
			var q_readonly = ['txtNoa', 'txtAccno', 'txtComp','txtNick','txtCardeal','txtSales', 'txtCno', 'txtAcomp', 'txtMoney', 'txtTax', 'txtTotal', 'txtTotalus', 'txtWorker', 'txtWorker2','txtComp2','textStatus','txtDriver','textInvomemo','textConn'];
			var q_readonlys = ['txtTotal', 'txtOrdeno', 'txtNo2','txtNoq','txtProduct','txtStore','txtStore2','txtSpec','txtUnit'];//txtSpec
			var bbmNum = [['txtMoney', 15, 0, 1], ['txtTax', 15, 0, 1],['txtTotal', 15, 0, 1], ['txtTotalus', 15, 0, 1]];
			var bbsNum = [];
			var bbmMask = [];
			var bbsMask = [];
			q_sqlCount = 6;
			brwCount = 6;
			brwCount2 = 14;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'datea';
			aPop = new Array(
				['txtCustno', 'lblCust_xy', 'cust', 'noa,comp,nick,tel,invoicetitle', 'txtCustno,txtComp,txtNick,txtTel', 'cust_b.aspx'],
				['txtStoreno_', 'btnStoreno_', 'store', 'noa,store', 'txtStoreno_,txtStore_', 'store_b.aspx'],
				['txtStoreno2_', 'btnStoreno2_', 'store', 'noa,store', 'txtStoreno2_,txtStore2_', 'store_b.aspx'],
				['txtRackno_', 'btnRackno_', 'rack', 'noa,rack,storeno,store', 'txtRackno_', 'rack_b.aspx'],
				['txtCardealno', 'lblCardeal', 'cardeal', 'noa,comp', 'txtCardealno,txtCardeal', 'cardeal_b.aspx'],
				['txtCno', 'lblAcomp', 'acomp', 'noa,acomp', 'txtCno,txtAcomp', 'acomp_b.aspx'],
				['txtSalesno', 'lblSales', 'sss', 'noa,namea', 'txtSalesno,txtSales', 'sss_b.aspx'],
				['txtCustno2', 'lblCust2', 'cust', 'noa,comp', 'txtCustno2,txtComp2', 'cust_b.aspx'],
				['txtDriverno', 'lblDriver', 'sss', 'noa,namea', 'txtDriverno,txtDriver', 'sss_b.aspx'],
				['txtProductno_', 'btnProductno_', 'ucaucc', 'noa,product,spec,unit', 'txtProductno_,txtProduct_,txtSpec_,txtUnit_', 'ucaucc_b.aspx']
			);

			var isinvosystem = false;
			//購買發票系統
			$(document).ready(function() {
				q_desc = 1;
				bbmKey = ['noa'];
				bbsKey = ['noa', 'noq'];
				q_brwCount();
				//q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
				q_gt('acomp', 'stop=1 ', 0, 0, 0, "cno_acomp");
				//q_gt('ucca', 'stop=1 ', 0, 0, 0, "ucca_invo");//判斷是否有買發票系統
				q_gt('flors_coin', '', 0, 0, 0, "flors_coin");
				q_gt('sss', "where=^^noa='"+r_userno+"'^^", 0, 0, 0, "sssissales");
			});

			function main() {
				if (dataErr) {
					dataErr = false;
					return;
				}
				mainForm(1);
			}

			function sum() {
				var t1 = 0, t_unit, t_mount;
				if(q_cur==1 || q_cur==2){
					for (var j = 0; j < q_bbsCount; j++) {
						var t_price = dec($('#txtPrice_' + j).val());//單價
						t_mount=q_add(q_float('txtWidth_'+j),q_float('txtTranmoney2_'+j));
						q_tr('txtMount_'+j,t_mount);
						
						$('#txtTotal_' + j).val(round(q_mul(t_price, t_mount), 0));
						
						t1 = q_add(t1, dec(q_float('txtTotal_' + j)));
					}
					$('#txtMoney').val(round(t1, 0));
					
					calTax();
					q_tr('txtTotalus', round(q_mul(q_float('txtTotal'), q_float('txtFloata')), 0));
				}
			}

			function mainPost() {
				if(r_rank<'5'){ //1050128 可直接在出貨單上 增加產品
					//q_readonlys.push('txtMount');
					q_readonlys.push('txtProductno');
					q_readonlys.push('txtPrice');
				}
					
				q_getFormat();
				bbmMask = [['txtDatea', r_picd], ['txtMon', r_picm]];
				bbsMask = [['txtChecker', r_picd]];
				q_mask(bbmMask);
				bbmNum = [['txtMoney', 15, 0, 1], ['txtTax', 15, 0, 1], ['txtTotal', 15, 0, 1], ['txtTotalus', 15, 0, 1]];
				bbsNum = [['txtMount', 10, q_getPara('vcc.mountPrecision'), 1]
				, ['txtWidth', 9, q_getPara('vcc.mountPrecision'), 1], ['txtTotal', 15, 0, 1]
				, ['txtTranmoney2', 9, q_getPara('vcc.mountPrecision'), 1], ['txtTranmoney3', 9, q_getPara('vcc.mountPrecision'), 1]
				, ['txtDime', 9, q_getPara('vcc.mountPrecision'), 1]
				];//['txtPrice', 12, q_getPara('vcc.pricePrecision'), 1]
				//q_cmbParse("cmbTranstyle", q_getPara('sys.transtyle'));
				q_cmbParse("cmbTypea", q_getPara('vcc.typea'));
				q_cmbParse("cmbStype", q_getPara('vcc.stype'));
				q_cmbParse("cmbTaxtype", q_getPara('sys.taxtype'));
				//q_cmbParse("cmbCoin", q_getPara('sys.coin'));
				q_cmbParse("combPay", q_getPara('vcc.paytype'));
				q_cmbParse("cmbTrantype", q_getPara('sys.tran'));
				q_cmbParse("cmbTranstyle", '@,隨貨@隨貨,月結@月結,週結@週結,PO@PO');
				
				var t_where = "where=^^ 1=0  ^^";
				q_gt('custaddr', t_where, 0, 0, 0, "");
				//104/08/17 要跟訂單一樣 單行判斷出貨.寄庫.庫出
				q_cmbParse("cmbItemno",'0@ ,1@寄庫,2@庫出,3@公關品,4@樣品,5@換貨','s');
				//1050111
				q_gt('sss', "where=^^ typea='司機' ^^", 0, 0, 0, "driver_sss");
				
				$('#combDriver').change(function() {
					if(q_cur>0&&q_cur<4){
						$('#txtDriverno').val($('#combDriver').val())
						$('#txtDriver').val($('#combDriver').find("option:selected").text());
					}
					$('#combDriver')[0].selectedIndex=0;
				});
				
				//限制帳款月份的輸入 只有在備註的第一個字為*才能手動輸入					
				$('#txtMemo').change(function(){
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
						if($('#txtMon').val()<=q_getPara('sys.edate').substr(0,r_lenm)){
							alert('帳款月份禁止低於關帳日');
							$('#txtMon').val('');
						}
					}
				});
								
				$('#txtCardealno').change(function(){
					//取得車號下拉式選單
					var thisVal = $(this).val();
					var t_where = "where=^^ noa=N'" + thisVal + "' ^^";
					q_gt('cardeal', t_where, 0, 0, 0, "getCardealCarno");
				});
				
				$('#btnOrdes').click(function() {
					if(q_cur==1 || q_cur==2){
						var t_custno = trim($('#txtCustno').val());
						var t_where = '';
							//105/08/08
							t_where = "isnull(a.enda,0)!=1 and isnull(a.cancel,0)!=1 and a.productno!='' and (a.mount-isnull(b.vccdime,0))>0"
							t_where += " and exists (select * from view_orde where noa=a.noa and len(isnull(apv,''))>0 )";
							if (t_custno.length>0)
								t_where += " and (a.custno='"+t_custno+"')";
							if (!emp($('#txtOrdeno').val()))
								t_where += " and charindex(noa,'" + $('#txtOrdeno').val() + "')>0";
							//105/10/17 判斷 新版、改版的訂單，若未進貨或入庫，禁止轉出貨單
							t_where += " and (a.classa not like '%新版%' or a.classa not like '%改版%' or exists (select * from view_cub where ordeno=a.noa and no2=a.no2 and isnull(mount,0)>0 and isnull(enda,0)=1) )";
							t_where+=" order by case when isnull(a.datea,'')<='"+q_date()+"' and isnull(a.datea,'') !='' then 'A' else 'B' end+isnull(a.datea,''),a.noa,a.no2 -- "
						
						q_box("ordes_b2_xy.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'ordes_xy', "95%", "650px", q_getMsg('popOrde'));
					}
				});
				
				$('#btnVccs').click(function() {
					if(!emp($('#txtCustno').val())){
						var t_custno=$('#txtCustno').val();
						//取最近的出貨單>>先取最後50筆出貨單
						var t_where = " exists (select * from (select top 50 noa from view_vcc where custno='"+t_custno+"' and typea='1' and noa!='"+$('#txtNoa').val()+"' order by datea desc) tmp where noa=view_vccs"+r_accy+".noa ) order by datea desc,noa desc,noq "
						q_box("vccs_b_xy.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where+";"+ r_accy, 'vccs_xy', "95%", "650px", $('#btnVccs').val());
					}else{
						alert("請輸入客戶編號!!");
					}
				});

				$('#lblOrdeno').click(function() {
					q_pop('txtOrdeno', "orde_xy.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";charindex(noa,'" + $('#txtOrdeno').val() + "')>0;" + r_accy + '_' + r_cno, 'orde', 'noa', '', "92%", "1024px", q_getMsg('lblOrdeno'), true);
				});

				$('#lblAccc').click(function() {
					q_pop('txtAccno', "accc.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";accc3='" + $('#txtAccno').val() + "';" + $('#txtDatea').val().substring(0, 3) + '_' + r_cno, 'accc', 'accc3', 'accc2', "92%", "1054px", q_getMsg('lblAccc'), true);
				});

				$('#lblInvono').click(function() {
					t_where = '';
					t_invo = $('#txtInvono').val();
					if (t_invo.length > 0) {
						t_where = "noa='" + t_invo + "'";
						q_box("vcca.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'vcca', "95%", "95%", $('#lblInvono').val());
					}
				});
				
				$('#lblInvo').click(function() {
					t_where = '';
					t_invo = $('#txtInvo').val();
					if (t_invo.length > 0) {
						t_where = "noa='" + t_invo + "'";
						q_box("invo.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'invo', "95%", "95%", $('#lblInvo').val());
					}
				});
				
				$('#btnGenvcca').click(function() {
					$('#btnGenvcca').attr('disabled', 'disabled');
					if(dec($('#txtTotal').val())==0 || dec($('#txtMoney').val())==0){
						alert('金額為零禁止開立發票');
						$('#btnGenvcca').removeAttr('disabled');
						return;
					}
					//105/08/12 強制鎖 只能開3聯發票
					//105/10/03 可以使用2聯式 但稅別禁止空白
					var t_custno=$('#txtCustno').val(),t_serial='';
					var t_p23='',t_taxtype='';
					var t_where = " where=^^ noa='" + t_custno + "'^^";
					q_gt('custm', t_where, 0, 0, 0, 'getinvocustnoGenvcca', r_accy,1);
					var as = _q_appendData("custm", "", true);
					if (as[0] != undefined) {
						if(as[0].invocustno.length>0 && t_custno!=as[0].invocustno){
							t_custno=as[0].invocustno;
						}
					}
					
					var t_where = " where=^^ noa='" + t_custno + "'^^";
					q_gt('cust', t_where, 0, 0, 0, 'getcustGenvcca', r_accy,1);
					var as = _q_appendData("cust", "", true);
					if (as[0] != undefined) {
						t_serial=as[0].serial;
					}
					
					var t_where = " where=^^ noa='" + t_custno + "'^^";
					q_gt('custm', t_where, 0, 0, 0, 'getinvomemoGenvcca', r_accy,1);
					var as = _q_appendData("custm", "", true);
					if (as[0] != undefined) {
						t_p23=as[0].p23;
						t_taxtype=as[0].taxtype;
					}
					
					if(t_p23==''){
						alert('發票聯式未指定!!');
						$('#btnGenvcca').removeAttr('disabled');
						return;
					}
					
					if((t_serial.indexOf('二聯')>-1 || t_p23=='2') && q_date()<'105/09/01'){
						alert('請手開二聯式發票!!');
						$('#btnGenvcca').removeAttr('disabled');
						return;
					}
					
					/*if(t_taxtype!='應稅'){
						alert('客戶發票非應稅禁止自動產生發票!!');
						return;
					}*/
					
					if($('#cmbTaxtype').val()=='0' || $('#cmbTaxtype').val()==''){
						alert('稅別禁止空白!!');
						$('#btnGenvcca').removeAttr('disabled');
						return;
					}
					
					if($('#cmbTypea').val()!='1' || $('#cmbStype').val()=='3'){
						alert('非出貨單禁止開立開票!!');
					}else if($('#cmbTranstyle').val()!='隨貨'){
						alert('發票開立非【隨貨】!!');
					}else{
						if($('#txtInvono').val().length>10){
							alert("多張發票不產生發票!!");
						}else if(r_rank>='3' && $('#txtDatea').val()>='105/07/01'){ //105/08/02 調整3以上可以開發票
							q_func('qtxt.query.vcc2vcca0', 'cust_ucc_xy.txt,vcc2vcca,' + encodeURI(r_accy) + ';' + encodeURI($('#txtNoa').val())+ ';0'+ ';' + encodeURI(r_userno));
						}else if($('#txtDatea').val()<'105/07/01'){
							alert("出貨單日期小於 105/07/01 不產生發票!!");
						}else
							alert('權限不足!!');
					}
					$('#btnGenvcca').removeAttr('disabled');
				});
				
				$('#cmbTypea').change(function() {
					typea_chang();
				});
				
				$('#cmbStype').change(function() {
					stype_chang();
				});
				
				$('#txtFloata').change(function() {
					sum();
				});
				
				$('#cmbTrantype').change(function() {
					Trantype_cardeal();
				});
				
				$('#txtAddr').change(function() {
					var t_custno = trim($(this).val());
					if (!emp(t_custno)) {
						focus_addr = $(this).attr('id');
						var t_where = "where=^^ noa='" + t_custno + "' ^^";
						q_gt('cust', t_where, 0, 0, 0, "cust_addr");
					}
				});

				$('#txtAddr2').change(function() {
					var t_custno = trim($(this).val());
					if (!emp(t_custno)) {
						focus_addr = $(this).attr('id');
						var t_where = "where=^^ noa='" + t_custno + "' ^^";
						q_gt('cust', t_where, 0, 0, 0, "cust_addr");
					}
				});

				$('#txtCustno').change(function() {
					if (!emp($('#txtCustno').val())) {
						var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^";
						q_gt('custaddr', t_where, 0, 0, 0, "");
					}
					cashsalecust();
				}).focusin(function() {
					q_msg($(this),'請輸入客戶編號');
				});
				
				$('#btnClose_div_stk').click(function() {
					$('#div_stk').toggle();
				});
				
				$('#btnStore2').click(function() {
					$('#div_store2').hide();
					if(!emp($('#txtCustno').val())){
						var t_custno=$('#txtCustno').val().substr(0,$('#txtCustno').val().indexOf('-'));
						if(t_custno=='') 
							t_custno=$('#txtCustno').val();
						var t_where = "where=^^ a.storeno2 like '"+t_custno +"%' and a.noa !='"+$('#txtNoa').val()+"' and isnull(a.productno,'')!='' ^^";
						q_gt('vcc_xy_store2', t_where, 0, 0, 0, "store2_store2", r_accy);
					}else{
						alert("請輸入客戶編號!!");
					}
				});
				$('#btnClose_div_store2').click(function() {
					$('#div_store2').hide();
				});
				
				if (isinvosystem)
					$('.istax').hide();
				
				$('#lblDownvcc').click(function() {
					$('#xdownload').attr('src','uploadXYvcc_download.aspx?FileName='+$('#txtZipcode').val()+'&TempName='+$('#txtZipcode').val());
				});
				
				$('#lblIsvcce').click(function() {
					var t_where = '';
					var t_noa = $('#txtNoa').val();
					if (t_noa.length > 0) {
						t_where = "noa=( select top 1 noa from view_vcces where ordeno='" + t_noa + "' and isnull(dime,0)=1 )";
						q_box("vcce_xy.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'vcce_xy', "95%", "95%", '派車作業');
					}
				});
			}

			function q_funcPost(t_func, result) {
				switch(t_func) {
					case 'qtxt.query.vcc2vcca0':
						var t_invono='';
						var as = _q_appendData("tmp0", "", true, true);
						if (as[0] != undefined) {
							t_invono=as[0].invono;
						}
						if(stpostvcca && (t_invono.length==0 || t_invono!=$('#txtInvono').val() ||  emp($('#txtInvono').val()) || $('#txtDatea').val()<'105/07/01' )){
							stpostvcca=false;
							break;
						}
						if(!($('#cmbTypea').val()!='1' || $('#cmbStype').val()=='3' || $('#cmbTranstyle').val()!='隨貨') && r_rank>='3' && $('#txtDatea').val()>='105/07/01'){
							q_func('qtxt.query.vcc2vcca1', 'cust_ucc_xy.txt,vcc2vcca,' + encodeURI(r_accy) + ';' + encodeURI($('#txtNoa').val())+ ';1'+ ';' + encodeURI(r_userno));
						}else{
							if(stpostvcca && t_invono.length>0){
								alert('變更的出貨單不符合開立發票條件!!');
							}else{
								alert('出貨單不符合開立發票條件!!');
							}
							stpostvcca=false;
						}
						break
					case 'qtxt.query.vcc2vcca1':
						var as = _q_appendData("tmp0", "", true, true);
						if (as[0] != undefined) {
							if(as[0].t_err.length>0){
								alert(as[0].t_err);
							}else{
								abbm[q_recno]['invono'] = as[0].invono;
								$('#txtInvono').val(as[0].invono);
								if(stpostvcca){
									alert('發票已更新!!');
								}else{
									alert('發票已產生完畢!!');
								}
							}
						}else{
							alert('發票產生錯誤!!');
						}
						stpostvcca=false;
						break;
					case 'qtxt.query.vcc2vcca2':
						q_cur = 3;
						_btnOk($('#txtNoa').val(), bbmKey[0],'', '', 3);
						Unlock(1);
						break;
					default:
						break;
				}
			}

			function q_boxClose(s2) {
				var ret;
				switch (b_pop) {
					case 'ordes_xy':
						if (q_cur > 0 && q_cur < 4) {
							b_ret = getb_ret();
							if (!b_ret || b_ret.length == 0)
								return;
							
							var t_oredeno = b_ret[0].noa;
							var t_datea = b_ret[0].datea;
							
							//105/01/04 出貨日根據訂單的預交日 //0106 當預交日小於出貨日不變動//01/12 有日期表示優先出貨
							if(t_datea.length>0 && t_datea>=$('#txtDatea').val()){
								$('#txtDatea').val(t_datea);
								$('#txtMemo').val('優先'+$('#txtMemo').val());
							}else if(t_datea.length>0 && t_datea<=$('#txtDatea').val()){ //1050701
								$('#txtDatea').val(q_date());
								$('#txtMemo').val('優先'+$('#txtMemo').val());
							}
							//105/08/24 月份清空 避免換客戶導致帳款月份錯誤
							$('#txtMon').val('');
							
							//帶入表身資料
							for (var i = 0; i < b_ret.length; i++) {
								b_ret[i].tranmoney3=0;
								b_ret[i].tranmoney2=0;
								b_ret[i].width=0;
								b_ret[i].dime=q_sub(dec(b_ret[i].mount),dec(b_ret[i].vccdime));
								b_ret[i].storeno='A';
								b_ret[i].store='總倉庫';
								b_ret[i].storeno2='';
								b_ret[i].store2='';
								if(b_ret[i].source=='2'){//庫出
									b_ret[i].tranmoney3=b_ret[i].mount;
									b_ret[i].mount=0;
									b_ret[i].storeno='';
									b_ret[i].store='';
									b_ret[i].storeno2=b_ret[i].custno.substr(0,5);
									b_ret[i].store2='';
								}else if(b_ret[i].source=='1'){//寄庫
									b_ret[i].tranmoney2=b_ret[i].mount;
									b_ret[i].storeno2=b_ret[i].custno.substr(0,5);
									b_ret[i].store2='';
								}else{
									b_ret[i].width=b_ret[i].mount;
								}
								
								if(b_ret[i].spec.indexOf(b_ret[i].classa)==-1)
									b_ret[i].spec=b_ret[i].classa+' '+b_ret[i].spec;
							}
									
							q_gridAddRow(bbsHtm, 'tbbs', 'txtProductno,txtProduct,txtSpec,txtUnit,txtStoreno,txtStore,txtStoreno2,txtStore2,txtDime,txtMount,txtWidth,txtTranmoney2,txtTranmoney3,txtPrice,txtMemo,txtOrdeno,txtNo2,cmbItemno', b_ret.length, b_ret
							,'productno,product,spec,unit,storeno,store,storeno2,store2,dime,mount,width,tranmoney2,tranmoney3,price,memo,noa,no2,source', 'txtProductno,txtProduct,txtSpec');
							
							for (var i = 0; i < q_bbsCount; i++) {
								if(!emp($('#txtStoreno2_'+i).val()) && emp($('#txtStore2_'+i).val())){
									$('#txtStoreno2_'+i).change();
								}
							}
							
							if (t_oredeno.length > 0) {							
								//取得訂單備註 + 指定地址
								var t_where = "where=^^ charindex(noa,'" + t_oredeno + "')>0 ^^";
								q_gt('view_orde', t_where, 0, 0, 0, "", r_accy);
							}

							$('#txtOrdeno').val(t_oredeno);
						}
						break;
					case 'vccs_xy':
						if (q_cur > 0 && q_cur < 4) {
							b_ret = getb_ret();
							if (!b_ret || b_ret.length == 0)
								return;
							
							ret = q_gridAddRow(bbsHtm, 'tbbs', 'txtProductno,txtProduct,txtSpec,txtUnit,txtDime,txtMount,txtWidth,txtTranmoney2,txtTranmoney3,txtPrice,txtMemo,txtOrdeno,txtNo2,cmbItemno,txtStoreno,txtStore,txtStoreno2,txtStore2', b_ret.length, b_ret
							, 'productno,product,spec,unit,dime,mount,width,tranmoney2,tranmoney3,price,memo,noa,noq,itemno,storeno,store,storeno2,store2', 'txtProductno,txtProduct,txtSpec');
							
						}
						break;
					case q_name + '_s':
						if(issales && s2[1]!=undefined)
							s2[1]="where=^^"+replaceAll(replaceAll(s2[1],'where=^^',''),'^^','')+" and salesno='"+r_userno+"' "+"^^";
						q_boxClose2(s2);
						break;
				}
				b_pop = '';
				AutoNoq();
			}
			
			var t_msg = '';
			var focus_addr = '';
			var z_cno = r_cno, z_acomp = r_comp, z_nick = r_comp.substr(0, 2);
			var carnoList = [];
			var thisCarSpecno = '';
			var issales=false;
			function q_gtPost(t_name) {
				var as;
				switch (t_name) {
					case 'custm':
						var as = _q_appendData("custm", "", true);
						//105/08/01 改抓發票客戶的資料
						var t_cust=$('#txtCustno').val();
						var t_invocust=t_cust;
						if (as[0] != undefined) {
							$('#textConn').val(as[0].conn);
							if(t_invocust.length==0 || t_invocust==t_cust){
								t_invocust=t_cust;
								$('#textInvomemo').val(as[0].invomemo+' '+as[0].p23!=''?(" "+as[0].p23+"聯"):'');
							}else{
								var t_where = " where=^^ noa='" + t_invocust + "'^^";
								q_gt('custm', t_where, 0, 0, 0, 'getinvomemo2', r_accy,1);
								var as2 = _q_appendData("custm", "", true);
								if (as2[0] != undefined) {
									$('#textInvomemo').val(as[0].invomemo+' '+as2[0].p23!=''?(" "+as2[0].p23+"聯"):'');
								}
							}
						}
						
						var t_where = "where=^^ noa='" + t_invocust + "' ^^";
						q_gt('cust', t_where, 0, 0, 0, "getcust",r_accy,1);
						var ass = _q_appendData("cust", "", true);
						if (ass[0] != undefined) {
							$('#textInvomemo').val($('#textInvomemo').val()+' '+ass[0].invoicetitle+' '+ass[0].serial);
						}
						if (as[0] != undefined) {
							$('#textInvomemo').val($('#textInvomemo').val()+' 交貨時間:'+as[0].trantime);
						}
						break;
					case 'checkVccno_btnOk':
						var as = _q_appendData("view_vcc", "", true);
                        if (as[0] != undefined) {
                            alert('出貨單號已存在!!!');
                        } else {
                            wrServer($('#txtNoa').val());
                        }
						break;
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
					case 'umms':
						var as = _q_appendData("umms", "", true);
						var z_msg = "", t_paysale = 0,t_tpaysale=0;
						if (as[0] != undefined) {
							for (var i = 0; i < as.length; i++) {
								t_paysale = parseFloat(as[i].paysale.length == 0 ? "0" : as[i].paysale);
								t_tpaysale+= parseFloat(as[i].paysale.length == 0 ? "0" : as[i].paysale);
								if (t_paysale != 0)
									z_msg += (as[i].noa+';');
							}
							
							if (z_msg.length > 0) {
								z_msg='已收款：'+FormatNumber(t_tpaysale)+'，收款單號【'+z_msg.substr(0,z_msg.length-1)+ '】。 '
							}
						}else{
							z_msg='未收款。'
						}
						$('#textStatus').val(z_msg);
						break;
					case 'sssissales':
						var as = _q_appendData("sss", "", true);
	                        if (as[0] != undefined) {
	                        	issales=(as[0].issales=="true"?true:false);
	                        	if(issales){
	                        		if(q_content.length>0){
	                        			q_content = "where=^^salesno='" + r_userno + "' and "+replaceAll(q_content,'where=^^','');
	                        		}else{
	                        			q_content = "where=^^salesno='" + r_userno + "'^^";
	                        		}
	                        	}
							}
							q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
						break;
					case 'vccprice_quat':
						var as = _q_appendData("view_quats", "", true);
						for(var i=0;i<q_bbsCount;i++){
							for(var j=0;j<as.length;j++){
								if($('#txtProductno_'+i).val()==as[j].productno){
									q_tr('txtPrice_'+i,dec(as[j].price));
									break;
								}
							}
						}
						sum();
						break;
					case 'btnOk_check_stock':
						var as = _q_appendData("view_vccs", "", true);
						var stkmount_exist="";
						if (as[0] != undefined) {
							for (var i = 0; i < as.length; i++) {
								if(dec(as[i].stkmount)>0){
									stkmount_exist+=(stkmount_exist.length>0?'\n':'')+as[i].product+"尚有寄庫"+as[i].stkmount;
								}
							}
						}else{
							check_stock=true;
						}
						if(stkmount_exist.length>0){
							alert(stkmount_exist+"\n請先將寄庫銷售!!!");
						}else{
							check_stock=true;
							btnOk();	
						}
						break;
					case 'getCardealCarno' :
						var as = _q_appendData("cardeals", "", true);
						carnoList = as;
						var t_item = " @ ";
						if (as[0] != undefined) {
							for ( i = 0; i < as.length; i++) {
								t_item = t_item + (t_item.length > 0 ? ',' : '') + as[i].carno + '@' + as[i].carno;
							}
						}
						for(var k=0;k<carnoList.length;k++){
							if(carnoList[k].carno==$('#txtCarno').val()){
								thisCarSpecno = carnoList[k].carspecno;
								break;
							}
						}
						document.all.combCarno.options.length = 0;
						q_cmbParse("combCarno", t_item);
						$('#combCarno').unbind('change').change(function(){
							if (q_cur == 1 || q_cur == 2) {
								$('#txtCarno').val($('#combCarno').find("option:selected").text());
							}
							for(var k=0;k<carnoList.length;k++){
								if(carnoList[k].carno==$('#txtCarno').val()){
									thisCarSpecno = carnoList[k].carspecno;
									break;
								}
							}
						});
						break;
					case 'msg_stk_all':
						var as = _q_appendData("stkucc", "", true);
						var rowslength=document.getElementById("table_stk").rows.length-3;
							for (var j = 1; j < rowslength; j++) {
								document.getElementById("table_stk").deleteRow(3);
							}
						var stk_row=0;
						
						var stkmount = 0;
						for (var i = 0; i < as.length; i++) {
							//倉庫庫存
							if(dec(as[i].mount)!=0){
								var tr = document.createElement("tr");
								tr.id = "bbs_"+j;
								tr.innerHTML = "<td id='assm_tdStoreno_"+stk_row+"'><input id='assm_txtStoreno_"+stk_row+"' type='text' class='txt c1' value='"+as[i].storeno+"' disabled='disabled'/></td>";
								tr.innerHTML+="<td id='assm_tdStore_"+stk_row+"'><input id='assm_txtStore_"+stk_row+"' type='text' class='txt c1' value='"+as[i].store+"' disabled='disabled' /></td>";
								tr.innerHTML+="<td id='assm_tdMount_"+stk_row+"'><input id='assm_txtMount_"+stk_row+"' type='text' class='txt c1 num' value='"+as[i].mount+"' disabled='disabled'/></td>";
								var tmp = document.getElementById("stk_close");
								tmp.parentNode.insertBefore(tr,tmp);
								stk_row++;
							}
							//庫存總計
							stkmount = stkmount + dec(as[i].mount);
						}
						var tr = document.createElement("tr");
						tr.id = "bbs_"+j;
						tr.innerHTML="<td colspan='2' id='stk_tdStore_"+stk_row+"' style='text-align: right;'><span id='stk_txtStore_"+stk_row+"' class='txt c1' >倉庫總計：</span></td>";
						tr.innerHTML+="<td id='stk_tdMount_"+stk_row+"'><span id='stk_txtMount_"+stk_row+"' type='text' class='txt c1 num' > "+stkmount+"</span></td>";
						var tmp = document.getElementById("stk_close");
						tmp.parentNode.insertBefore(tr,tmp);
						stk_row++;
						
						$('#div_stk').css('top',mouse_point.pageY-parseInt($('#div_stk').css('height')));
						$('#div_stk').css('left',mouse_point.pageX-parseInt($('#div_stk').css('width')));
						$('#div_stk').toggle();
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
							tr.id = "store2_"+i;
							tr.innerHTML = "<td><input id='store2_txtProductno_"+store2_row+"' type='text' class='txt c1' value='"+as[i].productno+"' disabled='disabled'/></td>";
							tr.innerHTML+="<td><input id='store2_txtProduct_"+store2_row+"' type='text' class='txt c1' value='"+as[i].product+"' disabled='disabled' /></td>";
							tr.innerHTML+= "<td><input id='store2_txtSpec_"+store2_row+"' type='text' class='txt c1' value='"+as[i].spec+"' disabled='disabled'/></td>";
							tr.innerHTML+="<td><input id='store2_txtStore_"+store2_row+"' type='text' class='txt c1' value='"+as[i].store2+"' disabled='disabled' /></td>";
							tr.innerHTML+="<td><input id='store2_txtMount_"+store2_row+"' type='text' class='txt c1 num' value='"+dec(as[i].stkmount)+"' disabled='disabled'/></td>";
							
							//總倉庫存
							var t_where = "where=^^ ['" + q_date() + "','A','"+as[i].productno+"')  ^^";//總倉
							q_gt('calstk', t_where, 0, 0, 0, "get_stk", r_accy,1);
							var stk = _q_appendData("stkucc", "", true);
							if (stk[0] != undefined) {
								tr.innerHTML+="<td><input id='store2_txtStk_"+store2_row+"' type='text' class='txt c1 num' value='"+dec(stk[0].mount)+"' disabled='disabled'/></td>";
							}else{
								tr.innerHTML+="<td><input id='store2_txtStk_"+store2_row+"' type='text' class='txt c1 num' value='0' disabled='disabled'/></td>";
							}
							
							//庫存單位
							var t_where = "where=^^ noa='"+as[i].productno+"' ^^";
							q_gt('ucc', t_where, 0, 0, 0, "get_unit", r_accy,1);
							var tunit = _q_appendData("ucc", "", true);
							if (tunit[0] != undefined) {
								tr.innerHTML+="<td><input id='store2_txtUnit_"+store2_row+"' type='text' class='txt c1' value='"+tunit[0].unit+"' disabled='disabled'/></td>";
							}else{
								tr.innerHTML+="<td><input id='store2_txtUnit_"+store2_row+"' type='text' class='txt c1' value='' disabled='disabled'/></td>";
							}
							
							var tmp = document.getElementById("store2_close");
							tmp.parentNode.insertBefore(tr,tmp);
							store2_row++;
						}
						$('#div_store2').css('top', $('#btnStore2').offset().top+25);
						$('#div_store2').css('left', $('#btnStore2').offset().left-parseInt($('#div_store2').css('width'))-5);
						$('#div_store2').show();
						break;
					case 'ucca_invo':
						var as = _q_appendData("ucca", "", true);
						if (as[0] != undefined) {
							isinvosystem = true;
							$('.istax').hide();
						} else {
							isinvosystem = false;
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
					case 'flors':
						var as = _q_appendData("flors", "", true);
						if (as[0] != undefined) {
							q_tr('txtFloata',as[0].floata);
							sum();
						}
						break;
					case 'msg_stk':
						var as = _q_appendData("stkucc", "", true);
						var stkmount = 0;
						t_msg = '';
						for (var i = 0; i < as.length; i++) {
							stkmount = stkmount + dec(as[i].mount);
						}
						t_msg = "庫存量：" + stkmount;
						
						//取得寄庫量
						if(!emp($('#txtProductno_' + b_seq).val())){						
								var t_where = "where=^^ a.productno='" + $('#txtProductno_' + b_seq).val() + "' and a.storeno2='"+$('#txtStoreno2_' + b_seq).val() +"' and a.noa !='"+$('#txtNoa').val()+"' ^^";
								q_gt('vcc_xy_store2', t_where, 0, 0, 0, "store2", r_accy);
						}else{
							q_msg($('#txtMount_' + b_seq), t_msg,10,5000);
						}
						break;
					case 'store2':
						var as = _q_appendData("view_vccs", "", true);
						var stkmount = 0;
						for (var i = 0; i < as.length; i++) {
							stkmount = stkmount + dec(as[i].stkmount);
						}
						if(stkmount!=0)
							t_msg = t_msg + "<BR>寄庫量：" + stkmount;
						q_msg($('#txtMount_' + b_seq), t_msg,10,5000);
						break;
					case 'check_store2':
						var as = _q_appendData("view_vccs", "", true);
						if (as[0] != undefined) {
							if(dec(as[0].stkmount)==0){
								alert("無寄庫量，不得庫出貨!!");
								$('#txtTranmoney3_' + b_seq).val(0);
							}else if (dec($('#txtTranmoney3_' + b_seq).val())>dec(as[0].stkmount)){
								alert("【"+q_getMsg('lblTranmoney3_s')+"】不得大於【寄庫量】!!");
								$('#txtTranmoney3_' + b_seq).val(dec(as[0].stkmount));
							}
						}else{
							alert("無寄庫量，不得庫出貨!!");
							$('#txtTranmoney3_' + b_seq).val(0);	
						}
						break;	
					case 'store2_stk':
						var as = _q_appendData("view_vccs", "", true);
						t_msg='';
						for (var i = 0; i < as.length; i++) {
							if(dec(as[i].stkmount)!=0){
								if(t_msg.length==0)
									t_msg =(as[i].storeno2!=''?(as[i].storeno2+' '+as[i].store2):'(無倉庫名稱)')+" 寄庫量：" +as[i].stkmount;
								else 
									t_msg ="<BR>"+(as[i].storeno2!=''?(as[i].storeno2+' '+as[i].store2):'(無倉庫名稱)')+" 寄庫量：" +as[i].stkmount;
							}
						}
						
						if(t_msg.length>0)
							q_msg($('#txtStoreno2_' + b_seq), t_msg,10,5000);
						break;
					case 'msg_ucc':
						var as = _q_appendData("ucc", "", true);
						t_msg = '';
						if (as[0] != undefined) {
							t_msg = "銷售單價：" + dec(as[0].saleprice) + "<BR>";
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
					case 'view_orde':
						var as = _q_appendData("view_orde", "", true);
						var t_memo = $('#txtMemo').val();
						var t_post2 = '';
						var t_addr2 = '';
						var t_custorde = '';
						
						//20160120 要備註
						$('#txtMemo').val(t_memo+(t_memo.length>0 &&as[0].memo.length>0 ?',':'')+as[0].memo);
						$('#txtPost2').val(t_post2);
						$('#txtAddr2').val(t_addr2);
						
						if (as[0] != undefined) {
							$('#txtCustno').val(as[0].custno);
							$('#txtComp').val(as[0].comp);
							$('#txtNick').val(as[0].nick);
							$('#txtPaytype').val(as[0].paytype);
							$('#cmbTrantype').val(as[0].trantype);
							Trantype_cardeal();
							$('#txtTel').val(as[0].tel);
							$('#txtFax').val(as[0].fax);
							$('#txtPost').val(as[0].post);
							$('#txtAddr').val(as[0].addr);
							$('#txtPost2').val(as[0].post2);
							$('#txtAddr2').val(as[0].addr2);
							$('#txtSalesno').val(as[0].salesno);
							$('#txtSales').val(as[0].sales);
							$('#cmbTaxtype').val(as[0].taxtype);
							$('#cmbCoin').val(as[0].coin);
							$('#txtFloata').val(as[0].floata);
							$('#txtWeight').val(as[0].weight);
							$('#cmbTranstyle').val(as[0].conform);
							
							if(as[0].mon.length>0 && as[0].mon>=$('#txtDatea').val().substr(0,r_lenm)){
								$('#txtMon').val(as[0].mon);
								if($('#txtMemo').val().substr(0,1)!='*')
									$('#txtMemo').val('*'+$('#txtMemo').val());
							}
							Trantype_cardeal();
							//取得收款客戶
							var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^";
							q_gt('cust', t_where, 0, 0, 0, "cust_orde");
						}
						sum();
						refreshBbm();
						break;
					case 'cust_orde':
						var as = _q_appendData("cust", "", true);
						if (as[0] != undefined) {
							$('#txtCustno2').val(as[0].custno2);
							$('#txtComp2').val(as[0].cust2);
						}
						break;
					case 'cust_addr':
						var as = _q_appendData("cust", "", true);
						if (as[0] != undefined && focus_addr != '') {
							$('#' + focus_addr).val(as[0].addr_fact);
							focus_addr = '';
						}
						break;
					case 'cust_detail':
						var as = _q_appendData("cust", "", true);
						if (as[0] != undefined) {
							$('#txtFax').val(as[0].fax);
							$('#txtPost').val(as[0].zip_comp);
							$('#txtAddr').val(as[0].addr_comp);
							$('#txtPost2').val(as[0].zip_home);
							$('#txtAddr2').val(as[0].addr_home);
							$('#txtPaytype').val(as[0].paytype);
							$('#cmbTrantype').val(as[0].trantype);
							Trantype_cardeal();
							$('#txtSalesno').val(as[0].salesno);
							$('#txtSales').val(as[0].sales);
							$('#txtCustno2').val(as[0].custno2);
							$('#txtComp2').val(as[0].cust2);
						}
						break;
					case 'cust_detail2':
						var as = _q_appendData("custm", "", true);
						//105/08/01 改抓發票客戶的資料
						var t_cust=$('#txtCustno').val();
						var t_invocust=t_cust;
						if (as[0] != undefined) {
							//$('#txtPrice').val(as[0].tranprice);
							var t_taxtyp=as[0].taxtype;
							var taxtype='0',xy_taxtypetmp=q_getPara('sys.taxtype').split(',');
							for (var i=0;i<xy_taxtypetmp.length;i++){
								if(xy_taxtypetmp[i].split('@')[1]==t_taxtyp)
									taxtype=xy_taxtypetmp[i].split('@')[0];
							}
							$('#cmbTaxtype').val(taxtype);
							$('#textConn').val(as[0].conn);
							$('#cmbTranstyle').val(as[0].invomemo);
							
							if(t_invocust.length==0 || t_invocust==t_cust){
								t_invocust=t_cust;
								$('#textInvomemo').val(as[0].invomemo+' '+as[0].p23!=''?(" "+as[0].p23+"聯"):'');
							}else{
								var t_where = " where=^^ noa='" + t_invocust + "'^^";
								q_gt('custm', t_where, 0, 0, 0, 'getinvomemo2', r_accy,1);
								var as2 = _q_appendData("custm", "", true);
								if (as2[0] != undefined) {
									$('#textInvomemo').val(as[0].invomemo+' '+as2[0].p23!=''?(" "+as2[0].p23+"聯"):'');
								}
							}
						}
						
						var t_where = "where=^^ noa='" + t_invocust + "' ^^";
						q_gt('cust', t_where, 0, 0, 0, "getcust",r_accy,1);
						var ass = _q_appendData("cust", "", true);
						if (ass[0] != undefined) {
							$('#textInvomemo').val($('#textInvomemo').val()+' '+ass[0].invoicetitle+' '+ass[0].serial);
						}
						if (as[0] != undefined) {
							$('#textInvomemo').val($('#textInvomemo').val()+' 交貨時間:'+as[0].trantime);
						}
						
						break;
					case 'btnDele':
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
								Unlock(1);
								return;
							}
						}
						
						var t_where = " where=^^ vccno='" + $('#txtNoa').val() + "' and [type]='V' ^^";
						q_gt('vcca', t_where, 0, 0, 0, 'btnDele2', r_accy);
						break;
					case 'btnDele2':
						var as = _q_appendData("vcca", "", true);
						var t_invono='';
						if (as[0] != undefined) {
							t_invono=as[0].noa;
						}
						
						if(t_invono.length>0 && r_dele){
							if (!confirm('發票已產生，是否要刪除出貨單並將發票作廢?')){
								Unlock(1);
								return;
							}else{
								q_func('qtxt.query.vcc2vcca2', 'cust_ucc_xy.txt,vcc2vcca,' + encodeURI(r_accy) + ';' + encodeURI($('#txtNoa').val())+ ';2'+ ';' + encodeURI(r_userno));
							}
						}else{
							_btnDele();
							Unlock(1);
						}
						break;
					case 'btnModi':
						var as = _q_appendData("umms", "", true);
						if (as[0] != undefined) {
							var z_msg = "", t_paysale = 0;
							for (var i = 0; i < as.length; i++) {
								t_paysale = parseFloat(as[i].paysale.length == 0 ? "0" : as[i].paysale);
								if (t_paysale != 0)
									z_msg += String.fromCharCode(13) + '收款單號【' + as[i].noa + '】 ' + FormatNumber(t_paysale);
							}
							//105/10/06 恢復正常鎖單
							alert('已沖帳:' + z_msg);
							Unlock(1); //1041225暫時開放可以修改
							return;
							
							/*if (z_msg.length > 0 && r_rank<'3') { //105/05/04 權限2以下提示
								alert('已沖帳:' + z_msg);
								//Unlock(1); //1041225暫時開放可以修改
								//return;
							}*/
						}
						_btnModi();
						if((q_cur==1 || q_cur==2) && r_rank < '9')
							$('.bbsitem').attr('disabled', 'disabled');
						Unlock(1);
						$('#txtDatea').focus();
						if (!emp($('#txtCustno').val())) {
							var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^";
							q_gt('custaddr', t_where, 0, 0, 0, "");
						}
						
						//105/05/03 提示已派車 和 已列印  105/05/04 權限2以下提示
						if(r_rank<'3'){
							q_gt('view_vcc', "where=^^ noa='" + $('#txtNoa').val() + "' ^^", 0, 0, 0, "isprint",r_accy,1);
							var as = _q_appendData("view_vcc", "", true);
							if(as[0]!=undefined){
								if(dec(as[0].tranadd)>0){
									alert('出貨單已列印!!');
								}
							}
							q_gt('view_vcces', "where=^^ ordeno='" + $('#txtNoa').val() + "' ^^", 0, 0, 0, "isvcce",r_accy,1);
							var as = _q_appendData("view_vcces", "", true);
							if(as[0]!=undefined){
								alert('出貨單已派車!!');
							}
						}
						
						break;
					case q_name:
						if (q_cur == 4)
							q_Seek_gtPost();
						break;
					case 'sss':
						as = _q_appendData('sss', '', true);
						break;
					case 'startdate':
						var as = _q_appendData('cust', '', true);
						var t_startdate='';
						if (as[0] != undefined) {
							t_startdate=as[0].startdate;
						}
						if(t_startdate.length==0 || ('00'+t_startdate).slice(-2)=='00' || $('#txtDatea').val().substr(7, 2)<('00'+t_startdate).slice(-2)){
							$('#txtMon').val($('#txtDatea').val().substr(0, r_lenm));
						}else{
							var t_date=$('#txtDatea').val();
							var nextdate=new Date(dec(t_date.substr(0,3))+1911,dec(t_date.substr(4,2))-1,1);
				    		nextdate.setMonth(nextdate.getMonth() +1)
				    		t_date=''+(nextdate.getFullYear()-1911)+'/'+(nextdate.getMonth()<9?'0':'')+(nextdate.getMonth()+1);
							$('#txtMon').val(t_date);
						}
						check_startdate=true;
						btnOk();
						break;
				}
			}
			
			var check_startdate=false,check_stock=false;
			function btnOk() {
				var t_err = q_chkEmpField([['txtNoa', q_getMsg('lblNoa')],['txtDatea', q_getMsg('lblDatea')], ['txtCustno', q_getMsg('lblCust')], ['txtCno', q_getMsg('lblAcomp')]]);
				if (t_err.length > 0) {
					alert(t_err);
					return;
				}
				if(checkId($('#txtDatea').val())!=r_len){
					alert('日期格式錯誤!!');
					return;
				}
				/*if(dec($('#cmbTaxtype').val())<=0){
					alert('請選擇稅別!!');
					return;
				}*/
				
				//判斷只要有商品 數量(出貨 寄庫/出) 為0 彈出警告視窗
				t_err='';
				for (var i = 0; i < q_bbsCount; i++) {
					if(!emp($('#txtProductno_'+i).val()) && q_float('txtWidth_'+i)==0 && q_float('txtTranmoney2_'+i)==0 && q_float('txtTranmoney3_'+i)==0 && q_float('txtMount_'+i)==0 && q_float('txtDime_'+i)==0){
						t_err=t_err+(t_err.length>0?'\n':'')+$('#txtProduct_'+i).val()+'數量為0，請確認出貨、寄庫、庫出數量!!';
					}
				}
				if (t_err.length > 0) {
					alert(t_err);
					return;
				}
				
				for (var i = 0; i < q_bbsCount; i++) {
					if($('#cmbItemno_'+i).val()=='1'){//寄庫
						$('#txtTranmoney2_'+i).val($('#txtDime_'+i).val());
						$('#txtTranmoney3_'+i).val(0);
						$('#txtWidth_'+i).val(0);
					}else if($('#cmbItemno_'+i).val()=='2'){//庫出
						$('#txtTranmoney3_'+i).val($('#txtDime_'+i).val());
						$('#txtTranmoney2_'+i).val(0);
						$('#txtWidth_'+i).val(0);
					}else if($('#cmbItemno_'+i).val()=='3' || $('#cmbItemno_'+i).val()=='4' || $('#cmbItemno_'+i).val()=='5'){//公關品 樣品 補送
						$('#txtWidth_'+i).val($('#txtDime_'+i).val());
						$('#txtTranmoney3_'+i).val(0);
						$('#txtTranmoney2_'+i).val(0);
						$('#txtPrice_'+i).val(0);
					}else{//出貨
						$('#txtWidth_'+i).val($('#txtDime_'+i).val());
						$('#txtTranmoney3_'+i).val(0);
						$('#txtTranmoney2_'+i).val(0);
					}
				}
				
				sum();
				
				//104/02/26 判斷寄庫倉編號要與客戶編號相似
				t_err='';
				var t_custno=$('#txtCustno').val().substr(0,$('#txtCustno').val().indexOf('-'));
				for (var i = 0; i < q_bbsCount; i++) {
					if(!emp($('#txtProductno_'+i).val()) && !emp($('#txtStoreno2_'+i).val()) && $('#txtStoreno2_'+i).val().indexOf(t_custno)==-1 && (q_float('txtTranmoney2_'+i)!=0 || q_float('txtTranmoney3_'+i)!=0)){
						t_err=t_err+(t_err.length>0?'\n':'')+$('#txtProduct_'+i).val()+'寄庫/出倉與寄庫客戶不同!!';
					}
				}
				if (t_err.length > 0) {
					alert(t_err);
					return;
				}
				
				//判斷起算日,寫入帳款月份
				//104/09/30 如果備註沒有*字就重算帳款月份
				//105/01/30 帳款月份不自動變更
				if(!check_startdate && emp($('#txtMon').val())){
				//if(!check_startdate && $('#txtMemo').val().substr(0,1)!='*'){	
					var t_where = "where=^^ noa='"+$('#txtCustno').val()+"' ^^";
					q_gt('cust', t_where, 0, 0, 0, "startdate", r_accy);
					return;
				}
				
				if($('#txtMon').val()<=q_cdn($('#txtDatea').val().substr(0,r_lenm)+'/01',-45).substr(0,r_lenm)){
					alert('帳款月份禁止低於出貨日期前2個月');
					return;
				}
				
				if($('#txtMon').val()<=q_getPara('sys.edate').substr(0,r_lenm)){
					alert('帳款月份禁止低於關帳日');
					return;
				}
				
				//判斷出貨商品是否有寄庫 如果有要先將寄庫出貨完畢才能出貨
				//104/03/02 等寄庫存完整再判斷
				/*if(!check_stock){
					var productno_where="";
					for (var i = 0; i < q_bbsCount; i++) {
						if(!emp($('#txtProductno_'+i).val())&&dec($('#txtWidth_'+i).val())!=0){
							productno_where+=(productno_where.length>0?",":"")+"'"+$('#txtProductno_'+i).val()+"'";
						}
					}
					if(productno_where=="")
						productno_where="''";
					
					//var t_custno=$('#txtCustno').val().substr(0,$('#txtCustno').val().indexOf('-'));
					//if(t_custno=='') 
					//	t_custno=$('#txtCustno').val();
					var t_where = "where=^^ a.noa!='"+$('#txtNoa').val()+"' and a.productno in ("+productno_where+") and a.productno !='' ^^";
					q_gt('vcc_xy_store2', t_where, 0, 0, 0, "btnOk_check_stock", r_accy);
					return;
				}*/
				
				check_stock=false;
				check_startdate=false;
					
				if (q_cur == 1)
					$('#txtWorker').val(r_name);
				else
					$('#txtWorker2').val(r_name);
					
				sum();

				var s1 = $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val();
				if ((s1.length == 0 || s1 == "AUTO") && $('#cmbTypea').val() == '1'){
					q_gtnoa(q_name, replaceAll(q_getPara('sys.key_vcc') + $('#txtDatea').val(), '/', ''));
				}else if ((s1.length == 0 || s1 == "AUTO") && $('#cmbTypea').val() == '2'){
					q_gtnoa(q_name, replaceAll('R' + $('#txtDatea').val(), '/', ''));
				}else{
					if (q_cur == 1){
						t_where = "where=^^ noa='" + $('#txtNoa').val() + "'^^";
                    	q_gt('view_vcc', t_where, 0, 0, 0, "checkVccno_btnOk", r_accy);
					}else{
						wrServer(s1);
					}
				}
			}

			function _btnSeek() {
				if (q_cur > 0 && q_cur < 4)// 1-3
					return;
				q_box('vcc_xy_s.aspx', q_name + '_s', "520px", "850px", q_getMsg("popSeek"));
			}

			function combPay_chg() {
				var cmb = document.getElementById("combPay");
				if (q_cur==1 || q_cur==2)
					$('#txtPaytype').val(cmb.value);
				cmb.value = '';
			}
			
			function coin_chg() {
				var t_where = "where=^^ ('" + $('#txtDatea').val() + "' between bdate and edate) and coin='"+$('#cmbCoin').find("option:selected").text()+"' ^^";
				q_gt('flors', t_where, 0, 0, 0, "");
			}

			function combAddr_chg() {
				if (q_cur == 1 || q_cur == 2) {
					$('#txtAddr2').val($('#combAddr').find("option:selected").text());
					$('#txtPost2').val($('#combAddr').find("option:selected").val());
				}
			}
			
			var mouse_point;
			function bbsAssign() {
				for (var i = 0; i < q_bbsCount; i++) {
					if (!$('#btnMinus_' + i).hasClass('isAssign')) {
						$('#txtUnit_' + i).focusout(function() {
							sum();
						});
						$('#txtPrice_' + i).focusout(function() {
							if(q_cur==1 || q_cur==2){
								$(this).val(round(dec($(this).val()),4));
								sum();
							}
						});
						
												
						$('#txtDime_' + i).focusout(function() {
							if (q_cur == 1 || q_cur == 2){
								t_IdSeq = -1;
								q_bodyId($(this).attr('id'));
								b_seq = t_IdSeq;
								var t_err = q_chkEmpField([['txtCustno', q_getMsg('lblCust')]]);
								if (t_err.length > 0 && $('#txtProductno_'+b_seq).val().length>0) {
									alert(t_err);
									$(this).val('');
									return;
								}
								if($('#cmbItemno_'+b_seq).val()=='1'){//寄庫
									$('#txtTranmoney2_'+b_seq).val($('#txtDime_'+b_seq).val());
									$('#txtTranmoney3_'+b_seq).val(0);
									$('#txtWidth_'+b_seq).val(0);
								}else if($('#cmbItemno_'+b_seq).val()=='2'){//庫出
									$('#txtTranmoney3_'+b_seq).val($('#txtDime_'+b_seq).val());
									$('#txtTranmoney2_'+b_seq).val(0);
									$('#txtWidth_'+b_seq).val(0);
									$('#txtPrice_'+b_seq).val(0);
								}else if($('#cmbItemno_'+b_seq).val()=='3' || $('#cmbItemno_'+b_seq).val()=='4' || $('#cmbItemno_'+b_seq).val()=='5'){//公關品 樣品 補送
									$('#txtWidth_'+b_seq).val($('#txtDime_'+b_seq).val());
									$('#txtTranmoney3_'+b_seq).val(0);
									$('#txtTranmoney2_'+b_seq).val(0);
									$('#txtPrice_'+b_seq).val(0);
								}else{//出貨
									$('#txtWidth_'+b_seq).val($('#txtDime_'+b_seq).val());
									$('#txtTranmoney3_'+b_seq).val(0);
									$('#txtTranmoney2_'+b_seq).val(0);
								}
								$('#cmbItemno_' + b_seq).change();
								sum();
							}
						});
						
						$('#txtMount_' + i).focusout(function() {
							if (q_cur == 1 || q_cur == 2){
								var t_err = q_chkEmpField([['txtCustno', q_getMsg('lblCust')]]);
								if (t_err.length > 0) {
									alert(t_err);
									$(this).val('');
									return;
								}
								sum();
							}
						});
						
						$('#cmbItemno_' + i).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if($('#cmbItemno_'+b_seq).val()=='1'){//寄庫
								$('#txtTranmoney2_'+b_seq).val($('#txtDime_'+b_seq).val());
								$('#txtTranmoney3_'+b_seq).val(0);
								$('#txtWidth_'+b_seq).val(0);
								$('#txtStoreno2_'+b_seq).val($('#txtCustno').val().substr(0,5)).change();
								if(emp($('#txtStoreno_'+b_seq).val()))
									$('#txtStoreno_'+b_seq).val('A').change();
							}else if($('#cmbItemno_'+b_seq).val()=='2'){//庫出
								$('#txtTranmoney3_'+b_seq).val($('#txtDime_'+b_seq).val());
								$('#txtTranmoney2_'+b_seq).val(0);
								$('#txtWidth_'+b_seq).val(0);
								$('#txtPrice_'+b_seq).val(0);
								$('#txtStoreno2_'+b_seq).val($('#txtCustno').val().substr(0,5)).change();
							}else if($('#cmbItemno_'+b_seq).val()=='3' || $('#cmbItemno_'+b_seq).val()=='4' || $('#cmbItemno_'+b_seq).val()=='5'){//公關品樣品補送
								$('#txtWidth_'+b_seq).val($('#txtDime_'+b_seq).val());
								$('#txtTranmoney3_'+b_seq).val(0);
								$('#txtTranmoney2_'+b_seq).val(0);
								$('#txtPrice_'+b_seq).val(0);
								$('#txtStoreno2_'+b_seq).val('');
								$('#txtStore2_'+b_seq).val('');
								if(emp($('#txtStoreno_'+b_seq).val()))
									$('#txtStoreno_'+b_seq).val('HHC').change();
								//105/10/18 若為 公關 樣品 換貨 倉庫=換貨倉
							}else{//出貨
								$('#txtWidth_'+b_seq).val($('#txtDime_'+b_seq).val());
								$('#txtTranmoney3_'+b_seq).val(0);
								$('#txtTranmoney2_'+b_seq).val(0);
								$('#txtStoreno2_'+b_seq).val('');
								$('#txtStore2_'+b_seq).val('');
								if(emp($('#txtStoreno_'+b_seq).val()))
									$('#txtStoreno_'+b_seq).val('A').change();
							}
							sum();
							
							var t_max_unit='';
							var t_max_inmout=0;
							var t_unit=$('#txtUnit_'+b_seq).val();
							var t_inmount=0;
							var t_mount=dec($('#txtDime_'+b_seq).val());
							
							var t_where = "where=^^noa='"+$('#txtProductno_'+b_seq).val()+"'^^";
							q_gt('pack2s', t_where, 0, 0, 0, "getpack2s", r_accy, 1);
							var as = _q_appendData("pack2s", "", true);
											
							for(var i=0 ; i<as.length;i++){
								if(t_max_inmout<dec(as[i].inmount)){
									t_max_unit=as[i].pack;
									t_max_inmout=dec(as[i].inmount);
								}
								if(t_unit==as[i].pack){
									t_inmount=dec(as[i].inmount);
								}
							}
							if(t_max_inmout==0){
								t_max_inmout=1;
								t_max_unit=t_unit;
							}
							
							if(t_max_unit!=t_unit && Math.floor(t_mount/t_max_inmout)>0){
								var t_m1=Math.floor(t_mount/t_max_inmout);
								var t_m2=t_mount-(Math.floor(t_mount/t_max_inmout)*t_max_inmout);
								if($('#cmbItemno_' + b_seq).val()=='0')
									$('#txtMemo_'+b_seq).val(t_m1+t_max_unit+(t_m2>0?t_m2+t_unit:''));
								else
									$('#txtMemo_'+b_seq).val($('#cmbItemno_' + b_seq).find("option:selected").text()+'：'+t_m1+t_max_unit+(t_m2>0?t_m2+t_unit:''));
							}else{
								if($('#cmbItemno_' + b_seq).val()!='0'){
									$('#txtMemo_'+b_seq).val($('#cmbItemno_' + b_seq).find("option:selected").text()+'：'+t_mount+t_unit);
								}else{
									$('#txtMemo_'+b_seq).val('');
								}
							}
							
							/*if($('#cmbItemno_' + b_seq).val()!='0'){
								if(!emp($('#txtMemo_'+b_seq).val()))
									$('#txtMemo_'+b_seq).val($('#cmbItemno_' + b_seq).find("option:selected").text()+'：'+$('#txtDime_' + b_seq).val()+$('#txtUnit_' + b_seq).val()+','+$('#txtMemo_'+b_seq).val());
								else
									$('#txtMemo_'+b_seq).val($('#cmbItemno_' + b_seq).find("option:selected").text()+'：'+$('#txtDime_' + b_seq).val()+$('#txtUnit_' + b_seq).val());
							}*/
						});
						
						$('#txtWidth_' + i).focusout(function() {
							if (q_cur == 1 || q_cur == 2){
								var t_err = q_chkEmpField([['txtCustno', q_getMsg('lblCust')]]);
								if (t_err.length > 0) {
									alert(t_err);
									$(this).val('');
									return;
								}
								sum();
							}
						});
						
						$('#txtProductno_' + i).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							
							var t_err = q_chkEmpField([['txtCustno', q_getMsg('lblCust')]]);
							if (t_err.length > 0) {
								alert(t_err);
								$(this).val('');
								return;
							}
							AutoNoq();
						});
						
						$('#txtPrice_' + i).focusin(function() {
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
						
						$('#txtTranmoney2_' + i).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							var t_err = q_chkEmpField([['txtCustno', q_getMsg('lblCust')]]);
							if (t_err.length > 0) {
								alert(t_err);
								$(this).val('');
								return;
							}
							sum();
							if(dec($('#txtTranmoney2_' + b_seq).val()) > dec($('#txtMount_' + b_seq).val())){
								alert("【"+q_getMsg('lblTranmoney2_s')+"】不得大於【出貨"+q_getMsg('lblMount_s')+"】!!");
								$('#txtTranmoney2_' + b_seq).val($('#txtMount_' + b_seq).val());
							}
						});
						
						$('#txtTranmoney3_' + i).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							var t_err = q_chkEmpField([['txtCustno', q_getMsg('lblCust')]]);
							if (t_err.length > 0) {
								alert(t_err);
								$(this).val('');
								return;
							}
							sum();
							//判斷寄出量是否大於寄庫量
							/*if(!emp($('#txtCustno').val()) && !emp($('#txtProductno_' + b_seq).val()) && dec($(this).val())!=0){
								var t_custno=$('#txtCustno').val().substr(0,$('#txtCustno').val().indexOf('-'));
								if(t_custno=='') 
									t_custno=$('#txtCustno').val();
								
								//var t_where = "where=^^ custno='" + $('#txtCustno').val() + "' and productno='" + $('#txtProductno_' + b_seq).val() + "' and storeno2='"+$('#txtStoreno2_' + b_seq).val() +"' ^^";
								var t_where = "where=^^ b.custno='" + t_custno + "' and productno='" + $('#txtProductno_' + b_seq).val() + "' ^^";
								q_gt('vcc_xy_store2', t_where, 0, 0, 0, "check_store2", r_accy);
							}*/
							//104/03/02 等寄庫存完整再判斷
							/*if(!emp($('#txtProductno_' + b_seq).val()) && dec($(this).val())!=0){						
								var t_where = "where=^^ a.productno='" + $('#txtProductno_' + b_seq).val() + "' and a.storeno2='"+$('#txtStoreno2_' + b_seq).val() +"' and a.noa !='"+$('#txtNoa').val()+"' ^^";
								q_gt('vcc_xy_store2', t_where, 0, 0, 0, "check_store2", r_accy);
							}*/
						});
						
						$('#txtStoreno2_' + i).focusin(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;								
							sum();
							//顯示寄庫資料
							if(!emp($('#txtProductno_' + b_seq).val()) && dec($(this).val())!=0){						
								var t_where = "where=^^ a.productno='" + $('#txtProductno_' + b_seq).val() + "' and a.storeno2='"+$('#txtStoreno2_' + b_seq).val() +"' and a.noa !='"+$('#txtNoa').val()+"' ^^";
								q_gt('vcc_xy_store2', t_where, 0, 0, 0, "store2_stk", r_accy);
							}
						});
						
						$('#btnRecord_' + i).click(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							t_where = "custno='" + $('#txtCustno').val() + "' and comp='" + $('#txtComp').val() + "' and productno='" + $('#txtProductno_' + b_seq).val() + "' and product='" + $('#txtProduct_' + b_seq).val() + "'";
							q_box("z_vccrecord.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'vccrecord', "95%", "95%", q_getMsg('lblRecord_s'));
						});
						
						$('#btnStk_' + i).mousedown(function(e) {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if (!emp($('#txtProductno_' + b_seq).val()) && $("#div_stk").is(":hidden")) {
								mouse_point=e;
								document.getElementById("stk_productno").innerHTML = $('#txtProductno_' + b_seq).val();
								document.getElementById("stk_product").innerHTML = $('#txtProduct_' + b_seq).val();
								//庫存
								var t_where = "where=^^ ['" + q_date() + "','','" + $('#txtProductno_' + b_seq).val() + "') ^^";
								q_gt('calstk', t_where, 0, 0, 0, "msg_stk_all", r_accy);
							}
						});
					}
				}
				_bbsAssign();
				HiddenTreat();
				refreshBbm();
				cashsalecust();
				//$('.store2').hide();//104/02/06 不用昌庫104/02/26恢復用倉庫(不判斷客戶)
				if((q_cur==1 || q_cur==2) && r_rank < '9')
					$('.bbsitem').attr('disabled', 'disabled');
			}

			function btnIns() {
				_btnIns();
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val('AUTO');
				$('#txtCno').val(z_cno);
				$('#txtAcomp').val(z_acomp);
				$('#txtDatea').val(q_cdn(q_date(),1));//105/01/04 當天不會實際出貨 所以當天打得出貨單預設隔天出貨
				$('#cmbTypea').val('1');
				typea_chang();
				$('#txtDatea').focus();
				$('#cmbTaxtype').val('0');
				var t_where = "where=^^ 1=0  ^^";
				q_gt('custaddr', t_where, 0, 0, 0, "");
				refreshBbm();
				Trantype_cardeal();
			}

			function btnModi() {
				if (emp($('#txtNoa').val()))
					return;
				Lock(1, {
					opacity : 0
				});
				$('#txtCustno').focus();
				//取得車號下拉式選單
				var thisVal = $('#txtCardealno').val();
				var t_where = "where=^^ noa=N'" + thisVal + "' ^^";
				q_gt('cardeal', t_where, 0, 0, 0, "getCardealCarno");
				var t_where = " where=^^ vccno='" + $('#txtNoa').val() + "'^^";
				q_gt('umms', t_where, 0, 0, 0, 'btnModi', r_accy);
			}

			function btnPrint() {
				q_box('z_vccp_xy.aspx' + "?;;;noa=" + trim($('#txtNoa').val()) + " and invo=" + trim($('#txtInvono').val()) +";"+ r_accy, '', "95%", "95%", q_getMsg("popPrint"));
			}

			function wrServer(key_value) {
				var i;
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
				_btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
			}

			function bbsSave(as) {
				if (!as['productno'] ) {
					as[bbsKey[1]] = '';
					return;
				}

				q_nowf();
				as['typea'] = abbm2['typea'];
				as['mon'] = abbm2['mon'];
				as['noa'] = abbm2['noa'];
				as['datea'] = abbm2['datea'];
				as['custno'] = abbm2['custno'];
				if (abbm2['storeno'])
					as['storeno'] = abbm2['storeno'];

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
			
			var stpostvcca=false;
			function q_stPost() {
				if (q_cur == 1 || q_cur == 2) {
					var s2 = xmlString.split(';');
					abbm[q_recno]['accno'] = s2[0];
				}
				
				//105/11/07 1張發票號碼才更新
				if(q_cur==2 && $('#txtInvono').val().length==10){//修改後重新產生 避免發票資料不對應
					stpostvcca=true;
					q_func('qtxt.query.vcc2vcca0', 'cust_ucc_xy.txt,vcc2vcca,' + encodeURI(r_accy) + ';' + encodeURI($('#txtNoa').val())+ ';0'+ ';' + encodeURI(r_userno));
				}
			}

			function refresh(recno) {
				_refresh(recno);
				if (isinvosystem)
					$('.istax').hide();
				HiddenTreat();
				stype_chang();
				typea_chang();
				$('#div_stk').hide();
				$('#div_store2').hide();
				if(!emp($('#txtNoa').val())){ //1050111
					var t_where = " where=^^ vccno='" + $('#txtNoa').val() + "'^^";
					q_gt('umms', t_where, 0, 0, 0, '', r_accy);
				}
				if(!emp($('#txtCustno').val())){ //1050113
					//105/08/01 改抓發票客戶的資料
					var t_cust=$('#txtCustno').val();
					t_where = " where=^^ noa='" + t_cust + "'^^";
					q_gt('custm', t_where, 0, 0, 0, '', r_accy);
				}
				refreshBbm();
				//1050429 顯示派車是否已簽收
				$('#lblIsvcce').text('');
				if(!emp($('#txtNoa').val())){ 
					t_where = " where=^^ ordeno='" + $('#txtNoa').val() + "' and isnull(dime,0)=1^^";
					q_gt('view_vcces', t_where, 0, 0, 0, '', r_accy,1);
					var as = _q_appendData("view_vcces", "", true);
					if (as[0] != undefined) {
						$('#lblIsvcce').text('出貨單已簽收');
					}
				}
				
				if($('#txtZipcode').val().length>0)
					$('#lblDownvcc').show();
				else
					$('#lblDownvcc').hide();
			}
			
			function AutoNoq(){
				var maxnoq='001';
				for (var j = 0; j < q_bbsCount; j++) {
					if((!emp($('#txtProductno_'+j).val())) || (!emp($('#txtProduct_'+j).val()))){
						$('#txtNoq_'+j).val(maxnoq);
						maxnoq=('000'+(dec(maxnoq)+1)).substr(-3);
					}
					if(emp($('#txtProductno_'+j).val()) && emp($('#txtProduct_'+j).val())){
						$('#txtNoq_'+j).val('');
					}
				}
			}
			
			function Trantype_cardeal(){//1050111
				if($('#cmbTrantype').val()=='送達'){
					$('#txtCardealno').val('YUDA');
					$('#txtCardeal').val('有達實業有限公司');
				}else if($('#cmbTrantype').val()=='貨運'){
					$('#txtCardealno').val('H002');
					$('#txtCardeal').val('新竹貨運物流');
				}else{
					$('#txtCardealno').val('');
					$('#txtCardeal').val('');
				}
			}

			function HiddenTreat(){
				for (var j = 0; j < q_bbsCount; j++) {
					if(!emp($('#txtOrdeno_'+j).val())){
						$('#txtProductno_'+j).attr('disabled', 'disabled');
						$('#btnProductno_'+j).attr('disabled', 'disabled');
					}else{
						$('#txtProductno_'+j).removeAttr('disabled');
						$('#btnProductno_'+j).removeAttr('disabled');
					}
				}
			}
			
			function typea_chang(){
				if($('#cmbTypea').val()=='1'){
					$('#btnOrdes').show();
					$('#btnVccs').hide();
				}else{
					$('#btnOrdes').hide();
					$('#btnVccs').show();
				}
			}
			
			function stype_chang(){
				if($('#cmbStype').val()=='3'){
					$('.invo').show();
					$('.vcca').hide();
				}else{
					$('.invo').hide();
					$('.vcca').show();
				}
			}

			function readonly(t_para, empty) {
				_readonly(t_para, empty);
				if (t_para) {
					$('#combAddr').attr('disabled', 'disabled');
					$('#btnGenvcca').removeAttr('disabled');
					$('#btnOrdes').attr('disabled', 'disabled');
				} else {
					$('#combAddr').removeAttr('disabled');
					$('#btnGenvcca').attr('disabled', 'disabled');
					$('#btnOrdes').removeAttr('disabled');
				}
				//$('.bbsprice').attr('disabled', 'disabled');
				//1050108 鎖住 //105/07/01 只開放給等級9以上改
				if((q_cur==1 || q_cur==2) && r_rank < '9')
					$('.bbsitem').attr('disabled', 'disabled');
				
				//105/11/07 只開放權限5以下禁止改發票號碼 //出貨單開兩張發票
				if((q_cur==1 || q_cur==2) && r_rank < '5')
					$('#txtInvono').attr('disabled', 'disabled');
				
				HiddenTreat();
				//限制帳款月份的輸入 只有在備註的第一個字為*才能手動輸入
				if ($('#txtMemo').val().substr(0,1)=='*' && (q_cur==1 || q_cur==2))
					$('#txtMon').removeAttr('readonly');
				else
					$('#txtMon').attr('readonly', 'readonly');
				
				if(q_cur==2){
					if($('#txtInvono').val().length>0 && $('#cmbTranstyle').val()!='' && r_rank<5){
						for (var i=0;i<fbbm.length;i++){
							//105/08/19 排除帳款月份(備註) 交運方式 PS 稅別絕對不能開放修改
							if(fbbm[i]!='txtMemo' && fbbm[i]!='txtMon' && fbbm[i]!='cmbTrantype')
								$('#'+fbbm[i]).attr('disabled', 'disabled');
						}
						$('#combPay').attr('disabled', 'disabled');
						$('#combDriver').attr('disabled', 'disabled');
						$('#combAddr').attr('disabled', 'disabled');
						$('#btnOrdes').attr('disabled', 'disabled');
						aPop = new Array(
							['txtStoreno_', 'btnStoreno_', 'store', 'noa,store', 'txtStoreno_,txtStore_', 'store_b.aspx'],
							['txtStoreno2_', 'btnStoreno2_', 'store', 'noa,store', 'txtStoreno2_,txtStore2_', 'store_b.aspx'],
							['txtRackno_', 'btnRackno_', 'rack', 'noa,rack,storeno,store', 'txtRackno_', 'rack_b.aspx'],
							['txtProductno_', 'btnProductno_', 'ucaucc', 'noa,product,spec,unit', 'txtProductno_,txtProduct_,txtSpec_,txtUnit_', 'ucaucc_b.aspx']
						);
					}else{
						$('#combPay').removeAttr('disabled');
						$('#combDriver').removeAttr('disabled');
						$('#combAddr').removeAttr('disabled');
						$('#btnOrdes').removeAttr('disabled');
						aPop = new Array(
							['txtCustno', 'lblCust_xy', 'cust', 'noa,comp,nick,tel,invoicetitle', 'txtCustno,txtComp,txtNick,txtTel', 'cust_b.aspx'],
							['txtStoreno_', 'btnStoreno_', 'store', 'noa,store', 'txtStoreno_,txtStore_', 'store_b.aspx'],
							['txtStoreno2_', 'btnStoreno2_', 'store', 'noa,store', 'txtStoreno2_,txtStore2_', 'store_b.aspx'],
							['txtRackno_', 'btnRackno_', 'rack', 'noa,rack,storeno,store', 'txtRackno_', 'rack_b.aspx'],
							['txtCardealno', 'lblCardeal', 'cardeal', 'noa,comp', 'txtCardealno,txtCardeal', 'cardeal_b.aspx'],
							['txtCno', 'lblAcomp', 'acomp', 'noa,acomp', 'txtCno,txtAcomp', 'acomp_b.aspx'],
							['txtSalesno', 'lblSales', 'sss', 'noa,namea', 'txtSalesno,txtSales', 'sss_b.aspx'],
							['txtCustno2', 'lblCust2', 'cust', 'noa,comp', 'txtCustno2,txtComp2', 'cust_b.aspx'],
							['txtDriverno', 'lblDriver', 'sss', 'noa,namea', 'txtDriverno,txtDriver', 'sss_b.aspx'],
							['txtProductno_', 'btnProductno_', 'ucaucc', 'noa,product,spec,unit', 'txtProductno_,txtProduct_,txtSpec_,txtUnit_', 'ucaucc_b.aspx']
						);
					}
				}
			}
			
			function refreshBbm() {
                if (q_cur == 1 && r_rank>='7') {
                    $('#txtNoa').css('color', 'black').css('background', 'white').removeAttr('readonly');
                } else {
                    $('#txtNoa').css('color', 'green').css('background', 'RGB(237,237,237)').attr('readonly', 'readonly');
                }
                
                if(r_rank<5){ //105/08/19 開放給財務可以調整
                	var t_ordeno='';
                	for (var j = 0; j < q_bbsCount; j++) {
                		if(!emp($('#txtOrdeno_'+j).val()))
                			t_ordeno=$('#txtOrdeno_'+j).val();
                	}
                	if(t_ordeno.length>0){
                		$('#cmbTranstyle').attr('disabled', 'disabled');
                	}
                }
            }

			function btnMinus(id) {
				_btnMinus(id);
				var n=id.split('_')[id.split('_').length-1];
				sum();
				HiddenTreat();
				AutoNoq();
			}

			function btnPlus(org_htm, dest_tag, afield) {
				_btnPlus(org_htm, dest_tag, afield);
			}

			function q_appendData(t_Table) {
				dataErr = !_q_appendData(t_Table);
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
				if (q_chkClose())
					return;
				Lock(1, {
					opacity : 0
				});
				var t_where = " where=^^ vccno='" + $('#txtNoa').val() + "'^^";
				q_gt('umms', t_where, 0, 0, 0, 'btnDele', r_accy);
			}

			function btnCancel() {
				_btnCancel();
			}

			function q_popPost(s1) {
				switch (s1) {
					case 'txtCardealno':
						//取得車號下拉式選單
						var thisVal = $('#txtCardealno').val();
						var t_where = "where=^^ noa=N'" + thisVal + "' ^^";
						q_gt('cardeal', t_where, 0, 0, 0, "getCardealCarno");
						break;
					case 'txtCustno':
						
						if (!emp($('#txtCustno').val())) {
							var t_where = "where=^^ noa='" + $('#txtCustno').val() + "'  ^^";
							q_gt('custaddr', t_where, 0, 0, 0, "");
							var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^";
							q_gt('cust', t_where, 0, 0, 0, "cust_detail");
							
							var t_cust=$('#txtCustno').val();
							var t_where = "where=^^ noa='" + t_cust + "' ^^";
							q_gt('custm', t_where, 0, 0, 0, "cust_detail2");
							
							//105/04/29 現銷客戶 不需要訂單和報價可以直接出貨  交運方式＝自取 單價可改
							for (var j = 0; j < q_bbsCount; j++) {
								$('#btnMinus_'+j).click();
							}
							
							cashsalecust();
						}
						
						$('#txtSalesno').attr('disabled', 'disabled');
						
						
						break;
					case 'txtProductno_':
						if(!emp($('#txtProductno_'+b_seq).val())){
							//重新取得style+spec
							var t_where = "where=^^ noa='" + $('#txtProductno_'+b_seq).val() + "' ^^";
							q_gt('ucaucc', t_where, 0, 0, 0, "ucaucc", r_accy, 1);
							var as = _q_appendData("ucaucc", "", true);
							if (as[0] != undefined) {
								$('#txtSpec_'+b_seq).val(as[0].style+' '+as[0].spec);
							}
						}
						AutoNoq();
						break;
				}
			}
			
			function cashsalecust() {
				//105/04/29 現銷客戶 不需要訂單和報價可以直接出貨  交運方式＝自取 單價可改
				if($('#txtComp').val().indexOf('現銷')>-1 && (q_cur==1 || q_cur==2)){
					$('#cmbTrantype').val('自取');
					for (var j = 0; j < q_bbsCount; j++) {
						$('#txtProductno_'+j).css('color', 'black').css('background', 'white').removeAttr('readonly');
						$('#txtPrice_'+j).css('color', 'black').css('background', 'white').removeAttr('readonly');
						$('#txtProductno_'+j).removeAttr('disabled');
						$('#txtPrice_'+j).removeAttr('disabled');
					}
				}
            }

			function FormatNumber(n) {
				var xx = "";
				if (n < 0) {
					n = Math.abs(n);
					xx = "-";
				}
				n += "";
				var arr = n.split(".");
				var re = /(\d{1,3})(?=(\d{3})+$)/g;
				return xx + arr[0].replace(re, "$1,") + (arr.length == 2 ? "." + arr[1] : "");
			}

			function calTax() {
				var t_money = 0, t_tax = 0, t_total = 0;
				for (var j = 0; j < q_bbsCount; j++) {
					t_money += q_float('txtTotal_' + j);
				}
				t_total = t_money;
				if (!isinvosystem) {
					var t_taxrate = q_div(parseFloat(q_getPara('sys.taxrate')), 100);
					switch ($('#cmbTaxtype').val()) {
						case '0': // 無
							t_tax = 0;
							t_total = q_add(t_money, t_tax);
							break;
						case '1': // 應稅
							t_tax = round(q_mul(t_money, t_taxrate), 0);
							t_total = q_add(t_money, t_tax);
							break;
						case '2': //零稅率
							t_tax = 0;
							t_total = q_add(t_money, t_tax);
							break;
						case '3': // 內含
							t_tax = round(q_mul(q_div(t_money, q_add(1, t_taxrate)), t_taxrate), 0);
							t_total = t_money;
							t_money = q_sub(t_total, t_tax);
							break;
						case '4': // 免稅
							t_tax = 0;
							t_total = q_add(t_money, t_tax);
							break;
						case '5': // 自定
							$('#txtTax').attr('readonly', false);
							$('#txtTax').css('background-color', 'white').css('color', 'black');
							t_tax = round(q_float('txtTax'), 0);
							t_total = q_add(t_money, t_tax);
							break;
						case '6': // 作廢-清空資料
							t_money = 0, t_tax = 0, t_total = 0;
							break;
						default:
					}
				}
				$('#txtMoney').val(FormatNumber(t_money));
				$('#txtTax').val(FormatNumber(t_tax));
				$('#txtTotal').val(FormatNumber(t_total));
			}
			
			function checkId(str) {
                if ((/^[a-z,A-Z][0-9]{9}$/g).test(str)) {//身分證字號
                    var key = 'ABCDEFGHJKLMNPQRSTUVXYWZIO';
                    var s = (key.indexOf(str.substring(0, 1)) + 10) + str.substring(1, 10);
                    var n = parseInt(s.substring(0, 1)) * 1 + parseInt(s.substring(1, 2)) * 9 + parseInt(s.substring(2, 3)) * 8 + parseInt(s.substring(3, 4)) * 7 + parseInt(s.substring(4, 5)) * 6 + parseInt(s.substring(5, 6)) * 5 + parseInt(s.substring(6, 7)) * 4 + parseInt(s.substring(7, 8)) * 3 + parseInt(s.substring(8, 9)) * 2 + parseInt(s.substring(9, 10)) * 1 + parseInt(s.substring(10, 11)) * 1;
                    if ((n % 10) == 0)
                        return 1;
                } else if ((/^[0-9]{8}$/g).test(str)) {//統一編號
                    var key = '12121241';
                    var n = 0;
                    var m = 0;
                    for (var i = 0; i < 8; i++) {
                        n = parseInt(str.substring(i, i + 1)) * parseInt(key.substring(i, i + 1));
                        m += Math.floor(n / 10) + n % 10;
                    }
                    if ((m % 10) == 0 || ((str.substring(6, 7) == '7' ? m + 1 : m) % 10) == 0)
                        return 2;
                }else if((/^[0-9]{4}\/[0-9]{2}\/[0-9]{2}$/g).test(str)){//西元年
                	var regex = new RegExp("^(?:(?:([0-9]{4}(-|\/)(?:(?:0?[1,3-9]|1[0-2])(-|\/)(?:29|30)|((?:0?[13578]|1[02])(-|\/)31)))|([0-9]{4}(-|\/)(?:0?[1-9]|1[0-2])(-|\/)(?:0?[1-9]|1\\d|2[0-8]))|(((?:(\\d\\d(?:0[48]|[2468][048]|[13579][26]))|(?:0[48]00|[2468][048]00|[13579][26]00))(-|\/)0?2(-|\/)29))))$"); 
               		if(regex.test(str))
               			return 4;
                }else if((/^[0-9]{3}\/[0-9]{2}\/[0-9]{2}$/g).test(str)){//民國年
                	str = (parseInt(str.substring(0,3))+1911)+str.substring(3);
                	var regex = new RegExp("^(?:(?:([0-9]{4}(-|\/)(?:(?:0?[1,3-9]|1[0-2])(-|\/)(?:29|30)|((?:0?[13578]|1[02])(-|\/)31)))|([0-9]{4}(-|\/)(?:0?[1-9]|1[0-2])(-|\/)(?:0?[1-9]|1\\d|2[0-8]))|(((?:(\\d\\d(?:0[48]|[2468][048]|[13579][26]))|(?:0[48]00|[2468][048]00|[13579][26]00))(-|\/)0?2(-|\/)29))))$"); 
               		if(regex.test(str))
               			return 3
               	}
               	return 0;//錯誤
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
			.txt.c1 {
				width: 98%;
				float: left;
			}
			.txt.c2 {
				width: 30%;
				float: left;
			}
			.txt.c3 {
				width: 68%;
				float: left;
			}
			.txt.c4 {
				width: 49%;
				float: left;
			}
			.txt.c6 {
				width: 25%;
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
			}
			.dbbs {
				width: 100%;
			}
			.tbbs a {
				font-size: medium;
			}
			input[type="text"], input[type="button"] {
				font-size: medium;
			}
			.num {
				text-align: right;
			}
			select {
				font-size: medium;
			}
			#q_acDiv {
                white-space: nowrap;
            }
		</style>
	</head>
	<body>
		<div id="div_stk" style="position:absolute; top:300px; left:400px; display:none; width:400px; background-color: #CDFFCE; border: 5px solid gray;">
			<table id="table_stk" style="width:100%;" border="1" cellpadding='2'  cellspacing='0'>
				<tr>
					<td style="background-color: #f8d463;" align="center">產品編號</td>
					<td style="background-color: #f8d463;" colspan="2" id='stk_productno'> </td>
				</tr>
				<tr>
					<td style="background-color: #f8d463;" align="center">產品名稱</td>
					<td style="background-color: #f8d463;" colspan="2" id='stk_product'> </td>
				</tr>
				<tr id='stk_top'>
					<td align="center" style="width: 30%;">倉庫編號</td>
					<td align="center" style="width: 45%;">倉庫名稱</td>
					<td align="center" style="width: 25%;">倉庫數量</td>
				</tr>
				<tr id='stk_close'>
					<td align="center" colspan='3'>
						<input id="btnClose_div_stk" type="button" value="關閉視窗">
					</td>
				</tr>
			</table>
		</div>
		<div id="div_store2" style="position:absolute; top:300px; left:400px; display:none; width:820px; background-color: #CDFFCE; border: 5px solid gray;">
			<table id="table_store2" style="width:100%;" border="1" cellpadding='2'  cellspacing='0'>
				<tr id='store2_top'>
					<td style="background-color: #f8d463;width: 130px;" align="center">產品編號</td>
					<td style="background-color: #f8d463;width: 150px;" align="center">產品名稱</td>
					<td style="background-color: #f8d463;width: 200px;" align="center">規格</td>
					<td style="background-color: #f8d463;width: 100px;" align="center">寄庫倉庫</td>
					<td style="background-color: #f8d463;width: 100px;" align="center">寄庫數量</td>
					<td style="background-color: #f8d463;width: 100px;" align="center">總倉數量</td>
					<td style="background-color: #f8d463;width: 40px;" align="center">庫存單位</td>
				</tr>
				<tr id='store2_close'>
					<td align="center" colspan='7'>
						<input id="btnClose_div_store2" type="button" value="關閉視窗">
					</td>
				</tr>
			</table>
		</div>
		<div id="dmain" style="width: 1260px;">
			<!--#include file="../inc/toolbar.inc"-->
			<div class="dview" id="dview" >
				<table class="tview" id="tview">
					<tr>
						<td align="center" style="width:5%"><a id='vewChk'> </a></td>
						<td align="center" style="width:5%"><a id='vewType'> </a></td>
						<td align="center" style="width:25%"><a id='vewDatea'> </a></td>
						<td align="center" style="width:25%"><a id='vewNoa'> </a></td>
						<td align="center" style="width:40%"><a id='vewNick_xy'>客戶簡稱</a></td>
					</tr>
					<tr>
						<td><input id="chkBrow.*" type="checkbox" style=''/></td>
						<td align="center" id='typea=vcc.typea'>~typea=vcc.typea</td>
						<td align="center" id='datea'>~datea</td>
						<td align="center" id='noa'>~noa</td>
						<td align="center" id='nick' style="text-align: left;">~nick</td>
					</tr>
				</table>
			</div>
			<div class='dbbm'>
				<table class="tbbm"  id="tbbm" style="width: 872px;">
					<tr>
						<td style="width: 108px;"><span> </span><a id='lblType' class="lbl"> </a></td>
						<td style="width: 108px;"><select id="cmbTypea"> </select></td>
						<td style="width: 108px;">
							<a id='lblStype' class="lbl" style="float: left;"> </a>
							<span style="float: left;"> </span>
							<select id="cmbStype" style="width: 60px;"> </select>
						</td>
						<td style="width: 108px;"><span> </span><a id='lblDatea' class="lbl"> </a></td>
						<td style="width: 108px;"><input id="txtDatea" type="text"  class="txt c1"/></td>
						<td style="width: 108px;">
							<input id="txtZipcode" type="hidden" class="txt c1"/>
							<a id="lblDownvcc" class='lbl btn'>下載簽收單 </a>
						</td>
						<td style="width: 108px;"><span> </span><a id='lblNoa' class="lbl"> </a></td>
						<td style="width: 108px;"><input id="txtNoa" type="text" class="txt c1" /></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblAcomp" class="lbl btn"> </a></td>
						<td><input id="txtCno" type="text" class="txt c1"/></td>
						<td><input id="txtAcomp" type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblMon' class="lbl"> </a></td>
						<td><input id="txtMon" type="text" class="txt c1"/></td>
						<td><a id="lblIsvcce" class='lbl btn'> </a></td>
						<td><span> </span><a id='lblOrdeno' class="lbl btn"> </a></td>
						<td><input id="txtOrdeno" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblCust_xy" class="lbl btn">客戶簡稱</a></td>
						<td><input id="txtCustno" type="text" class="txt c1"/></td>
						<td>
							<input id="txtComp" type="hidden" class="txt c1"/>
							<input id="txtNick" type="text" class="txt c1"/>
						</td>
						<td><span> </span><a id='lblPay' class="lbl"> </a></td>
						<td><input id="txtPaytype" type="text" class="txt c1"/></td>
						<td><select id="combPay" style="width: 98%;" onchange='combPay_chg()'> </select></td>
						<td align="right"><input id="btnOrdes" type="button"/></td>
						<td align="right"><input id="btnVccs" type="button" value="退貨單匯入"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblTel" class="lbl"> </a></td>
						<td colspan='2'><input id="txtTel" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblFax" class="lbl"> </a></td>
						<td colspan='2'><input id="txtFax" type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblTrantype' class="lbl"> </a></td>
						<td><select id="cmbTrantype" style="width: 98%;"> </select></td>
					</tr>
					<tr>
						<td><span> </span><a class="lbl">郵遞區號</a></td>
						<td><input id="txtPost" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblAddr" class="lbl"> </a></td>
						<td colspan='3'><input id="txtAddr" type="text" class="txt c1"/></td>
						<td>
							<span> </span>
							<a id='lblInvono' class="lbl btn vcca"> </a>
							<a id='lblInvo' class="lbl btn invo"> </a>
						</td>
						<td>
							<input id="txtInvono" type="text" class="txt c1 vcca"/>
							<input id="txtInvo" type="text" class="txt c1 invo"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a class="lbl">指送區號</a></td>
						<td><input id="txtPost2"  type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblAddr2' class="lbl"> </a></td>
						<td colspan='3'>
							<input id="txtAddr2"  type="text" class="txt c1" style="width: 302px;"/>
							<select id="combAddr" style="width: 20px" onchange='combAddr_chg()'> </select>
						</td>
						<td><span> </span><a class="lbl">發票開立</a></td>
						<td><select id="cmbTranstyle" style="width: 100%;"> </select></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblCardeal" class="lbl btn"> </a></td>
						<td><input id="txtCardealno" type="text" class="txt c1"/></td>
						<td><input id="txtCardeal" type="text" class="txt c1"/></td>
						<td style="display: none;"><span> </span><a id='lblCarno' class="lbl"> </a></td>
						<td style="display: none;">
							<input id="txtCarno"  type="text" class="txt" style="width:75%;"/>
							<select id="combCarno" style="width: 20%;"> </select>
						</td>
						<td><span> </span><a id="lblDriver" class="lbl btn"> </a></td>
						<td>
							<input id="txtDriverno"  type="text" class="txt c1" style="width: 85px;"/>
							<select id="combDriver" class="txt c1" style="width: 20px"> </select>
						</td>
						<td><input id="txtDriver"  type="text" class="txt c1"/></td>
						<td align="right"><input id="btnGenvcca" type="button" value="產生發票"/></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblSales' class="lbl btn"> </a></td>
						<td><input id="txtSalesno" type="text" class="txt c1"/></td>
						<td><input id="txtSales" type="text" class="txt c1"/></td>
						<td><span> </span><a class="lbl">訂金</a></td>
						<td colspan='2'><input id="txtWeight" type="text" class="txt num c1"/></td>
						<td align="right"><input id="btnStore2" type="button" value="寄庫顯示"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblMoney" class="lbl"> </a></td>
						<td colspan='2'><input id="txtMoney" type="text" class="txt num c1"/></td>
						<td><span> </span><a id='lblTax' class="lbl"> </a></td>
						<td><select id="cmbTaxtype" class="txt c1" onchange="calTax();"> </select></td>
						<td><input id="txtTax" type="text" class="txt num c1 istax" /></td>
						<td><span> </span><a id='lblTotal' class="lbl istax"> </a></td>
						<td><input id="txtTotal" type="text" class="txt num c1 istax"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblCust2" class="lbl"> </a></td>
						<td colspan='2'>
							<input id="txtCustno2" type="text" class="txt c2" style="width: 95px;"/>
							<input id="txtComp2" type="text" class="txt c3" style="width: 120px;"/>
						</td>
						<td><span> </span><a id='lblFloata' class="lbl"> </a></td>
						<td><select id="cmbCoin" style="width: 98%;" onchange='coin_chg()'> </select></td>
						<td><input id="txtFloata" type="text" class="txt num c1"/></td>
						<td><span> </span><a id="lblTotalus" class="lbl"> </a></td>
						<td><input id="txtTotalus" type="text" class="txt num c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblWorker" class="lbl"> </a></td>
						<td colspan='2'><input id="txtWorker" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblWorker2" class="lbl"> </a></td>
						<td colspan='2'><input id="txtWorker2" type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblAccc' class="lbl btn"> </a></td>
						<td><input id="txtAccno" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a class="lbl">發票資訊</a></td>
						<td colspan='5'><input id="textInvomemo" type="text" class="txt c1"/></td>
						<td><span> </span><a class="lbl">聯絡人員</a></td>
						<td><input id="textConn" type="text" class="txt c1" /></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblMemo" class="lbl"> </a></td>
						<td colspan='7'><textarea id="txtMemo" cols="10" rows="5" style="width: 99%;height: 50px;"> </textarea></td>
					</tr>
					<tr>
						<td class="td1"><span> </span><a class="lbl">收款情況</a></td>
						<td class="td2" colspan='7'><input id="textStatus" type="text" class="txt c1"/></td>
					</tr>
				</table>
			</div>
		</div>
		<div class='dbbs' style="width: 1900px;">
			<table id="tbbs" class='tbbs'>
				<tr style='color:White; background:#003366;' >
					<td align="center" style="width:40px;"><input class="btn"  id="btnPlus" type="button" value='＋' style="font-weight: bold;width:" /></td>
					<td align="center" style="width:40px;"><a>項次</a></td>
					<td align="center" style="width:130px"><a id='lblProductno_s'> </a></td>
					<td align="center" style="width:180px;"><a id='lblProduct_s'> </a></td>
					<td align="center" style="width:250px;"><a id='lblSpec_s'> </a></td>
					<td align="center" style="width:40px;"><a id='lblUnit_s'> </a></td>
					<td align="center" style="width:80px;display: none;">請款數量</td>
					<td align="center" style="width:80px;">出貨數量</td>
					<td align="center" style="width:70px;"><a >寄/出庫</a></td>
					<td align="center" style="width:80px;"><a id='lblPrice_s'> </a></td>
					<td align="center" style="width:80px;"><a id='lblTotal_s'> </a></td>
					<td align="center" style="width:150px;">出貨倉庫</td>
					<td class="store2" align="center" style="width:150px;"><a id='lblStore2_s'> </a></td>
					<td align="center" style="width:80px;display: none;"><a id='lblTranmoney2_s'> </a></td>
					<td align="center" style="width:80px;display: none;"><a id='lblTranmoney3_s'> </a></td>
					<td align="center"><a id='lblMemo_s'> </a></td>
					<td align="center" style="width:150px;">訂單號碼</td>
					<td align="center" style="width:40px;"><a id='lblStk_s'> </a></td>
					<td align="center" style="width:40px;"><a id='lblRecord_s'> </a></td>
					<td class="store2" align="center" style="width:80px;"><a id='lblChecker_s_xy'>寄庫到期日</a></td>
				</tr>
				<tr style='background:#cad3ff;'>
					<td align="center"><input class="btn"  id="btnMinus.*" type="button" value='－' style=" font-weight: bold;" /></td>
					<td align="center"><input id="txtNoq.*" type="text" class="txt c1"/></td>
					<td align="center">
						<input class="txt c1"  id="txtProductno.*" type="text" style="width: 95%;" />
						<input class="btn"  id="btnProductno.*" type="button" value='.' style=" font-weight: bold;display: none;" />
					</td>
					<td><input id="txtProduct.*" type="text" class="txt c1" /></td>
					<td><input id="txtSpec.*" type="text" class="txt c1" /></td>
					<td><input id="txtUnit.*" type="text" class="txt c1"/></td>
					<td style="display: none;"><input id="txtMount.*" type="text" class="txt num c1"/></td>
					<td style="display: none;"><input id="txtWidth.*" type="text" class="txt num c1"/></td>
					<td><input id="txtDime.*" type="text" class="txt num c1"/></td>
					<td><select id="cmbItemno.*" class="txt c1 bbsitem"> </select></td>
					<td><input id="txtPrice.*" type="text" class="txt num c1 bbsprice"/>
						<input id="txtSprice.*" type="hidden" class="txt num c1"/>
					</td>
					<td><input id="txtTotal.*" type="text" class="txt num c1"/></td>
					<td>
						<input id="txtStoreno.*" type="text" class="txt c1" style="width: 30%"/>
						<input class="btn"  id="btnStoreno.*" type="button" value='.' style=" font-weight: bold;" />
						<input id="txtStore.*" type="text" class="txt c1" style="width: 50%"/>
					</td>
					<td class="store2">
						<input id="txtStoreno2.*" type="text" class="txt c1 store2" style="width: 30%"/>
						<input class="btn"  id="btnStoreno2.*" type="button" value='.' style=" font-weight: bold;" />
						<input id="txtStore2.*" type="text" class="txt c1 store2" style="width: 50%"/>
					</td>
					<td style="display: none;"><input id="txtTranmoney2.*" type="text" class="txt num c1"/></td>
					<td style="display: none;"><input id="txtTranmoney3.*" type="text" class="txt num c1"/></td>
					<td><input id="txtMemo.*" type="text" class="txt c1"/></td>
					<td>
						<input id="txtOrdeno.*" type="text"  class="txt" style="width:65%;"/>
						<input id="txtNo2.*" type="text" class="txt" style="width:23%;"/>
					</td>
					<td align="center"><input class="btn"  id="btnStk.*" type="button" value='.' style="width:1%;"/></td>
					<td align="center"><input class="btn"  id="btnRecord.*" type="button" value='.' style=" font-weight: bold;" /></td>
					<td class="store2"><input id="txtChecker.*" type="text" class="txt c1"/></td>
				</tr>
			</table>
		</div>
		<iframe id="xdownload" style="display:none;"> </iframe>
		<input id="q_sys" type="hidden" />
	</body>
</html>