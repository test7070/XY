<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" >
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title></title>
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
            
            $(document).ready(function() {
                _q_boxClose();
                q_getId();
				q_gt('custtype', '', 0, 0, 0, "");
            });
            
            function q_gfPost() {
                $('#q_report').q_report({
                    fileName : 'z_cust_xy',
                    options : [{//[1]
                        type : '0',
                        name : 'accy',
                        value : q_getId()[4]
                    }, {//[2]
                        type : '0',
                        name : 'namea',
                        value : r_name
                    }, {/*1 [3],[4]*/
                        type : '2',
                        name : 'xcust',
                        dbf : 'cust',
                        index : 'noa,comp,nick,invoicetitle,serial',
                        src : 'cust_b.aspx'
                    }, {/*3 [5],[6]*/
                        type : '2',
                        name : 'xsales',
                        dbf : 'sss',
                        index : 'noa,namea',
                        src : 'sss_b.aspx'
                    }, {/*1 [7],[8]*/
                        type : '2',
                        name : 'cust2',
                        dbf : 'cust',
                        index : 'noa,comp',
                        src : 'cust_b.aspx'
                    }, {/*1 [9],[10]*/
                        type : '2',
                        name : 'xgrp',
                        dbf : 'cust',
                        index : 'noa,comp',
                        src : 'cust_b.aspx'
                    }, {/*4-[11]*/
                        type : '5',
                        name : 'xstatus',
                        value : ('#non@全部,'+q_getPara('cust.status')).split(',')
                    }, {/*5-[12]*/
                        type : '6',
                        name : 'xstartdate'
                    }, {/*6-[13]*/
						type : '5',
						name : 'xinvo',
                        value : '#non@全部,須@須,不須@不須,空值@空值'.split(',')
                    }, {/*7-[14]*/
                        type : '6',
                        name : 'xpaytype'
                    }, {/*8-[15]*/
                        type : '5',
                        name : 'xpost', 
                        value : '#non@全部,不寄單@不寄單,郵寄@郵寄,附回郵@附回郵,雙掛號@雙掛號,抵貨款@抵貨款,僅回郵@僅回郵,親送單@親送單,傳真@傳真,電郵@電郵,空值@空值'.split(',')
                    }, {/*6-[16]*/
						type : '5',
						name : 'xtrantype',
                        value : ('#non@全部,'+q_getPara('sys.tran')+',空值@空值').split(',')
                    }, {/*6-[17]*/
						type : '5',
						name : 'xshowprice',
                        value : '#non@全部,Y@Y,N@N'.split(',')
                    }, {/*6-[18]*/
						type : '5',
						name : 'xcobtype',
                        value : '#non@全部,2@2聯,3@3聯,空值@空值'.split(',')
                    }, {/*6-[19]*/
						type : '5',
						name : 'xcustorder',
                        value : 'noa@編號,comp@公司名稱,zip_comp@郵編,serial@統編,checkmemo@驗單需求,taxtype@課稅方式,invomemo@發票開立,postmemo@寄單方式,showprice@顯示單價,vccmemo@貨單開立'.split(',')
                    }, {/*5-[20]*/
                        type : '6',
                        name : 'xaddr'
                    }, {//[21]
                        type : '0',
                        name : 'custstatus',
                        value : q_getPara('cust.status')
                    }, {/*1 [22],[23]*/
                        type : '2',
                        name : 'xuccno',
                        dbf : 'ucc',
                        index : 'noa,product,spec',
                        src : 'ucc_b.aspx'
                    }, {/*5-[24]*/
                        type : '6',
                        name : 'xproduct'
                    }, {/*6-[25]*/
						type : '5',
						name : 'xucctypea',
                        value : ('#non@全部,'+q_getPara('ucc.typea')).split(',')
                    }, {/*6-[26]*/
						type : '5',
						name : 'xuccgroupa',
                        value : t_uccga.split(',')
                    }, {/*6-[27]*/
						type : '5',
						name : 'xuccorder',
                        value : 'noa@品號,product@品名,style@版別,unit@單位'.split(',')
                    }, {/*[28][29]*/
						type : '1',
						name : 'xkdate',
                    }]
                });
                q_popAssign();
                q_getFormat();
                q_langShow();
                
                $('#txtXstartdate').mask('99');
                $('#txtXkdate1').mask(r_picd);
                $('#txtXkdate2').mask(r_picd);
                
                var tmp = document.getElementById("txtXpaytype");
				var selectbox = document.createElement("select");
				selectbox.id = "combPay";
				selectbox.style.cssText = "width:15px;font-size: medium;";
				//selectbox.attachEvent('onchange',combPay_chg);
				//selectbox.onchange="combPay_chg";
				tmp.parentNode.appendChild(selectbox, tmp);
				q_cmbParse("combPay", '@全部,' + q_getPara('vcc.paytype').substr(1)+',空值@空值');
				
				$('#combPay').change(function() {
					var cmb = document.getElementById("combPay")
					$('#txtXpaytype').val(cmb.value);
				});
                
            }

            function q_boxClose(s2) {
            	
            }
			
			var t_custtype='',t_uccga='',t_uccgb='',t_uccgc='';
            function q_gtPost(t_name) {
				switch (t_name) {
					case 'custtype':
						var as = _q_appendData("custtype", "", true);
						t_custtype = "#non@全部";
						for ( i = 0; i < as.length; i++) {
							t_custtype = t_custtype + (t_custtype.length > 0 ? ',' : '') + as[i].noa + '@' + as[i].namea;
						}
						q_gt('uccga', '', 0, 0, 0, "");
						break;
					case 'uccga':
						var as = _q_appendData("uccga", "", true);
						if (as[0] != undefined) {
							t_uccga = "#non@全部";
							for ( i = 0; i < as.length; i++) {
								t_uccga = t_uccga + (t_uccga.length > 0 ? ',' : '') + as[i].noa + '@' + as[i].namea;
							}
						}
						
						q_gt('uccgb', '', 0, 0, 0, "");
						break;
					case 'uccgb':
						//中類
						var as = _q_appendData("uccgb", "", true);
						if (as[0] != undefined) {
							t_uccgb = "#non@全部";
							for ( i = 0; i < as.length; i++) {
								t_uccgb = t_uccgb + (t_uccgb.length > 0 ? ',' : '') + as[i].noa + '@' + as[i].namea;
							}
						}
						
						q_gt('uccgc', '', 0, 0, 0, "");
						break;
					case 'uccgc':
						//小類
						var as = _q_appendData("uccgc", "", true);
						if (as[0] != undefined) {
							t_uccgc = "#non@全部";
							for ( i = 0; i < as.length; i++) {
								t_uccgc = t_uccgc + (t_uccgc.length > 0 ? ',' : '') + as[i].noa + '@' + as[i].namea;
							}
						}
						
						q_gf('', 'z_cust_xy');
						break;
				}
			}
		</script>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	>
		<div id="q_menu"></div>
		<div style="position: absolute;top: 10px;left:50px;z-index: 1;width:2000px;">
			<div id="container">
				<div id="q_report"></div>
			</div>
			<div class="prt" style="margin-left: -40px;">
				<!--#include file="../inc/print_ctrl.inc"-->
			</div>
		</div>
	</body>
</html>
