<%@ Page Language="C#" Debug="true" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr">
	<head>
		<title>新版改版上傳</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />

		<script type="text/javascript">
            var q_name = 'uploaddc';
            $(document).ready(function() {
                _q_boxClose();
                q_getId();
                q_gf('', 'uploaddc');
                $('#btnUpload').click(function() {
                    $('#txtAddr').val(location.href);
                });
                $('#btnFile1').click(function() {
                    $('#txtAddr').val(location.href);
                    $('#TextBox1').val(location.href);
                });
                $('#btnAuthority').click(function() {
                    btnAuthority(q_name);
                });
            });

            function q_gfPost() {
                q_langShow();
                $('#txtUserno').val(r_userno);
                if(window.parent.q_name=='cub'){
                	$('#txtCustno').val(window.parent.$('#txtCustno').val());	
                	$('#txtComp').val(window.parent.$('#txtComp').val());	
                }
                if(window.parent.q_name=='ordc'){ //只抓第一個客戶 //10/19 採購暫時不做
                	$('#txtCustno').val(window.parent.$('#txtCustno_0').val());	
                }
            }
            
            function q_gtPost(t_name) {
                switch (t_name) {
                }
            }

            function getAddr() {
                document.getElementsByName('TextBox1').value = location.href;
            }
            
            if(navigator.appName=="Microsoft Internet Explorer"){
            	window.onbeforeunload = function(e){
					 if(window.parent.q_name=='cub'){
						 var wParent = window.parent.document;
						 wParent.getElementById("txtVcceno").value=$('#txtNoa').val();
					 }
				}
            }else{
            	window.onunload = function(e){
					  if(window.parent.q_name=='cub'){
						 var wParent = window.parent.document;
						 wParent.getElementById("txtVcceno").value=$('#txtNoa').val();
					 }
				}
            }
		</script>

		<script language="c#" runat="server">
			System.IO.MemoryStream stream = new System.IO.MemoryStream();
        	string connectionString = "";
	        public void Page_Load()
	        {
	            Encoding encoding = System.Text.Encoding.UTF8;
	            Response.ContentEncoding = encoding;
	            int formSize = Request.TotalBytes,i;
	            byte[] formData = Request.BinaryRead(formSize);
	            byte[] bCrLf = { 0xd, 0xa };// \r\n
	
	            string savepath = "F:\\doc\\cust\\";
	
	            string[] s2 = HttpContext.Current.Request.Path.Split('/');
	            if (s2.Length < 2)
	            {
	                Response.Write("<br>Path Error=" + HttpContext.Current.Request.Path + "</br>");
	                return;
	            }
	
	            string t_userno = Request.Form["txtUserno"];
	            string t_custno = Request.Form["txtCustno"];
                DateTime time = DateTime.Now;
                string t_datea = (time.Year - 1911).ToString("000") + "/" + time.Month.ToString("00") + "/" + time.Day.ToString("00");
                long t_now = (long)DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc)).TotalMilliseconds;
                string g = Guid.NewGuid().ToString().Replace("-", "").Substring(0, 16);
                string t_noa = "";
                
	            var tmp = Request.Form["btnAuthority"];
	
	            if (formSize == 0)
	            {
	                return;
	            }
	
	            //origin
	            string origin = encoding.GetString(formData);
	            // sign
	            int nSign = IndexOf(formData, bCrLf);
	            if (nSign == -1)
	            {
	                Response.Write("<br>" + "Error_1: token sign error!" + "</br>");
	                return;
	            }
	            byte[] sign = new byte[nSign];
	            Array.ConstrainedCopy(formData, 0, sign, 0, nSign);
	            string cSign = encoding.GetString(sign);
	            byte[] signStr = new byte[nSign + 2];
	            Array.ConstrainedCopy(sign, 0, signStr, 0, nSign);
	            Array.ConstrainedCopy(bCrLf, 0, signStr, nSign, 2);
	            string cSignStr = encoding.GetString(signStr);
	            byte[] signEnd = new byte[nSign + 2];
	            Array.ConstrainedCopy(sign, 0, signEnd, 0, nSign);
	            Array.ConstrainedCopy((new byte[] { 0x2d, 0x2d }), 0, signEnd, nSign, 2);//add --
	            string cSignEnd = encoding.GetString(signEnd);
	
	            Array[] item = new Array[2];
	            ArrayList items = new ArrayList();
	
	            byte[] temp = new byte[formData.Length];
	            byte[] temp2 = null;
	            byte[] temp3 = null;
	            int str, end;
	            Array.ConstrainedCopy(formData, 0, temp, 0, temp.Length);
	            try
	            {
	                while (true)
	                {
	                    if (IndexOf(temp, sign) == -1)
	                        break;
	                    else
	                    {
	                        str = IndexOf(temp, signStr);
	                        if (str == -1)
	                        {
	                            //Response.Write("<br>end</br>");     
	                            break;
	                        }
	
	                        temp2 = new byte[temp.Length - (str + signStr.Length)];
	                        Array.ConstrainedCopy(temp, str + signStr.Length, temp2, 0, temp2.Length);
	                        end = IndexOf(temp2, signStr);
	                        end = (end == -1 ? IndexOf(temp2, signEnd) : end);
	                        if (end == -1)
	                        {
	                            Response.Write("<br>Struct error!</br>");
	                            break;
	                        }
	                        item = new Array[2];
	                        temp3 = new byte[end];
	                        Array.ConstrainedCopy(temp2, 0, temp3, 0, temp3.Length);
	                        str = IndexOf(temp3, (new byte[] { 0xd, 0xa, 0xd, 0xa }));
	                        item[0] = new byte[str];
	                        Array.ConstrainedCopy(temp3, 0, item[0], 0, item[0].Length);
	                        item[1] = new byte[temp3.Length - (str + 4)-2];
	                        Array.ConstrainedCopy(temp3, str + 4, item[1], 0, item[1].Length);
	                        items.Add(item);
	
	                        temp = new byte[temp2.Length - end];
	                        Array.ConstrainedCopy(temp2, end, temp, 0, temp.Length);
	                    }
	                }
	
	                IEnumerator e = items.GetEnumerator();
	                while (e.MoveNext())
	                {
	                    Array[] obj = (Array[])e.Current;
	                    string header = encoding.GetString((byte[])obj[0]);
	                    int nFileNameStr = header.IndexOf("filename=\"") + 10;
	                    if (nFileNameStr >= 10)
	                    {
	                        string path = header.Substring(nFileNameStr, header.IndexOf("\"", nFileNameStr) - nFileNameStr);
                            string ofilename = System.IO.Path.GetFileName(path);
                            string filename = g + t_now.ToString();
	                        if (filename.Length != 0)
	                        {
	                            try
	                            {
	                                end = ofilename.LastIndexOf(".");
	                                if (end < 0)
	                                {
	                                    Response.Write("<br>" + ofilename + " Error </br>");
	                                    return;
	                                }

                                    System.IO.FileStream fs = new System.IO.FileStream(savepath + filename + ofilename.Substring(end), System.IO.FileMode.OpenOrCreate);
									filename = filename + ofilename.Substring(end);
									
	                                System.IO.BinaryWriter w = new System.IO.BinaryWriter(fs);
	                                w.Write((byte[])obj[1]);
	                                w.Close();
	                                fs.Close();
	                                
	                                string db = "st";
						        	if(Request.QueryString["db"] !=null && Request.QueryString["db"].Length>0)
										db= Request.QueryString["db"];
										connectionString = "Data Source=127.0.0.1,1799;Persist Security Info=True;User ID=sa;Password=artsql963;Database="+db;
									
									//資料
						            System.Data.DataTable dt = new System.Data.DataTable();
						            using (System.Data.SqlClient.SqlConnection connSource = new System.Data.SqlClient.SqlConnection(connectionString))
						            {
										System.Data.SqlClient.SqlDataAdapter adapter = new System.Data.SqlClient.SqlDataAdapter();
						                connSource.Open();
						                string queryString = @"
                                            declare @noa nvarchar(50)=REPLACE(@datea,'/','')
                                            +right('000'+cast(cast(right(isnull((select top 1 noa from upcust where noa like REPLACE(@datea,'/','')+'%' order by noa desc),'000'),3) as int)+1 as nvarchar(10)),3)
                                            
                                            declare @t_userno nvarchar(50)=@userno
                                            declare @t_custno nvarchar(50)=@custno
                                            declare @t_datea nvarchar(50)=@datea
                                            declare @t_ofilename nvarchar(50)=@ofilename
                                            declare @t_filename nvarchar(50)=@filename

											EXEC('insert upcust (noa,datea,typea,custno,comp,nick,memo,worker,worker2)
											select '''+@noa+''','''+@t_datea+''',''CUBAUTO''
											,'''+@t_custno+''',(select comp from cust where noa='''+@t_custno+''')
											,(select nick from cust where noa='''+@t_custno+''')
											,'''',(select namea from nhpe where noa='''+@t_userno+'''),'''' ')

                                            EXEC('insert upcusts (noa,noq,namea,files,filesname,memo)
											select '''+@noa+''',''001'','''','''+@t_filename+''','''+@t_ofilename+''','''' ')

                                            select @noa
										";
						                System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(queryString, connSource);
                                        cmd.Parameters.AddWithValue("@userno", t_userno);
                                        cmd.Parameters.AddWithValue("@custno", t_custno);
                                        cmd.Parameters.AddWithValue("@datea", t_datea);
						                cmd.Parameters.AddWithValue("@ofilename", ofilename);
                                        cmd.Parameters.AddWithValue("@filename", filename);
						                adapter.SelectCommand = cmd;
						                adapter.Fill(dt);
						                connSource.Close();
						            }

                                    foreach (System.Data.DataRow r in dt.Rows)
                                    {
                                        t_noa = System.DBNull.Value.Equals(r.ItemArray[0]) ? "" : (System.String)r.ItemArray[0];
                                    }
                                    
                                    var script = "$('#txtNoa').val('"+t_noa+"');if(window.parent.q_name=='cub'){window.parent.$('#txtVcceno').val('"+t_noa+"')}";
	            					ClientScript.RegisterStartupScript(typeof(string), "textvaluesetter", script, true);
									
	                                Response.Write("<br>" + ofilename + "  upload finish!" + "</br>");
	                            }
	                            catch (System.Exception se)
	                            {
	                                Response.Write("<br>" + se.Message + "</br>");
	                            }
	                        }
	                    }
	                }
	            }
	            catch (System.Exception e)
	            {
	                Response.Write("<br>" + e.Message + "</br>");
	            }
	        }
	
	        public int IndexOf(byte[] ByteArrayToSearch, byte[] ByteArrayToFind)
	        {
	            Encoding encoding = Encoding.ASCII;
	            string toSearch = encoding.GetString(ByteArrayToSearch, 0, ByteArrayToSearch.Length);
	            string toFind = encoding.GetString(ByteArrayToFind, 0, ByteArrayToFind.Length);
	            int result = toSearch.IndexOf(toFind, StringComparison.Ordinal);
	            return result;
	        }
	
	    </script>
		<style type="text/css">
            .style1 {
                font-family: 標楷體;
                color: #0066FF;
                font-size: x-large;
            }
		</style>
	</head>
	<body>
		<div id='q_menu'> </div>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type='button' id='btnAuthority' name='btnAuthority' style='font-size:16px;' value='權限'/>

		<p>
			&nbsp;
		</p>
		<div>
			<form id="Form1" name='form1' method='post' action=' ' runat="server" enctype='multipart/form-data' style='width:725px;'>
				<input type='file' name='btnFile1' style='font-size:16px;' onclick='getAddr()'/>
				<input type='hidden' name='txtAddr' style='font-size:16px;'/>
				<asp:TextBox ID="TextBox1"  name="TextBox1" runat="server" Visible="false"></asp:TextBox>
				<input type='submit' name='btnUpload' value='上傳' style='font-size:16px;'/>
				<BR><BR>
				<input id="txtUserno" name="txtUserno" type="hidden"/>
				<input id="txtCustno" name="txtCustno" type="hidden"/>
				<BR>
				<a>客戶名稱 </a><input id="txtComp" name="txtComp" type="text" disabled="disabled"/>
                <input id="txtNoa"  name="txtNoa" type="hidden" />
			</form>
		</div>

	</body>
</html>

