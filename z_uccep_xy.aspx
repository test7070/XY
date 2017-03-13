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
			var uccgaItem = '';
			$(document).ready(function() {
				_q_boxClose();
				q_getId();
				if (uccgaItem.length == 0) {
					q_gt('uccga', '', 0, 0, 0, "");
				}
			});
			function q_gfPost() {
				$('#q_report').q_report({
					fileName : 'z_uccep_xy',
					options : [{
						type : '0',
						name : 'accy',
						value : r_accy //[1]
                    },{
						type : '0',
						name : 'rank',
						value : r_rank //[2]
                    },{
						type : '0',
						name : 'userno',
						value : r_userno //[3]
                    },{
						type : '0',
						name : 'namea',
						value : r_name //[4]
                    }, {
						type : '2', //[5][6]
						name : 'xproductno',
						dbf : 'ucc',
						index : 'noa,product',
						src : 'ucc_b.aspx'
					},{
						type : '2', //[7] [8]
						name : 'xstoreno',
						dbf : 'store',
						index : 'noa,store',
						src : 'store_b.aspx'
					}, {
						type : '5',
						name : 'xucctype', //[9]
						value : [q_getPara('report.all')].concat(q_getPara('ucc.typea').split(','))
					}, {
						type : '5', //[10]
						name : 'xgroupano',
						value : uccgaItem.split(',')
					}, {
						type : '2', //[11][12]
						name : 'xtgg',
						dbf : 'tgg',
						index : 'noa,comp',
						src : 'tgg_b.aspx'
					}, {
						type : '6',
						name : 'xedate' //[13]
					}, {
						type : '8',
						name : 'xallucc',//[14]
						value : '1@顯示零庫存產品'.split(',')
					}, {
                        type : '6', //[15]
                        name : 'xucc'
                    }, {
                        type : '6', //[16]
                        name : 'xproduct'
                    }, {
                        type : '5', //[17]
                        name : 'xstyle',
                        value : [q_getPara('report.all')].concat('便品,空白,公版,加工,印刷,私-空白,新版,改版,新版數位樣,新版正式樣,改版數位樣,改版正式樣'.split(','))
                    }, {
                        type : '6', //[18]
                        name : 'xspec'
                    }, {
						type : '8',
						name : 'xnoqrcode',//[19]
						value : '1@不顯示QRCODE'.split(',')
					}]
				});
				q_popAssign();
				q_getFormat();
				q_langShow();
				
				if(r_len==4){                	
                	$.datepicker.r_len=4;
					//$.datepicker.setDefaults($.datepicker.regional["ENG"]);
                }
				
				$('#txtXedate').mask(r_picd);
				$('#txtXedate').datepicker();
				$('#txtXedate').val(q_date());
				
				$('#Xallucc').css('width','300px').css('height','30px');
				$('#Xallucc .label').css('width','0px');
				
				$('#Xucc').css("width","605px");
				$('#txtXucc').css("width","515px");
				$('#lblXucc').css("color","#0000ff");
				$('#lblXucc').click(function(e) {
                	q_box("ucc_b2.aspx?;;;;", 'ucc', "40%", "620px", q_getMsg("popUcc"));
                });
                
                $('#Xnoqrcode').css('width','300px').css('height','30px');
				$('#Xnoqrcode .label').css('width','0px');
			}

			function q_boxClose(s2) {
                var ret;
                switch (b_pop) {
                	case 'ucc':
                        ret = getb_ret();
                        if(ret==null)
                        	return;
                        var xucc='';
                        if(ret[0]!=undefined){
                        	for (var i = 0; i < ret.length; i++) {
                        		xucc+=ret[i].noa+'.'
                        	}
                        }
                        xucc=xucc.substr(0,xucc.length-1);
                        $('#txtXucc').val(xucc);
                        break;	
					
                }   /// end Switch
				b_pop = '';
            }

			function q_gtPost(t_name) {
				switch (t_name) {
					case 'uccga':
						var as = _q_appendData("uccga", "", true);
						uccgaItem = "#non@全部";
						for ( i = 0; i < as.length; i++) {
							uccgaItem = uccgaItem + (uccgaItem.length > 0 ? ',' : '') + as[i].noa + '@' + as[i].noa + ' . ' + as[i].namea;
						}
						q_gf('', 'z_uccep_xy');
						break;

				}
			}
		</script>
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