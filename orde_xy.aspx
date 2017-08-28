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
			var q_readonly = ['txtNoa', 'txtWorker', 'txtWorker2', 'txtComp', 'txtCno', 'txtAcomp', 'txtMoney', 'txtTax', 'txtTotal', 'txtTotalus', 'txtSales', 'txtOrdbno', 'txtOrdcno','txtVccno','txtApv','textInvomemo','textConn','textMemo2'];
			var q_readonlys = ['txtTotal', 'txtQuatno', 'txtNo2', 'txtNo3', 'txtC1', 'txtNotv','txtHard','txtLengthc','txtMount','txtPrice','txtZinc'];
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
					['txtCustno', 'lblCust', 'cust', 'noa,nick,nick,tel,invoicetitle,serial', 'txtCustno,txtComp,txtNick,txtTel', 'cust_b.aspx'],
					['ordb_txtTggno_', '', 'tgg', 'noa,comp', 'ordb_txtTggno_,ordb_txtTgg_', ''],
					['txtSize_', 'btnSize_', 'store', 'noa,store', 'txtSize_,txtUcolor_', 'store_b.aspx']
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
				var t1 = 0;
				if(q_cur==1 || q_cur==2){
					for (var j = 0; j < q_bbsCount; j++) {
						var t_unit = $('#txtUnit_' + j).val();
						var t_mount = dec($('#txtMount_' + j).val());
						var t_price = dec($('#txtPrice_' + j).val());//單價
						
						$('#txtTotal_' + j).val(round(q_mul(t_price, t_mount), 0));
					
						q_tr('txtNotv_' + j, q_sub(q_float('txtMount_' + j), q_float('txtC1' + j)));
						t1 = q_add(t1, dec($('#txtTotal_' + j).val()));
					}
					$('#txtMoney').val(round(t1, 0));
					q_tr('txtTotal', q_add(t1, dec($('#txtTax').val())));
					q_tr('txtTotalus', q_mul(q_float('txtMoney'), q_float('txtFloata')));
					calTax();
				}
			}
			
			var x_ordevccumm=false;
			var xy_datea='';
			function mainPost() {
				q_getFormat();
				bbmMask = [['txtOdate', r_picd], ['txtMon', r_picm],['txtXydatea',r_picd]];
				q_mask(bbmMask);
				bbsMask = [['txtDatea', r_picd]];
				bbsNum = [ ['txtMount', 10, q_getPara('vcc.mountPrecision'), 1],['txtLengthb', 10, q_getPara('vcc.mountPrecision'), 1]
				, ['txtTotal', 10, 0, 1],['txtC1', 10, q_getPara('vcc.mountPrecision'), 1], ['txtNotv', 10, q_getPara('vcc.mountPrecision'), 1]
				,['txtDime', 10, q_getPara('vcc.mountPrecision'), 1]];
				//['txtPrice', 12, q_getPara('vcc.pricePrecision'), 1],
				q_cmbParse("cmbStype", q_getPara('vcc.stype'));
				//q_cmbParse("cmbCoin", q_getPara('sys.coin'));
				q_cmbParse("combPaytype", q_getPara('vcc.paytype'));
				q_cmbParse("cmbTrantype", q_getPara('sys.tran'));
				q_cmbParse("cmbTaxtype", q_getPara('sys.taxtype'));
				q_cmbParse("combClassa",' ,便品,空白,公版,加工,印刷,私-空白','s');
				q_cmbParse("cmbScolor",',新版,改版,新版數位樣,新版正式樣,改版數位樣,改版正式樣','s');
				q_cmbParse("cmbSource",'0@ ,1@寄庫,2@庫出,3@公關品,4@樣品,5@換貨','s');
				q_cmbParse("cmbConform", '@,隨貨@隨貨,月結@月結,週結@週結,PO@PO');
				q_cmbParse("cmbIndate", '當天@當天,之前@之前,等待@等待','s');
				q_cmbParse("combXyindate", ',當天@當天,之前@之前,等待@等待');

				var t_where = "where=^^ 1=0 ^^";
				q_gt('custaddr', t_where, 0, 0, 0, "");
				
				$('#cmbTrantype').change(function() {
					if((q_cur==1 || q_cur==2) && $('#cmbTrantype').val()=='直寄' && $('#txtMemo').val().substr(0,1)!='#'){
						$('#txtMemo').val('#'+$('#txtMemo').val());
					}
				});
				
				$('#txtXydatea').change(function() {
					if((q_cur==1 || q_cur==2) && xy_datea!=$('#txtXydatea').val()){
						for(var i=0;i<q_bbsCount;i++){
							$('#txtDatea_'+i).val($('#txtXydatea').val());
						}
					}
				}).focusout(function() {
					if((q_cur==1 || q_cur==2) && xy_datea!=$('#txtXydatea').val()){
						for(var i=0;i<q_bbsCount;i++){
							$('#txtDatea_'+i).val($('#txtXydatea').val());
						}
					}
				}).focusin(function() {
					xy_datea=$('#txtXydatea').val();
				});
				
				$('#combXyindate').change(function() {
					if((q_cur==1 || q_cur==2) && $('#combXyindate').val()!=''){
						for(var i=0;i<q_bbsCount;i++){
							$('#cmbIndate_'+i).val($('#combXyindate').val());
						}
					}
				});
				
				$('#btnPlusCust').click(function(){
					q_box('cust.aspx','pluscust', "95%", "95%", '新增客戶');
				});

				$('#btnOrdei').click(function() {
					if (q_cur != 1 && $('#cmbStype').find("option:selected").text() == '外銷')
						q_box("ordei.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";noa='" + $('#txtNoa').val() + "';" + r_accy + ";" + q_cur, 'ordei', "95%", "95%", q_getMsg('popOrdei'));
				});
				$('#btnQuat').click(function() {
					if(q_cur==1 || q_cur==2){
						btnQuat();
					}
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
					
				}).focusin(function() {
					//q_msg($(this),'請輸入客戶編號');
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
				
				$('#btnCont').click(function() {
					//105/10/06合併到＂報價匯入＂
					var t_datea=q_date();
					var t_custno = trim($('#txtCustno').val());
					var t_productno='#non';
					var t_kind='PO';
					if(q_cur==1 || q_cur==2){
						if(t_custno.length>0){
							q_func('qtxt.query.contimport', 'cust_ucc_xy.txt,contimport,' + encodeURI(t_datea)+';'+t_custno+';'+t_productno+';'+t_kind,r_accy,1);
							var as = _q_appendData("tmp0", "", true, true);
							if (as[0] != undefined) {
								q_gridAddRow(bbsHtm, 'tbbs', 'txtProductno,txtProduct,txtClassa,txtSpec,txtHard,txtLengthc,txtZinc,txtUnit,txtPrice,txtQuatno,txtNo3'
								, as.length, as, 'productno,product,class,spec,unit,price,ounit,uunit,price,noa,noq', 'txtProductno,txtProduct,txtSpec');
								
								combzincchange('ALL');
								for (var i = 0; i < q_bbsCount; i++) {
									unitchange(i);
									pricecolor();
								}
								
								if(emp($('#txtCustorde').val())){
									$('#txtCustorde').val(as[0].contract);
								}
							}/*else{
								alert('無客戶PO!!');
							}*/
						}else{
							alert(q_getMsg('msgCustEmp'));
						}
					}
				});
				
				$('#btnCont2').click(function() {
					if (!emp($('#txtCustno').val())) {
						q_box("cont_xy.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";kind!='PO' and custno like '" + $('#txtCustno').val().substr(0,5) + "%';" + r_accy + ";" + q_cur, 'ordei', "95%", "95%", $('#btnCont2').val());
					}
				});
				
				$('#btnUpload').change(function() {
					if(!(q_cur==1 || q_cur==2)){
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
						$('#txtGdate').val(file.name);
						//$('#txtGtime').val(guid()+Date.now()+ext);
						//106/05/22 不再使用亂數編碼
						$('#txtGtime').val(file.name);
						
						fr = new FileReader();
						fr.fileName = $('#txtGtime').val();
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
							oReq.open("POST", 'orde_xy_upload.aspx', true);
							oReq.setRequestHeader("Content-type", "text/plain");
							oReq.setRequestHeader("FileName", escape(fr.fileName));
							oReq.send(fr.result);//oReq.send(e.target.result);
						};
					}
					ShowDownlbl();
				});
				
				$('#lblDownload').click(function(){
					if($('#txtGdate').val().length>0 && $('#txtGtime').val().length>0){
						$('#xdownload').attr('src','orde_xy_download.aspx?FileName='+$('#txtGdate').val()+'&TempName='+$('#txtGtime').val());
                    }else if($('#txtGtime').val().length>0){
						$('#xdownload').attr('src','orde_xy_download.aspx?FileName='+$('#txtNoa').val()+'&TempName='+$('#txtGtime').val());
                    }else{    
						alert('無資料...!!');
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
					
					//105/07/11 判斷是否有超過3個月的帳款 等級權限9不處理 //等級7以下判斷
					if(r_rank<'7'){
						var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^";
						q_gt('cust', t_where, 0, 0, 0, "getummcust", r_accy, 1);
						var as = _q_appendData("cust", "", true);
						if (as[0] != undefined) {
							var t_custno=as[0].custno2;
							var t_comp=as[0].cust2;
							if(t_custno.length==0){
								t_custno=as[0].noa;
								t_comp=as[0].comp;
							}
							var t_mon=q_cdn(q_date().substr(0,r_lenm)+'/01',-105).substr(0,r_lenm)
							
							//取出出貨單
							q_gt('umm_import',"where=^^['','"+t_custno+"','','"+t_mon+"','"+q_getPara('sys.d4taxtype')+"')^^", 0, 0, 0, "umm_import", r_accy, 1);
							var as2 = _q_appendData('umm_import', "", true);
							if(as2.length>0){
								alert('客戶有超過3個月的帳款未沖帳，禁止核准訂單!!');
								return;
							}
						}else{
							alert('客戶編號錯誤!!');
							return;
						}
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
					$('#div_store2').hide();
					/*if(!emp($('#txtCustno').val())){
						var t_custno=$('#txtCustno').val().substr(0,$('#txtCustno').val().indexOf('-'));
						if(t_custno=='') 
							t_custno=$('#txtCustno').val();
						var t_where = "where=^^ a.storeno2 like '"+t_custno +"%' and a.noa !='"+$('#txtNoa').val()+"' and isnull(a.productno,'')!='' ^^";
						q_gt('vcc_xy_store2', t_where, 0, 0, 0, "store2_store2", r_accy);
					}else{
						alert("請輸入客戶編號!!");
					}*/
					//106/02/10 改用txt
					if(!emp($('#txtCustno').val())){
						var t_datea=q_date();
						var t_custno=$('#txtCustno').val();
						var t_noa='#non';//修改排除該張出貨單
						var t_pno='#non';
						q_func('qtxt.query.btnstore2', 'cust_ucc_xy.txt,btnstore2,' + encodeURI(t_custno)+';'+encodeURI(t_noa)+';'+encodeURI(t_datea)+';'+encodeURI(t_pno));
					}else{
						alert("請輸入客戶編號!!");
					}
				});
				$('#btnClose_div_store2').click(function() {
					$('#div_store2').hide();
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
					$('#btnOrdetoVcc').attr('disabled', 'disabled');
					
					if(emp($('#txtAddr2').val())){
						alert("指送地址空白禁止轉出貨單!!");
						return;
					}
					
					//20160113 多預交日不轉單，或單一預交日
					var t_datea=$('#txtDatea_0').val();
					var date_rep=false;
					var date_wait=false;
					var date_store2=false;
					for(var i=0;i<q_bbsCount;i++){
						if(t_datea!=$('#txtDatea_'+i).val()){
							date_rep=true;
							break;
						}
						if($('#cmbIndate_'+i).val()=='等待'){
							date_wait=true;
							break;
						}
						
						if(($('#cmbSource_' + i).val()=='1' || $('#cmbSource_' + i).val()=='2') && emp($('#txtSize_'+i).val())){
							date_store2=true;
							break;
						}
					}
					if(date_rep){
						alert("多預交日禁止轉出貨單!!");
						return;
					}
					if(date_wait){
						alert("明細內含有等待，禁止轉出貨單!!");
						return;
					}
					if(date_store2){
						alert("寄庫／庫出倉禁止空白!!");
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
					
					//105/10/17 判斷 新版、改版的訂單，若未進貨或入庫，禁止轉出貨單
					var t_err='';
					for(var i=0;i<q_bbsCount;i++){
						if($('#cmbScolor_'+i).val().indexOf('新版')>-1 || $('#cmbScolor_'+i).val().indexOf('改版')>-1){
							var t_where = " where=^^ ordeno='" + $('#txtNoa').val() + "' and no2='"+$('#txtNo2_'+i).val()+"' and isnull(enda,0)=1 and isnull(mount,0)>0 ^^";
							q_gt('view_cub', t_where, 0, 0, 0, 'checkcubenda', r_accy, 1);
							var as = _q_appendData("view_cub", "", true);
							if (as[0] == undefined) {
								t_err=t_err+($('#txtProductno_'+i).val()+' '+$('#txtProduct_'+i).val()+' 【'+$('#cmbScolor_'+i).val()+'】 未製令入庫禁止轉出貨!!\n');
								break;
							}
						}
					}
					if(t_err.length>0){
						alert(t_err);
						$('#btnOrdetoVcc').removeAttr('disabled');
						return;
					}
					
					//檢查是否已收款
					if(!x_ordevccumm && !emp($('#txtVccno').val())){
						var t_where = " where=^^ vccno='" + $('#txtVccno').val() + "'^^";
						q_gt('umms', t_where, 0, 0, 0, 'ordevccumm', r_accy);
						return;
					}
					x_ordevccumm=false;
					
					//106/02/13 判斷庫存是否足夠 //02/14 交運方式=直寄 不判斷//02/15 寄庫不處理
					var t_stkerr='';
					var t_pno='',t_pno2='';
					if($('#cmbTrantype').val()!='直寄'){
						for(var i=0;i<q_bbsCount;i++){
							if(!emp($('#txtProductno_'+i).val()) && $('#txtProduct_'+i).val()!='費用' && dec($('#txtMount_'+i).val())!=0 && $('#cmbSource_'+i).val()!='1'){
								if($('#cmbSource_'+i).val()=='2'){
									t_pno2=t_pno2+(t_pno2.length>0?'###':'')+$('#txtProductno_'+i).val()+'@'+$('#txtSize_'+i).val();
								}else{
									t_pno=t_pno+(t_pno.length>0?'###':'')+$('#txtProductno_'+i).val()+'@'+($('#txtCustno').val().substr(0,5)!='DY001'?'A':'DY');
								}
							}
						}
						if(t_pno.length>0 || t_pno2.length>0){
							q_func('qtxt.query.chkstk', 'cust_ucc_xy.txt,chkstk,' + encodeURI($('#txtNoa').val()) + ';' + encodeURI(t_pno)+ ';' + encodeURI(t_pno2)+ ';' + encodeURI(q_date()),r_accy,1);
							var as = _q_appendData("tmp0", "", true, true);
							for(var i=0;i<q_bbsCount;i++){
								if(!emp($('#txtProductno_'+i).val()) && $('#txtProduct_'+i).val()!='費用' && dec($('#txtMount_'+i).val())!=0){
									for(var j=0;j<as.length;j++){
										if($('#cmbSource_'+i).val()=='1'){//寄庫
											if($('#txtProductno_'+i).val()==as[j].productno && as[j].typea=='2'){
												as[j].stkmount=q_add(dec(as[j].stkmount),dec($('#txtMount_'+i).val()))
											}
										}else if($('#cmbSource_'+i).val()=='2'){//庫出
											if($('#txtProductno_'+i).val()==as[j].productno && as[j].typea=='2'
											&& as[j].stkmount<dec($('#txtMount_'+i).val())){
												t_stkerr=$('#txtProductno_'+i).val()+'寄庫數量('+as[j].stkmount+')小於訂單庫出數量('+$('#txtMount_'+i).val()+')';
												break;
											}
											if($('#txtProductno_'+i).val()==as[j].productno && as[j].typea=='2'){
												as[j].stkmount=q_sub(dec(as[j].stkmount),dec($('#txtMount_'+i).val()))
											}
										}else{//出貨
											if($('#txtProductno_'+i).val()==as[j].productno && as[j].typea=='1'
											&& as[j].stkmount<dec($('#txtMount_'+i).val())){
												t_stkerr=$('#txtProductno_'+i).val()+'庫存數量('+as[j].stkmount+')小於訂單數量('+$('#txtMount_'+i).val()+')';
												break;
											}
											if($('#txtProductno_'+i).val()==as[j].productno && as[j].typea=='1'){
												as[j].stkmount=q_sub(dec(as[j].stkmount),dec($('#txtMount_'+i).val()))
											}
										}
									
									}
								}
								if(t_stkerr.length>0){
									break;
								}
							}
						}
						if(t_stkerr.length>0){
							alert(t_stkerr);
							//return;
						}
					}
					
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
			
			var guid = (function() {
				function s4() {return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);}
				return function() {return s4() + s4() + s4() + s4();};
			})();
			
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
								
								if(!emp($('#txtProductno_'+b_seq).val())){
									var t_grpno=''; //客戶集團編號
									var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^";
									q_gt('cust', t_where, 0, 0, 0, "getcustgrpno", r_accy, 1);
									var as = _q_appendData("cust", "", true);
									if (as[0] != undefined) {
										t_grpno=as[0].grpno;
									}
									//105/07/21集團本身底下子公司
									var t_where = "where=^^ grpno='"+$('#txtCustno').val()+"' ^^";
									q_gt('cust', t_where, 0, 0, 0, "getcustgrpno2", r_accy, 1);
									var as2 = _q_appendData("cust", "", true);
									var isexists=false;
									for ( i = 0; i < as2.length; i++) {
										if($('#txtProductno_' + b_seq).val().substr(0,5)==as2[i].noa.substr(0,5)){
											isexists=true;
										}
									}
									
									if($('#txtProductno_' + b_seq).val().indexOf('-')>0){
										if($('#txtProductno_' + b_seq).val().substr(0,5)!=$('#txtCustno').val().substr(0,5)
										&&  $('#txtProductno_' + b_seq).val().substr(0,5)!=t_grpno
										&& !isexists	){
											$('#btnMinus_'+b_seq).click();
											break;
										}
									}
																
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
										q_func('qtxt.query.keyin_pno_xy_'+b_seq, 'cust_ucc_xy.txt,quatimport,' + t_where);
										
									}else {
										alert(q_getMsg('msgCustEmp'));
										$('#txtCustno').focus();
										$('#btnMinus_'+b_seq).click();
										return;
									}
								}
								combzincchange(b_seq);
								unitchange(b_seq);
								pricecolor();
								AutoNo2();
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
							
							/*if(b_ret[0]!=undefined){
								//取得報價的第一筆匯率等資料
								var t_where = "where=^^ noa='" + b_ret[0].noa + "' ^^";
								q_gt('view_quat', t_where, 0, 0, 0, "", r_accy);
							}

							var i, j = 0;
							ret = q_gridAddRow(bbsHtm, 'tbbs', 'txtProductno,txtProduct,txtSpec,txtSizea,txtDime,txtUnit,txtPrice,txtMount,txtQuatno,txtNo3,txtClassa,txtClass'
							, b_ret.length, b_ret, 'productno,product,spec,sizea,dime,unit,price,mount,noa,no3,classa,class', 'txtProductno,txtProduct,txtSpec');
							/// 最後 aEmpField 不可以有【數字欄位】
							sum();
							bbsAssign();*/
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
								if(noa.substr(0,1)=='C'){
									q_box("cont_xy.aspx?;;;noa='" + noa + "';" + r_accy, 'cont', "95%", "95%", q_getMsg("popCont"));
								}else{
									q_box("quat_xy.aspx?;;;noa='" + noa + "';" + r_accy, 'quat', "95%", "95%", q_getMsg("popQuat"));
								}
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
						var t_cust=$('#txtCustno').val();
						var t_invocust=t_cust;
						if (as[0] != undefined) {
							t_invocust=as[0].invocustno;
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
	                        	if(issales){
	                        		if(q_content.length>0)
	                        			q_content="where=^^salesno='" + r_userno + "' and "+q_content.substr(q_content.indexOf('^^')+2);
	                        		else
	                        			q_content = "where=^^salesno='" + r_userno + "'^^";
	                        	}
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
						var quat_unit = '';	
						if (as[0] != undefined) {
							for (var i = 0; i < as.length; i++) {
								if (as[0].productno == $('#txtProductno_' + b_seq).val())
									quat_price = dec(as[i].price);
									quat_unit=as[i].unit;
							}
						}
						t_msg = t_msg + "最近報價單價：" + quat_price + "/"+quat_unit+"<BR>";
						//最新出貨單價
						var t_where = "where=^^ custno='" + $('#txtCustno').val() + "' and noa in (select noa from vccs" + r_accy + " where productno='" + $('#txtProductno_' + b_seq).val() + "' and price>0 ) ^^ stop=1";
						q_gt('vcc', t_where, 0, 0, 0, "msg_vcc", r_accy);
						break;
					case 'msg_quat_xy':
						var as = _q_appendData("view_quats", "", true);
						if (as[0] != undefined) {
							t_msg = t_msg + "最近報價單價：" + dec(as[0].price) + "/"+as[0].unit+"<BR>";
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
						var vcc_unit = '';
						if (as[0] != undefined) {
							for (var i = 0; i < as.length; i++) {
								if (as[0].productno == $('#txtProductno_' + b_seq).val())
									vcc_price = dec(as[i].price);
									vcc_unit=as[i].unit;
							}
						}
						t_msg = t_msg + "最近出貨單價：" + vcc_price+"/"+vcc_unit;
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
						q_msg($('#txtMount_' + b_seq), t_msg,10,5000);
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
											if(dec($('#txtLengthc_'+i).val())< dec(as[j].price)){
												error_productno+=$('#txtProductno_'+i).val()+' '+$('#txtProduct_'+i).val()+' 訂單單價小於報價單價!!\n'
											}
											break;
										}
									}else if(as[j].productno==$('#txtProductno_'+i).val()){
										product_in_quat=true;
										if(as[j].price>dec($('#txtLengthc_'+i).val())){
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
						//105/08/01 改抓發票客戶的資料
						var t_cust=$('#txtCustno').val();
						var t_invocust=t_cust;
						if (as[0] != undefined) {
							t_invocust=as[0].invocustno;
							var t_taxtype=as[0].taxtype;
							var taxtype='0',xy_taxtypetmp=q_getPara('sys.taxtype').split(',');
							for (var i=0;i<xy_taxtypetmp.length;i++){
								if(xy_taxtypetmp[i].split('@')[1]==t_taxtype)
									taxtype=xy_taxtypetmp[i].split('@')[0];
							}
							$('#cmbTaxtype').val(taxtype);
							$('#textConn').val(as[0].conn);
							$('#cmbConform').val(as[0].invomemo);
							
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
					/*case 'store2_store2':
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
							tr.innerHTML+="<td><input id='store2_txtStoreno_"+store2_row+"' type='text' class='txt c1' value='"+as[i].storeno2+"' disabled='disabled' /></td>";
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
						break;*/
					case 'flors':
						var as = _q_appendData("flors", "", true);
						if (as[0] != undefined) {
							q_tr('txtFloata',as[0].floata);
							sum();
						}
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
				/*if(t_name.substr(0,9)=='getStore_'){
					var n=t_name.substr(9);
					var as = _q_appendData('store', '', true);
					//106/02/09 預設寄庫倉庫＝出貨分店倉1、總店2、集團3、它分店倉4
					var t_storeno='',t_store='',t_rank=5;
					for (var i = 0; i < as.length; i++) {
						//出貨分店倉
						if($('#txtCustno').val()==as[i].noa){
							t_storeno=as[i].noa;
							t_store=as[i].store;
							break;	
						}
						//總店
						if($('#txtCustno').val().substr(0,5)==as[i].noa && t_rank>2){
							t_storeno=as[i].noa;
							t_store=as[i].store;
							t_rank=2;
						}
						//集團
						if($('#txtCustno').val().substr(0,5)!=as[i].noa.substr(0,5) && t_rank>3){
							t_storeno=as[i].noa;
							t_store=as[i].store;
							t_rank=3;
						}
						//它分店倉 只會取第一個其他分店
						if($('#txtCustno').val().substr(0,5)==as[i].noa.substr(0,5) && t_rank>4){
							t_storeno=as[i].noa;
							t_store=as[i].store;
							t_rank=4;
						}
					}
					
					if (t_storeno.length>0) {
						$('#txtSize_'+n).val(t_storeno);
						$('#txtUcolor_'+n).val(t_store);
					}
				}else */
				if (t_name.substr(0,13)=='keyin_pno_xy_'){
					var n=t_name.substr(13);
					var as = _q_appendData("view_quats", "", true);
					if (as[0] != undefined) {
						$('#txtLengthc_'+n).val(as[0].price);
						$('#txtHard_'+n).val(as[0].unit);
						$('#txtQuatno_'+n).val(as[0].noa);
						$('#txtNo3_'+n).val(as[0].no3);	
						sum();
						HiddenTreat();
					}
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
				//105/10/13 若訂購量小於最低訂購量時，不能存檔 //105/10/18 提示 可以存檔
				//105/10/26 修改狀態 數量0不刪除 //10/27 有出貨數量0不刪除
				var isvcc=false;
				if(q_cur==2){
					var t_where = "where=^^ ordeno='" + $('#txtNoa').val() + "' ^^";
					q_gt('view_vccs', t_where, 0, 0, 0, "istovcc", r_accy, 1);
					var as = _q_appendData("view_vccs", "", true);
					if (as[0] != undefined) {
						isvcc=true;
					}
				}
				
				var t_err = '',t_count=0;
				for(var k=0;k<q_bbsCount;k++){
					if(dec($('#txtMount_'+k).val())==0 && !isvcc){
						$('#btnMinus_'+k).click();
					}
					
					var t_sizea=dec($('#txtSizea_'+k).val());
					var t_m1=0;
					var t_m3=0;
					
					if(($('#cmbSource_'+k).val()=='0' || $('#cmbSource_'+k).val()=='1') && dec($('#txtMount_'+k).val())>0){
						$("#combZinc_"+k).children().each(function(){
							if($('#txtZinc_'+k).val()==$(this).text()){
								t_m1=$(this).val();
							}
							if($('#txtHard_'+k).val()==$(this).text()){
								t_m3=$(this).val();
							}
						});
						t_sizea=round(t_sizea*t_m1/t_m3,1);
						
						if(t_sizea>dec($('#txtLengthb_'+k).val())){
							t_err=t_err+$('#txtProductno_'+k).val()+"客單數量低於最低訂購量\n";
						}
					}
					if(!emp($('#txtProductno_'+k).val()) || !emp($('#txtProduct_'+k).val()) || !emp($('#txtSpec_'+k).val()) || dec($('#txtTotal'+k).val())>0)
						t_count++;
				}
				
				if (t_err.length > 0) {
					alert(t_err);
					//return;
				}
				
				if (t_count = 0) {
					alert('表身禁止空白!!')
					return;
				}
				
				//105/12/15寄庫沒有倉庫不能存檔
				t_err = '';
				for(var k=0;k<q_bbsCount;k++){
					if(!emp($('#txtProductno_'+k).val()) && ($('#cmbSource_' + k).val()=='1' || $('#cmbSource_' + k).val()=='2') && emp($('#txtSize_'+k).val())){
						t_err=t_err+$('#txtProductno_'+k).val();
						if($('#cmbSource_' + k).val()=='1')
							t_err=t_err+"寄庫倉空白\n";
						else
							t_err=t_err+"庫出倉空白\n";
					}
				}
				if (t_err.length > 0) {
					alert(t_err);
					return;
				}
				
				t_err = '';
				t_err = q_chkEmpField([['txtNoa', q_getMsg('lblNoa')], ['txtCustno', q_getMsg('lblCustno')], ['txtCno', q_getMsg('btnAcomp')], ['txtOdate', q_getMsg('lblOdate')]]);
				if (t_err.length > 0) {
					alert(t_err);
					return;
				}
				
				if(checkId($('#txtOdate').val())!=r_len){
					alert('日期格式錯誤!!');
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
				//106/02/08 判斷 客戶主檔 是否需附附採購單
				var isfranchisestore='false';
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
					isfranchisestore=as[0].isfranchisestore;
				}
				
				if(isfranchisestore=='true' && emp($('#txtCustorde').val())){
					alert('客戶需附採購單，請填寫客單編號!!');
					return;
				}
				
				if($('#cmbTrantype').val()=='直寄' && $('#txtMemo').val().substr(0,1)!='#'){
					$('#txtMemo').val('#'+$('#txtMemo').val());
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
						}).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
						});
						
						$('#txtLengthb_'+j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							unitchange(b_seq);
							$('#cmbSource_' + b_seq).change();
							pricecolor();
							
						});
						
						$('#txtMount_'+j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							$('#cmbSource_' + b_seq).change();
						});
						
						$('#combZinc_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							
							if($('#combZinc_'+b_seq).find("option:selected").text()!=''){
								$('#txtZinc_'+b_seq).val($('#combZinc_'+b_seq).find("option:selected").text());
							}
							
							$('#combZinc_'+b_seq)[0].selectedIndex=0;
							
							unitchange(b_seq);
							$('#cmbSource_' + b_seq).change();
							pricecolor();
						});
						
						$('#cmbSource_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							
							Lock();
							
							var t_max_unit='';
							var t_max_inmout=0;
							var t_unit=$('#txtUnit_'+b_seq).val();
							var t_inmount=0;
							var t_mount=dec($('#txtMount_'+b_seq).val());
											
							$("#combZinc_"+b_seq).children().each(function(){
								//if(t_max_inmout<dec($(this).val())){
								//106/08/09 調整 取最大單位 可以抓中單位 根據目前訂單最大數量取最大可換算單位
								if(t_max_inmout<dec($(this).val()) && t_mount>=dec($(this).val())){
									t_max_unit=$(this).text()
									t_max_inmout=dec($(this).val());
								}
								if(t_unit==$(this).text()){
									t_inmount=dec($(this).val());
								}
							});
							if(t_max_inmout==0){
								t_max_inmout=1;
								t_max_unit=t_unit;
							}
							
							if(t_max_unit!=t_unit && Math.floor(t_mount/t_max_inmout)>0){
								var t_m1=Math.floor(q_div(t_mount,t_max_inmout));
								var t_m2=q_sub(t_mount,(q_mul(Math.floor(q_div(t_mount,t_max_inmout)),t_max_inmout)));
								if($('#cmbSource_' + b_seq).val()=='0')
									$('#txtMemo_'+b_seq).val(t_m1+t_max_unit+(t_m2>0?('+'+t_m2+t_unit):''));
								else
									$('#txtMemo_'+b_seq).val($('#cmbSource_' + b_seq).find("option:selected").text()+'：'+t_m1+t_max_unit+(t_m2>0?('+'+t_m2+t_unit):''));
							}else{
								if($('#cmbSource_' + b_seq).val()!='0'){
									$('#txtMemo_'+b_seq).val($('#cmbSource_' + b_seq).find("option:selected").text()+'：'+t_mount+t_unit);
								}else{
									$('#txtMemo_'+b_seq).val('');
								}
							}
							if(($('#cmbSource_' + b_seq).val()=='1' || $('#cmbSource_' + b_seq).val()=='2') && emp($('#txtSize_'+b_seq).val())){
								//$('#txtSize_'+b_seq).val($('#txtCustno').val().substr(0,5)).change();
								//var t_where="where=^^noa like '"+$('#txtCustno').val().substr(0,5)+"%' ^^";
								//106/02/09 預設寄庫倉庫＝出貨分店倉、總店、集團、它分店倉
								var t_where="noa like '"+$('#txtCustno').val().substr(0,5)+"%'";
								t_where=t_where+" or ((select count(*) from cust where noa='"+$('#txtCustno').val()+"' and isnull(grpno,'')!='')>0 and noa like (select top 1 grpno from cust where noa='"+$('#txtCustno').val()+"')+'%')";
								t_where="where=^^"+t_where+"^^";
								q_gt('store', t_where, 0, 0, 0, "getStore_"+b_seq,r_accy,1);
								var n=b_seq;
								var as = _q_appendData('store', '', true);
								//106/02/09 預設寄庫倉庫＝出貨分店倉1、總店2、集團3、它分店倉4
								var t_storeno='',t_store='',t_rank=5;
								for (var i = 0; i < as.length; i++) {
									//出貨分店倉
									if($('#txtCustno').val()==as[i].noa){
										t_storeno=as[i].noa;
										t_store=as[i].store;
										break;	
									}
									//總店
									if($('#txtCustno').val().substr(0,5)==as[i].noa && t_rank>2){
										t_storeno=as[i].noa;
										t_store=as[i].store;
										t_rank=2;
									}
									//集團
									if($('#txtCustno').val().substr(0,5)!=as[i].noa.substr(0,5) && t_rank>3){
										t_storeno=as[i].noa;
										t_store=as[i].store;
										t_rank=3;
									}
									//它分店倉 只會取第一個其他分店
									if($('#txtCustno').val().substr(0,5)==as[i].noa.substr(0,5) && t_rank>4){
										t_storeno=as[i].noa;
										t_store=as[i].store;
										t_rank=4;
									}
								}
								
								if (t_storeno.length>0) {
									$('#txtSize_'+n).val(t_storeno);
									$('#txtUcolor_'+n).val(t_store);
								}
							}
							
							if($('#cmbSource_' + b_seq).val()!='0' && $('#cmbSource_' + b_seq).val()!='1'){
								//105/01/08 寄庫、寄出... 備註 直接為 寄庫、寄出...X件 
								/*
								if(!emp($('#txtMemo_'+b_seq).val()))
									$('#txtMemo_'+b_seq).val($('#cmbSource_' + b_seq).find("option:selected").text()+'：'+$('#txtMount_' + b_seq).val()+$('#txtUnit_' + b_seq).val()+','+$('#txtMemo_'+b_seq).val());
								else 
									$('#txtMemo_'+b_seq).val($('#cmbSource_' + b_seq).find("option:selected").text()+'：'+$('#txtMount_' + b_seq).val()+$('#txtUnit_' + b_seq).val());
								*/
								
								$('#txtPrice_'+b_seq).val(0);
							}else{
								/*$('#txtMemo_'+b_seq).val('');
								if($('#cmbSource_' + b_seq).val()=='1'){
									if(!emp($('#txtMemo_'+b_seq).val()))
										$('#txtMemo_'+b_seq).val($('#cmbSource_' + b_seq).find("option:selected").text()+'：'+$('#txtMount_' + b_seq).val()+$('#txtUnit_' + b_seq).val()+','+$('#txtMemo_'+b_seq).val());
									else 
										$('#txtMemo_'+b_seq).val($('#cmbSource_' + b_seq).find("option:selected").text()+'：'+$('#txtMount_' + b_seq).val()+$('#txtUnit_' + b_seq).val());
								}*/
								
								if(!emp($('#txtQuatno_'+b_seq).val()) && !emp($('#txtNo3_'+b_seq).val())){
									var t_where="where=^^noa='"+$('#txtQuatno_'+b_seq).val()+"' and no3='"+$('#txtNo3_'+b_seq).val()+"' ^^"
									q_gt('view_quats', t_where, 0, 0, 0, "keyin_pno_xy_"+b_seq);
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
											q_func('qtxt.query.keyin_pno_xy2_'+b_seq, 'cust_ucc_xy.txt,quatimport,' + t_where);
										}else {
											alert(q_getMsg('msgCustEmp'));
											$('#txtCustno').focus();
											$('#btnMinus_'+b_seq).click();
											return;
										}
									}
								}
							}
							
							if((q_cur==1 || q_cur==2) && ($('#cmbSource_'+b_seq).val()=='3' || $('#cmbSource_'+b_seq).val()=='4' || $('#cmbSource_'+b_seq).val()=='5')){
								//105/12/15 調整
								//$('#txtUnit_'+b_seq).val($('#txtZinc_'+b_seq).val());
								$('#txtMount_'+b_seq).val($('#txtLengthb_'+b_seq).val());
								$('#txtUnit_'+b_seq).removeAttr('disabled');
							}else{
								//$('#txtProductno_'+b_seq).change()
								//$('#txtUnit_'+b_seq).attr('disabled', 'disabled');
							}
							
							unitchange(b_seq);
							sum();
							
							//106/02/13 判斷寄庫量<訂購量
							if($('#cmbSource_'+b_seq).val()=='2'){
								if(!emp($('#txtCustno').val())){
									var t_datea=q_date();
									var t_custno=$('#txtCustno').val();
									var t_noa='#non';//修改排除該張出貨單
									var t_pno=$('#txtProductno_'+b_seq).val();
									q_func('qtxt.query.source2_'+b_seq, 'cust_ucc_xy.txt,btnstore2,' + encodeURI(t_custno)+';'+encodeURI(t_noa)+';'+encodeURI(t_datea)+';'+encodeURI(t_pno));
								}else{
									alert("請輸入客戶編號!!");
									$('#btnMinus_'+b_seq).click();
									Unlock();
								}
							}else{
								Unlock();
							}
						});

						$('#txtUnit_' + j).focusout(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							unitchange(b_seq);
							sum();
						});
						
						$('#txtPrice_' + j).focusout(function() {
							if(q_cur==1 || q_cur==2){
								$(this).val(round(dec($(this).val()),4));
								sum();
							}
						});
						$('#txtLengthb_' + j).focusout(function() {
							if (q_cur == 1 || q_cur == 2) {
								t_IdSeq = -1;
								q_bodyId($(this).attr('id'));
								b_seq = t_IdSeq;
								if (!emp($('#txtProductno_' + b_seq).val()) && dec($('#txtLengthb_'+b_seq).val())!=0) {
									var t_datea=q_date();
									var t_custno=$('#txtCustno').val();
									var t_noa=(q_cur==2?'#non':$('#txtNoa').val());//修改排除該張出貨單
									var t_pno=$('#txtProductno_'+b_seq).val();
									q_func('qtxt.query.lengthb', 'cust_ucc_xy.txt,btnstore2,' + encodeURI(t_custno)+';'+encodeURI(t_noa)+';'+encodeURI(t_datea)+';'+encodeURI(t_pno),r_accy,1);
									
									var as = _q_appendData("tmp0", "", true, true);
									for (var i = 0; i < as.length; i++) {
										if(dec(as[i].mount)==0 || as[i].productno!=$('#txtProductno_' + b_seq).val()){
											as.splice(i, 1);
											i--;
										}
									}
									if (as[0] != undefined) {
										if(dec(as[0].mount)!=0){
											t_msgs='預設客倉剩餘:'+as[0].mount;
										}
										if(dec(as[0].othmount)!=0){
											t_msgs=t_msgs+(t_msgs.length>0?'<br>':'')+'其他客倉剩餘:'+as[0].othmount;
										}
										
										q_msg($('#txtMount_' + b_seq), t_msgs,100,15000);
										
										if(dec(as[0].mount)!=0 && dec(as[0].mount)>=dec($('#txtMount_'+b_seq).val()))
											$('#cmbSource_'+b_seq).val('2').change();
										else
											$('#cmbSource_'+b_seq).val('0').change();
									}else{
										$('#cmbSource_'+b_seq).val('0').change();
									}
								}
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
						
						$('#btnOrdemount_' + j).click(function() {
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
							if(q_cur==1 || q_cur==2){
								if($('#txtClassa_'+b_seq).val().indexOf('印')>-1 || $('#txtClassa_'+b_seq).val().indexOf('便')>-1){
									$('#combClassa_' + b_seq).val($('#txtClassa_'+b_seq).val());
									$('#combClassa_' + b_seq).focusout();
								}else{
									$('#combClassa_' + b_seq).val('');
								}
							}
						});
						
						$('#combClassa_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2){
								$('#txtClassa_'+b_seq).val($('#combClassa_'+b_seq).val());
							}
						});
						
						$('#combClassa_' + j).bind('contextmenu',function(e) {
							e.preventDefault();
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2){
								$('#txtClassa_'+b_seq).val($('#combClassa_'+b_seq).val());
							}
							
							var t_class=$.trim($('#combClassa_'+b_seq).val());
							if(t_class.length>0 &&(q_cur==1 || q_cur==2)){
								var t_html='';
								if(t_class.indexOf('印')>-1 || t_class.indexOf('便')>-1){
									if(t_class.indexOf('印')>-1){
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
									if(t_class.indexOf('便')>-1){
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
									if(t_class.indexOf('印')>-1)
										$('#cost_txtCost0').focus();
									if(t_class.indexOf('便')>-1)
										$('#cost_txtWdate').focus();
										
									$('#btnClose_div_cost').click(function() {
										var t_memo='';
										
										if(t_class.indexOf('印')>-1){
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
													$('#txtProductno_'+(dec(b_seq)+1)).val('BF0000001');
													$('#txtProduct_'+(dec(b_seq)+1)).val('費用');
													$('#txtSpec_'+(dec(b_seq)+1)).val('版費');
													$('#txtUnit_'+(dec(b_seq)+1)).val('色');
													$('#txtMount_'+(dec(b_seq)+1)).val(1);
													$('#txtPrice_'+(dec(b_seq)+1)).val($('#cost_txtCost0').val());
													
													$('#txtZinc_'+(dec(b_seq)+1)).val('色');
													$('#txtLengthb_'+(dec(b_seq)+1)).val(1);
													$('#txtHard_'+(dec(b_seq)+1)).val('色');
													$('#txtLengthc_'+(dec(b_seq)+1)).val($('#cost_txtCost0').val());
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
													$('#txtProductno_'+((dec(b_seq)+t_iscost1)+1)).val('DM0000001');
													$('#txtProduct_'+((dec(b_seq)+t_iscost1)+1)).val('費用');
													$('#txtSpec_'+((dec(b_seq)+t_iscost1)+1)).val('刀模費');
													$('#txtUnit_'+((dec(b_seq)+t_iscost1)+1)).val('式');
													$('#txtMount_'+((dec(b_seq)+t_iscost1)+1)).val(1);
													$('#txtPrice_'+((dec(b_seq)+t_iscost1)+1)).val($('#cost_txtCost1').val());
													
													$('#txtZinc_'+(dec(b_seq)+1)).val('式');
													$('#txtLengthb_'+(dec(b_seq)+1)).val(1);
													$('#txtHard_'+(dec(b_seq)+1)).val('式');
													$('#txtLengthc_'+((dec(b_seq)+t_iscost1)+1)).val($('#cost_txtCost1').val());
													AutoNo2();
												}
												sum();
											}
										}
										
										//訂金
										if(t_class.indexOf('印')>-1){
											if($('#cost_txtDeposit').val()!='')
												t_memo=t_memo+(t_memo.length>0?' ':'')+'訂金：'+$('#cost_txtDeposit').val();
										}
										//工期,交貨日
										if($('#cost_txtWdate').val()!=''){
											if(t_class.indexOf('印')>-1){
												t_memo=t_memo+(t_memo.length>0?' ':'')+'工期：'+$('#cost_txtWdate').val();
											}
											if(t_class.indexOf('便')>-1){
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
							}
						});
						
						$('#txtSizea_'+j).focusin(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							var t_class=$.trim($('#combClassa_'+b_seq).val());
							if(!$('#div_cost').is(':hidden')){
								if(t_class.indexOf('印')>-1)
									$('#cost_txtCost0').focus();
								if(t_class.indexOf('便')>-1)
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
							
							$('#combGroupbno_'+b_seq)[0].selectedIndex=0;
						});
						
						$('#btnSpec_'+j).click(function() {
							//顯示規格
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
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
				pricecolor();
				HiddenTreat();
				ShowDownlbl();
				
				/*for (var i = 0; i < q_bbsCount; i++) {
					combzincchange(i);
				}*/
				combzincchange('ALL');
				
				$('.yellow').css('background-color','yellow');
				if (q_cur<1 && q_cur>2) {
					for (var j = 0; j < q_bbsCount; j++) {
						$('#txtDatea_'+j).datepicker('destroy');
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
				ShowDownlbl();
				
				//copy_field();
				
				$('#chkIsproj').attr('checked', true);
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val('AUTO');
				$('#txtCno').val(z_cno);
				$('#txtAcomp').val(z_acomp);
				$('#txtOdate').val(q_date());
				$('#txtCustno').focus();
				$('#txtVccno').val('');
				$('#combXyindate').val('');

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
				modi_chgcust_count=0;
				$('#combXyindate').val('');
				combzincchange('ALL');
				for (var i = 0; i < q_bbsCount; i++) {
					unitchange(i);
				}
				pricecolor();
				ShowDownlbl();
				//copy_field();
				$('#txtCustno').focus();
				$('.yellow').css('background-color','yellow');
				if (!emp($('#txtCustno').val())) {
					var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^";
					q_gt('custaddr', t_where, 0, 0, 0, "");
				}
				orde2vcc_modi=false;
				HiddenTreat();
				//105/05/03 已轉製令單,但又修改訂單的問題 只開放數量修改
				if(r_rank<"8" && q_cur==2){
					q_gt('view_cub', "where=^^ ordeno='" + $('#txtNoa').val() + "' ^^", 0, 0, 0, "istocub",r_accy,1);
					var as = _q_appendData("view_cub", "", true);
					
					q_gt('view_ordbs', "where=^^ ordeno='" + $('#txtNoa').val() + "' ^^", 0, 0, 0, "istoordb",r_accy,1);
					var as2 = _q_appendData("view_ordbs", "", true);
					
					if(as[0]!=undefined || as2[0]!=undefined){
						if(as[0]!=undefined){
							alert('訂單【'+$('#txtNoa').val()+'】已轉製令單【'+as[0].noa+'】!!');
						}else if(as2[0]!=undefined){
							alert('訂單【'+$('#txtNoa').val()+'】已轉請購單【'+as2[0].noa+'】!!');
						}
						$('#btnPlus').attr('disabled', 'disabled');
						for (var j = 0; j < q_bbsCount; j++) {
							$('#btnMinus_'+j).attr('disabled', 'disabled');
							$('#txtProductno_'+j).attr('disabled', 'disabled');
							$('#btnProduct_'+j).attr('disabled', 'disabled');
							$('#btnSpec_'+j).attr('disabled', 'disabled');
							$('#txtProduct_'+j).attr('disabled', 'disabled');
							$('#combGroupbno_'+j).attr('disabled', 'disabled');
							$('#combZinc_'+j).attr('disabled', 'disabled');
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
				as['comp'] = abbm2['nick'];

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
				pricecolor();
				HiddenTreat();
				ShowDownlbl();
				$('.yellow').css('background-color','yellow');
				
				var emp_productno=false;
				for (var j = 0; j < q_bbsCount; j++) {
					if (q_cur==1 || q_cur==2) {
						$('#combGroupbno_'+j).removeAttr('disabled');
						$('#combClassa_'+j).removeAttr('disabled');
						$('#combZinc_'+j).removeAttr('disabled');
					}else{
						$('#combGroupbno_'+j).attr('disabled', 'disabled');
						$('#combClassa_'+j).attr('disabled', 'disabled');
						$('#combZinc_'+j).attr('disabled', 'disabled');
					}
					
					if(emp($('#txtProductno_'+j).val()) && !emp($('#txtProduct_'+j).val()))
						emp_productno=true;
				}
				if(!emp($('#txtCustno').val())){//1050113
					//105/08/01
					t_where = " where=^^ noa='" + $('#txtCustno').val() + "'^^";
					q_gt('custm', t_where, 0, 0, 0, '', r_accy);
				}
				if(!emp($('#txtNoa').val()) && $('#txtNoa').val()!='AUTO' && !$('#chkEnda').prop('checked') && !$('#chkCancel').prop('checked')){//1051017
					var t_para = encodeURI($('#txtNoa').val());
					q_func('qtxt.query.ordecheckstk', 'cust_ucc_xy.txt,ordecheckstk,' + t_para);
				}
				$('#combXyindate').val('');
				$('#btnUpload').val('');
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
					$('#txtXydatea').datepicker('destroy');
					for (var j = 0; j < q_bbsCount; j++) {
						$('#combGroupbno_'+j).attr('disabled', 'disabled');
						$('#combClassa_'+j).attr('disabled', 'disabled');
						$('#combZinc_'+j).attr('disabled', 'disabled');
					}
					$('#checkCopy').removeAttr('disabled');
					$('#btnUpload').attr('disabled', 'disabled');
					$('#btnQuat').attr('disabled', 'disabled');
					if($('#cmbStype').val()!='3'){
						$('#btnOrdei').attr('disabled', 'disabled');
					}else{
						$('#btnOrdei').removeAttr('disabled');
					}
					
				} else {
					$('#checkCopy').attr('disabled', 'disabled');
					$('#btnOrdei').attr('disabled', 'disabled');
					$('#combAddr').removeAttr('disabled');
					$('#btnOrdetoVcc').attr('disabled', 'disabled');
					$('#txtOdate').datepicker();
					$('#txtXydatea').removeClass('hasDatepicker');
					$('#txtXydatea').datepicker();
					for (var j = 0; j < q_bbsCount; j++) {
						$('#combGroupbno_'+j).removeAttr('disabled');
						$('#combClassa_'+j).removeAttr('disabled');
						$('#combZinc_'+j).removeAttr('disabled');
					}
					$('#btnUpload').removeAttr('disabled', 'disabled');
					$('#btnQuat').removeAttr('disabled');
					$('#btnOrdei').attr('disabled', 'disabled');
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
				
				if (q_cur == 1 || q_cur == 2)
                    $('#btnApv').attr('disabled', 'disabled');
                else
                    $('#btnApv').removeAttr('disabled');
                $('#btnUpload').val('');
			}
			
			function AutoNo2(){
				if(q_cur==1 || q_cur==2){
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
			}
			
			function HiddenTreat() {
				/*if (r_rank<9){
					$('.bonus').hide();
				}*/
				
				for (var j = 0; j < q_bbsCount; j++) {
					if(q_cur==1 || q_cur==2){
						if(!emp($('#txtQuatno_'+j).val()) || !q_authRun(7)){
							//$('#txtProductno_'+j).attr('disabled', 'disabled'); //1050127 開放修改 輸入相同產品 
							//$('#btnProduct_'+j).attr('disabled', 'disabled');
							$('#btnSpec_'+j).attr('disabled', 'disabled');
							$('#txtProduct_'+j).attr('disabled', 'disabled');
							$('#txtSpec_'+j).attr('disabled', 'disabled');
							$('#txtClassa_'+j).attr('disabled', 'disabled');
							$('#txtSizea_'+j).attr('disabled', 'disabled');
							$('#txtDime_'+j).attr('disabled', 'disabled');
							//$('#txtUnit_'+j).attr('disabled', 'disabled');
							//$('#txtPrice_'+j).attr('disabled', 'disabled');
							$('#combGroupbno_'+j).attr('disabled', 'disabled');
							$('#combClassa_'+j).attr('disabled', 'disabled');
						}else{
							//$('#txtProductno_'+j).removeAttr('disabled');
							//$('#btnProduct_'+j).removeAttr('disabled');
							$('#btnSpec_'+j).removeAttr('disabled');
							$('#txtProduct_'+j).removeAttr('disabled');
							$('#txtSpec_'+j).removeAttr('disabled');
							$('#txtClassa_'+j).removeAttr('disabled');
							$('#txtSizea_'+j).removeAttr('disabled');
							$('#txtDime_'+j).removeAttr('disabled');
							//$('#txtUnit_'+j).removeAttr('disabled');
							//$('#txtPrice_'+j).removeAttr('disabled');
							$('#combGroupbno_'+j).removeAttr('disabled');
							$('#combClassa_'+j).removeAttr('disabled');
						}
					}else{
						$('#btnSpec_'+j).attr('disabled', 'disabled');
						$('#txtProduct_'+j).attr('disabled', 'disabled');
						$('#txtSpec_'+j).attr('disabled', 'disabled');
						$('#txtClassa_'+j).attr('disabled', 'disabled');
						$('#txtSizea_'+j).attr('disabled', 'disabled');
						$('#txtDime_'+j).attr('disabled', 'disabled');
						$('#combGroupbno_'+j).attr('disabled', 'disabled');
						$('#combClassa_'+j).attr('disabled', 'disabled');
					}
					
					if(orde2vcc57 && q_cur==2 && r_rank<'8'){
						$('#btnPlus').attr('disabled', 'disabled');
						for (var j = 0; j < q_bbsCount; j++) {
							$('#btnMinus_'+j).attr('disabled', 'disabled');
							$('#txtProductno_'+j).attr('disabled', 'disabled');
							$('#btnProduct_'+j).attr('disabled', 'disabled');
							$('#btnSpec_'+j).attr('disabled', 'disabled');
							$('#txtProduct_'+j).attr('disabled', 'disabled');
							$('#combGroupbno_'+j).attr('disabled', 'disabled');
							$('#txtSpec_'+j).attr('disabled', 'disabled');
							$('#btnSpec_'+j).attr('disabled', 'disabled');
							$('#txtClassa_'+j).attr('disabled', 'disabled');
							$('#combClassa_'+j).attr('disabled', 'disabled');
							$('#txtSizea_'+j).attr('disabled', 'disabled');
							$('#txtDime_'+j).attr('disabled', 'disabled');
							//$('#txtUnit_'+j).attr('disabled', 'disabled');
							//$('#txtPrice_'+j).attr('disabled', 'disabled');
							$('#cmbSource_'+j).attr('disabled', 'disabled');
							//$('#txtDatea_'+j).attr('disabled', 'disabled');
							$('#txtMemo_'+j).attr('disabled', 'disabled');
						}
					}
					
					//105/10/18 訂單 若為 公關 樣品 換貨 倉庫=換貨倉 且庫存單位可以修改
					if((q_cur==1 || q_cur==2) && ($('#cmbSource_'+j).val()=='3' || $('#cmbSource_'+j).val()=='4' || $('#cmbSource_'+j).val()=='5')){
						$('#txtUnit_'+j).removeAttr('disabled');
					}else{
						$('#txtUnit_'+j).attr('disabled', 'disabled');
					}
					
					//copy_field();
				}
				
				/*if(emp($('#txtOrdbno').val()) && (q_cur<1 || q_cur>2)){
					$('#lblOrde2ordb').show();
					$('#lblOrdbno').hide();
				}else{
					$('#lblOrde2ordb').hide();
					$('#lblOrdbno').show();
				}*/
				
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
							if(!(fbbs[i]=='txtLengthb'|| fbbs[i]=='txtMemo' || fbbs[i]=='txtDatea'))
								$('#'+fbbs[i]+'_'+j).attr('disabled', 'disabled');
						}
						$('#btnProduct_'+j).attr('disabled', 'disabled');
						$('#combGroupbno_'+j).attr('disabled', 'disabled');
						$('#combClassa_'+j).attr('disabled', 'disabled');
						$('#btnSpec_'+j).attr('disabled', 'disabled');
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
				q_gt('view_vccs', "where=^^ ordeno='"+$('#txtNoa').val()+"' ^^", 0, 0, 0, "btnDel_orde",r_accy,1);
				var as = _q_appendData("view_vccs", "", true);
				if (as[0] != undefined) {
					alert('訂單已出貨【'+as[0].noa+'】禁止刪除!!');
					return;
				}
				
				_btnDele();
			}

			function btnCancel() {
				_btnCancel();
				pricecolor();
				HiddenTreat();
			}
			
			var modi_chgcust_count=0;
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
							
							//106/06/19 功能重新開放
							//106/08/09 修改狀態 同總店 不刪除 給提示
							var t_minusbbs=true;
							if(q_cur==2 && abbm[q_recno] != undefined && modi_chgcust_count==0){
								if(abbm[q_recno].custno.substr(0,5)==$('#txtCustno').val().substr(0,5)){
									t_minusbbs=false;
									alert('請確認報價明細是否正確!!');
									modi_chgcust_count=1;
								}
							}
							if(t_minusbbs){
								for(var j=0 ;j<q_bbsCount;j++){
									$('#btnMinus_'+j).click();
								}
							}
							
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
						var t_n=b_seq;
						if(!emp($('#txtProductno_'+t_n).val())){
							var t_grpno=''; //客戶集團編號
							var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^";
							q_gt('cust', t_where, 0, 0, 0, "getcustgrpno", r_accy, 1);
							var as = _q_appendData("cust", "", true);
							if (as[0] != undefined) {
								t_grpno=as[0].grpno;
							}
							//105/07/21集團本身底下子公司
							var t_where = "where=^^ grpno='"+$('#txtCustno').val()+"' ^^";
							q_gt('cust', t_where, 0, 0, 0, "getcustgrpno2", r_accy, 1);
							var as2 = _q_appendData("cust", "", true);
							var isexists=false;
							for ( i = 0; i < as2.length; i++) {
								if($('#txtProductno_' + t_n).val().substr(0,5)==as2[i].noa.substr(0,5)){
									isexists=true;
								}
							}
							
							if($('#txtProductno_' + t_n).val().indexOf('-')>0){
								if($('#txtProductno_' + t_n).val().substr(0,5)!=$('#txtCustno').val().substr(0,5)
								&&  $('#txtProductno_' + t_n).val().substr(0,5)!=t_grpno
								&& !isexists	){
									$('#btnMinus_'+t_n).click();
									break;
								}
							}
														
							var t_custno = trim($('#txtCustno').val());
							var t_odate = trim($('#txtOdate').val());
							var t_pno = trim($('#txtProductno_'+t_n).val());
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
								q_func('qtxt.query.keyin_pno_xy_'+t_n, 'cust_ucc_xy.txt,quatimport,' + t_where);
								
							}else {
								alert(q_getMsg('msgCustEmp'));
								$('#txtCustno').focus();
								$('#btnMinus_'+t_n).click();
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
				
				//更新PO單的未交量
				if(!emp($('#txtNoa').val()) && $('#txtNoa').val()!='AUTO'){
					var t_paras = $('#txtNoa').val();
					q_func('qtxt.query.contenda', 'cust_ucc_xy.txt,contenda,' + t_paras);
				}
			}
			
			function q_funcPost(t_func, result) {
				switch(t_func) {
					case 'qtxt.query.ordecheckstk':
						var as = _q_appendData("tmp0", "", true, true);
						var t_memo2='';
						for(var i = 0; i < as.length; i++){
							if(as[i].stkmemo.length>0){
								t_memo2=t_memo2+(t_memo2.length>0?',':'')+'項次:'+as[i].no2+' '+as[i].stkmemo;
							}
						}
						$('#textMemo2').val(t_memo2);
						break;
					case 'qtxt.query.contenda':
						var as = _q_appendData("tmp0", "", true, true);
						break;
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
						
						q_gridAddRow(bbsHtm, 'tbbs', 'txtProductno,txtProduct,txtSpec,txtSizea,txtDime,txtZinc,txtUnit,txtPrice,txtHard,txtLengthc,txtQuatno,txtNo3,txtClassa,txtClass'
						, as.length, as, 'productno,product,spec,sizea,dime,ounit,uunit,price,unit,price,noa,no3,classa,class', 'txtProductno,txtProduct,txtSpec');
						
						combzincchange('ALL');
						for (var i = 0; i < q_bbsCount; i++) {
							unitchange(i);
						}
						pricecolor();
						$('#txtMount_'+t_n).focus();
						AutoNo2();
						bbsAssign();
						break;
					case 'qtxt.query.btnOk_xy':
						var as = _q_appendData("tmp0", "", true, true);
						var error_productno='';
						var product_in_quat=false;
						for (var i = 0; i < q_bbsCount; i++) {
							if(!emp($('#txtProductno_'+i).val()) && $('#cmbSource_'+i).val()!='2' && $('#cmbSource_'+i).val()!='3' && $('#cmbSource_'+i).val()!='4' && $('#txtQuatno_'+i).val().substr(0,1)!='C' ){
								product_in_quat=false;
								for (var j = 0; j < as.length; j++) {
									if(!emp($('#txtQuatno_'+i).val()) && !emp($('#txtNo3_'+i).val())){
										if($('#txtQuatno_'+i).val()==as[j].noa && $('#txtNo3_'+i).val()==as[j].no3 && as[j].productno==$('#txtProductno_'+i).val()){
											product_in_quat=true;
											if(dec($('#txtLengthc_'+i).val())< dec(as[j].price)){
												error_productno+=$('#txtProductno_'+i).val()+' '+$('#txtProduct_'+i).val()+' 訂單單價小於報價單價!!\n'
											}
											break;
										}else if ($('#txtQuatno_'+i).val()==as[j].noa && $('#txtNo3_'+i).val()==as[j].no3 && as[j].productno!=$('#txtProductno_'+i).val()){
											error_productno+=$('#txtProductno_'+i).val()+' '+$('#txtProduct_'+i).val()+' 關聯報價單錯誤請重新輸入品項或匯入!!\n'
										}
									}else if(as[j].productno==$('#txtProductno_'+i).val()){
										product_in_quat=true;
										if(dec(as[j].price)>dec($('#txtLengthc_'+i).val())){
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
							t_msg = t_msg + "最近報價單價：" + dec(as[0].price) + "/"+as[0].unit+"<BR>";
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
                        $('#btnOrdetoVcc').removeAttr('disabled');
                        break;
					case 'qtxt.query.btnstore2':
						var as = _q_appendData("tmp0", "", true, true);
						for (var i = 0; i < as.length; i++) {
							if(dec(as[i].mount)==0){
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
							tr.innerHTML+="<td><input id='store2_txtStoreno_"+store2_row+"' type='text' class='txt c1' value='"+as[i].storeno2+"' disabled='disabled' /></td>";
							tr.innerHTML+="<td><input id='store2_txtStore_"+store2_row+"' type='text' class='txt c1' value='"+as[i].store2+"' disabled='disabled' /></td>";
							tr.innerHTML+="<td><input id='store2_txtMount_"+store2_row+"' type='text' class='txt c1 num' value='"+dec(as[i].mount)+"' disabled='disabled'/></td>";
							tr.innerHTML+="<td><input id='store2_txtOthmount_"+store2_row+"' type='text' class='txt c1 num' value='"+dec(as[i].othmount)+"' disabled='disabled'/></td>";
							tr.innerHTML+="<td><input id='store2_txtStkmount_"+store2_row+"' type='text' class='txt c1 num' value='"+dec(as[i].stkmount)+"' disabled='disabled'/></td>";
							tr.innerHTML+="<td><input id='store2_txtUnit_"+store2_row+"' type='text' class='txt c1' value='"+as[i].unit+"' disabled='disabled'/></td>";
							tr.innerHTML+="<td><input id='store2_txtTotal_"+store2_row+"' type='text' class='txt c1 num' value='"+dec(as[i].total)+"' disabled='disabled'/></td>";
							
							var tmp = document.getElementById("store2_close");
							tmp.parentNode.insertBefore(tr,tmp);
							store2_row++;
						}
						$('#div_store2').css('top', $('#btnStore2').offset().top+25);
						if($('#btnStore2').offset().left-parseInt($('#div_store2').css('width'))-5>0)
							$('#div_store2').css('left', $('#btnStore2').offset().left-parseInt($('#div_store2').css('width'))-5);
						else
							$('#div_store2').css('left', 0);
						$('#div_store2').show();
						break;
					default:
						break;
				}
				
				if(t_func.substr(0,24)=='qtxt.query.keyin_pno_xy_'){
					//case 'qtxt.query.keyin_pno_xy':
						var t_n=replaceAll(t_func,'qtxt.query.keyin_pno_xy_','')
						var as = _q_appendData("tmp0", "", true, true);
						
						if(!pno_keyin_apop){
							$('#btnMinus_'+t_n).click();
							if (as[0] != undefined) {
								$('#txtProductno_'+t_n).val(as[0].productno);
								$('#txtProduct_'+t_n).val(as[0].product);
								$('#txtSpec_'+t_n).val(as[0].spec);
								$('#txtSizea_'+t_n).val(as[0].sizea);
								$('#txtDime_'+t_n).val(as[0].dime);
								$('#txtZinc_'+t_n).val(as[0].ounit);
								$('#txtUnit_'+t_n).val(as[0].uunit);
								$('#txtPrice_'+t_n).val(as[0].price);
								$('#txtHard_'+t_n).val(as[0].unit);
								$('#txtLengthc_'+t_n).val(as[0].price);
								//$('#txtLengthb_'+t_n).val(as[0].mount);
								//$('#txtMount_'+t_n).val(as[0].mount);
								$('#txtQuatno_'+t_n).val(as[0].noa);
								$('#txtNo3_'+t_n).val(as[0].no3);
								$('#txtClassa_'+t_n).val(as[0].classa);
								$('#txtClass_'+t_n).val(as[0].class);
								
								combzincchange(t_n);
								unitchange(t_n);
							}
							pricecolor();
							HiddenTreat();
							AutoNo2();
						}else{
							pno_keyin_apop=true;
						}
				}else if (t_func.substr(0,25)=='qtxt.query.keyin_pno_xy2_'){
					var t_n=replaceAll(t_func,'qtxt.query.keyin_pno_xy2_','')
					var as = _q_appendData("tmp0", "", true, true);
					if (as[0] != undefined) {
						$('#txtHard_'+t_n).val(as[0].unit);
						$('#txtUnit_'+t_n).val(as[0].uunit);
						$('#txtPrice_'+t_n).val(as[0].price);
						$('#txtLengthc_'+t_n).val(as[0].price);
						$('#txtQuatno_'+t_n).val(as[0].noa);
						$('#txtNo3_'+t_n).val(as[0].no3);
						combzincchange(t_n);
						unitchange(t_n);
						HiddenTreat();	
					}
					pricecolor();
				}else if (t_func.substr(0,19)=='qtxt.query.source2_'){
					var t_n=replaceAll(t_func,'qtxt.query.source2_','')
					var as = _q_appendData("tmp0", "", true, true);
					for (var i = 0; i < as.length; i++) {
						if(dec(as[i].mount)==0 || as[i].productno!=$('#txtProductno_' + t_n).val()){
							as.splice(i, 1);
							i--;
						}
					}
					if (as[0] != undefined) {
						var smount=0;
						for (var i = 0; i < as.length; i++) {
							if($('#txtSize_'+t_n).val()==as[i].storeno2){
								smount=as[i].mount;
								break;
							}	
						}
						if(smount<dec($('#txtMount_'+t_n).val())){
							alert('請先新增寄庫!!');
							//$('#cmbSource_'+t_n).val('0');
							//$('#cmbSource_'+t_n).change();
						}
					}else{
						alert('請先新增寄庫!!');
						//$('#cmbSource_'+t_n).val('0');
						//$('#cmbSource_'+t_n).change();
					}
					Unlock();
				}
				
			}
			
			function ShowDownlbl() {				
				$('#lblDownload').text('').hide();
				if(!emp($('#txtGtime').val()))
					$('#lblDownload').text('下載').show();
			}
			
			function combzincchange(i){
				if(q_cur==1 || q_cur==2){
					if(i=='ALL'){
						var t_where = "1=0";
						for (var j = 0; j < q_bbsCount; j++) {
							$('#combZinc_'+j).text('');
							if(!emp($('#txtProductno_'+j).val())){
								t_where=t_where+" or noa='"+$('#txtProductno_'+j).val()+"'";
							}
						}
						t_where="where=^^"+t_where+"^^";
						q_gt('pack2s', t_where, 0, 0, 0, "getpack2s", r_accy, 1);
						var as = _q_appendData("pack2s", "", true);
						for (var j = 0; j < q_bbsCount; j++) {
							if(!emp($('#txtProductno_'+j).val())){
								var t_unit='';
								for(var k=0;k<as.length;k++){
									if($('#txtProductno_'+j).val()==as[k].noa && as[k].pack.length>0 && t_unit.indexOf(as[k].pack)==-1){
										t_unit=t_unit+(t_unit.length>0 && as[k].pack.length>0?',':'')+(as[k].inmount+'@'+as[k].pack);
									}
								}
								if(t_unit.length>0)
									q_cmbParse("combZinc_"+j,','+t_unit);
							}
						}
					}else{
						$('#combZinc_'+i).text('');
						if(!emp($('#txtProductno_'+i).val())){
							var t_where = "where=^^noa='"+$('#txtProductno_'+i).val()+"'^^";
							var t_unit='';
							q_gt('pack2s', t_where, 0, 0, 0, "getpack2s", r_accy, 1);
							var as = _q_appendData("pack2s", "", true);
							for(var j=0;j<as.length;j++){
								if(as[j].pack.length>0 && t_unit.indexOf(as[j].pack)==-1){
									t_unit=t_unit+(t_unit.length>0 && as[j].pack.length>0?',':'')+(as[j].inmount+'@'+as[j].pack);
								}
							}
							if(t_unit.length>0)
								q_cmbParse("combZinc_"+i,','+t_unit);
						}
					}
				}
			}
			
			function unitchange(i){
				if(q_cur==1 || q_cur==2){
					if(!emp($('#txtProductno_'+i).val())){
						var t_lengthb=dec($('#txtLengthb_'+i).val());
						var t_lengthc=dec($('#txtLengthc_'+i).val());
						var t_unit=$('#txtUnit_'+i).val();
						var t_m1=0;
						var t_m2=0;
						var t_m3=0;
						
						$("#combZinc_"+i).children().each(function(){
							if($('#txtZinc_'+i).val()==$(this).text()){
								t_m1=$(this).val();
							}
							if($('#txtUnit_'+i).val()==$(this).text()){
								t_m2=$(this).val();
							}
							if($('#txtHard_'+i).val()==$(this).text()){
								t_m3=$(this).val();
							}
						});
						
						t_unit=t_unit.toUpperCase();
						
						if(t_m2!=0){
							var t_f1=Math.floor(t_lengthb*t_m1/t_m2);
							var t_c1=Math.ceil(t_lengthb*t_m1/t_m2);
							
							if(t_f1!=t_c1 && t_unit!='KG' && t_unit!='令'){ //105/10/04 公斤排除 //105/12/12 增加令
								$('#txtZinc_'+i).val('');
								$('#txtLengthb_'+i).val('');
								$('#txtMount_'+i).val(0);
								$('#txtPrice_'+i).val(0);
								sum();
								alert('數量錯誤，請確認單位是否正確!!');
								return;
							}	
							if(t_unit!='KG' && t_unit!='令'){
								$('#txtMount_'+i).val(round(t_lengthb*t_m1/t_m2,0));
							}else{
								$('#txtMount_'+i).val(round(t_lengthb*t_m1/t_m2,2));
							}
							
						}else{
							$('#txtMount_'+i).val(0);
						}
						
						if(t_m3!=0 && ($('#cmbSource_'+i).val()=='1' || $('#cmbSource_'+i).val()=='0')){
							$('#txtPrice_'+i).val(round(t_lengthc*t_m2/t_m3,4));
						}else{
							$('#txtPrice_'+i).val(0);
						}
					}
					sum();
				}
			}
			
			function pricecolor(){
				for (var i = 0; i < q_bbsCount; i++) {
					var t_price=dec($('#txtPrice_'+i).val());
					var t_lengthc=dec($('#txtLengthc_'+i).val());
					if(t_lengthc!=t_price){
						$('#txtPrice_'+i).css('color','red');
					}
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
			#q_acDiv {
                white-space: nowrap;
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
		
		<div id="div_store2" style="position:absolute; top:300px; left:400px; display:none; width:1120px; background-color: #CDFFCE; border: 5px solid gray;">
			<table id="table_store2" style="width:100%;" border="1" cellpadding='2'  cellspacing='0'>
				<tr id='store2_top'>
					<td style="background-color: #f8d463;width: 130px;" align="center">品號</td>
					<td style="background-color: #f8d463;width: 150px;" align="center">品名</td>
					<td style="background-color: #f8d463;width: 200px;" align="center">規格</td>
					<td style="background-color: #f8d463;width: 100px;" align="center">客倉編號</td>
					<td style="background-color: #f8d463;width: 100px;" align="center">客倉名稱</td>
					<td style="background-color: #f8d463;width: 100px;" align="center">客倉數量</td>
					<td style="background-color: #f8d463;width: 100px;" align="center">其它客倉量</td>
					<td style="background-color: #f8d463;width: 100px;" align="center">實體倉總量</td>
					<td style="background-color: #f8d463;width: 40px;" align="center">庫存單位</td>
					<td style="background-color: #f8d463;width: 100px;" align="center">合計數量</td>
				</tr>
				<tr id='store2_close'>
					<td align="center" colspan='10'>
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
						<td align="center" style="width:25%"><a id='vewOdate'> </a></td>
						<td align="center" style="width:25%"><a id='vewNoa'> </a></td>
						<td align="center" style="width:40%"><a id='vewNick_xy'>客戶簡稱</a></td>
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
					<tr style="height: 0px">
						<td style="width: 128px;"> </td>
						<td style="width: 88px;"> </td>
						<td style="width: 108px;"> </td>
						<td style="width: 108px;"> </td>
						<td style="width: 108px;"> </td>
						<td style="width: 108px;"> </td>
						<td style="width: 108px;"> </td>
						<td style="width: 108px;"> </td>
					</tr>
					<tr>
						<td>
							<input id="checkCopy" type="checkbox" style="float:left;"/>
							<a id='lblCopy' class="lbl" style="float:left;"> </a>
							<span> </span><a id='lblOdate' class="lbl"> </a>
						</td>
						<td><input id="txtOdate" type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblMon' class="lbl"> </a></td>
						<td><input id="txtMon" type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblStype' class="lbl"> </a></td>
						<td><select id="cmbStype" class="txt c1"> </select></td>
						<td><span> </span><a id='lblNoa' class="lbl"> </a></td>
						<td><input id="txtNoa" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span>
							<a id="lblAcomp" class="lbl btn"> </a>
							<a id="lblAcompx" class="lbl btn" style="display: none;"> </a>
						</td>
						<td><input id="txtCno" type="text" class="txt c1"/></td>
						<td colspan="2"><input id="txtAcomp" type="text" class="txt c1"/></td>
						<td ><span> </span><a id='lblContract' class="lbl"> </a></td>
						<td colspan="2"><input id="txtContract" type="text" class="txt c1"/></td>
						<td align="center"><input id="btnOrdei" type="button" /></td>
						<!--105/06/14沒使用暫時拿掉<input id="btnOrdem" type="button"/>-->
					</tr>
					<tr>
						<td>
							<span> </span>
							<a id="lblCust" class="lbl btn"> </a>
							<a id="lblCustx" class="lbl btn" style="display: none;"> </a>
							<input class="btn" id="btnPlusCust" type="button" value='+' style="font-weight: bold;float: right;" />
						</td>
						<td><input id="txtCustno" type="text" class="txt c1"/></td>
						<td colspan="2"><input id="txtComp" type="text" class="txt c1"/>
							<input id="txtNick" type="hidden" class="txt c1"/>
						</td>
						<td><span> </span><a id='lblPaytype' class="lbl"> </a></td>
						<td><input id="txtPaytype" type="text" class="txt c1"/></td>
						<td>
							<select id="combPaytype" class="txt c1" onchange='combPaytype_chg()' > </select>
						</td>
						<td align="center"><input id="btnCredit" type="button" value='' /></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblTel' class="lbl"> </a></td>
						<td colspan='3'><input id="txtTel" type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblFax' class="lbl"> </a></td>
						<td colspan="2"><input id="txtFax" type="text" class="txt c1" /></td>
						<td align="center"><input id="btnQuat" type="button" value='' /></td>
					</tr>
					<tr>
						<td><span> </span><a class="lbl">郵遞區號</a></td>
						<td><input id="txtPost" type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblAddr' class="lbl"> </a></td>
						<td colspan='3'><input id="txtAddr" type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblXydatea' class="lbl">預交日期</a></td>
						<td><input id="txtXydatea" type="text" class="txt c1"/></td>
						<!--<td><span> </span>
							<a id='lblOrdbno' class="lbl"> </a>
							<a id='lblOrde2ordb' class="lbl btn"> </a>
						</td>
						<td><input id="txtOrdbno" type="text" class="txt c1"/></td>-->
					</tr>
					<tr>
						<td><span> </span><a class="lbl">指送區號</a></td>
						<td><input id="txtPost2" type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblAddr2' class="lbl"> </a></td>
						<td colspan='3'>
							<input id="txtAddr2" type="text" class="txt c1" style="width: 302px;"/>
							<select id="combAddr" style="width: 20px" onchange='combAddr_chg()'> </select>
						</td>
						<td><input id="btnAddr2" type="button" value='...' style="width: 30px;height: 21px" /></td>
						<!--<td>
							<span> </span><a id='lblOrdcno' class="lbl"> </a>
							<input id="txtOrdcno" type="text" class="txt c1"/>
						</td>-->
						<td align="center">
							<select id="combXyindate" class="txt c1" style="font-size: medium;"> </select>
							<!--<input id="btnCont" type="button" value="PO匯入"/>-->
						</td>
					</tr>
					<tr>
						<td><span> </span><a id='lblTrantype' class="lbl"> </a></td>
						<td colspan="2"><select id="cmbTrantype" class="txt c1" name="D1" > </select></td>
						<td><span> </span><a id="lblSales" class="lbl btn"> </a></td>
						<td colspan="2">
							<input id="txtSalesno" type="text" class="txt c2"/>
							<input id="txtSales" type="text" class="txt c3"/>
						</td>
						<td><span> </span><a id='lblCustorde' class="lbl"> </a></td>
						<td><input id="txtCustorde" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblMoney' class="lbl"> </a></td>
						<td colspan='2'><input id="txtMoney" type="text" class="txt c1" style="text-align: center;"/></td>
						<td><span> </span><a id='lblTax' class="lbl"> </a></td>
						<td><input id="txtTax" type="text" class="txt num c1"/></td>
						<td><select id="cmbTaxtype" class="txt c1" onchange='sum()' > </select></td>
						<td><span> </span><a id='lblTotal' class="lbl"> </a></td>
						<td><input id="txtTotal" type="text" class="txt num c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblFloata' class="lbl"> </a></td>
						<td><select id="cmbCoin" class="txt c1" onchange='coin_chg()'> </select></td>
						<td><input id="txtFloata" type="text" class="txt num c1" /></td>
						<td><span> </span><a id='lblTotalus' class="lbl"> </a></td>
						<td colspan='2'><input id="txtTotalus" type="text" class="txt num c1"/></td>
						<td><input style="float: right;" class="btn" id="btnOrdetoVcc" type="button" value='轉出貨單' /> </td>
						<td><input id="txtVccno" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblWorker' class="lbl"> </a></td>
						<td><input id="txtWorker" type="text" class="txt c1" /></td>
						<td><input id="txtWorker2" type="text" class="txt c1" /></td>
						<td><span> </span><a class="lbl">訂金</a></td>
						<td colspan='2'><input id="txtWeight" type="text" class="txt num c1" /></td>
						<td><input id="btnStore2" type="button" style="float: right;" value="寄庫顯示"/></td>
						<td>
							<input id="btnApv" type="button" style="float: left;" value="核可"/>
							<input id="txtApv" type="text" class="txt c1" style="width: 50px;"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a class="lbl">發票開立</a></td>
						<td colspan="2"><select id="cmbConform" class="txt c1"> </select></td>
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
						<td><input id="btnCont2" type="button" style="float: float;" value="客戶備貨"/></td>
					</tr>
					<tr>
						<td><span> </span><a class="lbl">發票資訊</a></td>
						<td colspan="5"><input id="textInvomemo" type="text" class="txt c1" /></td>
						<td><span> </span><a class="lbl">聯絡人員</a></td>
						<td><input id="textConn" type="text" class="txt c1" /></td>
					</tr>
						<td><span> </span><a  id="lblUpload_xy" class="lbl">PO上傳</a></td>
						<td colspan="3">
							<input type="file" id="btnUpload" value="選擇檔案" style="width: 70%;"/>
							<input id="txtGdate" type="hidden" class="txt c1"/><!--原檔名-->
							<input id="txtGtime" type="hidden" class="txt c1"/><!--上傳檔名-->
							<a id="lblDownload" class='lbl btn'> </a>
						</td>
						<td><span> </span><a id='lblMemo2_xy' class='lbl'>庫存不足</a></td>
						<td colspan='3'><input id="textMemo2" type="text" class="txt c1" /></td>
						<td style="display: none;"><div style="width:100%;" id="FileList"> </div></td>
					<tr>
						<td><span> </span><a id='lblMemo' class='lbl'> </a></td>
						<td colspan='7'>
							<textarea id="txtMemo" cols="10" rows="5" style="width: 99%;height: 50px;"> </textarea>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class='dbbs' style="width: 2950px;">
			<table id="tbbs" class='tbbs' border="1" cellpadding='2' cellspacing='1'>
				<tr style='color:White; background:#003366;' >
					<td align="center" style="width:40px;"><input class="btn" id="btnPlus" type="button" value='＋' style="font-weight: bold;" /></td>
					<td align="center" style="width:40px;"><a>項次</a></td>
					<td align="center" style="width:120px;"><a id='lblProductno'> </a></td>
					<td align="center" style="width:130px;"><a id='lblProduct_s'> </a></td>
					<td align="center" style="width:85px;"><a>版別</a></td>
					<td align="center" style="width:115px;"><a>版本</a></td>
					<td align="center" style="width:300px;"><a>規格</a></td>
					<td align="center" style="width:70px;"><a>最低<BR>訂購量</a></td>
					<td align="center" style="width:40px;display: none;"><a>色數</a></td>
					<td align="center" style="width:85px;"><a id='lblZinc_xy'>客單單位</a></td>
					<td align="center" style="width:85px;"><a id='lblLengthb_xy'>客單數量</a></td>
					<td align="center" style="width:40px;"><a id='lblUnit_xy_s'>單位</a></td>
					<td align="center" style="width:85px;"><a id='lblMount_xy'>訂貨數量</a></td>
					<td align="center" style="width:80px;"><a id='lblPrices'> </a></td>
					<td align="center" style="width:100px;"><a id='lblTotal_s'> </a></td>
					<td align="center" style="width:60px;"><a >寄庫／庫出</a></td>
					<td align="center" style="width:150px;"><a >寄庫／庫出倉</a></td>
					<td align="center" style="width:150px;"><a id='lblDateas'> </a></td>
					<!--<td align="center" style="width:85px;" class="bonus"><a>獎金比例</a></td>-->
					<td align="center" style="width:85px;"><a id='lblGemounts'> </a></td>
					<td align="center" style="width:85px;"><a>未交量</a></td>
					<td align="center" ><a>備註</a></td>
					<td align="center" style="width:40px;"><a id='lblHard_xy_s'>報價單位</a></td>
					<td align="center" style="width:80px;"><a id='lblLengthc_xy_s'>報價單價</a></td>
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
					<td><select id="cmbScolor.*" class="txt c1" style="font-size: medium;"> </select></td>
					<td>
						<input id="txtSpec.*" type="text" class="txt c1" style="width:270px;"/>
						<input class="btn" id="btnSpec.*" type="button" value='.' style=" font-weight: bold;" />
					</td>
					<td><input id="txtSizea.*" type="text" class="txt c1"/></td>
					<td style="display: none;"><input id="txtDime.*" type="text" class="txt c1 num"/></td>
					<td align="center">
						<input class="txt c7" id="txtZinc.*" type="text" style="width:45px;"/>
						<select id="combZinc.*" class="txt c1" style="width:35px;float: right;font-size: medium;"> </select>
					</td>
					<td><input class="txt num c7 yellow" id="txtLengthb.*" type="text"/></td>
					<td align="center"><input class="txt c7" id="txtUnit.*" type="text"/></td>
					<td><input class="txt num c7" id="txtMount.*" type="text"/></td>
					<td><input class="txt num c7" id="txtPrice.*" type="text" /></td>
					<td><input class="txt num c7" id="txtTotal.*" type="text" /></td>
					<td><select id="cmbSource.*" class="txt c1"> </select></td>
					<td>
						<input id="txtSize.*" type="text" class="txt c1 store2" style="width: 30%"/>
						<input class="btn"  id="btnSize.*" type="button" value='.' style=" font-weight: bold;" />
						<input id="txtUcolor.*" type="text" class="txt c1 store2" style="width: 50%"/>
					</td>
					<td>
						<input class="txt c7 yellow" id="txtDatea.*" type="text" style="width: 58%;"/>
						<select id="cmbIndate.*" class="txt c1" style="width: 38%;font-size: medium;"> </select>
					</td>
					<!--<td class="bonus"><input class="txt num c7 bonus" id="txtClass.*" type="text" /></td>-->
					<td><input class="txt num c1" id="txtC1.*" type="text" /></td>
					<td><input class="txt num c1" id="txtNotv.*" type="text" /></td>
					<td><input class="txt c7" id="txtMemo.*" type="text" /></td>
					<td align="center"><input class="txt c7" id="txtHard.*" type="text"/></td>
					<td><input class="txt num c7" id="txtLengthc.*" type="text" /></td>
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
		<iframe id="xdownload" style="display:none;"> </iframe>
		<input id="q_sys" type="hidden" />
	</body>
</html>