<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<meta http-equiv="Content-Language" content="en-us" />
		<title> </title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src="../script/qj2.js" type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src="../script/qj_mess.js" type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript">
            var q_name = 'view_vcc', t_bbsTag = 'tbbs', t_content = "", afilter = [], bbsKey = ['noa'], as;
			var t_sqlname = 'vcce_import_xy_load';
			t_postname = q_name;
			brwCount = -1;
			brwCount2 = 0;
			var isBott = false;
			var txtfield = [], afield, t_data, t_htm;
			var i, s1;
            var bbsNum = [['txtTotal', 15, 0, 1]];
            $(document).ready(function() {
                if (!q_paraChk())
                    return;

                main();
            });

            function main() {
                if (dataErr) {
                    dataErr = false;
                    return;
                }
                mainBrow(6, t_content, t_sqlname, t_postname, r_accy);
            }

            function bbsAssign() {
                _bbsAssign();
            }

            function q_gtPost() {

            }
			
			var xy_seq=0;
            function refresh() {
                _refresh();
                var xy_cust='';
                for (var j = 0; j < q_bbsCount; j++) {
                	if($('#txtTypea_'+j).val()=='1')
                		$('#textTypea_'+j).val('出');
                	if($('#txtTypea_'+j).val()=='2')
                		$('#textTypea_'+j).val('退');
                	if($('#txtNoa_'+j).val().substr(0,1)=='G')
                		$('#textTypea_'+j).val('領');
                	if($('#txtNoa_'+j).val().substr(0,1)=='X')
                		$('#textTypea_'+j).val('調');
                		
                	$('#textTypea_'+j).attr('disabled', 'disabled');
		            $('#textTypea_'+j).css('background', t_background2);
		            
		            if(!($('#txtPaytype_'+j).val()=='貨到收現' || $('#txtPaytype_'+j).val()=='貨運代收')){
		            	$('#txtTotal_'+j).val(0);
		            }
                }
                                
                $('#checkAllCheckbox').click(function() {
                    $('input[type=checkbox][id^=chkSel]').each(function() {
                        $(this).attr('checked', $('#checkAllCheckbox').is(':checked'));
                    });
                });
                
                $('[type="checkbox"]').not($('#checkAllCheckbox')).each(function(index) {
					$(this).click(function() {
						var n=$(this).attr('id').split('_')[1];
						if($(this).prop('checked')){ //順序不用重編，回傳時還會再重新排序
							xy_seq++;
							$('#txtCheckseq_'+n).val(('000000'+xy_seq).slice(-6));
						}else{
							$('#txtCheckseq_'+n).val('');
						}
					});
                });

                $('#btnTop').hide();
                $('#btnPrev').hide();
                $('#btnNext').hide();
                $('#btnBott').hide();
            }
            
            function q_gtPost(t_name) { 
            	switch (t_name) {
            	}
			}

		</script>
		<style type="text/css">
            .seek_tr {
                color: white;
                text-align: center;
                font-weight: bold;
                BACKGROUND-COLOR: #76a2fe
            }
            input[type="text"], input[type="button"] {
                font-size: medium;
            }
		</style>
	</head>
	<body>
		<div  id="dbbs"  >
			<table id="tbbs" class='tbbs'  border="2"  cellpadding='2' cellspacing='1' style='width:100%'  >
				<tr style='color:White; background:#003366;' >
					<td align="center">
					<input type="checkbox" id="checkAllCheckbox"/>
					</td>
					<td align="center"><a id='lblDatea'>出貨日期</a></td>
					<td align="center"><a id='lblNoa'>出貨單號</a></td>
					<td align="center"><a id='lblTypea'>單別</a></td>
					<td align="center"><a id='lblCustno'>客戶編號</a></td>
					<td align="center"><a id='lblComp'>客戶名稱</a></td>
					<td align="center"><a id='lblTotal'>總計</a></td>
					<td align="center"><a id='lblMemo'>備註</a></td>
					<td align="center"><a >送貨時間 </a></td>
				</tr>
				<tr  style='background:#cad3ff;'>
					<td style="width:1%;" align="center"><input id="chkSel.*" type="checkbox"/></td>
					<td style="width:8%;"><input class="txt"  id="txtDatea.*" type="text" style="width:98%;" /></td>
					<td style="width:12%;"><input class="txt" id="txtNoa.*" type="text" style="width:98%;"/></td>
					<td style="width:5%;">
						<input class="txt" id="textTypea.*" type="text" style="width:98%;"/>
						<input class="txt" id="txtTypea.*" type="hidden"/>
					</td>
					<td style="width:10%;"><input class="txt" id="txtCustno.*" type="text" style="width:98%;"/></td>
					<td style="width:18%;"><input class="txt" id="txtNick.*" type="text" style="width:98%;"/></td>
					<td style="width:10%;"><input class="txt" id="txtTotal.*" type="text" style="width:94%; text-align:right;"/></td>
					<td class="isRB">
						<input class="txt" id="txtMemo.*" type="text" style="width:98%;"/>
						<input id="recno.*" type="hidden" />
						<input id="txtPaytype.*" type="hidden" />
						<input id="txtWeight.*" type="hidden" />
					</td>
					<td class="isXY isRB" style="width:12%;">
						<input class="txt" id="txtTrantime.*" type="text" style="width:98%;"/>
						<input class="txt" id="txtCheckmemo.*" type="hidden" style="width:98%;"/>
						<input class="txt" id="txtCheckseq.*" type="hidden" style="width:98%;"/>
					</td>
				</tr>
			</table>
			<!--#include file="../inc/pop_ctrl.inc"-->
		</div>
	</body>
</html>
