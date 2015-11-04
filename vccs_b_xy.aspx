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
            var q_name = 'view_vccs', t_bbsTag = 'tbbs', t_content = " field=noa,noq,productno,product,spec,unit,dime,itemno,mount,width,tranmoney2,tranmoney3,price,total,storeno,store,storeno2,store2,memo,ordeno,no2", afilter = [], bbsKey = ['noa', 'noq'], as;
            //, t_where = '';
            var t_sqlname = 'view_vccs';
            t_postname = q_name;
            brwCount = -1;
            //brwCount2 = 10;
            var isBott = false;
            var txtfield = [], afield, t_data, t_htm;
            var i, s1;
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
            
            function mainPost() {
            	q_getFormat();
                q_cmbParse("cmbItemno",'0@ ,1@寄庫,2@庫出,3@公關品,4@樣品','s');
            }

            function bbsAssign() {
                _bbsAssign();
                for (var j = 0; j < q_bbsCount; j++) {
                	
                }
            }

            function q_gtPost() {

            }

            function refresh() {
                _refresh();
                
                 $('#checkAllCheckbox').click(function() {
                    $('input[type=checkbox][id^=chkSel]').each(function() {
                            $(this).attr('checked', $('#checkAllCheckbox').is(':checked'));
                    });
                });
                
                $('#btnTop').hide();
                $('#btnPrev').hide();
                $('#btnNext').hide();
                $('#btnBott').hide();
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
					<td align="center" style="width:1%;"><input type="checkbox" id="checkAllCheckbox"/></td>
					<td align="center" style="width:10%;"><a id='lblNoa'> </a></td>
					<td align="center" style="width:10%;"><a id='lblProductno'> </a></td>
					<td align="center" style="width:10%;"><a id='lblProduct'> </a></td>
					<td align="center" style="width:15%;"><a id='lblSpec'> </a></td>
					<td align="center" style="width:4%;"><a id='lblUnit'> </a></td>
					<td align="center" style="width:8%;">出貨數量</td>
					<td align="center" style="width:8%;">寄/出庫</td>
					<td align="center" style="width:8%;"><a id='lblPrice'> </a></td>
					<td align="center" style="width:10%;"><a id='lblTotal'> </a></td>
					<td align="center"><a id='lblMemo'> </a></td>
				</tr>
				<tr  style='background:#cad3ff;'>
					<td align="center">
						<input id="chkSel.*" type="checkbox"/>
						<input id="recno.*" type="hidden" />
						<input id="txtNoq.*" type="hidden" />
						<input id="txtMount.*" type="hidden" />
						<input id="txtWidth.*" type="hidden" />
						<input id="txtTranmoney2.*" type="hidden" />
						<input id="txtTranmoney3.*" type="hidden" />
						<input id="txtStoreno.*" type="hidden" />
						<input id="txtStore.*" type="hidden" />
						<input id="txtStoreno2.*" type="hidden" />
						<input id="txtStore2.*" type="hidden" />
						<input id="txtOrdeno.*" type="hidden" />
						<input id="txtNo2.*" type="hidden" />
					</td>
					<td><input class="txt"  id="txtNoa.*" type="text" style="width:98%;" /></td>
					<td><input class="txt"  id="txtProductno.*" type="text" style="width:98%;" /></td>
					<td><input class="txt" id="txtProduct.*" type="text" style="width:98%;" /></td>
					<td><input class="txt" id="txtSpec.*" type="text" style="width:98%;" /></td>
					<td><input class="txt" id="txtUnit.*" type="text" style="width:94%;"/></td>
					<td><input class="txt" id="txtDime.*" type="text" style="width:94%; text-align:right;"/></td>
					<td><select id="cmbItemno.*" class="txt" style="width:98%;"> </select></td>
					<td><input class="txt" id="txtPrice.*" type="text" style="width:96%; text-align:right;"/></td>
					<td><input class="txt" id="txtTotal.*" type="text" style="width:96%; text-align:right;"/></td>
					<td><input class="txt" id="txtMemo.*" type="text" style="width:98%;"/></td>
				</tr>
			</table>
			<!--#include file="../inc/pop_ctrl.inc"-->
		</div>
	</body>
</html>
