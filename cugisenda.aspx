<%@ Page Language="C#" Debug="true"%>
    <script language="c#" runat="server">     
        
        System.IO.MemoryStream stream = new System.IO.MemoryStream();
        string connectionString = "";
        public void Page_Load()
        {
        	string db = "st";
        	if(Request.QueryString["db"] !=null && Request.QueryString["db"].Length>0)
        		db= Request.QueryString["db"];
        	connectionString = "Data Source=127.0.0.1,1799;Persist Security Info=True;User ID=sa;Password=artsql963;Database="+db;
            //參數
            string workno="" ,noa = "", noq ="";
            int str = 0;
			if (Request.QueryString["workno"] != null && Request.QueryString["workno"].Length > 0)
            {
                workno = Request.QueryString["workno"];
            }
            if (Request.QueryString["noa"] != null && Request.QueryString["noa"].Length > 0)
            {
                noa = Request.QueryString["noa"];
            }
            if (Request.QueryString["noq"] != null && Request.QueryString["noq"].Length > 0)
            {
                noq = Request.QueryString["noq"];
            }
            
            //資料
            System.Data.DataTable dt = new System.Data.DataTable();
            using (System.Data.SqlClient.SqlConnection connSource = new System.Data.SqlClient.SqlConnection(connectionString))
            {
                System.Data.SqlClient.SqlDataAdapter adapter = new System.Data.SqlClient.SqlDataAdapter();
                connSource.Open();
                string queryString = @"                                    
                                    declare @accy nvarchar(20)=isnull((select top 1 accy from view_cug  where noa=@noa),'')
					                if(@accy!='')
										EXEC('update cugs'+@accy+' set issel=1 where noa='''+@noa+''' and noq='''+@noq+'''')
                                    
                                    ";
                System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(queryString, connSource);
                cmd.Parameters.AddWithValue("@noa", noa);
                cmd.Parameters.AddWithValue("@noq", noq);
                adapter.SelectCommand = cmd;
                adapter.Fill(dt);
                connSource.Close();
				Response.Write(workno+"製令已完工!!");
            }
            
        }
    </script>
