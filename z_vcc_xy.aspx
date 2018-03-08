<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" >
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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
            if (location.href.indexOf('?') < 0) {
                location.href = location.href + "?;;;;100";
            }
            $(document).ready(function() {
                q_getId();
                q_gf('', 'z_vcc_xy');
            });
            function q_gfPost() {
                $('#q_report').q_report({
                    fileName : 'z_vcc_xy',
                    options : [{
                        type : '0', //[1]
                        name : 'accy',
                        value : q_getId()[4]
                    }, {
                        type : '0', //[2]
                        name : 'mountprecision',
                        value : q_getPara('vcc.mountPrecision')
                    }, {
                        type : '0', //[3]
                        name : 'weightprecision',
                        value : q_getPara('vcc.weightPrecision')
                    }, {
                        type : '0', //[4]
                        name : 'priceprecision',
                        value : q_getPara('vcc.pricePrecision')
                    }, {
                        type : '1', //[5][6]
                        name : 'date'
                    }, {
                        type : '2', //[7][8]
                        name : 'cust',
                        dbf : 'cust',
                        index : 'noa,comp,nick,invoicetitle,serial',
                        src : 'cust_b.aspx'
                    }, {
                        type : '2', //[9][10]
                        name : 'ucc',
                        dbf : 'ucc',
                        index : 'noa,product,spec',
                        src : 'ucc_b.aspx'
                    }, {
						type : '2',
						name : 'store', //[11][12]
						dbf : 'store',
						index : 'noa,store',
						src : 'store_b.aspx'
					}, {
                        type : '6', //[13]
                        name : 'enddate'
                    }, {
                        type : '8', //[14]
                        name : 'laststoein',
                        value:'1@最後寄庫追蹤'.split(',')
                    }, {
                        type : '5', //[15]
                        name : 'posttype',
                        value:'#non@全部,email@電郵,fax@傳真'.split(',')
                    }, {
                        type : '1', //[16][17]
                        name : 'xedate'
                    }, {
                        type : '8', //[18]
                        name : 'xzero',
                        value:'1@顯示庫存0'.split(',')
                    }, {
                        type : '2', //[19][20]
                        name : 'xsales',
                        dbf : 'sss',
                        index : 'noa,namea',
                        src : 'sss_b.aspx'
                    }]
                });
                q_popAssign();
                q_langShow();
                
                $('#txtDate1').mask(r_picd);
				$('#txtDate1').datepicker();
				$('#txtDate2').mask(r_picd);
				$('#txtDate2').datepicker();
				$('#txtEnddate').mask(r_picd);
				$('#txtEnddate').datepicker();
				$('#txtEnddate').val(q_date());
				$('#txtXedate1').mask(r_picd);
				$('#txtXedate2').mask(r_picd);
				
				$('#txtXedate1').datepicker();
				$('#txtXedate2').datepicker();
				
				$('#txtDate1').val(q_date().substr(0,r_lenm)+'/01');
                $('#txtDate2').val(q_cdn(q_cdn(q_date().substr(0,r_lenm)+'/01',35).substr(0,r_lenm)+'/01',-1));
				
				$('#Xzero').css('width','300px');
				$('#Xzero').css('height','30px');
                $('#chkXzero').css('margin-top','5px');
                $('#Xzero .label').css('width','0px');
                
                if(window.parent.q_name=='z_uccep_xy' || window.parent.q_name=='z_ucc'){
                	if (q_getHref()[1] != undefined) {
                		$('#txtUcc1a').val(q_getHref()[1]);
                		$('#txtUcc2a').val(q_getHref()[1]);
                	}
                	
                	if (q_getHref()[3] != undefined) {
                		$('#txtEnddate').val(q_getHref()[3]);
                	}
                	$('#btnOk').click();
                }
                
            }

            function q_boxClose(s2) {
            }

            function q_gtPost(s2) {
            }
		</script>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();">
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