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
            $(document).ready(function() {
                _q_boxClose();
                q_getId();
                q_gf('', 'z_quatp_xy');
            });
            function q_gfPost() {
                $('#q_report').q_report({
                    fileName : 'z_quatp_xy',
                    options : [{
						type : '0',
						name : 'accy',
                        value : q_getId()[4] //[1]
                    },{
                        type : '1',
                        name : 'xdate'
                    },{
                        type : '1',
                        name : 'xnoa'
                    },{
                        type : '8',
                        name : 'showmemo',
                        value : "1@顯示參考供應客戶".split(',')
                    },{
                        type : '8',
                        name : 'showlogo2',
                        value : "1@顯示公司章".split(',')
                    }]
                });
                q_popAssign();
                q_getFormat();
                q_langShow();
                $('#txtXdate1').mask(r_picd);
                $('#txtXdate1').datepicker();
                $('#txtXdate2').mask(r_picd);
                $('#txtXdate2').datepicker();
                
                //$('#Showmemo').css('width','300px');
                //$('#chkShowmemo').css('width','220px');
                //$('#chkShowmemo span').css('width','180px');
                //$('#Showlogo2').css('width','300px');
                //$('#chkShowlogo2').css('width','220px');
                //$('#chkShowlogo2 span').css('width','180px');
                
                var t_key = q_getHref();
                if(t_key[1] != undefined)
                	$('#txtXnoa1').val(t_key[1]);
                	$('#txtXnoa2').val(t_key[1]);
            }

            function q_boxClose(s2) {
            }

            function q_gtPost(s2) {
            }
		</script>
		<style type="text/css">
			#frameReport table{
					border-collapse: collapse;
				}
		</style>
	</head>
	<body id="z_quatp_xy" ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	>
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