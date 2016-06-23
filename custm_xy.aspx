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
			var q_name = 'custm', t_bbsTag = 'tbbs', t_content = " ", afilter = [], t_count = 0, as, brwCount2 = 15;
			var t_sqlname = 'custm_load'; t_postname = q_name;
			var isBott = false;
			var afield, t_htm;
			var i, s1;
			aPop = new Array(
				['txtInvocustno', '', 'cust', 'noa,comp,nick,tel,invoicetitle', 'txtInvocustno', 'cust_b.aspx'],
				['txtVcccustno', '', 'cust', 'noa,comp,nick,tel,invoicetitle', 'txtVcccustno', 'cust_b.aspx']
			);
			
			var decbbs = [];
			var decbbm = [];
			var q_readonly = [];
			var q_readonlys = [];
			var bbmNum = [];
			var bbsNum = [];
			var bbmMask = [];
			var bbsMask = [];
			var bbmKey = ['noa'], bbsKey = ['noa', 'noq'];
			q_tables = 's';
			
			$(document).ready(function () {
				if (location.href.indexOf('?') < 0)   // debug
				{
					location.href = location.href + "?;;;noa='0015'";
					return;
				}
				if (!q_paraChk()) {
					return;
				}
				main();
			});                  /// end ready
			
			function main() {
				if (dataErr)
				{
					dataErr = false;
					return;
				}
				
				mainBrow(6, t_content, t_sqlname, t_postname, r_accy);
			}
			
			function mainPost(){
				q_mask(bbmMask);
				$('#txtNoa').val(q_getHref()[1]);
				
				$('#txtCommission').keyup(function(e) {
					if(e.which>=37 && e.which<=40){return;}
					var tmp=$('#txtCommission').val();
					tmp=tmp.match(/\d{1,3}\.{0,1}\d{0,2}/);
					$('#txtCommission').val(tmp);
				});
				$('#txtTranprice').keyup(function(e) {
					if(e.which>=37 && e.which<=40){return;}
					var tmp=$('#txtCommission').val();
					tmp=tmp.match(/\d{1,3}\.{0,1}\d{0,2}/);
					$('#txtCommission').val(tmp);
				});
				
				var xy_taxtype='',xy_taxtmp=q_getPara('sys.taxtype').split(',');
				for(var i=0;i<xy_taxtmp.length;i++)
					xy_taxtype=xy_taxtype+(xy_taxtype.length>0?',':'')+xy_taxtmp[i].split('@')[1]+'@'+xy_taxtmp[i].split('@')[1];
				q_cmbParse("cmbTaxtype", xy_taxtype);	
				q_cmbParse("cmbVccmemo", '@,須@須,不須@不須');
				q_cmbParse("cmbCheckmemo", '@,須@須,不須@不須');
				q_cmbParse("cmbInvomemo", '@,隨貨@隨貨,月結@月結,週結@週結,PO@PO');
				q_cmbParse("cmbPostmemo", '@,不寄單@不寄單,不寄單扣貨款@不寄單扣貨款,送單收現@送單收現,送單@送單,郵寄附回郵@郵寄附回郵,郵寄@郵寄,郵寄附回郵不寄單@郵寄附回郵不寄單');
				
			}
			
			function bbsAssign() {
				_bbsAssign();
				for (var j = 0; j < (q_bbsCount == 0 ? 1 : q_bbsCount); j++) {
					$('#btnMinus_' + j).click(function () { 
						btnMinus($(this).attr('id')); 
					});
				} //j
			}
			
			function btnOk() {
				t_key = q_getHref();
				
				_btnOk(t_key[1], bbsKey[0], bbsKey[1], '', 2); 
			}
			
			function bbsSave(as) {
				if (!as['account'] && !as['bankno'] && !as['bank'] ) {  // Dont Save Condition
					as[bbsKey[0]] = '';   /// noa  empty --> dont save
					return;
				}
				t_key = q_getHref();
				as[bbmKey[0]] = t_key[1];
				q_getId2( '' , as);  // write keys to as
				return true;
			}
			
			function btnModi() {
				var t_key = q_getHref();
				if (!t_key)
					return;
				_btnModi();
			}
			
			function refresh() {
				_refresh();
			}
						
			function readonly(t_para, empty) {
				_readonly(t_para, empty);
			}
			
			function btnMinus(id) {
				_btnMinus(id);
			}
			
			function btnPlus(org_htm, dest_tag, afield) {
				_btnPlus(org_htm, dest_tag, afield);
				if (q_tables == 's')
					bbsAssign();
			}

		</script>
	</head>
	<body>
		<div style="float:left;width:100%;margin-bottom: 10px;">
			<div class='dbbm' style="width: 100%;">
				<table class="tbbm"  id="tbbm"   border="0" cellpadding='2'  cellspacing='0'>
					<tr style="height: 1px;">
						<td style="width: 80px;"> </td>
						<td style="width: 20%;"> </td>
						<td style="width: 80px;"> </td>
						<td style="width: 20%;"> </td>
						<td style="width: 80px;"> </td>
						<td style="width: 20%;"> </td>
					</tr>
					<tr>
						<td style="width: 80px;"><a id="lblConn"> </a></td>
						<td colspan="3"><input id="txtConn" type="text" style='width:100%;'/></td>
						<td> </td>
						<td><input id="txtNoa" type="hidden" /></td>
					</tr>
					<tr>
						<td><a id="lblTrantime"> </a></td>
						<td><input id="txtTrantime" type="text" style='width:100%;'/></td>
						<td><a id="lblTranprice"> </a></td>
						<td><input id="txtTranprice" type="text" style='width:100%;text-align: right;'/></td>
						<td> </td>
						<td> </td>
					</tr>
					<tr>
						<td><a>貨單開立</a></td>
						<td><select id="cmbVccmemo"  style='width:98%;'> </select></td>
						<td><a id="lblTaxtype"> </a></td>
						<td><select id="cmbTaxtype"  style='width:98%;'> </select></td>
						<td><a>驗單需求</a></td>
						<td><select id="cmbCheckmemo"  style='width:98%;'> </select></td>
					</tr>
					<tr>
						<td><a>發票開立</a></td>
						<td><select id="cmbInvomemo"  style='width:98%;'> </select></td>
						<td style="width: 70px;">發票<a id="lblP23"> </a></td>
						<td><input id="txtP23" maxlength="10" type="text" style="width:50%;" /></td>
						<td><a>發票客編</a></td>
						<td><input id="txtInvocustno" type="text" style='width:98%;'/></td>
					</tr>
					<tr>
						<td><a>寄單方式</a></td>
						<td><select id="cmbPostmemo"  style='width:98%;'> </select></td>
						<td><a id="lblCommission"> </a></td>
						<td><input id="txtCommission" type="text" style='width:50%;text-align: right;'/>%</td>
						<td><a>對帳客編</a></td>
						<td><input id="txtVcccustno" type="text" style='width:98%;'/></td>
					</tr>
					<tr>
						<td colspan="2">
							<input id="chkIsfranchisestore" type="checkbox" />
							<span> </span><a id="lblIsfranchisestore"> </a>
						</td>
						<td colspan="2">
							<input id="chkNotprice" type="checkbox" />
							<span> </span><a id="lblNotprice"> </a>
						</td>
					</tr>
				</table>
			</div>
			<div id="dbbs" class='dbbs' >
				<table id="tbbs" class='tbbs'  border="1"  cellpadding='2' cellspacing='1'  >
					<tr style='color:White; background:#003366;' >
						<td align="center"><input class="btn"  id="btnPlus" type="button" value='+' style="font-weight: bold;"  /></td>
						<td align="center"><a id='lblAccount'> </a></td>
						<td align="center"><a id='lblBankno'> </a></td>
						<td align="center"><a id='lblBank'> </a></td>
					</tr>
					<tr  style='background:#cad3ff;'>
						<td style="width:1%;"  align="center">
							<input class="btn"  id="btnMinus.*" type="button" value='-' style=" font-weight: bold;" />
							<input id="txtNoa.*" type="hidden" />
							<input id="txtNoq.*" type="hidden" />
							<input id="recno.*" type="hidden" />
						</td>
						<td style="width:10%;"><input class="txt" id="txtAccount.*" maxlength='23'type="text" style="width:98%;"/></td>
						<td style="width:10%;"><input class="txt" id="txtBankno.*" maxlength='16'type="text" style="width:98%;"/></td>
						<td style="width:10%;"><input class="txt" id="txtBank.*" maxlength='28'type="text" style="width:98%;"/></td>
					</tr>
				</table>
			</div>
		</div>
		<div>
			<!--#include file="../inc/pop_modi.inc"-->
		</div>
		<input id="q_sys" type="hidden" />
	</body>
</html>
