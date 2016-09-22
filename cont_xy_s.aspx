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
		<script type="text/javascript">
            var q_name = "contst_xy_s";
            var aPop = new Array(
            	['txtCustno', 'lblCustno', 'cust', 'noa,comp,nick,invoicetitle,serial', 'txtCustno,txtComp', 'cust_b.aspx'],
            	['txtSalesno', 'lblSalesno', 'sss', 'noa,namea', 'txtSalesno,txtSales', 'sss_b.aspx']
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
                bbmMask = [['txtBdate', r_picd], ['txtEdate', r_picd]];
                q_mask(bbmMask);

            }

            function q_seekStr() {
                t_noa = $('#txtNoa').val();
                t_contract = $('#txtContract').val();
                t_bdate = $('#txtBdate').val();
                t_edate = $('#txtEdate').val();
                t_custno = $('#txtCustno').val();
                t_salesno = $('#txtSalesno').val();

                var t_where = " 1=1 " + q_sqlPara2("noa", t_noa) + q_sqlPara2("contract", t_contract) 
                + q_sqlPara2("datea", t_bdate, t_edate) + q_sqlPara2("custno", t_custno) + q_sqlPara2("salesno", t_salesno)
                ;

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
					<td class='seek'  style="width:30%;"><a id='lblNoa'>單據編號</a></td>
					<td><input class="txt" id="txtNoa" type="text" style="width:215px; font-size:medium;" /></td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:30%;"><a id='lblContract'>PO</a></td>
					<td><input class="txt" id="txtContract" type="text" style="width:215px; font-size:medium;" /></td>
				</tr>
				<tr class='seek_tr'>
					<td   style="width:35%;" ><a id='lblDatea'>簽約日期</a></td>
					<td style="width:65%;  ">
					<input class="txt" id="txtBdate" type="text" style="width:90px; font-size:medium;" />
					<span style="display:inline-block; vertical-align:middle">&sim;</span>
					<input class="txt" id="txtEdate" type="text" style="width:93px; font-size:medium;" />
					</td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblCustno'>客戶</a></td>
					<td>
						<input class="txt" id="txtCustno" type="text" style="width:90px;" />
						&nbsp;
						<input class="txt" id="txtComp" type="text" style="width:120px;" disabled="disabled" />
					</td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblSalesno'>業務</a></td>
					<td>
						<input class="txt" id="txtSalesno" type="text" style="width:90px;" />
						&nbsp;
						<input class="txt" id="txtSales" type="text" style="width:120px;" disabled="disabled" />
					</td>
				</tr>
			</table>
			<!--#include file="../inc/seek_ctrl.inc"-->
		</div>
	</body>
</html>