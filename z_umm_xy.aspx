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
            aPop = new Array();
            if (location.href.indexOf('?') < 0) {
                location.href = location.href + "?;;;;" + ((new Date()).getUTCFullYear() - 1911);
            }

            $(document).ready(function() {
                q_getId();
                q_gf('', 'z_umm_xy');

                $('#q_report').click(function(e) {
					if(r_rank<9){
						var delete_report=999;
						for(var i=0;i<$('#q_report').data().info.reportData.length;i++){
							if($('#q_report').data().info.reportData[i].report=='z_umm_xy3')
								delete_report=i;
						}
						if($('#q_report div div').text().indexOf('業務出貨獎金明細表')>-1)
							$('#q_report div div').eq(delete_report).hide();
						
						delete_report=999;
						for(var i=0;i<$('#q_report').data().info.reportData.length;i++){
							if($('#q_report').data().info.reportData[i].report=='z_umm_xy5')
								delete_report=i;
						}
						if($('#q_report div div').text().indexOf('對帳年月銷貨總帳統計表')>-1)
							$('#q_report div div').eq(delete_report).hide();
					}
				});

            });

            function q_gfPost() {
                $('#q_report').q_report({
                    fileName : 'z_umm_xy',
                    options : [{
                        type : '6', //[1]
                        name : 'xmon'
                    }, {
                        type : '1', //[2][3]
                        name : 'xdate'
                    }, {
                        type : '2', //[4][5]
                        name : 'xcust',
                        dbf : 'cust',
                        index : 'noa,comp,serial,invoicetitle',
                        src : 'cust_b.aspx'
                    }, {
                        type : '2', //[6][7]
                        name : 'xsales',
                        dbf : 'sss',
                        index : 'noa,namea',
                        src : 'sss_b.aspx'
                    }, {
                        type : '5', //[8]
                        name : 'ummcust',
                        value:'0@收款客戶,1@對帳客戶'.split(',')
                    }, {
                        type : '8', //[9]
                        name : 'showbranch',
                        value:'Y@顯示分店'.split(',')
                    }, {
                        type : '8', //[10]
                        name : 'paging',
                        value:'Y@統編分頁'.split(',')
                    }, {
                        type : '8', //[11]
                        name : 'showinvomemo',
                        value:'Y@顯示備註與發票號碼'.split(',')
                    }, {
                        type : '5', //[12]
                        name : 'xorder',
                        value:'cust@業務-客戶,paytype@業務-寄單-客戶'.split(',')
                    }, {
                        type : '5', //[13]
                        name : 'showpayed',
                        value:'Y@顯示已收,N@顯示未收'.split(',')
                    }]
                });

                q_popAssign();
                q_langShow();
                
                $('#txtXmon').mask(r_picm);
                $('#txtXmon').val(q_date().substr(0, r_lenm));
                
                $('#txtXdate1').mask(r_picd);
                $('#txtXdate1').datepicker();
                $('#txtXdate2').mask(r_picd);
                $('#txtXdate2').datepicker();
            }

            function q_boxClose(s2) {
            }

            function q_gtPost(t_name) {
                switch (t_name) {
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