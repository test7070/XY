<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title> </title>
		<script src="../script/jquery.min.js" type="text/javascript"> </script>
		<script src='../script/qj2.js' type="text/javascript"> </script>
		<script src='qset.js' type="text/javascript"> </script>
		<script src='../script/qj_mess.js' type="text/javascript"> </script>
		<script src='../script/mask.js' type="text/javascript"> </script>
        <link href="../qbox.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript">
			var q_name = "vcc_s";
            aPop = new Array( ['txtCustno', '', 'cust', 'noa,comp,nick,invoicetitle,serial', 'txtCustno', '']
            , ['txtSalesno', '', 'sss', 'noa,namea', 'txtSalesno', '']
            , ['txtCardealno', '', 'cardeal', 'noa,comp', 'txtCardealno', '']
            );
			$(document).ready(function() {
				main();
			});

			function main() {
				mainSeek();
				q_gf('', q_name);
			}

			function q_gfPost() {
				q_getFormat();
				q_langShow();

				bbmMask = [['txtMon', r_picm],['txtBdate', r_picd],['txtEdate', r_picd]];
				q_mask(bbmMask);
				q_gt('acomp', '', 0, 0, 0, "");
				q_gt('part', '', 0, 0, 0, "");
				q_cmbParse("cmbTypea", "@全部,1@出,2@退");
				q_cmbParse("cmbStatus", "@全部,Y@已收完,N@未收完");
				q_cmbParse("cmbStype", '@全部,'+q_getPara('vcc.stype'));
				q_cmbParse("cmbDime", "@全部,Y@已簽收,N@未簽收");
				q_cmbParse("cmbZipcode", "@全部,Y@已上傳簽收,N@未上傳簽收");
				q_cmbParse("cmbWidth", "@全部,Y@已驗收,N@未驗收");
				q_cmbParse("cmbTrantype",  '@全部,'+q_getPara('sys.tran'));
				
				q_cmbParse("cmbVcceenda", "@全部,Y@已送貨,N@未送貨"); //106/04/27 已送貨
				$('#txtNoa').focus();
			}
			function q_gtPost(t_name) {
                switch (t_name) {
                    case 'acomp':
                        t_acomp = '@全部';
                        var as = _q_appendData("acomp", "", true);
                        for ( i = 0; i < as.length; i++) {
                            t_acomp += (t_acomp.length > 0 ? ',' : '') + as[i].noa + '@' + as[i].acomp;
                        }
                        q_cmbParse("cmbCno", t_acomp);
                        break;
                    case 'part':
                        t_part = '@全部';
                        var as = _q_appendData("part", "", true);
                        for ( i = 0; i < as.length; i++) {
                            t_part += (t_part.length > 0 ? ',' : '') + as[i].noa + '@' + as[i].part;
                        }
                        q_cmbParse("cmbPart", t_part);
                        q_cmbParse("cmbPart2", t_part);
                        break;
                }
            }

			function q_seekStr() {
				t_typea=$('#cmbTypea').val();
				t_status = $('#cmbStatus').val();
				t_cno = $('#cmbCno').val();
				t_partno = $('#cmbPart').val();
				t_partno2 = $('#cmbPart2').val();
				t_noa = $.trim($('#txtNoa').val());
				t_mon = $('#txtMon').val();
				t_bdate = $('#txtBdate').val();
				t_edate = $('#txtEdate').val();
				t_custno = $.trim($('#txtCustno').val());
				t_accno = $('#txtAccno').val();
				t_invono = $('#txtInvono').val();
				t_ordeno = $('#txtOrdeno').val();
				t_salesno = $('#txtSalesno').val();
				t_stype = $('#cmbStype').val();
				t_memo = $('#txtMemo').val();
				t_dime=$('#cmbDime').val();//簽收
				t_zipcode=$('#cmbZipcode').val();//簽收上傳
				t_width=$('#cmbWidth').val();//驗收
				t_cardealno = $('#txtCardealno').val();
				t_trantype = $('#cmbTrantype').val();
				t_paytype = $('#txtPaytype').val();
				t_vcceenda = $('#cmbVcceenda').val();
				
				var t_where = " 1=1 "
				+ q_sqlPara2("typea", t_typea)
				+ q_sqlPara2("cno", t_cno)
				+ q_sqlPara2("partno", t_partno)
				+ q_sqlPara2("partno2", t_partno2)
				+q_sqlPara2("stype", t_stype)
				+ q_sqlPara2("noa", t_noa)
				+ q_sqlPara2("mon", t_mon)
				+ q_sqlPara2("datea", t_bdate, t_edate)
				+ q_sqlPara2("accno", t_accno)
				+ q_sqlPara2("custno", t_custno)
				+ q_sqlPara2("trantype", t_trantype)
				+ q_sqlPara2("cardealno", t_cardealno);
				
				if(t_invono.length>0)
					t_where += " and charindex('"+t_invono+"',invono)>0 ";	
				
				if(t_salesno.length>0)
					t_where += " and (salesno='"+t_salesno+"' or salesno2='"+t_salesno+"') ";
					
				if(t_memo.length>0)
					t_where += " and charindex('"+t_memo+"',memo)>0 ";	
				
                if(t_status=='Y')
                	t_where += " and unpay=0";
                if(t_status=='N')
                	t_where += " and unpay!=0";
                	
				if(t_ordeno.length>0)
                	t_where += " and (noa in (select noa from view_vccs where ordeno='"+t_ordeno+"') or noa in (select noa from view_vcc where ordeno='"+t_ordeno+"'))";
                
                //送貨
                if(t_vcceenda=='Y')
                	t_where += " and noa in (select ordeno from view_vcces where enda=1) ";
                if(t_vcceenda=='N')
                	t_where += " and noa in (select ordeno from view_vcces where enda=0) ";
                
                //簽收
                if(t_dime=='Y')
                	t_where += " and noa in (select ordeno from view_vcces where dime=1) ";
                if(t_dime=='N')
                	t_where += " and noa in (select ordeno from view_vcces where dime=0) ";
                	
                //簽收上傳
                if(t_zipcode=='Y')
                	t_where += " and isnull(zipcode,'')!='' ";
                if(t_zipcode=='N')
                	t_where += " and isnull(zipcode,'')='' ";
                	
                //驗收	
                if(t_width=='Y')
                	t_where += " and noa in (select ordeno from view_vcces where width=1) ";
                if(t_width=='N')
                	t_where += " and noa in (select ordeno from view_vcces where width=0 and charindex('不',class)==0) ";
				
				if(t_paytype=='N')
                	t_where += " and charindex('"+t_paytype+"',paytype)>0 ";	
                	
				t_where = ' where=^^ ' + t_where + ' ^^ ';
				return t_where;
			}
		</script>
		<style type="text/css">
			.seek_tr {
				color: white;
				text-align: center;
				font-weight: bold;
				background-color: #76a2fe
			}
			input{
				font-size: medium;
				width:95%;
			}
			select{
				font-size: medium;
				width:95%;
			}
		</style>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	>
		<div style="width:95%; text-align:center;padding:15px;" >
			<table id="seek" border="1" cellpadding="3" cellspacing="2" style="width:100%;">
				<tr class='seek_tr'>
					<td style="width: 15%;"><a id='lblTypea'> </a></td>
					<td style="width: 35%;"><select id="cmbTypea"> </select></td>
					<td style="width: 15%;"><a id='lblAcomp'> </a></td>
					<td style="width: 35%;"><select id="cmbCno"> </select></td>
				</tr>
				<tr class='seek_tr'>
					<td><a id='lblPart'> </a></td>
					<td><select id="cmbPart"> </select></td>
					<td><a id='lblPart2'> </a></td>
					<td><select id="cmbPart2"> </select></td>
				</tr>
				<tr class='seek_tr'>
					<td><a id='lblStatus'> </a></td>
					<td><select id="cmbStatus"> </select></td>
					<td><a id='lblStype'> </a></td>
	                <td><select id="cmbStype" class="txt c1" style="font-size:medium;"> </select></td>
				</tr>
				<tr class='seek_tr'>
					<td><a id='lblNoa'> </a></td>
					<td><input id="txtNoa" type="text"/></td>
					<td><a id='lblDatea'> </a></td>
					<td>
						<input id="txtBdate" type="text" style="width:40%; float:left;" />
						<span style="width:20px; display: block; float:left;">~</span>
						<input id="txtEdate" type="text" style="width:40%; float:left;" />
					</td>
				</tr>
				<tr class='seek_tr'>
					<td><a id='lblCustno'> </a></td>
					<td><input id="txtCustno" type="text"/></td>
					<td><a id='lblSalesno'> </a></td>
					<td><input id="txtSalesno" type="text"/></td>
				</tr>
				<tr class='seek_tr'>
					<td><a id='lblMon'> </a></td>
					<td><input id="txtMon" type="text" style="width:40%;"/></td>
					<td><a id='lblInvono'> </a></td>
					<td><input id="txtInvono" type="text"/></td>
				</tr>
				<tr class='seek_tr'>
					<td><a id='lblOrdeno'> </a></td>
					<td><input id="txtOrdeno" type="text"/></td>
					<td><a id='lblAccno'> </a></td>
					<td><input id="txtAccno" type="text"/></td>
				</tr>
				<tr class='seek_tr'>
					<td><a>送貨</a></td>
					<td><select id="cmbVcceenda"> </select></td>
					<td> </td>
					<td> </td>
				</tr>
				<tr class='seek_tr'>
					<td><a>簽收 </a></td>
					<td><select id="cmbDime"> </select></td>
					<td><a>簽收上傳</a></td>
					<td><select id="cmbZipcode"> </select></td>
				</tr>
				<tr class='seek_tr'>
					<td><a>交運方式 </a></td>
					<td><select id="cmbTrantype"> </select></td>
					<td><a>驗收</a></td>
					<td><select id="cmbWidth"> </select></td>
				</tr>
				<tr class='seek_tr'>
					<td><a id='lblCardealno'>車行</a></td>
					<td><input id="txtCardealno" type="text"/></td>
					<td><a id='lblPaytype'>收款方式</a></td>
					<td><input id="txtPaytype" type="text"/></td>
				</tr>
				<tr class='seek_tr'>
					<td><a id='lblMemo'>備註 </a></td>
					<td colspan="3"><input id="txtMemo" type="text"/></td>
				</tr>
				
			</table>
			<!--#include file="../inc/seek_ctrl.inc"-->
		</div>
	</body>
</html>