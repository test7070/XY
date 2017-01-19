<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" >
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title> </title>
		<script src="../script/jquery.min.js" type="text/javascript"> </script>
		<script src='../script/qj2.js' type="text/javascript"> </script>
		<script src='qset.js' type="text/javascript"> </script>
		<script src='../script/qj_mess.js' type="text/javascript"> </script>
		<script src="../script/qbox.js" type="text/javascript"> </script>
		<script src='../script/mask.js' type="text/javascript"> </script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
		<script src="css/jquery/ui/jquery.ui.core.js"> </script>
		<script src="css/jquery/ui/jquery.ui.widget.js"> </script>
		<script src="css/jquery/ui/jquery.ui.datepicker_tw.js"> </script>
		<script type="text/javascript">
			aPop = new Array(
				['txtXgrpno', 'lblXgrpno', 'cust', 'noa,comp', 'txtXgrpno', 'cust_b.aspx']
			);
		
			var t_first=true;
            if (location.href.indexOf('?') < 0) {
                location.href = location.href + "?;;;;"+((new Date()).getUTCFullYear()-1911);
            }
            $(document).ready(function() {
            	q_getId();
                q_gf('', 'z_vccp_xy');
                
                $('#q_report').click(function(e) {
					if(window.parent.q_name=="vcca"){
						for(var i=0;i<$('#q_report').data().info.reportData.length;i++){
							if($('#q_report').data().info.reportData[i].report!='z_vccp_xy4')
								$('#q_report div div').eq(i).hide();
						}
						$('#q_report div div .radio').parent().each(function(index) {
							if(!$(this).is(':hidden') && t_first){
								$(this).children().removeClass('nonselect').addClass('select');
								t_first=false;
							}
							if($(this).is(':hidden') && t_first){
								$(this).children().removeClass('select').addClass('nonselect');
							}
						});
					}
					if($('#q_report').data().info.reportData[$('#q_report').data().info.radioIndex].report=='z_vccp_xy5'){
						$('#lblXdate').text('出貨日期');	
					}else{
						$('#lblXdate').text(q_getMsg('lblXdate'));
					}
				});
            });
            function q_gfPost() {
				$('#q_report').q_report({
					fileName : 'z_vccp_xy',
					options : [{
						type : '0', //[1]
						name : 'accy',
						value : r_accy
					}, {
						type : '1', //[2][3]
						name : 'xnoa'
					}, {
						type : '1', //[4][5]
						name : 'xdate'
					}, {
						type : '2',
						name : 'xproduct', //[6][7]
						dbf : 'ucc',
						index : 'noa,product',
						src : 'ucc_b.aspx'
					}, {
						type : '2',
						name : 'xcust', //[8][9]
						dbf : 'cust',
						index : 'noa,comp,nick,invoicetitle,serial',
						src : 'cust_b.aspx'
					},{
						type : '0', //[10]
						name : 'userno',
						value : r_userno
					},{
						type : '1', //[11][12]
						name : 'xvccano'
					},{
						type : '6', //[13]
						name : 'xgrpno'
					},{
						type : '1', //[14][15]
						name : 'xmoney'
					}]
				});
                q_popAssign();
                q_getFormat();
                q_langShow();
                
                $('#txtXdate1').mask(r_picd);
                $('#txtXdate2').mask(r_picd);
                
                $('#txtXdate1').val(q_cdn(q_date(),1));
                $('#txtXdate2').val(q_cdn(q_date(),1));
                
				//20160115判斷隨貨發票是否存在 暫時拿掉
               /* $('#btnOk').click(function() {
                	if($('#q_report').data('info').radioIndex==0)
                		q_gt('view_vcc', "where=^^ noa between '"+$('#txtXnoa1').val()+"' and '"+$('#txtXnoa2').val()+"' ^^", 0, 0, 0, "getcustno");
				});*/
				
				var tmp = document.getElementById("btnWebPrint");
				var tmpbtn = document.createElement("input");
				tmpbtn.id="btnWebPrint2"
				tmpbtn.type="button"
				tmpbtn.value="雲端列印"
				tmpbtn.style.cssText = "font-size:medium;color: #0000FF;";
				tmp.parentNode.insertBefore(tmpbtn, tmp);
				$('#btnWebPrint').hide();
				
				$('#btnWebPrint2').click(function() {
					if($('#q_report').data('info').radioIndex==0 || $('#q_report').data('info').radioIndex==1){//先判斷是否可列印
						//20160115 判斷隨貨發票是否存在 暫時拿掉
						//20170118 功能重新開放
						q_gt('view_vcc', "where=^^ noa between '"+$('#txtXnoa1').val()+"' and '"+$('#txtXnoa2').val()+"' ^^", 0, 0, 0, "getcustno2");
						
						//列印次數+1
						/*var t_noa1=emp($('#txtXnoa1').val())?'#non':$('#txtXnoa1').val();
						var t_noa2=emp($('#txtXnoa2').val())?'#non':$('#txtXnoa2').val();
						var t_where = t_noa1+ ';'+t_noa2;
						q_func('qtxt.query.vccprintcount_xy', 'cust_ucc_xy.txt,vccprintcount,' + t_where);*/
					}else{
						$('#btnWebPrint').click();
					}
				});
				
	            var t_noa=typeof(q_getHref()[1])=='undefined'?'':q_getHref()[1];
                if(t_noa.length>0){
	                $('#txtXnoa1').val(t_noa);
	                $('#txtXnoa2').val(t_noa);
				}
				
				var t_invo = typeof(q_getHref()[3])=='undefined'?'':q_getHref()[3];
				if(t_invo.length>0){
					$('#txtXvccano1').val(t_invo);
					$('#txtXvccano2').val(t_invo);
				}
				if(window.parent.q_name=="vcca"){
					$('#txtXvccano1').val(window.parent.$('#txtNoa').val())
					$('#txtXvccano2').val(window.parent.$('#txtNoa').val())
					$('#q_report div div .radio.select').click();
				}
				
				$('#txtXmoney1').css('text-align','right').val(0);
				$('#txtXmoney2').css('text-align','right').val(700);
				
				$('#txtXmoney1').change(function() {
					$(this).val(dec($(this).val()));
                    if ($(this).val() == 'NaN')
                    	$(this).val(0);
				});
				$('#txtXmoney2').change(function() {
					$(this).val(dec($(this).val()));
                    if ($(this).val() == 'NaN')
                    	$(this).val(0);
				});
            }

            function q_boxClose(s2) {
            }
            
            function q_funcPost(t_func, result) {
				switch(t_func) {
					case 'qtxt.query.vccprintcount_xy':
					//isprint=true;
					//$('#btnOk').click();
					$('#txtUrl').val('');
					$('#txtUrl2').val('');
					$('#btnWebPrint').click();
					break;
				}
			}
			
            var invono="",vcctype="",isprint=false,custorde='';
            function q_gtPost(t_name) {
				switch (t_name) {
					case 'getcustno2':
						var as = _q_appendData("view_vcc", "", true);
						if (as[0] != undefined) {
							invono=as[0].invono;
							vcctype=as[0].typea;
							q_gt('custm', "where=^^ noa = '"+as[0].custno+"' ^^", 0, 0, 0, "getinvomemo2");	
						}else{
							alert("出貨單不存在 !!");
						}
						break;
					case 'getinvomemo2':
						var as = _q_appendData("custm", "", true);
						if(as[0] != undefined){
							if(invono.length==0 && vcctype=='1' && as[0].invomemo=='隨貨' && dec(as[0].total)>0 ){
								alert("請輸入發票號碼後再列印 !!");
							}else if (as[0].isfranchisestore=='true' && vcctype=='1' && dec(as[0].total)>0){
								q_gt('view_orde', "where=^^ noa in (select ordeno from view_vccs where noa='"+as[0].noa+"') ^^", 0, 0, 0, "getCustorde2");
							}else{
								//列印次數+1
								var t_noa1=emp($('#txtXnoa1').val())?'#non':$('#txtXnoa1').val();
								var t_noa2=emp($('#txtXnoa2').val())?'#non':$('#txtXnoa2').val();
								var t_where = t_noa1+ ';'+t_noa2;
								q_func('qtxt.query.vccprintcount_xy', 'cust_ucc_xy.txt,vccprintcount,' + t_where);
							}
						}else{
							alert("客戶資料不存在 !!");
						}
						break;
					case 'getCustorde2':
						var as = _q_appendData("view_orde", "", true);
						if(as[0] != undefined){
							if (as[0].custorde.length==0){
								alert("請輸入客單編號後再列印 !!");
							}else{
								//列印次數+1
								var t_noa1=emp($('#txtXnoa1').val())?'#non':$('#txtXnoa1').val();
								var t_noa2=emp($('#txtXnoa2').val())?'#non':$('#txtXnoa2').val();
								var t_where = t_noa1+ ';'+t_noa2;
								q_func('qtxt.query.vccprintcount_xy', 'cust_ucc_xy.txt,vccprintcount,' + t_where);
							}
						}else{
							alert("訂單資料不存在 !!");
						}
						break;
					case 'getcustno':
						var as = _q_appendData("view_vcc", "", true);
						if (as[0] != undefined) {
							invono=as[0].invono;
							vcctype=as[0].typea;
							q_gt('custm', "where=^^ noa = '"+as[0].custno+"' ^^", 0, 0, 0, "getinvomemo");	
						}
						break;
					case 'getinvomemo':
						var as = _q_appendData("custm", "", true);
						if(as[0] != undefined){
							if(invono.length==0 && vcctype=='1' && as[0].invomemo=='隨貨'){
								alert("請輸入發票號後再列印 !!");
							}else{
								if(isprint){
									$('#btnWebPrint').click();
									isprint=false;
								}
							}
						}else{
							//無資料
							if(isprint){
								$('#btnWebPrint').click();
								isprint=false;
							}
						}
						break;
				}
            }
		</script>
		<style type="text/css">
			#frameReport table{
					border-collapse: collapse;
				}
		</style>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();">
		<div id="q_menu"> </div>
		<div style="position: absolute;top: 10px;left:50px;z-index: 1;width:2000px;">
			<div id="container">
				<div id="q_report"> </div>
			</div>
			<div class="prt" style="margin-left: -40px;">
				<!--#include file="../inc/print_ctrl.inc"-->
			</div>
		</div>
	</body>
</html>
           
          