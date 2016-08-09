﻿<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
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
            if (location.href.indexOf('?') < 0) {
                location.href = location.href + "?;;;;" + ((new Date()).getUTCFullYear() - 1911);
            }
            $(document).ready(function() {
                q_getId();
                q_gf('', 'z_cub_xyp');
            });
            function q_gfPost() {
                $('#q_report').q_report({
                    fileName : 'z_cub_xyp',
                    options : [{//[1]
                        type : '0',
                        name : 'accy',
                        value : r_accy
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
                    }, {//[5]
                        type : '0',
                        name : 'worker',
                        value : r_name
                    }, {//[6][7]
                        type : '1',
                        name : 'xnoa'
                    }, {//[8][9]
                    	type : '1',
                    	name :'xdate'
                    }, {//[10][11]
                    	type : '1',
                    	name :'xfdate'
                    },{//[12][13]
                        type : '2', 
                        name : 'xpoduct',
                        dbf : 'ucc',
                        index : 'noa,product',
                        src : 'ucc_b.aspx'
                    },{//[14][15]
                        type : '2', 
                        name : 'xtgg',
                        dbf : 'tgg',
                        index : 'noa,comp',
                        src : 'tgg_b.aspx'
                    }, {//[16][17]
                    	type : '1',
                    	name :'xmon'
                    }, {//[18]
                        type : '5',
                        name : 'xtypea',
                        value : ['#non@全部','製造部','加工部','委外部']
                    }, {//[19]
						type : '5',
						name : 'xenda',
                        value : '#non@全部,Y@結案,N@未結案'.split(',')
                    }, {//[20]
						type : '5',
						name : 'xsorting',
                        value : 'Y@預交日,N@製令日'.split(',')
                    }]
                });
                
                q_popAssign();
                q_getFormat();
                q_langShow();
                
                var r_1911=1911;
				if(r_len==4){//西元年
					r_1911=0;
				}else{
					$('#txtXdate1').datepicker();
					$('#txtXdate2').datepicker();
				}
				$('#txtXdate1').mask(r_picd);
                $('#txtXdate2').mask(r_picd);
                $('#txtXmon1').mask(r_picm);
                $('#txtXmon2').mask(r_picm);
                
                $('#txtXdate1').val(q_date());
                $('#txtXdate2').val(q_date());
                $('#txtXmon1').val(q_date().substr(0,r_lenm));
                $('#txtXmon2').val(q_date().substr(0,r_lenm));

                if (q_getId()[3] != undefined) {
                    $('#txtXnoa1').val(q_getId()[3].replace('noa=', ''));
                    $('#txtXnoa2').val(q_getId()[3].replace('noa=', ''));
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

