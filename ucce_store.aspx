 <%@ Page Language="C#" Debug="true"%>
    <script language="c#" runat="server">     
        public class ParaIn
        {
            public string userno,namea;
        }
        
        public void Page_Load()
        {
            System.Text.Encoding encoding = System.Text.Encoding.UTF8;
            Response.ContentEncoding = encoding;
            int formSize = Request.TotalBytes;
            byte[] formData = Request.BinaryRead(formSize);
            System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            string t_out = "";
            try
            {
	            string t_db = HttpUtility.UrlDecode(Request.Headers["database"]);
	            if (t_db == null || t_db.Length == 0)
	                t_db = "st";
	
	            var itemIn = serializer.Deserialize<ParaIn>(encoding.GetString(formData));
	            if (itemIn == null)
	            {
	                ParaIn para = new ParaIn();

                    para.userno = "Z001";  // 使用者編號
                    para.namea = "軒威電腦";  // 使用者名稱
	                itemIn = para;
	            }
	             
				string DCConnectionString = "Data Source=127.0.0.1,1799;Persist Security Info=True;User ID=sa;Password=artsql963;Database=" + t_db;
	            System.Data.DataTable dt = new System.Data.DataTable();   
                using (System.Data.SqlClient.SqlConnection connSource = new System.Data.SqlClient.SqlConnection(DCConnectionString))
                {
                    System.Data.SqlClient.SqlDataAdapter adapter = new System.Data.SqlClient.SqlDataAdapter();
                    connSource.Open();

                    string queryString = @"
                       select STUFF((select ','+noa+'@'+store from store a where not exists (select * from cust where noa=a.noa) order by noa FOR XML PATH('')),1,1,'') store
					";
					
					System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(queryString, connSource);
					//cmd.ExecuteNonQuery();
                    adapter.SelectCommand = cmd;
                    adapter.Fill(dt);
					connSource.Close();
				}
				t_out = (dt.Rows.Count > 0 ? "" : "無倉庫資料");
				
	            foreach (System.Data.DataRow r in dt.Rows)
	            {
                    t_out = System.DBNull.Value.Equals(r.ItemArray[0]) ? "" : (System.String)r.ItemArray[0];
	            }
				
            }
            catch (Exception ex) {
                t_out = "Error=" + ex.Message + "\r\n" + ex.StackTrace;
            }
            Response.Write(t_out);
        }
    </script>