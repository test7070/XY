<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title> </title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript">
		
			var q_name = 'pack2s', t_bbsTag = 'tbbs', t_content = " ", afilter = [], bbsKey = [], t_count = 0, as, brwCount2 = 3;
			var t_sqlname = 'pack2s_load'; t_postname = q_name;
			var isBott = false;  /// 是否已按過 最後一頁
			var afield, t_htm;
			var i, s1;
			var decbbs = ['inmount'];
			var decbbm = [];
			var q_readonly = [];
			var q_readonlys = [];
			var bbmNum = [];
			var bbsNum = [['txtInmount',10,0,1]];
			var bbmMask = [];
			var bbsMask = [];
			aPop = new Array();
			
			$(document).ready(function () {
				bbmKey = [];
				bbsKey = ['noa', 'noq'];
				if (location.href.indexOf('?') < 0)   // debug
				{
					location.href = location.href + "?;;;1=0";
					return;
				}
				if (!q_paraChk())
					return;
				
				main();
			});            /// end ready

			function main() {
				if (dataErr)  /// 載入資料錯誤
				{
					dataErr = false;
					return;
				}
				mainBrow(6, t_content, t_sqlname, t_postname);
			}

			function mainPost() {
				q_getFormat();
				bbsMask = [];
				q_mask(bbsMask);
			}

			function bbsAssign() {  /// 表身運算式
				for(var j = 0; j < q_bbsCount; j++) {
					if (!$('#btnMinus_' + j).hasClass('isAssign')) {
						$('#checkPackway_'+j).click(function() {
							t_IdSeq = -1;
                            q_bodyId($(this).attr('id'));
                            b_seq = t_IdSeq;
                            
                            var t_true=$('#checkPackway_'+b_seq).prop('checked');
                            
                            $('.checkway').prop('checked',false);
                            $('.txtway').val('');
                            
                           	if(t_true){
	                            $('#checkPackway_'+b_seq).prop('checked',true);
	                            $('#txtPackway_'+b_seq).val('1');
							}
						});
					}
				}
				_bbsAssign();
				$('#lblPack_s').text('包裝單位');
				$('#lblInmount_s').text('內包裝含商品數');
				for(var j = 0; j < q_bbsCount; j++) {
					if($('#txtPackway_'+j).val()=='1'){
						$('#checkPackway_'+j).prop('checked',true);
						break;
					}
				}
			}
			
			function btnOk() {
				sum();
				
				t_key = q_getHref();
				
				_btnOk(t_key[1], bbsKey[0], bbsKey[1], '', 2);  // (key_value, bbmKey[0], bbsKey[1], '', 2);
			}

			function bbsSave(as) {
				if (!as['pack'] ) {  // Dont Save Condition
					as[bbsKey[0]] = '';   /// noa  empty --> dont save
					return;
				}

				q_getId2('', as);  // write keys to as
				
				return true;

			}

			function btnModi() {
				var t_key = q_getHref();
				
				if (!t_key)
					return;
				
				_btnModi();
				$('.checkway').removeAttr('disabled');
			}
			
			function refresh() {
				_refresh();
			}
			
			function sum() { }
			
			var salrank=[];
			var salranks=[];
			function q_gtPost(t_postname) {  /// 資料下載後 ...
				switch (t_postname) {
					
				}  /// end switch
			}

			function readonly(t_para, empty) {
				_readonly(t_para, empty);
			}

			function btnMinus(id) {
				_btnMinus(id);
				sum();
			}

			function btnPlus(org_htm, dest_tag, afield) {
				_btnPlus(org_htm, dest_tag, afield);
				if (q_tables == 's')
					bbsAssign();  /// 表身運算式
			}

		</script>
		<style type="text/css">
            .seek_tr {
                color: white;
                text-align: center;
                font-weight: bold;
                BACKGROUND-COLOR: #76a2fe
            }
            .tbbs {
                font-size: 12pt;
                color: blue;
                text-align: left;
                border: 1px #DDDDDD solid;
                width: 100%;
                height: 100%;
            }
            .txt.c1 {
                width: 95%;
            }
            .td1 {
                width: 2%;
            }
            .td2 {
                width: 4%;
            }
            .td3 {
                width: 5%;
            }
            .td4 {
                width: 7%;
            }
            .txt.num {
                text-align: right;
            }

		</style>
	</head>
	<body>
		<div  id="dbbs"  >
			<table id="tbbs" class='tbbs'  border="2"  cellpadding='2' cellspacing='1'   >
				<tr style='color:White; background:#003366;' >
					<td align="center" style="width:1%;"><input class="btn"  id="btnPlus" type="button" value='+' style="font-weight: bold;"  /></td>
					<td align="center" style="width: 35%;"><a id='lblPack_s'> </a></td>
					<td align="center" style="width: 50%;"><a id='lblInmount_s'> </a></td>
					<td align="center" style="width: 14%;"><a id='lblPackway_xy'>常用單位</a></td>
				</tr>
				<tr style='background:#cad3ff;'>
					<td  align="center"><input class="btn"  id="btnMinus.*" type="button" value='-' style="font-weight: bold; "  /></td>
					<td>
						<input class="txt c1"  id="txtPack.*" type="text"  />
						<input class="txt c1"  id="txtNoa.*" type="hidden"  />
						<input id="txtNoq.*" type="hidden" />
					</td>
					<td><input class="txt num c1" id="txtInmount.*" type="text"  /></td>
					<td>
						<input class="txt c1 checkway" id="checkPackway.*" type="checkbox" disabled="disabled" />
						<input class="txt c1 txtway" id="txtPackway.*" type="hidden" />
					</td>
				</tr>
			</table>
			<!--#include file="../inc/pop_modi.inc"-->
		</div>
		<input id="q_sys" type="hidden" />
	</body>
</html>
