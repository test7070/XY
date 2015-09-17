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
			var q_readonly = ['txtNoa', 'txtAccno', 'txtComp','txtCardeal','txtSales', 'txtCno', 'txtAcomp', 'txtMoney', 'txtTax', 'txtTotal', 'txtTotalus', 'txtWorker', 'txtWorker2','txtComp2','txtPrice'];
			var q_readonlys = ['txtTotal', 'txtOrdeno', 'txtNo2','txtNoq','txtProduct','txtSpec','txtStore','txtStore2','txtMount'];
			var bbmNum = [['txtMoney', 15, 0, 1], ['txtTax', 15, 0, 1],['txtTotal', 15, 0, 1], ['txtTotalus', 15, 0, 1]];
			var bbsNum = [];
			var bbmMask = [];
			var bbsMask = [];
			q_sqlCount = 6;
			brwCount = 6;
			brwCount2 = 12;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'datea';
			aPop = new Array(
				['txtCustno', 'lblCust', 'cust', 'noa,comp,nick,tel,invoicetitle', 'txtCustno,txtComp,txtNick,txtTel', 'cust_b.aspx'],
				['txtStoreno_', 'btnStoreno_', 'store', 'noa,store', 'txtStoreno_,txtStore_', 'store_b.aspx'],
				['txtStoreno2_', 'btnStoreno2_', 'store', 'noa,store', 'txtStoreno2_,txtStore2_', 'store_b.aspx'],
				['txtRackno_', 'btnRackno_', 'rack', 'noa,rack,storeno,store', 'txtRackno_', 'rack_b.aspx'],
				['txtCardealno', 'lblCardeal', 'cardeal', 'noa,comp', 'txtCardealno,txtCardeal', 'cardeal_b.aspx'],
				['txtCno', 'lblAcomp', 'acomp', 'noa,acomp', 'txtCno,txtAcomp', 'acomp_b.aspx'],
				['txtSalesno', 'lblSales', 'sss', 'noa,namea', 'txtSalesno,txtSales', 'sss_b.aspx'],
				['txtCustno2', 'lblCust2', 'cust', 'noa,comp', 'txtCustno2,txtComp2', 'cust_b.aspx'],
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
				q_gt('ucca', 'stop=1 ', 0, 0, 0, "ucca_invo");//判斷是否有買發票系統
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
				var t1 = 0, t_unit, t_mount, t_weight = 0;
				for (var j = 0; j < q_bbsCount; j++) {
					t_unit = $('#txtUnit_' + j).val();
					q_tr('txtMount_'+j,q_float('txtWidth_'+j)+q_float('txtTranmoney2_'+j))
					t_mount = q_float('txtMount_' + j);
					t_weight=+q_float('txtMount_' + j);
					$('#txtTotal_' + j).val(round(q_mul(q_float('txtPrice_' + j), dec(t_mount)), 0));
					t1 = q_add(t1, dec(q_float('txtTotal_' + j)));
				}
				$('#txtMoney').val(round(t1, 0));
				
				calTax();
				q_tr('txtTotalus', round(q_mul(q_float('txtTotal'), q_float('txtFloata')), 0));
			}

			function mainPost() {
				if(r_rank<'5')
					q_readonlys.push('txtPrice');
					
				q_getFormat();
				bbmMask = [['txtDatea', r_picd], ['txtMon', r_picm]];
				q_mask(bbmMask);
				bbmNum = [['txtMoney', 15, 0, 1], ['txtTax', 15, 0, 1], ['txtTotal', 15, 0, 1], ['txtTotalus', 15, 0, 1]];
				bbsNum = [['txtPrice', 12, q_getPara('vcc.pricePrecision'), 1], ['txtMount', 10, q_getPara('vcc.mountPrecision'), 1]
				, ['txtWidth', 9, q_getPara('vcc.mountPrecision'), 1], ['txtTotal', 15, 0, 1]
				, ['txtTranmoney2', 9, q_getPara('vcc.mountPrecision'), 1], ['txtTranmoney3', 9, q_getPara('vcc.mountPrecision'), 1]
				, ['txtDime', 9, q_getPara('vcc.mountPrecision'), 1]];
				//q_cmbParse("cmbTranstyle", q_getPara('sys.transtyle'));
				q_cmbParse("cmbTypea", q_getPara('vcc.typea'));
				q_cmbParse("cmbStype", q_getPara('vcc.stype'));
				q_cmbParse("cmbTaxtype", q_getPara('sys.taxtype'));
				//q_cmbParse("cmbCoin", q_getPara('sys.coin'));
				q_cmbParse("combPay", q_getPara('vcc.paytype'));
				q_cmbParse("cmbTrantype", q_getPara('sys.tran'));
				var t_where = "where=^^ 1=1  group by post,addr^^";
				q_gt('custaddr', t_where, 0, 0, 0, "");
				//104/08/17 要跟訂單一樣 單行判斷出貨.寄庫.庫出
				q_cmbParse("cmbItemno",'0@ ,1@寄庫,2@庫出','s');
				
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
				});
								
				$('#txtCardealno').change(function(){
					//取得車號下拉式選單
					var thisVal = $(this).val();
					var t_where = "where=^^ noa=N'" + thisVal + "' ^^";
					q_gt('cardeal', t_where, 0, 0, 0, "getCardealCarno");
				});
				
				$('#btnOrdes').click(function() {
					var t_custno = trim($('#txtCustno').val());
					var t_where = '';
					//if (t_custno.length > 0) {
						t_where = " isnull(enda,0)!=1 ";
						//t_where += " and left(productno,2)!='##' and left(custno,2)!='##' ";//非正式編號
						t_where += " and productno!='' ";
						t_where += " and datea!='' ";
						//t_where += " and (custno='"+t_custno+"' or custno='"+t_custno.substr(0,5)+"')";
						if (t_custno.length>0)
							t_where += " and (custno='"+t_custno+"')";
						t_where += " and (source!='2' or mount!=isnull((select SUM(tranmoney3) from view_vccs where ordeno=view_ordes.noa and no2=view_ordes.no2),0))";
						if (!emp($('#txtOrdeno').val()))
							t_where += " and charindex(noa,'" + $('#txtOrdeno').val() + "')>0";
						t_where = t_where;
					/*} else {
						alert(q_getMsg('msgCustEmp'));
						return;
					}*/
					q_box("ordes_b2_xy.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'ordes_xy', "95%", "650px", q_getMsg('popOrde'));
					//q_box("ordes_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'ordes', "95%", "650px", q_getMsg('popOrde'));
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
				
				$('#cmbStype').change(function() {
					stype_chang();
				});
				
				$('#txtFloata').change(function() {
					sum();
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
					/*if (!emp($('#txtCustno').val()) && $('#txtCustno').val().substr(0,2)=='##') {
						alert("非正式客戶編號，請聯絡專員轉正式客戶編號!!");
						$('#txtCustno').val('');
					}*/
					if (!emp($('#txtCustno').val())) {
						var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' group by post,addr ^^";
						q_gt('custaddr', t_where, 0, 0, 0, "");
					}
				}).focusin(function() {
					q_msg($(this),'請輸入客戶編號');
				});
				
				$('#btnClose_div_stk').click(function() {
					$('#div_stk').toggle();
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
				
				if (isinvosystem)
					$('.istax').hide();
					
			}

			function q_funcPost(t_func, result) {
				if (result.substr(0, 5) == '<Data') {
					var Asss = _q_appendData('sss', '', true);
					var Acar = _q_appendData('car', '', true);
					var Acust = _q_appendData('cust', '', true);
					alert(Asss[0]['namea'] + '^' + Acar[0]['car'] + '^' + Acust[0]['comp']);
				} else
					alert(t_func + '\r' + result);
			}

			function q_boxClose(s2) {
				var ret;
				switch (b_pop) {
					case 'ordes_xy':
						if (q_cur > 0 && q_cur < 4) {
							b_ret = getb_ret();
							if (!b_ret || b_ret.length == 0)
								return;
							for (var i = 0; i < b_ret.length; i++) {
								b_ret[i].tranmoney3=0;
								b_ret[i].tranmoney2=0;
								b_ret[i].width=0;
								b_ret[i].dime=b_ret[i].mount;
								if(b_ret[i].source=='2'){//庫出
									b_ret[i].tranmoney3=b_ret[i].mount;
									b_ret[i].mount=0;
								}else if(b_ret[i].source=='1'){//寄庫
									b_ret[i].tranmoney2=b_ret[i].mount;
								}else{
									b_ret[i].width=b_ret[i].mount;
								}
							}
								
							ret = q_gridAddRow(bbsHtm, 'tbbs', 'txtProductno,txtProduct,txtSpec,txtUnit,txtDime,txtMount,txtWidth,txtTranmoney2,txtTranmoney3,txtPrice,txtMemo,txtOrdeno,txtNo2,cmbItemno', b_ret.length, b_ret
							, 'productno,product,spec,unit,dime,mount,width,tranmoney2,tranmoney3,price,memo,noa,no2,source', 'txtProductno,txtProduct,txtSpec');
							//寫入訂單號碼
							var t_oredeno = '';
							for (var i = 0; i < b_ret.length; i++) {
								if (t_oredeno.indexOf(b_ret[i].noa) == -1)
									t_oredeno = t_oredeno + (t_oredeno.length > 0 ? (',' + b_ret[i].noa) : b_ret[i].noa);
							}
							//取得訂單備註 + 指定地址
							if (t_oredeno.length > 0) {
								var t_where = "where=^^ charindex(noa,'" + t_oredeno + "')>0 ^^";
								q_gt('orde', t_where, 0, 0, 0, "", r_accy);
							}

							$('#txtOrdeno').val(t_oredeno);
							sum();
							
							//103/12/04出貨單價抓最新的報價資料 >>後面取消
							//var t_where = "where=^^ productno+'_'+odate+'_'+noa in (select productno+'_'+MAX(odate+'_'+noa) from view_quats where custno='"+$('#txtCustno').val()+"' and odate<='"+q_date()+"' and productno!='' group by productno)  ^^";
							//q_gt('view_quats', t_where, 0, 0, 0, "vccprice_quat", r_accy);
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
					case 'sssissales':
						var as = _q_appendData("sss", "", true);
	                        if (as[0] != undefined) {
	                        	issales=(as[0].issales=="true"?true:false);
	                        	if(issales)
	                        		q_content = "where=^^salesno='" + r_userno + "'^^";
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
						/*if(!emp($('#txtCustno').val()) && !emp($('#txtProductno_' + b_seq).val())){
							var t_custno=$('#txtCustno').val().substr(0,$('#txtCustno').val().indexOf('-'));
							if(t_custno=='') 
								t_custno=$('#txtCustno').val();
							var t_where = "where=^^ a.noa!='"+$('#txtNoa').val()+"' and b.custno='" + t_custno + "' and productno='" + $('#txtProductno_' + b_seq).val() + "' ^^";
							q_gt('vcc_xy_store2', t_where, 0, 0, 0, "store2", r_accy);
						}else*/
						if(!emp($('#txtProductno_' + b_seq).val())){						
								var t_where = "where=^^ a.productno='" + $('#txtProductno_' + b_seq).val() + "' and a.storeno2='"+$('#txtStoreno2_' + b_seq).val() +"' and a.noa !='"+$('#txtNoa').val()+"' ^^";
								q_gt('vcc_xy_store2', t_where, 0, 0, 0, "store2", r_accy);
						}else{
							q_msg($('#txtMount_' + b_seq), t_msg);
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
						q_msg($('#txtMount_' + b_seq), t_msg);
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
							q_msg($('#txtStoreno2_' + b_seq), t_msg);
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
					case 'orde':
						var as = _q_appendData("orde", "", true);
						var t_memo = $('#txtMemo').val();
						var t_post2 = '';
						var t_addr2 = '';
						var t_custorde = '';
						for ( i = 0; i < as.length; i++) {
							t_memo = t_memo + as[i].noa + (as[i].memo.length>0? ':':'') + as[i].memo + (as[i].memo.length>0? '\n':(as.length-1==i?'':','));
							t_post2 = t_post2+(t_post2.length>0?';':'')+as[i].post2;
							t_addr2 = t_addr2+(t_addr2.length>0?';':'')+as[i].addr;
							t_custorde = t_custorde+(t_custorde.length>0?';':'')+as[i].custorde;
						}
						$('#txtMemo').val((t_custorde.length>0?('客戶訂單編號：'+t_custorde+'\n'):'')+t_memo);
						$('#txtPost2').val(t_post2);
						$('#txtAddr2').val(t_addr2);
						
						if (as[0] != undefined) {
							$('#txtCustno').val(as[0].custno);
							$('#txtComp').val(as[0].comp);
							$('#txtNick').val(as[0].nick);
							$('#txtPaytype').val(as[0].paytype);
							$('#cmbTrantype').val(as[0].trantype);
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
						}
						sum();
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
							var t_invomemo=as[0].invomemo;
							t_invomemo=t_invomemo.split('##');
							$('#txtPrice').val(t_invomemo[5]);
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
							$('#txtCustno2').val(as[0].custno2);
							$('#txtComp2').val(as[0].cust2);
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
						_btnDele();
						Unlock(1);
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
							if (z_msg.length > 0) {
								alert('已沖帳:' + z_msg);
								Unlock(1);
								return;
							}
						}
						_btnModi();
						Unlock(1);
						$('#txtDatea').focus();

						if (!emp($('#txtCustno').val())) {
							var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' group by post,addr ^^";
							q_gt('custaddr', t_where, 0, 0, 0, "");
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
							$('#txtMon').val($('#txtDatea').val().substr(0, 6));
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
				if(!check_startdate&&emp($('#txtMon').val())){
					var t_where = "where=^^ noa='"+$('#txtCustno').val()+"' ^^";
					q_gt('cust', t_where, 0, 0, 0, "startdate", r_accy);
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
				/*if (emp($('#txtMon').val()))
					$('#txtMon').val($('#txtDatea').val().substr(0, 6));*/
				
				check_stock=false;
				check_startdate=false;
					
				if (q_cur == 1)
					$('#txtWorker').val(r_name);
				else
					$('#txtWorker2').val(r_name);
					
				sum();

				var s1 = $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val();
				if (s1.length == 0 || s1 == "AUTO")
					q_gtnoa(q_name, replaceAll(q_getPara('sys.key_vcc') + $('#txtDatea').val(), '/', ''));
				else
					wrServer(s1);
			}

			function _btnSeek() {
				if (q_cur > 0 && q_cur < 4)// 1-3
					return;
				q_box('vcc_xy_s.aspx', q_name + '_s', "500px", "700px", q_getMsg("popSeek"));
			}

			function combPay_chg() {
				var cmb = document.getElementById("combPay");
				if (!q_cur)
					cmb.value = '';
				else
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
							sum();
						});
						
						$('#txtDime_' + i).focusout(function() {
							if (q_cur == 1 || q_cur == 2){
								t_IdSeq = -1;
								q_bodyId($(this).attr('id'));
								b_seq = t_IdSeq;
								var t_err = q_chkEmpField([['txtCustno', q_getMsg('lblCust')]]);
								if (t_err.length > 0) {
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
								}else{//出貨
									$('#txtWidth_'+b_seq).val($('#txtDime_'+b_seq).val());
									$('#txtTranmoney3_'+b_seq).val(0);
									$('#txtTranmoney2_'+b_seq).val(0);
								}
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
							}else if($('#cmbItemno_'+b_seq).val()=='2'){//庫出
								$('#txtTranmoney3_'+b_seq).val($('#txtDime_'+b_seq).val());
								$('#txtTranmoney2_'+b_seq).val(0);
								$('#txtWidth_'+b_seq).val(0);
							}else{//出貨
								$('#txtWidth_'+b_seq).val($('#txtDime_'+b_seq).val());
								$('#txtTranmoney3_'+b_seq).val(0);
								$('#txtTranmoney2_'+b_seq).val(0);
							}
							sum();
							
							if($('#cmbItemno_' + b_seq).val()!='0'){
								if(!emp($('#txtMemo_'+b_seq).val()))
									$('#txtMemo_'+b_seq).val($('#cmbItemno_' + b_seq).find("option:selected").text()+'：'+$('#txtMount_' + b_seq).val()+$('#txtUnit_' + b_seq).val()+','+$('#txtMemo_'+b_seq).val());
								else
									$('#txtMemo_'+b_seq).val($('#cmbItemno_' + b_seq).find("option:selected").text()+'：'+$('#txtMount_' + b_seq).val()+$('#txtUnit_' + b_seq).val());
							}
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
							/*if (!emp($('#txtProduct_'+b_seq).val()) && $('#txtProduct_'+b_seq).val().substr(0,2)=='##') {
								alert("非正式產品編號，請聯絡專員轉正式產品編號!!");
								$('#txtProduct_'+b_seq).val('');
							}*/
							var t_err = q_chkEmpField([['txtCustno', q_getMsg('lblCust')]]);
							if (t_err.length > 0) {
								alert(t_err);
								$(this).val('');
								return;
							}
							AutoNoq();
						});
						
						/*$('#txtMount_' + i).focusin(function() {
							if (q_cur == 1 || q_cur == 2) {
								t_IdSeq = -1;
								q_bodyId($(this).attr('id'));
								b_seq = t_IdSeq;
								if (!emp($('#txtProductno_' + b_seq).val())) {
									//庫存
									var t_where = "where=^^ ['" + q_date() + "','','" + $('#txtProductno_' + b_seq).val() + "')  ^^";
									q_gt('calstk', t_where, 0, 0, 0, "msg_stk", r_accy);
								}
							}
						});*/
						
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
							/*if(!emp($('#txtCustno').val()) && !emp($('#txtProductno_' + b_seq).val())){
								var t_custno=$('#txtCustno').val().substr(0,$('#txtCustno').val().indexOf('-'));
								if(t_custno=='') 
									t_custno=$('#txtCustno').val();
									
								//var t_where = "where=^^ noa!='"+$('#txtNoa').val()+"' and custno='" + $('#txtCustno').val() + "' and productno='" + $('#txtProductno_' + b_seq).val() + "' ^^";
								var t_where = "where=^^ a.noa!='"+$('#txtNoa').val()+"' and b.custno='" + t_custno + "' and productno='" + $('#txtProductno_' + b_seq).val() + "' ^^";
								q_gt('vcc_xy_store2', t_where, 0, 0, 0, "store2_stk", r_accy);
							}*/
							if(!emp($('#txtProductno_' + b_seq).val()) && dec($(this).val())!=0){						
								var t_where = "where=^^ a.productno='" + $('#txtProductno_' + b_seq).val() + "' and a.storeno2='"+$('#txtStoreno2_' + b_seq).val() +"' and a.noa !='"+$('#txtNoa').val()+"' ^^";
								q_gt('vcc_xy_store2', t_where, 0, 0, 0, "store2_stk", r_accy);
							}
						});
						
						$('#btnRecord_' + i).click(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							t_where = "cust='" + $('#txtCustno').val() + "' and noq='" + $('#txtProductno_' + b_seq).val() + "'";
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
				//$('.store2').hide();//104/02/06 不用昌庫104/02/26恢復用倉庫(不判斷客戶)
			}

			function btnIns() {
				_btnIns();
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val('AUTO');
				$('#txtCno').val(z_cno);
				$('#txtAcomp').val(z_acomp);
				$('#txtDatea').val(q_date());
				$('#cmbTypea').val('1');
				$('#txtDatea').focus();
				$('#cmbTaxtype').val('0');
				var t_where = "where=^^ 1=1  group by post,addr^^";
				q_gt('custaddr', t_where, 0, 0, 0, "");
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
				q_box('z_vccp_xy.aspx' + "?;;;noa=" + trim($('#txtNoa').val()) + ";" + r_accy, '', "95%", "95%", q_getMsg("popPrint"));
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

			function q_stPost() {
				if (q_cur == 1 || q_cur == 2) {
					var s2 = xmlString.split(';');
					abbm[q_recno]['accno'] = s2[0];
				}
			}

			function refresh(recno) {
				_refresh(recno);
				if (isinvosystem)
					$('.istax').hide();
				HiddenTreat();
				stype_chang();
				$('#div_stk').hide();
				$('#div_store2').hide();
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
				} else {
					$('#combAddr').removeAttr('disabled');
				}
				HiddenTreat();
				//限制帳款月份的輸入 只有在備註的第一個字為*才能手動輸入
				if ($('#txtMemo').val().substr(0,1)=='*')
					$('#txtMon').removeAttr('readonly');
				else
					$('#txtMon').attr('readonly', 'readonly');
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
						/*if (!emp($('#txtCustno').val()) && $('#txtCustno').val().substr(0,2)=='##') {
							alert("非正式客戶編號，請聯絡專員轉正式客戶編號!!");
							$('#txtCustno').val('');
						}*/
						if (!emp($('#txtCustno').val())) {
							var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' group by post,addr ^^";
							q_gt('custaddr', t_where, 0, 0, 0, "");
							var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^";
							q_gt('cust', t_where, 0, 0, 0, "cust_detail");
						}
						
						$('#txtSalesno').attr('disabled', 'disabled');
						/*if($('#txtComp').val().indexOf('現銷')>-1){
						}else{
							$('#txtSalesno').removeAttr('disabled');
						}*/
						
						break;
					case 'txtProductno_':
						/*if (!emp($('#txtProduct_'+b_seq).val()) && $('#txtProduct_'+b_seq).val().substr(0,2)=='##') {
							alert("非正式產品編號，請聯絡專員轉正式產品編號!!");
							$('#txtProduct_'+b_seq).val('');
						}*/
						
						if(($('#txtProduct_'+b_seq).val().indexOf('運費')>-1 || $('#txtSpec_'+b_seq).val().indexOf('運費')>-1) && dec($('#txtPrice').val())>0){
							var t_mount=0;
							for (var j = 0; j < q_bbsCount; j++) {
								if(j!=b_seq){
									t_mount=q_add(t_mount,q_float('txtMount_'+j));
								}
							}
							q_tr('txtWidth_'+b_seq,t_mount);
							q_tr('txtPrice_'+b_seq,dec($('#txtPrice').val()));
						}
						AutoNoq();
						break;
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
		<div id="dmain" style="width: 1260px;">
			<!--#include file="../inc/toolbar.inc"-->
			<div class="dview" id="dview" >
				<table class="tview" id="tview">
					<tr>
						<td align="center" style="width:5%"><a id='vewChk'> </a></td>
						<td align="center" style="width:5%"><a id='vewType'> </a></td>
						<td align="center" style="width:25%"><a id='vewDatea'> </a></td>
						<td align="center" style="width:25%"><a id='vewNoa'> </a></td>
						<td align="center" style="width:40%"><a id='vewComp'> </a></td>
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
						<td class="td1" style="width: 108px;"><span> </span><a id='lblType' class="lbl"> </a></td>
						<td class="td2" style="width: 108px;"><select id="cmbTypea"> </select></td>
						<td class="td3" style="width: 108px;">
							<a id='lblStype' class="lbl" style="float: left;"> </a>
							<span style="float: left;"> </span>
							<select id="cmbStype"> </select>
						</td>
						<td class="td4" style="width: 108px;"><span> </span><a id='lblDatea' class="lbl"> </a></td>
						<td class="td5" style="width: 108px;"><input id="txtDatea" type="text"  class="txt c1"/></td>
						<td class="td6" style="width: 108px;"> </td>
						<td class="td7" style="width: 108px;"><span> </span><a id='lblNoa' class="lbl"> </a></td>
						<td class="td8" style="width: 108px;"><input id="txtNoa" type="text" class="txt c1" /></td>
					</tr>
					<tr>
						<td class="td1"><span> </span><a id="lblAcomp" class="lbl btn"> </a></td>
						<td class="td2"><input id="txtCno" type="text" class="txt c1"/></td>
						<td class="td2"><input id="txtAcomp" type="text" class="txt c1"/></td>
						<td class="td7"><span> </span><a id='lblMon' class="lbl"> </a></td>
						<td class="td8"><input id="txtMon" type="text" class="txt c1"/></td>
						<td class="td8"> </td>
						<td class="td7">
							<span> </span>
							<a id='lblInvono' class="lbl btn vcca"> </a>
							<a id='lblInvo' class="lbl btn invo"> </a>
						</td>
						<td class="td8">
							<input id="txtInvono" type="text" class="txt c1 vcca"/>
							<input id="txtInvo" type="text" class="txt c1 invo"/>
						</td>
					</tr>
					<tr>
						<td class="td1"><span> </span><a id="lblCust" class="lbl btn"> </a></td>
						<td class="td2"><input id="txtCustno" type="text" class="txt c1"/></td>
						<td class="td2">
							<input id="txtComp" type="text" class="txt c1"/>
							<input id="txtNick" type="hidden" class="txt c1"/>
						</td>
						<td class="td4"><span> </span><a id='lblPay' class="lbl"> </a></td>
						<td class="td5"><input id="txtPaytype" type="text" class="txt c1"/></td>
						<td class="td6"><select id="combPay" style="width: 100%;" onchange='combPay_chg()'> </select></td>
						<td class="td6"align="right"><input id="btnOrdes" type="button"/></td>
					</tr>
					<tr>
						<td class="td1"><span> </span><a id="lblTel" class="lbl"> </a></td>
						<td class="td2" colspan='2'><input id="txtTel" type="text" class="txt c1"/></td>
						<td class="td1"><span> </span><a id="lblFax" class="lbl"> </a></td>
						<td class="td2" colspan='2'><input id="txtFax" type="text" class="txt c1"/></td>
						<td class="td4"><span> </span><a id='lblTrantype' class="lbl"> </a></td>
						<td class="td5"><select id="cmbTrantype" style="width: 100%;"> </select></td>
					</tr>
					<tr>
						<td class="td1"><span> </span><a class="lbl">郵遞區號</a></td>
						<td class="td2"><input id="txtPost" type="text" class="txt c1"/></td>
						<td class="td1"><span> </span><a id="lblAddr" class="lbl"> </a></td>
						<td class="td3" colspan='3'><input id="txtAddr" type="text" class="txt c1"/></td>
						<td class="td7"><span> </span><a id='lblOrdeno' class="lbl btn"> </a></td>
						<td class="td8"><input id="txtOrdeno" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td class="td1"><span> </span><a class="lbl">指送區號</a></td>
						<td class="td2"><input id="txtPost2"  type="text" class="txt c1"/></td>
						<td class="td1"><span> </span><a id='lblAddr2' class="lbl"> </a></td>
						<td class="td3" colspan='3'>
							<input id="txtAddr2"  type="text" class="txt c1" style="width: 302px;"/>
							<select id="combAddr" style="width: 20px" onchange='combAddr_chg()'> </select>
						</td>
						<td class="td6"align="right"><input id="btnStore2" type="button" value="寄庫顯示"/></td>
					</tr>
					<tr>
						<td class="td1"><span> </span><a id='lblSales' class="lbl btn"> </a></td>
						<td class="td2"><input id="txtSalesno" type="text" class="txt c1"/></td>
						<td class="td3"><input id="txtSales" type="text" class="txt c1"/></td>
						<td class="td4"><span> </span><a id="lblCardeal" class="lbl btn"> </a></td>
						<td class="td5"><input id="txtCardealno" type="text" class="txt c1"/></td>
						<td class="td6"><input id="txtCardeal" type="text" class="txt c1"/></td>
						<td class="td7"><span> </span><a id='lblCarno' class="lbl"> </a></td>
						<td class="td8">
							<input id="txtCarno"  type="text" class="txt" style="width:75%;"/>
							<select id="combCarno" style="width: 20%;"> </select>
						</td>
						<!--<td class="td5"><select id="cmbTranstyle" style="width: 100%;"> </select></td>-->
					</tr>
					<tr>
						<td class="td1"><span> </span><a id="lblMoney" class="lbl"> </a></td>
						<td class="td2" colspan='2'><input id="txtMoney" type="text" class="txt num c1"/></td>
						<td class="td4"><span> </span><a id='lblTax' class="lbl"> </a></td>
						<td class="td5" colspan='2'>
							<input id="txtTax" type="text" class="txt num c1 istax"  style="width: 49%;"/>
							<select id="cmbTaxtype" style="width: 49%;" onchange="calTax();"> </select>
						</td>
						<td class="td7"><span> </span><a id='lblTotal' class="lbl istax"> </a></td>
						<td class="td8"><input id="txtTotal" type="text" class="txt num c1 istax"/></td>
					</tr>
					<tr>
						<td class="td1"><span> </span><a id="lblCust2" class="lbl btn"> </a></td>
						<td class="td2" colspan='2'>
							<input id="txtCustno2" type="text" class="txt c2"/>
							<input id="txtComp2" type="text" class="txt c3"/>
						</td>
						<td class="td4"><span> </span><a id='lblFloata' class="lbl"> </a></td>
						<td class="td5"><select id="cmbCoin" style="width: 100%;" onchange='coin_chg()'> </select></td>
						<td class="td6"><input id="txtFloata" type="text" class="txt num c1"/></td>
						<td class="td7"><span> </span><a id="lblTotalus" class="lbl"> </a></td>
						<td class="td8"><input id="txtTotalus" type="text" class="txt num c1"/></td>
					</tr>
					<tr>
						<td class="td1"><span> </span><a id="lblWorker" class="lbl"> </a></td>
						<td class="td2"><input id="txtWorker" type="text" class="txt c1"/></td>
						<td class="td3"><input id="txtWorker2" type="text" class="txt c1"/></td>
						<td class="td4"><span> </span><a id='lblAccc' class="lbl btn"> </a></td>
						<td class="td5" colspan='2'><input id="txtAccno" type="text" class="txt c1"/></td>
						<td class="td7"><span> </span><a class="lbl">運費單價</a></td>
						<td class="td8"><input id="txtPrice" type="text" class="txt num c1"/></td>
					</tr>
					<tr>
						<td class="td1"><span> </span><a id="lblMemo" class="lbl"> </a></td>
						<td class="td2" colspan='7'><textarea id="txtMemo" cols="10" rows="5" style="width: 99%;height: 50px;"> </textarea></td>
					</tr>
				</table>
			</div>
		</div>
		<div class='dbbs' style="width: 2000px;">
			<table id="tbbs" class='tbbs'>
				<tr style='color:White; background:#003366;' >
					<td align="center" style="width:40px;"><input class="btn"  id="btnPlus" type="button" value='＋' style="font-weight: bold;width:" /></td>
					<td align="center" style="width:40px;"><a>項次</a></td>
					<td align="center" style="width:180px"><a id='lblProductno_s'> </a></td>
					<td align="center" style="width:180px;"><a id='lblProduct_s'> </a></td>
					<td align="center" style="width:180px;"><a id='lblSpec_s'> </a></td>
					<td align="center" style="width:40px;"><a id='lblUnit_s'> </a></td>
					<td align="center" style="width:80px;display: none;">請款數量</td>
					<td align="center" style="width:80px;">出貨數量</td>
					<td align="center" style="width:70px;"><a >寄/出庫</a></td>
					<td align="center" style="width:80px;"><a id='lblPrice_s'> </a></td>
					<td align="center" style="width:80px;"><a id='lblTotal_s'> </a></td>
					<td align="center" style="width:120px;">出貨倉庫</td>
					<td class="store2" align="center" style="width:120px;"><a id='lblStore2_s'> </a></td>
					<td align="center" style="width:80px;display: none;"><a id='lblTranmoney2_s'> </a></td>
					<td align="center" style="width:80px;display: none;"><a id='lblTranmoney3_s'> </a></td>
					<td align="center" style="width:150px;"><a id='lblMemo_s'> </a></td>
					<td align="center" style="width:150px;">訂單號碼</td>
					<td align="center" style="width:40px;"><a id='lblRecord_s'> </a></td>
					<td align="center" style="width:40px;"><a id='lblStk_s'> </a></td>
				</tr>
				<tr style='background:#cad3ff;'>
					<td align="center"><input class="btn"  id="btnMinus.*" type="button" value='－' style=" font-weight: bold;" /></td>
					<td align="center"><input id="txtNoq.*" type="text" class="txt c1"/></td>
					<td align="center">
						<input class="txt c1"  id="txtProductno.*" type="text" style="width: 85%;" />
						<input class="btn"  id="btnProductno.*" type="button" value='.' style=" font-weight: bold;" />
					</td>
					<td><input id="txtProduct.*" type="text" class="txt c1" /></td>
					<td><input id="txtSpec.*" type="text" class="txt c1" /></td>
					<td><input id="txtUnit.*" type="text" class="txt c1"/></td>
					<td style="display: none;"><input id="txtMount.*" type="text" class="txt num c1"/></td>
					<td style="display: none;"><input id="txtWidth.*" type="text" class="txt num c1"/></td>
					<td><input id="txtDime.*" type="text" class="txt num c1"/></td>
					<td><select id="cmbItemno.*" class="txt c1"> </select></td>
					<td><input id="txtPrice.*" type="text" class="txt num c1"/>
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
					<td align="center"><input class="btn"  id="btnRecord.*" type="button" value='.' style=" font-weight: bold;" /></td>
					<td align="center"><input class="btn"  id="btnStk.*" type="button" value='.' style="width:1%;"/></td>
				</tr>
			</table>
		</div>
		<input id="q_sys" type="hidden" />
	</body>
</html>