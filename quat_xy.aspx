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

			q_desc = 1;
			q_tables = 's';
			var q_name = "quat";
			var decbbs = ['price', 'weight', 'mount', 'total', 'dime', 'width', 'lengthb', 'c1', 'notv', 'theory'];
			var decbbm = ['money', 'tax', 'total', 'weight', 'floata', 'mount', 'price', 'totalus'];
			var q_readonly = ['txtNoa','txtWorker', 'txtCno', 'txtAcomp', 'txtSales', 'txtWorker2','txtMoney','txtTotal','txtTotalus','txtComp','txtConn'];
			var q_readonlys = ['txtTotal','txtAdd1'];
			var bbmNum = [];
			var bbsNum = [];
			var bbmMask = [];
			var bbsMask = [];
			q_sqlCount = 6;
			brwCount = 6;
			brwCount2 = 11;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'Datea';
			aPop = new Array(
				['txtProductno_', '', 'ucaucc', 'noa,product,unit,spec', 'txtProductno_,txtProduct_,txtUnit_,txtSpec_', 'ucaucc_b.aspx'],
				['txtCustno', 'lblCust', 'cust', 'noa,comp,nick,tel,invoicetitle','txtCustno,txtComp,txtNick,txtTel', 'cust_b.aspx'],
				['txtSalesno', 'lblSales', 'sss', 'noa,namea', 'txtSalesno,txtSales', 'sss_b.aspx'],
				['txtBoss', '', 'sss', 'noa,namea', 'txtBoss,txtConn', 'sss_b.aspx'],
				['txtAddno1_', '', 'tgg', 'noa,nick', 'txtAddno1_,txtAdd1_', 'tgg_b.aspx'],
				['txtCno', 'lblAcomp', 'acomp', 'noa,acomp', 'txtCno,txtAcomp', 'acomp_b.aspx']
			);
			$(document).ready(function() {
				bbmKey = ['noa'];
				bbsKey = ['noa', 'no3'];
				q_brwCount();
				//q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
				q_gt('acomp', 'stop=1 ', 0, 0, 0, "cno_acomp");
				q_gt('flors_coin', '', 0, 0, 0, "flors_coin");
				q_gt('uccgb', '', 0, 0, 0, "");
				//判斷是否是業務 是業務只能顯示自己的報價單
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
				exclude : ['txtNoa', 'chkEnda'], //bbm
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
				}
			};
			var curData = new currentData();

			function sum() {
				var t1 = 0, t_unit, t_mount, t_weight = 0, t_total = 0;
				for (var j = 0; j < q_bbsCount; j++) {
					q_tr('txtTotal_' + j, q_mul(q_float('txtMount_' + j), q_float('txtPrice_' + j)));
					t_total = q_add(t_total, q_float('txtTotal_' + j));
				}
				q_tr('txtMoney', t_total);
				q_tr('txtTotal', t_total);
				calTax();
				q_tr('txtTotalus', q_mul(q_float('txtMoney'), q_float('txtFloata')));
			}

			function mainPost() {
				q_getFormat();
				bbmMask = [['txtDatea', r_picd], ['txtOdate', r_picd]];
				q_mask(bbmMask);
				bbmNum = [['txtMoney', 15, 0, 1], ['txtTax', 10, 0, 1], ['txtTotal', 15, 0, 1],['txtTotalus', 15, 2, 1], ['txtFloata', 11, 5, 1]];
				bbsNum = [['txtMount', 10, q_getPara('vcc.mountPrecision'), 1], ['txtPrice', 10, q_getPara('vcc.pricePrecision'), 1], ['txtTotal', 15, 0, 1], ['txtDime', 2, 0, 1]];
				
				q_cmbParse("cmbStype", q_getPara('vcc.stype'));
				q_cmbParse("combPaytype", q_getPara('vcc.paytype'));
				q_cmbParse("cmbTrantype", q_getPara('sys.tran'));
				q_cmbParse("cmbTaxtype", q_getPara('sys.taxtype'));
				q_cmbParse("combClassa",' ,便品,印刷','s');
				q_cmbParse("combDay",'0@ ,15@15天,30@30天,45@45天');
				
				var t_where = "where=^^ 1=1 group by post,addr^^";
				q_gt('custaddr', t_where, 0, 0, 0, "");

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
					if (!emp($('#txtCustno').val())) {
						var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^";
						q_gt('custaddr', t_where, 0, 0, 0, "");
					}
				}).focusin(function() {
					q_msg($(this),'請輸入客戶編號');
				});
				
				$('#chkCancel').click(function(){
					if($(this).prop('checked')){
						for(var k=0;k<q_bbsCount;k++){
							$('#chkCancel_'+k).prop('checked',true);
						}
					}
				});
				
				/*$('#btnTmpCreate').click(function() {
					if(!emp($('#txtNoa').val())){
						var t_paras = $('#txtNoa').val()+ ';'+r_name+ ';'+r_accy;
						q_func('qtxt.query.tmp_cust_ucc', 'cust_ucc_xy.txt,tmp_cust_ucc,' + t_paras);
						$('#btnTmpCreate').attr('disabled', 'disabled');
					}
				});*/
				
				$('#btnPlusCust').click(function(){
					q_box('cust.aspx','pluscust', "95%", "95%", '新增客戶');
				});
				
				$('#checkGweight').click(function(){
					for (var i = 0; i < q_bbsCount; i++) {
						if(!emp($('#txtProductno_'+i).val()) || !emp($('#txtProduct_'+i).val())){
							if($('#checkGweight').prop('checked')){
								$('#checkGweight_'+i).prop('checked',true);
							}else{
								$('#checkGweight_'+i).prop('checked',false);
							}
						}
					}
				});
				
				$('#checkEweight').click(function(){
					for (var i = 0; i < q_bbsCount; i++) {
						if(!emp($('#txtProductno_'+i).val()) || !emp($('#txtProduct_'+i).val())){
							if($('#checkEweight').prop('checked')){
								$('#checkEweight_'+i).prop('checked',true);
								if($('#txtClass_'+i).val()=='') //104/03/05 預設代100
									$('#txtClass_'+i).val('100');
							}else{
								$('#checkEweight_'+i).prop('checked',false);
							}
						}
					}
				});
				
				$('#btnEmailpost').click(function() {
					$('#textTypea').val('1');//表示email
					$('#textEmailaddr').val('');
					$('#textSubject').val($('#txtComp').val()+'－報價單');
					$('#textContents').val("親愛的"+$('#txtComp').val()+":\n\n\n\n\n\n\n\n\n有達實業有限公司\n業務專員：\n手機號碼：\n電　　郵：");
					$('#lblEmailaddr').text('收件人信箱');
					$('#lblSubject').text('信件主旨');
					$('#lblContents').text('信件內容');
					$('#lblNote').text('不同的電子信箱請以分號分開');
					$('#div_email').show();
					$('#btnEmailpost').attr('disabled', 'disabled');
					$('#btnFaxpost').attr('disabled', 'disabled');
					var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^";
					q_gt('cust', t_where, 0, 0, 0, "emailcust");
					var t_where = "where=^^ noa='" + $('#txtSalesno').val() + "' ^^";
					q_gt('sss', t_where, 0, 0, 0, "emailsss");
				});
				
				$('#btnFaxpost').click(function() {
					$('#textTypea').val('2');//表示fax
					$('#textEmailaddr').val('');
					$('#textSubject').val($('#txtComp').val()+'－報價單');
					$('#textContents').val("親愛的"+$('#txtComp').val()+":\n\n\n\n\n\n\n\n\n有達實業有限公司\n業務專員：\n手機號碼：\n電　　郵：");
					$('#lblEmailaddr').text('傳真電話');
					$('#lblSubject').text('傳真主旨');
					$('#lblContents').text('傳真內容');
					$('#lblNote').text('不同的傳真號碼請以逗號分開');
					$('#div_email').show();
					$('#btnEmailpost').attr('disabled', 'disabled');
					$('#btnFaxpost').attr('disabled', 'disabled');
					if(!emp($('#txtFax').val())){
						$('#textEmailaddr').val($('#txtFax').val());
					}else{
						var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^";
						q_gt('cust', t_where, 0, 0, 0, "faxcust");
					}
					var t_where = "where=^^ noa='" + $('#txtSalesno').val() + "' ^^";
					q_gt('sss', t_where, 0, 0, 0, "emailsss");
				});
				
				$('#btnSend_div_email').click(function() {
					if(!emp($('#txtNoa').val()) && !emp($('#textTypea').val())){
						if(emp($('#textEmailaddr').val())){
							alert("無"+$('#lblEmailaddr').text()+"!!");
							return;
						}
						var reg = /^((([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6}\;))*(([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})))$/;
						if($('#textTypea').val()=='1' ){//email
							if(!(reg).test($('#textEmailaddr').val())){
								alert($('#lblEmailaddr').text()+"格式錯誤!!");
								return;
							}
						}
						if(emp($('#textSubject').val())){
							alert("無"+$('#lblSubject').text()+"!!");
							return;
						}
						if(emp($('#textContents').val())){
							alert("無"+$('#lblContents').text()+"!!");
							return;
						}
						if($('#textTypea').val()=='1'){//email
							if(confirm("確定要Email報價單給客戶【"+$('#txtComp').val()+"】?")){
								var t_email=replaceAll($('#textEmailaddr').val(),";","^");
								var t_subject=replaceAll($('#textSubject').val(),",","，");
								var t_contents=replaceAll($('#textContents').val(),",","，");
								
								q_func("quat.email",$('#txtNoa').val()+","+t_email+","+t_subject+","+t_contents);
								$('#div_email').hide();
								$('#btnEmailpost').removeAttr('disabled', 'disabled');
								$('#btnFaxpost').removeAttr('disabled', 'disabled');
							}
						}else{ //fax
							if(confirm("確定要傳真報價單給客戶【"+$('#txtComp').val()+"】?")){
								var t_fax=replaceAll($('#textEmailaddr').val(),",","^");
								var t_subject=replaceAll($('#textSubject').val(),",","，");
								var t_contents=replaceAll($('#textContents').val(),",","，");
								
								q_func("quat.fax",$('#txtNoa').val()+","+t_fax+","+t_subject+","+t_contents);
								$('#div_email').hide();
								$('#btnEmailpost').removeAttr('disabled', 'disabled');
								$('#btnFaxpost').removeAttr('disabled', 'disabled');
							}
						}
					}
				});
				
				$('#btnClose_div_email').click(function() {
					$('#textTypea').val('');
					$('#div_email').hide();
					$('#btnEmailpost').removeAttr('disabled', 'disabled');
					$('#btnFaxpost').removeAttr('disabled', 'disabled');
				});
			}

			function q_boxClose(s2) {
				var ret;
				switch (b_pop) {
					case 'ucaucc':
						if (q_cur > 0 && q_cur < 4) {
							b_ret = getb_ret();
							if (!b_ret || b_ret.length == 0)
								return;
							$('#txtProductno_'+b_seq).val(b_ret[0].noa);
							$('#txtProduct_'+b_seq).val(b_ret[0].product);
							$('#txtUnit_'+b_seq).val(b_ret[0].unit);
							$('#txtSpec_'+b_seq).val(b_ret[0].spec);
						}
						break;
					case q_name + '_s':
						if(issales && s2[1]!=undefined)
							s2[1]="where=^^"+replaceAll(replaceAll(s2[1],'where=^^',''),'^^','')+" and salesno='"+r_userno+"' "+"^^";
						q_boxClose2(s2);
						break;
				}
				b_pop = '';
				AutoNo3();
			}
			
			var uccgb;
			var focus_addr = '';
			var z_cno = r_cno, z_acomp = r_comp, z_nick = r_comp.substr(0, 2);
			var issales=false;
			function q_gtPost(t_name) {
				switch (t_name) {
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
					case 'cust':
						var as = _q_appendData("cust", "", true);
						if (as[0] != undefined && focus_addr != '') {
							$('#' + focus_addr).val(as[0].addr_fact);
							focus_addr = '';
						}
						break;
					case 'flors':
						var as = _q_appendData("flors", "", true);
						if (as[0] != undefined) {
							q_tr('txtFloata',as[0].floata);
							sum();
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
					case 'view_ordes':
						var as = _q_appendData("view_ordes", "", true);
						//暫不鎖定
						/*if (as[0] != undefined) {
							alert('已轉訂單禁止修改!!!');
						}else{
							orde_quat=true;
							btnModi();
						}*/
						
						if (as[0] != undefined) {
							quat_no3_disabled=true;
						}
						orde_quat=true;
						btnModi();
						break;
					case 'cust_detail':
						var as = _q_appendData("cust", "", true);
						if (as[0] != undefined) {
							var t_invomemo=as[0].invomemo;
							t_invomemo=t_invomemo.split('##');
							var taxtype='0',xy_taxtypetmp=q_getPara('sys.taxtype').split(',');
							for (var i=0;i<xy_taxtypetmp.length;i++){
								if(xy_taxtypetmp[i].split('@')[1]==t_invomemo[2])
									taxtype=xy_taxtypetmp[i].split('@')[0];
							}
							$('#cmbTaxtype').val(taxtype);
							$('#txtFax').val(as[0].fax);
							$('#txtPost').val(as[0].zip_comp);
							$('#txtAddr').val(as[0].addr_comp);
							$('#txtPost2').val(as[0].zip_home);
							$('#txtAddr2').val(as[0].addr_home);
							$('#txtPaytype').val(as[0].paytype);
							$('#cmbTrantype').val(as[0].trantype);
							$('#txtSalesno').val(as[0].salesno);
							$('#txtSales').val(as[0].sales);
						}
						break;
					case 'emailcust':
						var as = _q_appendData("cust", "", true);
						if (as[0] != undefined) {
							$('#textEmailaddr').val(as[0].email);
						}
						break;	
					case 'faxcust':
						var as = _q_appendData("cust", "", true);
						if (as[0] != undefined) {
							$('#textEmailaddr').val(as[0].fax);
						}
						break;	
					case 'emailsss':
						var as = _q_appendData("sss", "", true);
						if (as[0] != undefined) {
							$('#textContents').val("親愛的"+$('#txtComp').val()+":\n\n\n\n\n\n\n\n\n有達實業有限公司\n業務專員："+as[0].namea+"\n手機號碼："+as[0].mobile1+"\n電　　郵："+as[0].email);
						}
						break;
					case q_name:
						if (q_cur == 4)
							q_Seek_gtPost();
						break;
				}
			}

			function btnOk() {
				if(!$('#div_cost').is(':hidden')){
					var t_class=$.trim($('#combClassa_'+b_seq).val());
					if(t_class=='印刷')
						$('#cost_txtCost0').focus();
					else
						$('#cost_txtWdate').focus();
					return;
				}
				
				if(!$('#div_spec').is(':hidden')){
					$('#spec_txtSpec_0').focus();
					return;
				}
				
				t_err = '';
				t_err = q_chkEmpField([['txtNoa', q_getMsg('lblNoa')], ['txtSalesno', q_getMsg('lblSales')], ['txtOdate', q_getMsg('lblOdate')]]);
				if (t_err.length > 0) {
					alert(t_err);
					return;
				}
				
				var t_repeat=false;
				for (var i = 0; i < q_bbsCount; i++) {
					if(emp($('#txtProductno_'+i).val()) && emp($('#txtProduct_'+i).val())){
						$('#btnMinus_'+i).click();
					}
				}
				for (var i = 0; i < q_bbsCount; i++) {
					if(!emp($('#txtNo3_'+i).val())){
						for (var j = i+1; j < q_bbsCount; j++) {
							if($('#txtNo3_'+i).val()==$('#txtNo3_'+j).val() && i!=j){
								t_repeat=true;
								break;
							}
						}
						if(t_repeat){
							break;
						}
					}
				}
				if(t_repeat){
					alert('項次重複!!');
					return;
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
				if (q_cur == 2)
					$('#txtWorker2').val(r_name);
				
				//*************************************
				
				var all_gweight=true;
				var all_eweight=true;
				for (var i = 0; i < q_bbsCount; i++) {
					if($('#checkGweight_'+i).prop('checked')){
						$('#txtGweight_'+i).val(1);
					}else{
						$('#txtGweight_'+i).val(0);
						all_gweight=false;
					}
					if($('#checkEweight_'+i).prop('checked')){
						$('#txtEweight_'+i).val(1);
					}else{
						$('#txtEweight_'+i).val(0);
						all_eweight=false;
					}
				}
				/*if(all_gweight)
					$('#checkGweight').prop('checked',true);
				else
					$('#checkGweight').prop('checked',false);
				if(all_eweight)
					$('#checkEweight').prop('checked',true);
				else
					$('#checkEweight').prop('checked',false);
				*/
				if($('#checkGweight').prop('checked')){
					$('#txtGweight').val(1);
				}else{
					$('#txtGweight').val(0);
				}
				if($('#checkEweight').prop('checked')){
					$('#txtEweight').val(1);
				}else{
					$('#txtEweight').val(0);
				}
				//*************************************
				sum();

				var s1 = $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val();
				if (s1.length == 0 || s1 == "AUTO")
					q_gtnoa(q_name, replaceAll(q_getPara('sys.key_quat') + (!emp($('#txtOdate').val())?$('#txtOdate').val():q_date()), '/', ''));
				else
					wrServer(s1);
			}

			function _btnSeek() {
				if (q_cur > 0 && q_cur < 4)
					return;

				q_box('quat_xy_s.aspx', q_name + '_s', "500px", "510px", q_getMsg("popSeek"));
			}

			function combPay_chg() {
				var cmb = document.getElementById("combPaytype")
				if (!q_cur)
					cmb.value = '';
				else
					$('#txtPaytype').val(cmb.value);
				cmb.value = '';
			}
			
			function combDay_chg() {
				var cmb = document.getElementById("combDay")
				if (!q_cur)
					cmb.value = '';
				else
					$('#txtDatea').val(q_cdn(q_date(),dec(cmb.value)));
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

			function bbsAssign() {
				for (var j = 0; j < q_bbsCount; j++) {
					if (!$('#btnMinus_' + j).hasClass('isAssign')) {
						$('#txtUnit_' + j).change(function() {
							sum();
						});
						
						$('#txtMount_' + j).change(function() {
							sum();
						});
						
						$('#txtPrice_' + j).change(function() {
							sum();
						});
						
						$('#txtProductno_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							AutoNo3();
						});
						
						$('#btnProduct_' + j).click(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							t_where = "(len(noa)=9 or left(noa,5)='" + $('#txtCustno').val().substr(0,5) + "')";
							q_box("ucaucc_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'ucaucc', "45%", "", "");
						});
						
						$('#txtProduct_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							AutoNo3();
						});
						
						$('#btnVccrecord_' + j).click(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							t_where = "cust='" + $('#txtCustno').val() + "' and noq='" + $('#txtProductno_' + b_seq).val() + "'";
							q_box("z_vccrecord.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'vccrecord', "95%", "95%", q_getMsg('lblRecord_s'));
						});
						
						$('#txtClassa_'+j).focusout(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if($('#txtClassa_'+b_seq).val()=='印刷' || $('#txtClassa_'+b_seq).val()=='便品'){
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
							if($('#combClassa_'+b_seq).val()=='印刷'){
								//非該客戶的印刷品
								if ($('#txtProductno_'+b_seq).val().substr(0,5)!=$('#txtCustno').val().substr(0,5)){
									$('#txtProductno_'+b_seq).val('');
								}
							}
							
							var t_class=$.trim($('#combClassa_'+b_seq).val());
							if(t_class.length>0 &&(q_cur==1 || q_cur==2)){
								var t_html='';
								if(t_class=='印刷'){
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
								if(t_class=='便品'){
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
								if(t_class=='印刷')
									$('#cost_txtCost0').focus();
								if(t_class=='便品')
									$('#cost_txtWdate').focus();
									
								$('#btnClose_div_cost').click(function() {
									var t_memo='';
									
									if(t_class=='印刷'){
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
												AutoNo3();
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
												AutoNo3();
											}
											sum();
										}
									}
									
									//訂金
									if(t_class=='印刷'){
										if($('#cost_txtDeposit').val()!='')
											t_memo=t_memo+(t_memo.length>0?' ':'')+'訂金：'+$('#cost_txtDeposit').val();
									}
									//工期,交貨日
									if($('#cost_txtWdate').val()!=''){
										if(t_class=='印刷'){
											t_memo=t_memo+(t_memo.length>0?' ':'')+'工期：'+$('#cost_txtWdate').val();
										}
										if(t_class=='便品'){
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
								if(t_class=='印刷')
									$('#cost_txtCost0').focus();
								if(t_class=='便品')
									$('#cost_txtWdate').focus();
							}
						});
						
						$('#combGroupbno_'+j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							
							if($('#combGroupbno_'+b_seq).find("option:selected").text()!=''){
								$('#txtProduct_'+b_seq).val($('#combGroupbno_'+b_seq).find("option:selected").text());
								$('#combClassa_'+b_seq).val('印刷');
								$('#txtClassa_'+b_seq).val('印刷');
							}
							
							//顯示規格
							var t_spec="";
							for (var i = 0; i < uccgb.length; i++) {
								if($('#combGroupbno_'+b_seq).val()==uccgb[i].noa){
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
								
								AutoNo3();
							});
							
							$('#combGroupbno_'+b_seq)[0].selectedIndex=0;
						});
						
						$('#txtClass_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							$('#checkEweight_'+b_seq).prop('checked',true);
						});
					}
				}
				_bbsAssign();
				change_check();
				if (r_rank<9){
					$('.bonus').hide();
				}
				
				for (var j = 0; j < q_bbsCount; j++) {
					if(quat_no3_disabled && q_cur!=1){
						$('#btnMinus_'+j).attr('disabled', 'disabled');
						$('#txtNo3_'+j).attr('disabled', 'disabled');
						$('#txtProductno_'+j).attr('disabled', 'disabled');
						$('#btnProduct_'+j).attr('disabled', 'disabled');
						$('#txtProduct_'+j).attr('disabled', 'disabled');
						$('#combGroupbno_'+j).attr('disabled', 'disabled');
					}else{
						$('#btnMinus_'+j).removeAttr('disabled');
						$('#txtNo3_'+j).removeAttr('disabled');
						$('#txtProductno_'+j).removeAttr('disabled');
						$('#btnProduct_'+j).removeAttr('disabled');
						$('#txtProduct_'+j).removeAttr('disabled');
						$('#combGroupbno_'+j).removeAttr('disabled');
					}
					//獎金已完成不能修改
					/*if($('#checkEweight_'+j).prop('checked') && r_rank<9){
						$('#btnMinus_'+j).attr('disabled', 'disabled');
						$('#txtNo3_'+j).attr('disabled', 'disabled');
						$('#txtProductno_'+j).attr('disabled', 'disabled');
						$('#btnProduct_'+j).attr('disabled', 'disabled');
						$('#txtProduct_'+j).attr('disabled', 'disabled');
						$('#combGroupbno_'+j).attr('disabled', 'disabled');
						$('#txtSpec_'+j).attr('disabled', 'disabled');
						$('#txtClassa_'+j).attr('disabled', 'disabled');
						$('#combClassa_'+j).attr('disabled', 'disabled');
						$('#txtSizea_'+j).attr('disabled', 'disabled');
						$('#txtDime_'+j).attr('disabled', 'disabled');
						$('#txtUnit_'+j).attr('disabled', 'disabled');
						$('#txtMount_'+j).attr('disabled', 'disabled');
						$('#txtPrice_'+j).attr('disabled', 'disabled');
						$('#txtTotal_'+j).attr('disabled', 'disabled');
						$('#txtMemo_'+j).attr('disabled', 'disabled');
						$('#txtAddno1_'+j).attr('disabled', 'disabled');
					}else{
						$('#btnMinus_'+j).removeAttr('disabled');
						$('#txtNo3_'+j).removeAttr('disabled');
						$('#txtProductno_'+j).removeAttr('disabled');
						$('#btnProduct_'+j).removeAttr('disabled');
						$('#txtProduct_'+j).removeAttr('disabled');
						$('#combGroupbno_'+j).removeAttr('disabled');
						$('#txtSpec_'+j).removeAttr('disabled');
						$('#txtClassa_'+j).removeAttr('disabled');
						$('#combClassa_'+j).removeAttr('disabled');
						$('#txtSizea_'+j).removeAttr('disabled');
						$('#txtDime_'+j).removeAttr('disabled');
						$('#txtUnit_'+j).removeAttr('disabled');
						$('#txtMount_'+j).removeAttr('disabled');
						$('#txtPrice_'+j).removeAttr('disabled');
						$('#txtTotal_'+j).removeAttr('disabled');
						$('#txtMemo_'+j).removeAttr('disabled');
						$('#txtAddno1_'+j).removeAttr('disabled');
					}*/
				}
			}

			function btnIns() {
				if ($('#checkCopy').is(':checked'))
					curData.copy();
				_btnIns();
				if ($('#checkCopy').is(':checked'))
					curData.paste();
				
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val('AUTO');
				$('#txtOdate').val(q_date());
				$('#chkIsproj').attr('checked', false);
				
				//預設30天
				$('#txtDatea').val(q_cdn(q_date(),30));
				
				$('#txtCustno').focus();

				$('#txtCno').val(z_cno);
				$('#txtAcomp').val(z_acomp);
				
				//預設帶操作者
				$('#txtSalesno').val(r_userno);
				$('#txtSales').val(r_name);

				var t_where = "where=^^ 1=1 group by post,addr^^";
				q_gt('custaddr', t_where, 0, 0, 0, "");
			}
			
			var orde_quat=false,quat_no3_disabled=false;
			function btnModi() {
				if (emp($('#txtNoa').val()))
					return;
				if(!orde_quat){
					var t_where = "where=^^ quatno='" + $('#txtNoa').val() + "' ^^";
					q_gt('view_ordes', t_where, 0, 0, 0, "");
					return;
				}
				
				_btnModi();
				bbsAssign();
				$('#txtCustno').focus();

				if (!emp($('#txtCustno').val())) {
					var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^";
					q_gt('custaddr', t_where, 0, 0, 0, "");
				}
				orde_quat=false;
			}

			function btnPrint() {
				q_box('z_quatp_xy.aspx' + "?;;;noa=" + trim($('#txtNoa').val()) + ";" + r_accy, '', "95%", "95%", $('#btnPrint').val());
			}

			function wrServer(key_value) {
				var i;

				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
				_btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
			}

			function bbsSave(as) {
				if (!as['productno'] && !as['product']) {
					as[bbsKey[1]] = '';
					return;
				}

				q_nowf();
				as['datea'] = abbm2['datea'];
				as['odate'] = abbm2['odate'];
				as['custno'] = abbm2['custno'];
				return true;
			}

			function refresh(recno) {
				_refresh(recno);
				$('#div_spec').hide();
				$('#div_cost').hide();
				$('#div_email').hide();
				$('#btnEmailpost').removeAttr('disabled');
				$('#btnFaxpost').removeAttr('disabled');
				change_check();
				
				if (!q_cur) {
					$('#combAddr').attr('disabled', 'disabled');
				} else {
					$('#combAddr').removeAttr('disabled');
				}
				
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
				
				if((q_cur<1 || q_cur>2) && (emp($('#txtCustno').val()) || emp_productno)){
					$('#btnTmpCreate').show();
				}else{
					$('#btnTmpCreate').hide();
				}
			}

			function readonly(t_para, empty) {
				_readonly(t_para, empty);
				if(q_cur==1){
					$('#btnPlusCust').show();
				}else{
					$('#btnPlusCust').hide();
				}
				
				change_check();
				if (t_para) {
					$('#combAddr').attr('disabled', 'disabled');
					$('#checkGweight').attr('disabled', 'disabled');
					$('#checkEweight').attr('disabled', 'disabled');
					$('#btnEmailpost').removeAttr('disabled');
					$('#btnFaxpost').removeAttr('disabled');
					for (var j = 0; j < q_bbsCount; j++) {
						$('#combGroupbno_'+j).attr('disabled', 'disabled');
						$('#combClassa_'+j).attr('disabled', 'disabled');
						$('#checkGweight_'+j).attr('disabled', 'disabled');
						$('#checkEweight_'+j).attr('disabled', 'disabled');
					}
				} else {
					$('#combAddr').removeAttr('disabled');
					$('#checkGweight').removeAttr('disabled');
					$('#checkEweight').removeAttr('disabled');
					$('#btnEmailpost').attr('disabled', 'disabled');
					$('#btnFaxpost').attr('disabled', 'disabled');
					if (r_rank<9){
						$('.boss').attr('disabled', 'disabled');
					}
					
					for (var j = 0; j < q_bbsCount; j++) {
						$('#combGroupbno_'+j).removeAttr('disabled');
						$('#combClassa_'+j).removeAttr('disabled');
						$('#checkGweight_'+j).removeAttr('disabled');
						$('#checkEweight_'+j).removeAttr('disabled');
					}
				}
				
				var emp_productno=false;
				for (var j = 0; j < q_bbsCount; j++) {
					if(emp($('#txtProductno_'+j).val()) && !emp($('#txtProduct_'+j).val()))
						emp_productno=true;
				}
				if((q_cur<1 || q_cur>2) && (emp($('#txtCustno').val()) || emp_productno)){
					$('#btnTmpCreate').show();
				}else{
					$('#btnTmpCreate').hide();
				}
			}
			
			function AutoNo3(){
				var maxno3='001';
				for (var j = 0; j < q_bbsCount; j++) {
					if((!emp($('#txtProductno_'+j).val())) || (!emp($('#txtProduct_'+j).val()))){
						$('#txtNo3_'+j).val(maxno3);
						maxno3=('000'+(dec(maxno3)+1)).substr(-3);
					}
					if(emp($('#txtProductno_'+j).val()) && emp($('#txtProduct_'+j).val())){
						$('#txtNo3_'+j).val('');
					}
				}
			}

			function btnMinus(id) {
				_btnMinus(id);
				sum();
			}

			function btnPlus(org_htm, dest_tag, afield) {
				_btnPlus(org_htm, dest_tag, afield);
				if (q_tables == 's')
					bbsAssign();
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

			function q_popPost(s1) {
				switch (s1) {
					case 'txtCustno':
						if (!emp($('#txtCustno').val())) {
							var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^";
							q_gt('custaddr', t_where, 0, 0, 0, "");
							var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^";
							q_gt('cust', t_where, 0, 0, 0, "cust_detail");
						}
						break;
					case 'txtProductno_':
						if (!emp($('#txtProductno_'+b_seq).val())) {
							if($('#txtSpec_'+b_seq).val().indexOf('印')>-1 || $('#txtProductno_'+b_seq).val().indexOf($('#txtCustno').val()+"-")>-1){
								$('#combClassa_'+b_seq).val('印刷');
								$('#txtClassa_'+b_seq).val('印刷');
							}else{
								$('#combClassa_'+b_seq).val('便品');
								$('#txtClassa_'+b_seq).val('便品');
								$('#txtDime_'+b_seq).val(0);
							}
						}
						AutoNo3();
						break;	
				}
			}
			function q_funcPost(t_func, result) {
                switch(t_func) {
                	/*case 'qtxt.query.tmp_cust_ucc':
                		$('#btnTmpCreate').removeAttr('disabled');
						alert('臨時編號產生完畢。');
						
						var s2=[];
						s2[0]=q_name + '_s';
						s2[1]="where=^^ noa='"+$('#txtNoa').val()+"' ^^"
						if(issales)
							s2[1]="where=^^"+replaceAll(replaceAll(s2[1],'where=^^',''),'^^','')+" and salesno='"+r_userno+"' "+"^^";
						q_boxClose2(s2);
						break;*/
				}
			}
			
			function change_check() {
				if(dec($('#txtGweight').val())==0){
					$('#checkGweight').prop('checked',false);
				}else{
					$('#checkGweight').prop('checked',true);
				}
				if(dec($('#txtEweight').val())==0){
					$('#checkEweight').prop('checked',false);
				}else{
					$('#checkEweight').prop('checked',true);
				}
				for (var i = 0; i < brwCount; i++) {
					if($('#vtgweight_'+i).text()=='1' || $('#vtgweight_'+i).text()=='V'){
						$('#vtgweight_'+i).text('V');
					}else{
						$('#vtgweight_'+i).text('');
					}
					if($('#vteweight_'+i).text()=='1' || $('#vteweight_'+i).text()=='V'){
						$('#vteweight_'+i).text('V');
					}else{
						$('#vteweight_'+i).text('');
					}
				}
				for (var i = 0; i < q_bbsCount; i++) {
					if(q_cur==1 || q_cur==2){
						$('#checkGweight_'+i).removeAttr('disabled');
						$('#checkEweight_'+i).removeAttr('disabled');
					}else{
						$('#checkGweight_'+i).attr('disabled', 'disabled');
						$('#checkEweight_'+i).attr('disabled', 'disabled');
					}
					
					if($('#txtGweight_'+i).val()==0){
						$('#checkGweight_'+i).prop('checked',false);
					}else{
						$('#checkGweight_'+i).prop('checked',true);
					}
					if($('#txtEweight_'+i).val()==0){
						$('#checkEweight_'+i).prop('checked',false);
					}else{
						$('#checkEweight_'+i).prop('checked',true);
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
				/*width: 35%;*/
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
				/*width: 65%;*/
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
				/*width: 10%;*/
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
				width: 45%;
				float: left;
			}
			.txt.c3 {
				width: 50%;
				float: left;
			}
			.txt.c4 {
				width: 25%;
				float: left;
			}
			.txt.c5 {
				width: 72%;
				float: left;
			}
			.txt.c6 {
				width: 25%;
			}
			.txt.c7 {
				width: 95%;
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
			.tbbm td input[type="button"] {
				width: auto;
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
			.tbbm select {
				border-width: 1px;
				padding: 0px;
				margin: -1px;
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
			select {
				border-width: 1px;
				padding: 0px;
				margin: -1px;
				font-size: medium;
			}
		</style>
	</head>
	<body>
		<!--#include file="../inc/toolbar.inc"-->
		<div id="div_email" style="position:absolute; top:200px; left:400px; display:none; width:680px; background-color: #CDFFCE; border: 5px solid gray;">
			<table id="table_email" style="width:100%;" border="1" cellpadding='2'  cellspacing='0'>
				<tr>
					<td style="background-color: #f8d463;width: 130px;" align="center"><a id="lblEmailaddr"> </a></td>
					<td style="background-color: #f8d463;width: 550px;" align="center">
						<input id="textEmailaddr" type="text" class="txt c1"/>
						<a id="lblNote" style="float:left;;font-size: 12px;"> </a>
					</td>
				</tr>
				<tr>
					<td style="background-color: #f8d463;width: 130px;" align="center"><a id="lblSubject"> </a></td>
					<td style="background-color: #f8d463;width: 550px;" align="center"><input id="textSubject" type="text" class="txt c1" onblur="this.value=replaceAll(this.value,',','，')"/></td>
				</tr>
				<tr>
					<td style="background-color: #f8d463;" align="center"><a id="lblContents"> </a></td>
					<td style="background-color: #f8d463;" align="center"><textarea id="textContents" cols="10" rows="10" style="width: 99%;height: 280px;font-size: larger;" onblur="this.value=replaceAll(this.value,',','，')"> </textarea></td>
				</tr>
				<tr id='email_close'>
					<td align="center" colspan='5'>
						<input id="textTypea" type="hidden" class="txt c1"/>
						<input id="btnSend_div_email" type="button" value="發送">
						<input id="btnClose_div_email" type="button" value="關閉視窗">
					</td>
				</tr>
			</table>
		</div>
		<div id='dmain' style="overflow:hidden;width: 1270px;">
			<div class="dview" id="dview">
				<table class="tview" id="tview" style="width: 500px;"	>
					<tr>
						<td align="center" style="width:3%"><a id='vewChk'> </a></td>
						<td align="center" style="width:15%"><a id='vewOdate'> </a></td>
						<td align="center" style="width:15%">有效日期</td>
						<td align="center" style="width:20%"><a id='vewNoa'> </a></td>
						<td align="center" style="width:30%"><a id='vewComp'> </a></td>
						<td align="center" style="width:8%"><a id='vewGweight'>成交</a></td>
						<td align="center" style="width:8%" class="bonus"><a id='vewEweight'>獎金</a></td>
					</tr>
					<tr>
						<td><input id="chkBrow.*" type="checkbox" style=''/></td>
						<td align="center" id='odate'>~odate</td>
						<td align="center" id='datea'>~datea</td>
						<td align="center" id='noa'>~noa</td>
						<td align="center" id='comp' style="text-align: left;">~comp</td>
						<td align="center" id='gweight'>~gweight</td>
						<td align="center" id='eweight' class="bonus">~eweight</td>
					</tr>
				</table>
			</div>
			<div class='dbbm'>
				<table class="tbbm" id="tbbm" style="width: 760px;">
					<tr class="tr1">
						<td class="td1" style="width: 108px;">
							<input id="checkCopy" type="checkbox" style="float:left;"/>
							<a id='lblCopy' class="lbl" style="float:left;"> </a>
							<span> </span>
							<a id='lblStype' class="lbl"> </a>
						</td>
						<td class="td2" style="width: 108px;"><select id="cmbStype" class="txt c1"> </select></td>
						<td class="td3" style="width: 90px;"><span> </span><a id='lblOdate' class="lbl"> </a></td>
						<td class="td4" style="width: 90px;"><input id="txtOdate" type="text" class="txt c1"/></td>
						<td class="td5" style="width: 90px;"><span> </span><a id='lblDatea' class="lbl"> </a></td>
						<td class="td6" style="width: 108px;">
							<input id="txtDatea" type="text" class="txt c1" style="width: 85px;"/>
							<select id="combDay" class="txt c1" style="width: 20px;" onchange='combDay_chg()'> </select>
						</td>
						<td class="td7" style="width: 90px;"><span> </span><a id='lblNoa' class="lbl"> </a></td>
						<td class="td8" style="width: 108px;"><input id="txtNoa" type="text" class="txt c1"/></td>
					</tr>
					<tr class="tr2">
						<td><span> </span><a id='lblAcomp' class="lbl btn"> </a></td>
						<td><input id="txtCno" type="text" class="txt c1"/></td>
						<td colspan="2"><input id="txtAcomp" type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblContract' class="lbl"> </a></td>
						<td colspan="3"><input id="txtContract" type="text" class="txt c1"/></td>
					</tr>
					<tr class="tr3">
						<td>
							<span> </span><a id='lblCust' class="lbl btn"> </a>
							<input class="btn" id="btnPlusCust" type="button" value='+' style="font-weight: bold;float: right;" />
						</td>
						<td><input id="txtCustno" type="text" class="txt c1"/></td>
						<td colspan="2">
							<input id="txtComp" type="text" class="txt c1"/>
							<input id="txtNick" type="hidden" class="txt c1"/>
						</td>
						<td><span> </span><a id='lblPaytype' class="lbl"> </a></td>
						<td colspan="2"><input id="txtPaytype" type="text" class="txt c1" /></td>
						<td><select id="combPaytype" class="txt c1" onchange='combPay_chg()'> </select></td>
					</tr>
					<tr class="tr4">
						<td><span> </span><a id='lblTel' class="lbl"> </a></td>
						<td colspan='3'><input id="txtTel"	type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblFax' class="lbl"> </a></td>
						<td colspan='3'><input id="txtFax" type="text" class="txt c1"/></td>
					</tr>
					<!--<tr class="tr4">
						<td><span> </span><a class="lbl">聯絡人姓名</a></td>
						<td><input id="txtPostname" type="text" class="txt c1"/></td>
						<td><span> </span><a class="lbl">統一編號 </a></td>
						<td><input id="txtPay"	type="text" class="txt c1"/></td>
						<td><span> </span><a class="lbl">E-MAIL</a></td>
						<td colspan='3'><input id="txtMemo2" type="text" class="txt c1"/></td>
					</tr>-->
					<tr class="tr5">
						<td><span> </span><a class="lbl">郵遞區號</a></td>
						<td><input id="txtPost" type="text" class="txt c1"></td>
						<td><span> </span><a id='lblAddr' class="lbl"> </a></td>
						<td colspan='5' ><input id="txtAddr" type="text" class="txt c1" /></td>
					</tr>
					<tr class="tr6">
						<td><span> </span><a class="lbl">指送郵區 </a></td>
						<td><input id="txtPost2" type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblAddr2' class="lbl"> </a></td>
						<td colspan='5' >
							<input id="txtAddr2" type="text" class="txt c1" style="width: 455px;"/>
							<select id="combAddr" style="width: 20px" onchange='combAddr_chg()'> </select>
						</td>
					</tr>
					<tr class="tr7">
						<td><span> </span><a id='lblTrantype' class="lbl"> </a></td>
						<td colspan="2"><select id="cmbTrantype" class="txt c1" name="D1" > </select></td>
						<td><span> </span><a id='lblSales' class="lbl btn"> </a></td>
						<td><input id="txtSalesno" type="text" class="txt c1"/></td>
						<td><input id="txtSales" type="text" class="txt c1"/></td>
					</tr>
					<tr class="tr8">
						<td><span> </span><a id='lblMoney' class="lbl"> </a></td>
						<td colspan='2'>
							<input id="txtMoney" type="text" class="txt c1 num" />
						</td>
						<td><span> </span><a id='lblTax' class="lbl"> </a></td>
						<td><input id="txtTax" type="text" class="txt c1 num"/></td>
						<td><select id="cmbTaxtype" class="txt c1" onchange='sum()'> </select></td>
						<td><span> </span><a id='lblTotal' class="lbl"> </a></td>
						<td><input id="txtTotal" type="text" class="txt c1 num"/></td>
					</tr>
					<tr class="tr9">
						<td><span> </span><a id='lblFloata' class="lbl"> </a></td>
						<td><select id="cmbCoin" class="txt c1" onchange='coin_chg()'> </select></td>
						<td>
							<input id="txtFloata" type="text" class="txt c1 num"/>
						</td>
						<td><span> </span><a id='lblTotalus' class="lbl"> </a></td>
						<td colspan='2'><input id="txtTotalus"	type="text" class="txt c1 num"/></td>
						<!--<td class="label2"><span> </span><a id='lblWeight' class="lbl"> </a></td>
						<td colspan='2' ><input id="txtWeight" type="text" class="txt c1 num" /></td>-->
						<td colspan="2" style="text-align: center;">
							<input id="btnEmailpost" type="button" value="Email發送">
							<!--<input id="btnFaxpost" type="button" value="傳真發送">-->
						</td>
					</tr>
					<tr class="tr10">
						<td align="right">
							<span> </span><a id='lblMemo' class="lbl"> </a>
						</td>
						<td colspan='7' >
							<input id="txtMemo" type="text" style="width: 99%;"/>
						</td>
					</tr>
					<tr class="tr11" >
						<td><span> </span><a id='lblWorker' class="lbl"> </a></td>
						<td><input id="txtWorker" type="text" class="txt c1" /></td>
						<td><span> </span><a id='lblWorker2' class="lbl"> </a></td>
						<td><input id="txtWorker2" type="text" class="txt c1" /></td>
						<!--<td colspan="2" align="center"><input id="btnTmpCreate" type="button" value='產生臨時編號' /></td>-->
						<td colspan="2">
							<span> </span>
							<input id="chkIsproj" type="checkbox"/>
							<span> </span><a id='lblIsproj'> </a>
							<input id="chkEnda" type="checkbox"/>
							<span> </span><a id='lblEnda'> </a>
							<input id="chkCancel" type="checkbox"/>
							<span> </span><a id='lblCancel'> </a>
						</td>
					</tr>
					<tr class="tr11">
						<td colspan="2" style="text-align: right;">
							<span> </span>
							<input id="checkGweight" type="checkbox"/>
							<input id="txtGweight" type="hidden" />
							<span> </span><a>成交</a>
							<input id="checkEweight" type="checkbox" class="bonus"/>
							<input id="txtEweight" type="hidden" class="bonus" />
							<span class="bonus"> </span><a class="bonus">獎金</a>
						</td>
						<td><span> </span><a id='lblBoss' class="lbl">美編</a></td>
						<td><input id="txtBoss" type="text" class="txt c1 boss"/></td>
						<td><input id="txtConn" type="text" class="txt c1 boss"/></td>
					</tr>
				</table>
			</div>
		</div>
		<div class='dbbs' style="width: 1900px;">
			<table id="tbbs" class='tbbs' border="1" cellpadding='2' cellspacing='1' >
				<tr style='color:White; background:#003366;' >
					<td align="center" style="width:40px;"><input class="btn" id="btnPlus" type="button" value='＋' style="font-weight: bold;" /></td>
					<td align="center" style="width:40px;">項次</td>
					<td align="center" style="width:150px;"><a id='lblProductno'> </a></td>
					<td align="center" style="width:150px;"><a id='lblProduct'> </a></td>
					<td align="center" style="width:230px;"><a>規格</a></td>
					<td align="center" style="width:85px;"><a>便/印</a></td>
					<td align="center" style="width:70px;"><a>包裝方式</a></td>
					<td align="center" style="width:40px;"><a>色數</a></td>
					<td align="center" style="width:40px;"><a id='lblUnit'> </a></td>
					<td align="center" style="width:100px;"><a id='lblMount'> </a></td>
					<!--<td align="center"><a id='lblWeights'></a></td>-->
					<td align="center" style="width:100px;"><a id='lblPrices'> </a></td>
					<td align="center" style="width:100px;"><a id='lblTotals'> </a></td>
					<td align="center" style="width:85px;" class="bonus"><a>獎金比例</a></td>
					<td align="center" style="width:40px;" class="bonus"><a>獎金</a></td>
					<td align="center" style="width:150px;"><a id='lblMemos'> </a></td>
					<td align="center" style="width:40px;"><a>成交</a></td>
					<td align="center" style="width:200px;"><a>廠商</a></td>
					<td align="center" style="width:40px;"><a id='lblEnda_s'> </a></td>
					<td align="center" style="width:40px;"><a id='lblCancels'> </a></td>
					<td align="center" style="width:40px;"><a id='lblVccrecord'> </a></td>
				</tr>
				<tr style='background:#cad3ff;'>
					<td align="center"><input class="btn" id="btnMinus.*" type="button" value='－' style=" font-weight: bold;" /></td>
					<td align="center">
						<input id="txtNo3.*" type="text" class="txt c1" />
					</td>
					<td align="center">
						<input id="txtProductno.*" type="text" class="txt c1" style="width:115px;"/>
						<input class="btn" id="btnProduct.*" type="button" value='.' style=" font-weight: bold;" />
					</td>
					<td>
						<input id="txtProduct.*" type="text" class="txt c1" style="width:120px;"/>
						<select id="combGroupbno.*" class="txt c1" style="width: 20px; float: right;"> </select>
					</td>
					<td><input id="txtSpec.*" type="text" class="txt c1"/></td>
					<td>
						<input id="txtClassa.*" type="text" class="txt c1" style="width: 60px;"/>
						<select id="combClassa.*" class="txt c1" style="width:20px;float: right;"> </select>
					</td>
					<td><input id="txtSizea.*" type="text" class="txt c1"/></td>
					<td><input id="txtDime.*" type="text" class="txt c1 num"/></td>
					<td><input id="txtUnit.*" type="text" class="txt c1"/></td>
					<td><input id="txtMount.*" type="text" class="txt c1 num"/></td>
					<!--<td style="width:8%;"><input id="txtWeight.*" type="text" class="txt c2 num"/></td>-->
					<td><input id="txtPrice.*" type="text" class="txt c1 num"/></td>
					<td><input id="txtTotal.*" type="text" class="txt c1 num"/></td>
					<td class="bonus"><input class="txt num c7 bonus" id="txtClass.*" type="text" /></td>
					<td class="bonus" align="center">
						<input id="checkEweight.*" type="checkbox" class="bonus"/>
						<input id="txtEweight.*" type="hidden" />
					</td>
					<td>
						<input id="txtMemo.*" type="text" class="txt c1"/>
						<input class="txt" id="txtOrdeno.*" type="hidden"style="width:65%;" />
						<input class="txt" id="txtNo2.*" type="hidden" style="width:25%;" />
						<input id="txtNoq.*" type="hidden" />
						<input id="recno.*" type="hidden" />
					</td>
					<td align="center">
						<input id="checkGweight.*" type="checkbox"/>
						<input id="txtGweight.*" type="hidden" />
					</td>
					<td>
						<input id="txtAddno1.*" type="text" class="txt c2 boss"/>
						<input id="txtAdd1.*" type="text" class="txt c3 boss"/>
					</td>
					<td align="center"><input id="chkEnda.*" type="checkbox"/></td>
					<td align="center"><input id="chkCancel.*" type="checkbox"/></td>
					<td align="center">
						<input class="btn" id="btnVccrecord.*" type="button" value='.' style=" font-weight: bold;" />
					</td>
				</tr>
			</table>
		</div>
		<div id="div_spec" style="position:absolute; top:300px; left:400px; display:none; background-color: #CDFFCE; border: 5px solid gray;"> </div>
		<div id="div_cost" style="position:absolute; top:300px; left:400px; display:none; background-color: #CDFFCE; border: 5px solid gray;"> </div>
		<input id="q_sys" type="hidden" />
	</body>
</html>
