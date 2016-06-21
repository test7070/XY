﻿<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title> </title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
        <link href="../qbox.css" rel="stylesheet" type="text/css" />
        <link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
		<script src="css/jquery/ui/jquery.ui.core.js"> </script>
		<script src="css/jquery/ui/jquery.ui.widget.js"> </script>
		<script src="css/jquery/ui/jquery.ui.datepicker_tw.js"> </script>
		<script type="text/javascript">
            var q_name = "quat_s";
            var aPop = new Array(['txtCustno', '', 'cust', 'noa,comp,nick,invoicetitle,serial', 'txtCustno', '']
            , ['txtSalesno', '', 'sss', 'noa,namea', 'txtSalesno', '']
            , ['txtWorker', '', 'sss', 'namea,noa', 'txtWorker', '']
            , ['txtWorker2', '', 'sss', 'namea,noa', 'txtWorker2', '']
            );
            $(document).ready(function() {
                main();
            });
            /// end ready

            function main() {
                mainSeek();
                q_gf('', q_name);
            }

            function q_gfPost() {
                q_getFormat();
                q_langShow();

                bbmMask = [['txtBdate', r_picd], ['txtEdate', r_picd],['txtBodate', r_picd], ['txtEodate', r_picd]];
                q_mask(bbmMask);
                
                q_cmbParse("cmbGweight", '@全部,0@未成交,1@成交');
                q_cmbParse("cmbEweight", '@全部,0@未填獎金,1@已填獎金');

                $('#txtBdate').focus();
            }

            function q_seekStr() {
                t_noa = $('#txtNoa').val();
                t_bdate = $('#txtBdate').val();
                t_edate = $('#txtEdate').val();
                t_bodate = $('#txtBodate').val();
                t_eodate = $('#txtEodate').val();
                t_custno = $('#txtCustno').val();
                t_salesno = $('#txtSalesno').val();
                t_sales = $('#txtSales').val();
                t_worker = $('#txtWorker').val();
                t_worker2 = $('#txtWorker2').val();
                t_cust = $('#txtCust').val();
                t_gweight = $('#cmbGweight').val();
                t_eweight = $('#cmbEweight').val();

                var t_where = " 1=1 " + q_sqlPara2("noa", t_noa)+ q_sqlPara2("datea", t_bdate, t_edate) 
                + q_sqlPara2("odate", t_bodate, t_eodate)  + q_sqlPara2("salesno", t_salesno)  
                + q_sqlPara2("worker", t_worker)+ q_sqlPara2("worker2", t_worker2)
                ;
				if (t_sales.length>0)
		        	t_where += " and charindex('"+t_sales+"',sales)>0";
		        	
		        if (t_gweight.length>0 || t_eweight.length>0){
					t_where += " and noa in ( select noa from view_quats where 1=1 "
					if (t_gweight.length>0)
						t_where += "and isnull(gweight,0)="+t_gweight+" ";
					if (t_eweight.length>0)
						t_where += "and isnull(eweight,0)="+t_eweight+" ";
					t_where += ")";
				}
		        	
		        if (t_cust.length>0)
					t_where="("+t_where+") and charindex('"+t_cust+"',comp)>0 ";
				else
					t_where +=q_sqlPara2("custno", t_custno);
		        	
                t_where = ' where=^^' + t_where + '^^ ';
                return t_where;
            }
		</script>
		<style type="text/css">
            .seek_tr {
                color: white;
                text-align: center;
                font-weight: bold;
                BACKGROUND-COLOR: #76a2fe
            }
		</style>
	</head>
	<body>
		<div style='width:400px; text-align:center;padding:15px;' >
			<table id="seek"  border="1"   cellpadding='3' cellspacing='2' style='width:100%;' >
				<tr class='seek_tr'>
					<td   style="width:35%;" ><a id='lblDatea'> </a></td>
					<td style="width:65%;  ">
						<input class="txt" id="txtBdate" type="text" style="width:90px; font-size:medium;" />
						<span style="display:inline-block; vertical-align:middle">&sim;</span>
						<input class="txt" id="txtEdate" type="text" style="width:93px; font-size:medium;" />
					</td>
				</tr>
				<tr class='seek_tr'>
					<td   style="width:35%;" ><a id='lblOdate'>報價日</a></td>
					<td style="width:65%;  ">
						<input class="txt" id="txtBodate" type="text" style="width:90px; font-size:medium;" />
						<span style="display:inline-block; vertical-align:middle">&sim;</span>
						<input class="txt" id="txtEodate" type="text" style="width:93px; font-size:medium;" />
					</td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblCustno'> </a></td>
					<td><input class="txt" id="txtCustno" type="text" style="width:215px; font-size:medium;" /></td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblCust'> </a></td>
					<td><input class="txt" id="txtCust" type="text" style="width:215px; font-size:medium;" /></td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblNoa'> </a></td>
					<td><input class="txt" id="txtNoa" type="text" style="width:215px; font-size:medium;" /></td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblSalesno'> </a></td>
					<td><input class="txt" id="txtSalesno" type="text" style="width:215px; font-size:medium;" /></td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblSales'> </a></td>
					<td><input class="txt" id="txtSales" type="text" style="width:215px; font-size:medium;" /></td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblWorker'>操作者</a></td>
					<td><input class="txt" id="txtWorker" type="text" style="width:215px; font-size:medium;" /></td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblWorker2'>修改者</a></td>
					<td><input class="txt" id="txtWorker2" type="text" style="width:215px; font-size:medium;" /></td>
				</tr>
				<tr class='seek_tr'>
	                <td class='seek'  style="width:20%;"><a>成交</a></td>
	                <td><select id="cmbGweight" class="txt c1" style="font-size:medium;"> </select></td>
	             </tr>
	             <tr class='seek_tr'>
	                <td class='seek'  style="width:20%;"><a>獎金</a></td>
	                <td><select id="cmbEweight" class="txt c1" style="font-size:medium;"> </select></td>
	             </tr>
			</table>
			<!--#include file="../inc/seek_ctrl.inc"-->
		</div>
	</body>
</html>

