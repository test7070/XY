<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr">
	<head>
		<title> </title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
		<script src="css/jquery/ui/jquery.ui.core.js"></script>
		<script src="css/jquery/ui/jquery.ui.widget.js"></script>
		<script src="css/jquery/ui/jquery.ui.datepicker_tw.js"></script>
		<script type="text/javascript">
            this.errorHandler = null;

            function onPageError(error) {
                alert("An error occurred:\r\n" + error.Message);
            }

            q_desc = 1;
            q_tables = 's';
            var q_name = "cug";
            var q_readonly = ['txtNoa','txtWorker','txtWorker2','txtStation','txtProcess','txtKdate'];
            var q_readonlys = ['txtProductno','txtProduct','txtSpec','txtStyle'];
            var bbmNum = [];
            var bbsNum = [];
            var bbmMask = [];
            var bbsMask = [];
            q_sqlCount = 6;
            brwCount = 6;
            brwList = [];
            brwNowPage = 0;
            brwKey = 'noa';
            aPop = new Array(
            	['txtStationno', 'lblStation_xy', 'mech', 'noa,mech', 'txtStationno,txtStation', 'mech_b.aspx'],
            	['txtProcessno', 'lblProcess_xy', 'sss', 'noa,namea', 'txtProcessno,txtProcess', 'sss_b.aspx'],
            	['txtWorkno_', '', 'view_cub', 'noa,productno,product,spec,unit,mount', '0txtWorkno_,txtProductno_,txtProduct_,txtSpec_,txtStyle_,txtMount_', '']
            );
            
            $(document).ready(function() {
                bbmKey = ['noa'];
                bbsKey = ['noa', 'noq'];
                q_brwCount();
                q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy)
            }).mousedown(function(e) {
				if (!$('#div_row').is(':hidden')) {
					if (mouse_div) {
						$('#div_row').hide();
					}
					mouse_div = true;
				}
			});

            function main() {
                if (dataErr) {
                    dataErr = false;
                    return;
                }
                mainForm(1);
            }
			
			var t_bdate='';
			var t_edate='';
			var t_9=0;
			var t_13=0;
			var t_17=0;
            function mainPost() {
            	if(r_len==4){                	
                	$.datepicker.r_len=4;
					//$.datepicker.setDefaults($.datepicker.regional["ENG"]);
                }
                bbmMask = [['txtKdate', r_picd],['txtBdate', r_picd],['txtEdate', '99:99']];
                bbsMask = [['txtNos', '9999'],['txtCuadate', r_picd],['txtOrgcuadate', '99:99'],['txtUindate', r_picd],['txtOrguindate', '99:99']];
                bbsNum=[['txtMount',15,0,1],['txtHours',10,0,1]]
                q_getFormat();
                q_mask(bbmMask);
                
                q_cmbParse("combProcess", ',壓花輪,墨水,換版','s');
                
                $('#txtBdate').focusin(function() {
                	t_bdate=$('#txtBdate').val();
                	t_edate=$('#txtEdate').val();
                }).focusout(function() {
                	if(q_cur==1 || q_cur==2){
                		if(t_bdate!=$('#txtBdate').val() || t_edate!=$('#txtEdate').val()){
                			$('#txtCuadate_0').val($('#txtBdate').val());
                			$('#txtOrgcuadate_0').val($('#txtEdate').val());
                			changeetime(0);
                		}
                	}
                });
                
                $('#txtEdate').focusin(function() {
                	t_bdate=$('#txtBdate').val();
                	t_edate=$('#txtEdate').val();
                }).focusout(function() {
                	if(q_cur==1 || q_cur==2){
                		if(t_bdate!=$('#txtBdate').val() || t_edate!=$('#txtEdate').val()){
                			$('#txtCuadate_0').val($('#txtBdate').val());
                			$('#txtOrgcuadate_0').val($('#txtEdate').val());
                			changeetime(0);
                		}
                	}
                });
                
                $('#btnCub').click(function() {
                	if(q_cur==1 || q_cur==2){
                		if(emp($('#txtStationno').val())){
                			alert('請輸入機台!!');
                			return;
                		}
                		q_gt('mech', "where=^^noa='" +$('#txtStationno').val() + "'^^", 0, 0, 0, "getmech",r_accy,1);
                		var as = _q_appendData("mech", "", true);
						if (as[0] != undefined) {
							t_9=dec(as[0].gen);
							t_13=dec(as[0].dime1);
							t_17=dec(as[0].dime2);
							
							var c_9=dec(as[0].gen);
							var c_13=dec(as[0].dime1);
							var c_17=dec(as[0].dime2);
							
	                		var t_product=emp($('#txtProduct').val())?'#non':$('#txtProduct').val();
	                		var t_spec=emp($('#txtSpec').val())?'#non':$('#txtSpec').val();
	                		var t_size=$.trim($('#cmbSize').val());
	                		if(t_size.length>0){
	                			if(t_size=='9"'){
	                				c_13=0;
	                				c_17=0;
	                			}else if(t_size=='13"'){
	                				c_9=0;
	                				c_17=0;
	                			}else if(t_size=='17"'){
	                				c_9=0;
	                				c_13=0;
	                			}
	                		}
	                		
	                		t_spec=replaceAll(t_spec,'"','@$#');
	                		
	                		var t_paras = t_product+';'+t_spec+';'+c_9+';'+c_13+';'+c_17;
							q_func('qtxt.query.cubimport', 'cust_ucc_xy.txt,cubimport,' + t_paras);
						}else{
							alert('機台不存在!!');
						}
					}
				});
                
                //上方插入空白行
				$('#lblTop_row').mousedown(function(e) {
					if (e.button == 0) {
						mouse_div = false;
						q_bbs_addrow(row_bbsbbt, row_b_seq, 0);
						bbsAssign();
					}
				});
				
				//下方插入空白行
				$('#lblDown_row').mousedown(function(e) {
					if (e.button == 0) {
						mouse_div = false;
						q_bbs_addrow(row_bbsbbt, row_b_seq, 1);
						bbsAssign();
					}
				});
            }
            
            function q_boxClose(s2) {
                var ret;
                switch (b_pop) {
                    case q_name + '_s':
                        q_boxClose2(s2);
                        break;
                }
                b_pop = '';
            }
			
			var child_row = 0;//異動子階的欄位數
            function q_gtPost(t_name) {
                switch (t_name) {
                	
                    case q_name:
                        if (q_cur == 4)
                            q_Seek_gtPost();
                        break;
                }  /// end switch
            }

            function q_stPost() {
                if (!(q_cur == 1 || q_cur == 2))
                    return false;
                    
				//更新cub的預估完工日
				if(!emp($('#txtNoa').val()) && $('#txtNoa').val()!='AUTO'){
					q_func('qtxt.query.cugsup2cub', 'cust_ucc_xy.txt,cugsup2cub,' + $('#txtNoa').val());
				}
            }
			
            function btnOk() {
                var t_err = '';
                t_err = q_chkEmpField([['txtStationno', '機台'],['txtProcessno', '員工']]);
                if (t_err.length > 0) {
                    alert(t_err);
                    return;
                }
                var maxnoq='001';
                for (var i = 0; i < q_bbsCount; i++) {
                	$('txtNos_'+i).val('9000');
                	//noq 重新排序
                	if((!emp($('#txtWorkno_'+i).val()))){
						$('#txtNoq_'+i).val(maxnoq);
						maxnoq=('000'+(dec(maxnoq)+1)).slice(-3);
					}
                	if(!$('#chkIssel_'+i).prop('checked')){
                		$('#txtNosold_'+i).val('');
                	}
                }
                
                if (q_cur == 1)
                    $('#txtWorker').val(r_name);
                else
                    $('#txtWorker2').val(r_name);
								
				var t_noa = trim($('#txtNoa').val());
                var t_date = trim($('#txtKdate').val());

                if (t_noa.length == 0 || t_noa == "AUTO")
                    q_gtnoa(q_name, replaceAll(q_getPara('sys.key_cug') + (t_date.length == 0 ? q_date() : t_date), '/', ''));
                else
                    wrServer(t_noa);
            }

            function _btnSeek() {
                if (q_cur > 0 && q_cur < 4)// 1-3
                    return;
                q_box('cug_xy_s.aspx', q_name + '_s', "500px", "350px", q_getMsg("popSeek"));
            }

            function btnIns() {
                _btnIns();
                $('#txtNoa').val('AUTO');
                $('#txtKdate').val(q_date());
                $('#txtBdate').val(q_date());
                $('#txtEdate').val(padL(new Date().getHours(), '0', 2)+':'+padL(new Date().getMinutes(),'0',2));
                changecmbSize();
            }

            function btnModi() {
                if (emp($('#txtNoa').val()))
                    return;
                _btnModi();
                endashow();
                changecmbSize();
            }

            function btnPrint() {
                //q_box('z_cugp_xy.aspx', '', "95%", "95%", q_getMsg("popPrint"));
            }
			
			var issave=false;
            function wrServer(key_value) {
                var i;
                xmlSql = '';
                if (q_cur == 2)/// popSave
                    xmlSql = q_preXml();

                $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
                _btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
                issave=true;
            }
            
            var copy_row_b_seq = '';
            var copy_bbs_row;
            var row_b_seq = '';
            var row_bbsbbt = '';
            //控制滑鼠消失div
            var mouse_div = true;
            function bbsAssign() {
                for (var i = 0; i < q_bbsCount; i++) {
                	$('#lblNo_' + i).text(i + 1);
                    if (!$('#btnMinus_' + i).hasClass('isAssign')) {
                    	$('#combProcess_'+i).change(function() {
                    		t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							
							if(q_cur==1 || q_cur==2){
								var t_process=$(this).val();
								
	                    		$('#btnMinus_'+b_seq).click();
	                    		$('#combProcess_'+b_seq)[0].selectedIndex=0;
	                    		$('#txtWorkno_'+b_seq).val(t_process);
                    		}
						});
                    	
						$('#btnPlus_' + i).mousedown(function(e) {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(e.button==0){
								mouse_div = false;
								$('#div_row').css('top', e.pageY);
								$('#div_row').css('left', e.pageX);
								//顯示選單
								$('#div_row').show();
								//儲存選取的row
								row_b_seq = b_seq;
								//儲存要新增的地方
								row_bbsbbt = 'bbs';
							}
						});
						
						$('#txtCuadate_'+i).focusin(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
		                	t_bdate=$('#txtCuadate_'+b_seq).val();
		                	t_edate=$('#txtOrgcuadate_'+b_seq).val();
		                	
		                }).focusout(function() {
		                	t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
		                	if(q_cur==1 || q_cur==2){
		                		if(t_bdate!=$('#txtCuadate_'+b_seq).val() || t_edate!=$('#txtOrgcuadate_'+b_seq).val()){
		                			changeetime(b_seq);
		                		}
		                	}
		                });
						
						$('#txtOrgcuadate_'+i).focusin(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
		                	t_bdate=$('#txtCuadate_'+b_seq).val();
		                	t_edate=$('#txtOrgcuadate_'+b_seq).val();
		                	
		                }).focusout(function() {
		                	t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
		                	if(q_cur==1 || q_cur==2){
		                		if(t_bdate!=$('#txtCuadate_'+b_seq).val() || t_edate!=$('#txtOrgcuadate_'+b_seq).val()){
		                			changeetime(b_seq);
		                		}
		                	}
		                });
		                
		                $('#txtMount_'+i).change(function() {
		                	t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							var t_spec=$('#txtSpec_'+b_seq).val();
							var mount=$('#txtMount_'+b_seq).val();
							var t_gen=0;
							if(t_spec.indexOf('9"')>-1){
								t_gen=t_9;
							}else if(t_spec.indexOf('13"')>-1){
								t_gen=t_13;
							}else if(t_spec.indexOf('17"')>-1){
								t_gen=t_17;
							}
							$('#txtHours_'+b_seq).val(round(mount*t_gen,0));
							
							changeetime(b_seq);
						});
		                
		                $('#txtHours_'+i).change(function() {
		                	t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							changeetime(b_seq);
						});
						
						$('#btnDowntime_'+i).click(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							
							if(q_cur==1 || q_cur==2){
								for (var i = dec(b_seq); i < q_bbsCount; i++) {
									changeetime(i);
									if(i+1 < q_bbsCount){
										$('#txtCuadate_'+(i+1)).val($('#txtUindate_'+i).val());
										$('#txtOrgcuadate_'+(i+1)).val($('#txtOrguindate_'+i).val());
									}
								}
							}
						});
						
						$('#btnEnda_'+i).click(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(!emp($('#txtNoa').val()) && !emp($('#txtNoq_'+b_seq).val())){
								var t_worker=(q_date()+' '+padL(new Date().getHours(), '0', 2)+':'+padL(new Date().getMinutes(),'0',2)+':'+padL(new Date().getSeconds(),'0',2)+' '+r_name);
								if (confirm('製令單【'+$('#txtWorkno_'+b_seq).val()+'】確定要完工?\nPS.之前未完工製令也會強制完工')){
									var t_paras = $('#txtNoa').val()+';'+$('#txtNoq_'+b_seq).val()+';'+t_worker;
									q_func('qtxt.query.cugsenda', 'cust_ucc_xy.txt,cugsenda,' + t_paras);
								}
							}
						});
						
						$('#chkIssel_'+i).click(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							
							if($('#chkIssel_'+b_seq).prop('checked')){
								$('#txtNosold_'+b_seq).val(q_date()+' '+padL(new Date().getHours(), '0', 2)+':'+padL(new Date().getMinutes(),'0',2)+':'+padL(new Date().getSeconds(),'0',2)+' '+r_name);
							}else{
								$('#txtNosold_'+b_seq).val('');
							}
							
						});
					}
                }
                _bbsAssign();
                endashow();
            }

            function bbsSave(as) {
                if (!as['workno'] ) {//不存檔條件
                    as[bbsKey[1]] = '';
                    return;
                }
				
				as['stationno'] = abbm2['stationno'];
				as['station'] = abbm2['station'];
                q_nowf();

                return true;
            }

            function sum() {
               
            }

            function refresh(recno) {
                _refresh(recno);
                endashow();
            }

            function readonly(t_para, empty) {
                _readonly(t_para, empty);
                
                if(t_para){
	            	
	            }else{
	            	
	            }
	            
				for (var i = 0; i < q_bbsCount; i++) {
					if(q_cur==1 || q_cur==2){
						$('#btnPlus_'+i).removeAttr('disabled');
						$('#btnEnda_'+i).attr('disabled', 'disabled');
						$('#combProcess_'+i).removeAttr('disabled');
						$('#btnDowntime_'+i).removeAttr('disabled');
					}else{
						$('#btnPlus_'+i).attr('disabled', 'disabled');
						$('#btnEnda_'+i).removeAttr('disabled');
						$('#combProcess_'+i).attr('disabled', 'disabled');
						$('#btnDowntime_'+i).attr('disabled', 'disabled');
					}
				}
				endashow();
            }

            function btnMinus(id) {
                _btnMinus(id);
                sum();
                endashow();
            }

            function btnPlus(org_htm, dest_tag, afield) {
                _btnPlus(org_htm, dest_tag, afield);
            }

            function q_appendData(t_Table) {
                return _q_appendData(t_Table);
            }

            function btnSeek() {
                _btnSeek();
            }

            function btnTop() {
                _btnTop();
            }

            function btnPrev() {
                _btnPrev();
            }

            function btnPrevPage() {
                _btnPrevPage();
            }

            function btnNext() {
                _btnNext();
            }

            function btnNextPage() {
                _btnNextPage();
            }

            function btnBott() {
                _btnBott();
            }

            function q_brwAssign(s1) {
                _q_brwAssign(s1);
            }

            function btnDele() {
                _btnDele();
            }

            function btnCancel() {
                _btnCancel();
                endashow();
            }
            
            function q_popPost(s1) {
			   	switch (s1) {
					case 'txtStationno':
						changecmbSize();
						break;
			   	}
			}
			
			function changecmbSize() {
				$('#cmbSize').text('');
				if(!emp($('#txtStationno').val())){
					q_gt('mech', "where=^^noa='" +$('#txtStationno').val() + "'^^", 0, 0, 0, "getmech",r_accy,1);
                	var as = _q_appendData("mech", "", true);
					if (as[0] != undefined) {
						t_9=dec(as[0].gen);
						t_13=dec(as[0].dime1);
						t_17=dec(as[0].dime2);
						var t_size='@全部';
						if(t_9!=0)
							t_size=t_size+',9"';
						if(t_13!=0)
							t_size=t_size+',13"';
						if(t_17!=0)
							t_size=t_size+',17"';
						
						q_cmbParse("cmbSize", t_size);
					}
				}
			}
            
			function q_funcPost(t_func, result) {
                switch(t_func) {
                	case 'qtxt.query.cubimport':
                		var as = _q_appendData("tmp0", "", true, true);
                		if (as[0] != undefined) {
                			//移除相同的製令單
							for(var i = 0; i < as.length; i++){
								for (var j = 0; j < q_bbsCount; j++) {
									if(as[i].noa==$('#txtWorkno_'+j).val()){
										as.splice(i, 1);
										i--;
										break;
									}
								}
							}
                			
                			q_gridAddRow(bbsHtm, 'tbbs', 'txtWorkno,txtProductno,txtProduct,txtSpec,txtStyle,txtMount,txtHours', as.length, as, 'noa,productno,product,spec,unit,emount,ehours', 'txtWorkno');
                			
                			
		                	if(!emp($('#txtBdate').val()) && !emp($('#txtEdate').val())
		                		&&(emp($('#txtCuadate_0').val()) || emp($('#txtOrgcuadate_0').val()))
		                	){
		                		$('#txtCuadate_0').val($('#txtBdate').val());
		                		$('#txtOrgcuadate_0').val($('#txtEdate').val());
		                	}
		                	
                			
                			for (var i = dec(b_seq); i < q_bbsCount; i++) {
								changeetime(i);
								if(i+1 < q_bbsCount){
									$('#txtCuadate_'+(i+1)).val($('#txtUindate_'+i).val());
									$('#txtOrgcuadate_'+(i+1)).val($('#txtOrguindate_'+i).val());
								}
							}
                			
                		}else{
                			alert('無製令單!!');
                		}
                		break;
                	case 'qtxt.query.cugsenda':
                		var as = _q_appendData("tmp0", "", true, true);
                		if (as[0] != undefined) {
                        	if($('#txtNoa').val()==as[0].noa){
                        		for(var j = 0; j < q_bbsCount; j++) {
                        			for(var i = 0; i < as.length; i++) {
                        				if($('#txtNoa').val()==as[i].noa && $('#txtNoq_'+j).val()==as[i].noq){
                        					if(as[i].issel=='true' || as[i].issel=='1'){
                        						$('#chkIssel_'+j).prop('checked',true);
                        						abbs[j]['issel']='true';
                        						$('#txtNosold_'+j).val(as[i].nosold);
                        						abbs[j]['nosold']=as[i].nosold;
                        					}else{
                        						$('#chkIssel_'+j).prop('checked',false);
                        						abbs[j]['issel']='false';
                        					}
                        					break;	
                        				}
                        			}
                        		}
                        	}
                        }
                		endashow();
                		break;
                }
			}
			
			function FormatNumber(n) {
            	var xx = "";
            	if(n<0){
            		n = Math.abs(n);
            		xx = "-";
            	}     		
                n += "";
                var arr = n.split(".");
                var re = /(\d{1,3})(?=(\d{3})+$)/g;
                return xx+arr[0].replace(re, "$1,") + (arr.length == 2 ? "." + arr[1] : "");
            }
            
            function endashow() {
            	for (var i = 0; i < q_bbsCount; i++) {
            		if(q_cur==1 || q_cur==2){
            			$('#btnEnda_'+i).hide();
            			$('#chkIssel_'+i).show();	
            		}else{
            			if($('#chkIssel_'+i).prop('checked')){
            				$('#chkIssel_'+i).show();
            				$('#btnEnda_'+i).hide();
            			}else{
            				$('#btnEnda_'+i).show();
            				$('#chkIssel_'+i).hide();	
            			}
            		}
            	}
            }
            
            function changeetime(i) {
            	var t_dates=$('#txtCuadate_'+i).val();
            	var t_times=$('#txtOrgcuadate_'+i).val();
            	var t_mins=dec($('#txtHours_'+i).val());
            	
            	if(!emp(t_dates) && !emp(t_times)
            	&&(/^[0-9]{3,4}\/[0-9]{2}\/[0-9]{2}$/g).test(t_dates)
            	&&(/^[0-9]{2}\:[0-9]{2}$/g).test(t_times)){
            		var t_year='';
            		var t_mon='';
            		var t_date='';
            		var t_hour='';
            		var t_min='';
            		
            		t_year=dec(t_dates.substr(0,r_len));
            		if(r_len==3){
            			t_year=t_year+1911;
            		}
            		t_mon=dec(t_dates.substr(r_len+1,2))-1;
            		t_date=t_dates.substr(r_lenm+1,2);
            		t_hour=t_times.substr(0,2);
            		t_min=t_times.substr(3,2);
            		
            		var ttdate=new Date(t_year,t_mon,t_date,t_hour,t_min);
            		ttdate.setMinutes(ttdate.getMinutes()+t_mins);
            		
            		t_year=ttdate.getFullYear();
            		if(r_len==3){
            			t_year=t_year-1911;
            		}
            		t_mon=ttdate.getMonth()+1;
            		t_date=ttdate.getDate();
            		t_hour=ttdate.getHours();
            		t_min=ttdate.getMinutes();
            		
            		$('#txtUindate_'+i).val(t_year+'/'+('0'+t_mon).slice(-2)+'/'+('0'+t_date).slice(-2));
            		$('#txtOrguindate_'+i).val(('0'+t_hour).slice(-2)+':'+('0'+t_min).slice(-2));
            	}
            }
			
		</script>
		<style type="text/css">
            #dmain {
                overflow: hidden;
                width: 1240px;
            }
            .dview {
                float: left;
                width: 360px;
            }
            .tview {
                margin: 0;
                padding: 2px;
                border: 1px black double;
                border-spacing: 0;
                font-size: medium;
                background-color: #FFFF66;
                color: blue;
                width: 100%;
            }
            .tview td {
                padding: 2px;
                text-align: center;
                border: 1px black solid;
            }
            .dbbm {
                float: left;
                width: 870px;
                margin: -1px;
                border: 1px black solid;
                border-radius: 5px;
            }
            .tbbm {
                padding: 0px;
                border: 1px white double;
                border-spacing: 0;
                border-collapse: collapse;
                font-size: medium;
                color: blue;
                background: #cad3ff;
                width: 100%;
            }
            .tbbm tr {
                height: 35px;
            }
            .tbbm tr td {
                /*width: 9%;*/
            }
            .tbbm .tdZ {
                width: 2%;
            }
            .tbbm tr td span {
                float: right;
                display: block;
                width: 5px;
                height: 10px;
            }
            .tbbm tr td .lbl {
                float: right;
                color: blue;
                font-size: medium;
            }
            .tbbm tr td .lbl.btn {
                color: #4297D7;
                font-weight: bolder;
                font-size: medium;
            }
            .tbbm tr td .lbl.btn:hover {
                color: #FF8F19;
            }
            .txt.c1 {
                width: 98%;
                float: left;
            }
            .txt.c2 {
                width: 48%;
                float: right;
            }
            .txt.c3 {
                width: 50%;
                float: left;
            }
            .txt.c4 {
                width: 18%;
                float: left;
            }
            .txt.c5 {
                width: 100%;
                float: left;
            }
            .txt.c6 {
                width: 25%;
            }
            .txt.c7 {
                width: 95%;
                float: left;
            }
            .txt.num {
                text-align: right;
            }
            .tbbm td {
                margin: 0 -1px;
                padding: 0;
            }
            .tbbm td input[type="text"] {
                border-width: 1px;
                padding: 0px;
                margin: -1px;
                float: left;
            }
            .tbbm td input[type="button"] {
                float: left;
                width: auto;
            }
            .tbbm select {
                border-width: 1px;
                padding: 0px;
                margin: -1px;
            }
            .num {
                text-align: right;
            }
            input[type="text"], input[type="button"] {
                font-size: medium;
            }
            .tbbm select {
                font-size: medium;
            }
            .dbbs {
                width: 1240px;
                background:#cad3ff;
            }
            .tbbs a {
                font-size: medium;
            }
            input[type="text"], input[type="button"] {
                font-size: medium;
            }
            .tbbs tr.chkIssel { background:bisque;} 
		</style>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	>
		
		<!---DIV分隔線---->
		<div id="div_row" style="position:absolute; top:300px; left:500px; display:none; width:150px; background-color: #ffffff; ">
			<table id="table_row" class="table_row" style="width:100%;" border="1" cellpadding='1' cellspacing='0'>
				<tr>
					<td align="center" ><a id="lblTop_row" class="lbl btn">上方插入空白行</a></td>
				</tr>
				<tr>
					<td align="center" ><a id="lblDown_row" class="lbl btn">下方插入空白行</a></td>
				</tr>
			</table>
		</div>
		<!--#include file="../inc/toolbar.inc"-->
		<div id='dmain' >
			<div class="dview" id="dview">
				<table class="tview" id="tview">
					<tr>
						<td align="center" style="width:5%"><a id='vewChk'> </a></td>
						<td align="center" style="width:30%"><a id='vewKdate_xy'>製單日期</a></td>
						<td align="center" style="width:30%"><a id='vewStation_xy'>機台</a></td>
						<td align="center" style="width:30%"><a id='vewProcess_xy'>員工</a></td>
					</tr>
					<tr>
						<td >
						<input id="chkBrow.*" type="checkbox" style=''/>
						</td>
						<td align="center" id='kdate'>~kdate</td>
						<td align="center" id='station'>~station</td>
						<td align="center" id='process'>~process</td>
					</tr>
				</table>
			</div>
			<div class='dbbm'>
				<table class="tbbm"  id="tbbm">
					<tr>
						<td style="width: 105px;"><span> </span><a id='lblNoa_xy' class="lbl">排程單號</a></td>
						<td style="width: 206px;"><input id="txtNoa"  type="text" class="txt c1"/></td>
						<td style="width: 105px;"><span> </span><a id='lblKdate_xy' class="lbl">製單日期</a></td>
						<td style="width: 176px;"><input id="txtKdate"  type="text" class="txt c1"/></td>
						<td style="width: 105px;"> </td>
						<td style="width: 176px;"> </td>
					</tr>
					<tr>
						<td><span> </span><a id='lblStation_xy' class="lbl btn">機台</a></td>
						<td>
							<input id="txtStationno"  type="text" class="txt c2"/>
							<input id="txtStation"  type="text" class="txt c3"/>
						</td>
						<td><span> </span><a id='lblProcess_xy' class="lbl btn">員工</a></td>
						<td>
							<input id="txtProcessno"  type="text" class="txt c2"/>
							<input id="txtProcess"  type="text" class="txt c3"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id='lblProduct_xy' class="lbl">品名篩選</a></td>
						<td>
							<input id="txtProduct"  type="text" class="txt c1" style="width: 50%;" />
							<select id="cmbSize" style="font-size: medium;width: 40%;"> </select>
						</td>
						<td><span> </span><a id='lblSpec_xy' class="lbl">規格篩選</a></td>
						<td><input id="txtSpec"  type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblBdate_xy' class="lbl">開始日期</a></td>
						<td><input id="txtBdate"  type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblEdate_xy' class="lbl">開始時間</a></td>
						<td><input id="txtEdate"  type="text" class="txt c1"/></td>
						<td><input id="btnCub" type="button" value="製令匯入"></td>
					</tr>
					<tr>
						<td class="td1"><span> </span><a id='lblMemo' class="lbl"> </a></td>
						<td class="td2" colspan="5"><input id="txtMemo"  type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td class="td1"><span> </span><a id='lblWorker' class="lbl"> </a></td>
						<td class="td2"><input id="txtWorker"  type="text" class="txt c1"/></td>
						<td class="td3"><span> </span><a id='lblWorker2' class="lbl"> </a></td>
						<td class="td4"><input id="txtWorker2"  type="text" class="txt c1"/></td>
					</tr>
				</table>
			</div>
		</div>
		<div class='dbbs'>
			<table id="tbbs" class='tbbs'>
				<tr style='color:white; background:#003366;' >
					<td align="center" style="width:45px;"><input class="btn"  id="btnPlus" type="button" value='+' style="font-weight: bold;"  /></td>
					<td style="width:20px;"> </td>
					<td align="center" style="width:60px;display: none;"><a id='lblNos_xy_s'>排程<br>序號</a></td>
					<td align="center" style="width:130px;"><a id='lblWorkno_xy_s'>製令編號</a></td>
					<td align="center" style="width:100px;"><a id='lblProductno_s'> </a></td>
					<td align="center" style="width:120px;"><a id='lblProduct_s'> </a></td>
					<td align="center"><a id='lblSpec_s'> </a></td>
					<td align="center" style="width:40px;"><a id='lblStyle_xy_s'>單位 </a></td>
					<td align="center" style="width:80px;"><a id='lblMount_s'> </a></td>
					<td align="center" style="width:70px;"><a id='lblhours_xy_s'>工作時數(Min.)</a></td>
					<td align="center" style="width:80px;"><a id='lblCuadate_xy_s'>排產日期</a></td>
					<td align="center" style="width:75px;"><a id='lblOrgcuadate_xy_s'>排產時間</a></td>
					<td align="center" style="width:80px;"><a id='lblUindate_xy_s'>預估完成<br>日期</a></td>
					<td align="center" style="width:75px;"><a id='lblOrguindate_xy_s'>預估完成<br>時間</a></td>
					<td align="center" style="width:45px;"><a id='lblIssel_xy_s'>完工</a></td>
				</tr>
				<tr id="trSel.*">
					<td align="center">
						<input class="btn"  id="btnPlus.*" type="button" value='+'  style=" font-weight: bold;width: 26px;"/>
						<input class="btn"  id="btnMinus.*" type="button" value='-' style=" font-weight: bold;width: 26px;" />
					</td>
					<td><a id="lblNo.*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
					<td style="display: none;">
						<input id="txtNos.*" type="text" class="txt c1"/>
						<input id="txtNoq.*" type="hidden" class="txt c1"/>
					</td>
					<td>
						<input id="txtWorkno.*" type="text" class="txt c1" style="width: 80%;"/>
						<select id="combProcess.*" style="font-size: medium;width: 20px;"> </select>
					</td>
					<td><input id="txtProductno.*" type="text" class="txt c1"/></td>
					<td><input id="txtProduct.*" type="text" class="txt c1"/></td>
					<td><input id="txtSpec.*" type="text" class="txt c1"/></td>
					<td><input id="txtStyle.*" type="text" class="txt c1"/></td>
					<td><input id="txtMount.*" type="text" class="txt num c1"/></td>
					<td><input id="txtHours.*" type="text" class="txt num c1"/></td>
					<td><input id="txtCuadate.*" type="text" class="txt c1"/></td>
					<td>
						<input id="txtOrgcuadate.*" type="text" class="txt c1" style="width: 45px;"/>
						<input id="btnDowntime.*" type="button" value="↓">
					</td>
					<td><input id="txtUindate.*" type="text" class="txt c1"/></td>
					<td><input id="txtOrguindate.*" type="text" class="txt c1"/></td>
					<td>
						<input id="chkIssel.*" type="checkbox" class="txt c1" style="display: none;"/>
						<input id="txtNosold.*" type="hidden" class="txt c1"/><!--紀錄按完工的時間-->
						<input id="btnEnda.*" type="button" value="完工" >
					</td>
				</tr>
			</table>
		</div>
		<input id="q_sys" type="hidden" />
	</body>
</html>
