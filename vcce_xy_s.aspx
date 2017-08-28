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
		<script src="css/jquery/ui/jquery.ui.core.js"></script>
		<script src="css/jquery/ui/jquery.ui.widget.js"></script>
		<script src="css/jquery/ui/jquery.ui.datepicker_tw.js"></script>
		<script type="text/javascript">
            var q_name = "vcce_xy_s";
            var aPop = new Array(
				['txtSalesno', '', 'sss', 'noa,namea', 'txtSalesno,txtSales', ''],
				['txtDriverno', '', 'sss', 'noa,namea', 'txtDriverno,txtDriver', ''],
				['txtCustno', '', 'cust', 'noa,comp,nick,invoicetitle,serial', 'txtCustno,txtComp', '']
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
                $('#txtBdate').datepicker();
                $('#txtEdate').datepicker();
                $('#txtNoa').focus();
				
				$('#txtDriver').attr('disabled', 'disabled');
				$('#txtDriver').css('background', t_background2);
				$('#txtSales').attr('disabled', 'disabled');
				$('#txtSales').css('background', t_background2);
				$('#txtComp').attr('disabled', 'disabled');
				$('#txtComp').css('background', t_background2);
            }

            function q_seekStr() {
                t_noa = $.trim($('#txtNoa').val());
                t_driverno = $.trim($('#Driverno').val());
                t_carno = $.trim($('#txtCarno').val());
                t_salesno = $.trim($('#txtSalesno').val());
                t_vccno = $.trim($('#txtVccno').val());
                t_bdate = $.trim($('#txtBdate').val());
                t_edate = $.trim($('#txtEdate').val());
                t_custno = $.trim($('#txtCustno').val());

                var t_where = " 1=1 " + q_sqlPara2("noa", t_noa) 
                + q_sqlPara2("driverno", t_driverno) 
                + q_sqlPara2("carno", t_carno) 
                + q_sqlPara2("salesno", t_salesno) 
                + q_sqlPara2("datea", t_bdate, t_edate);

                if (t_vccno.length > 0)
                    t_where += " and noa in (select noa from view_vcces where ordeno='"+t_vccno+"')";
                    
                if (t_custno.length > 0)
                    t_where += " and noa in (select noa from view_vcces where custno='"+t_custno+"')";    

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
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();">
		<div style='width:400px; text-align:center;padding:15px;' >
			<table id="seek"  border="1"   cellpadding='3' cellspacing='2' style='width:100%;' >
				<tr class='seek_tr'>
					<td   style="width:35%;"><a id='lblDatea'> </a></td>
					<td style="width:65%;  ">
						<input class="txt" id="txtBdate" type="text" style="width:90px; font-size:medium;" />
						<span style="display:inline-block; vertical-align:middle">&sim;</span>
						<input class="txt" id="txtEdate" type="text" style="width:93px; font-size:medium;" />
					</td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblNoa'> </a></td>
					<td><input class="txt" id="txtNoa" type="text" style="width:215px; font-size:medium;" /></td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblCarno'> </a></td>
					<td><input class="txt" id="txtCarno" type="text" style="width:215px; font-size:medium;" /></td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblDriver'> </a></td>
					<td>
						<input class="txt" id="txtDriverno" type="text" style="width:90px; font-size:medium;" />
						&nbsp;
						<input class="txt" id="txtDriver" type="text" style="width:115px; font-size:medium;" />
					</td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblSales'> </a></td>
					<td>
						<input class="txt" id="txtSalesno" type="text" style="width:90px; font-size:medium;" />
						&nbsp;
						<input class="txt" id="txtSales" type="text" style="width:115px; font-size:medium;" />
					</td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblVccno'> </a></td>
					<td><input class="txt" id="txtVccno" type="text" style="width:215px; font-size:medium;" /></td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblCustno'> </a></td>
					<td>
						<input class="txt" id="txtCustno" type="text" style="width:90px; font-size:medium;" />
						&nbsp;
						<input class="txt" id="txtComp" type="text" style="width:115px; font-size:medium;" />
					</td>
				</tr>
			</table>
			<!--#include file="../inc/seek_ctrl.inc"-->
		</div>
	</body>
</html>
