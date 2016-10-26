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
            if (location.href.indexOf('?') < 0) {
                location.href = location.href + "?;;;;" + ((new Date()).getUTCFullYear() - 1911);
            }
            $(document).ready(function() {
                q_getId();
                q_gt('cardeal', "where=^^ 1=1 ^^", 0, 0, 0, "getcardeal");
            });
            function q_gfPost() {
                $('#q_report').q_report({
                    fileName : 'z_vcce_xyp',
                    options : [{
                        type : '0',
                        name : 'accy',
                        value : r_accy
                    }, {
                        type : '1',
                        name : 'date'
                    }, {
                        type : '2',
                        name : 'cust',
                        dbf : 'cust',
                        index : 'noa,comp,nick,invoicetitle,serial',
                        src : 'cust_b.aspx'
                    }, {
                        type : '2',
                        name : 'driver',
                        dbf : 'sss',
                        index : 'noa,namea',
                        src : 'sss_b.aspx'
                    }, {
                        type : '6',
                        name : 'xcarno'
                    },{
                    	type : '5',
                    	name : 'xcardeal',
                    	value : t_cardeal.split(',')
                    }]
                });
				q_popAssign();
                q_getFormat();
                q_langShow();

                $('#txtDate1').mask(r_picd);
                $('#txtDate1').datepicker();
                $('#txtDate1').val(q_cdn(q_date(),1));
                $('#txtDate2').mask(r_picd);
                $('#txtDate2').datepicker();
				$('#txtDate2').val(q_cdn(q_date(),1));
                
            }

            function q_boxClose(s2) {
            }
			
			var t_cardeal='#non@全部';
			
            function q_gtPost(t_name) {
				switch (t_name) {
					case 'getcardeal':
						var as = _q_appendData("cardeal", "", true);
						for(var i=0;i<as.length;i++){
							t_cardeal=t_cardeal+','+as[0].noa+'@'+as[0].comp;
						}
						q_gf('', 'z_vcce_xyp');
						break;
				}
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